import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import '../../../core/config/app_config.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/l10n/l10n_helper.dart';
import '../../../core/logging/log_entry.dart';
import '../../device/models/device_info.dart';
import '../../device/providers/device_provider.dart';
import '../../device/services/device_service.dart';
import '../../files/services/file_service.dart';
import '../models/operation_step.dart';
import '../services/kptools_service.dart';
import '../services/safety_service.dart';
import 'version_provider.dart';

enum PatchOperationState { idle, running, completed, failed, cancelled }

class PatchProvider extends ChangeNotifier {
  final KpToolsService _kptoolsService;
  final FileService _fileService;
  final SafetyService _safetyService;

  PatchProvider({
    KpToolsService? kptoolsService,
    FileService? fileService,
    SafetyService? safetyService,
  })  : _kptoolsService = kptoolsService ?? KpToolsService(),
        _fileService = fileService ?? FileService(),
        _safetyService = safetyService ?? SafetyService();

  String? _selectedFilePath;
  String? _patchedFilePath;
  String? _backupFilePath;
  Set<String> _selectedKpmModules = {};
  List<OperationStep> _steps = [];
  int _currentStepIndex = -1;
  PatchOperationState _operationState = PatchOperationState.idle;
  FlashingPhase _phase = FlashingPhase.idle;
  final List<LogEntry> _logs = [];
  String? _errorMessage;
  AppError? _lastError;
  bool _isCancelling = false;
  String _operationId = '';
  String? _activeDeviceSerial;

  String? get selectedFilePath => _selectedFilePath;
  String? get patchedFilePath => _patchedFilePath;
  String? get backupFilePath => _backupFilePath;
  Set<String> get selectedKpmModules => Set.unmodifiable(_selectedKpmModules);
  List<OperationStep> get steps => _steps;
  int get currentStepIndex => _currentStepIndex;
  PatchOperationState get operationState => _operationState;
  FlashingPhase get phase => _phase;

  /// Maximum number of log entries kept in memory per session to keep UI scrolling responsive.
  static const int maxLogEntries = 2000;

  List<LogEntry> get logs => List.unmodifiable(_logs);
  String? get errorMessage => _errorMessage;
  AppError? get lastError => _lastError;
  String get operationId => _operationId;
  bool get isRunning => _operationState == PatchOperationState.running;
  bool get isCriticalOperationInProgress =>
      isRunning &&
      (_phase == FlashingPhase.rebootingToFastboot ||
          _phase == FlashingPhase.fastbootDetection ||
          _phase == FlashingPhase.flashing ||
          _phase == FlashingPhase.rebootingToSystem);
  bool get isCompleted => _operationState == PatchOperationState.completed;
  bool get isFailed => _operationState == PatchOperationState.failed;
  bool get canSafelyRetry =>
      _phase != FlashingPhase.uncertain && (_lastError?.canSafelyRetry ?? true);
  double get progress =>
      _steps.isEmpty ? 0 : (_currentStepIndex + 1) / _steps.length;

  void clearError() {
    _lastError = null;
    _errorMessage = null;
    notifyListeners();
  }

  void setSelectedFile(String path) {
    _selectedFilePath = path;
    _patchedFilePath = null;
    _operationState = PatchOperationState.idle;
    _phase = FlashingPhase.idle;
    _logs.clear();
    _errorMessage = null;
    _lastError = null;
    notifyListeners();
  }

  void setKpmModules(Set<String> modules) {
    _selectedKpmModules = Set.from(modules);
    notifyListeners();
  }

  void addKpmModule(String path) {
    _selectedKpmModules.add(path);
    notifyListeners();
  }

  void removeKpmModule(String path) {
    _selectedKpmModules.remove(path);
    notifyListeners();
  }

  void clearKpmModules() {
    _selectedKpmModules.clear();
    notifyListeners();
  }

  void clearLogs() {
    _logs.clear();
    notifyListeners();
  }

  /// Exposes internal log insertion for deterministic unit testing of buffer caps.
  @visibleForTesting
  void addLogEntryForTest(LogLevel level, String message) {
    _addLog(level, message);
  }

  void _addLog(
    LogLevel level,
    String message, {
    AppErrorCategory? category,
    String? technicalDetails,
  }) {
    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
      operationId: _operationId.isEmpty ? null : _operationId,
      deviceSerial: _activeDeviceSerial,
      stage: _phase == FlashingPhase.idle ? null : _phase.name,
      category: category,
      technicalDetails: technicalDetails,
    );
    if (_logs.length >= maxLogEntries) {
      _logs.removeRange(0, _logs.length - maxLogEntries + 1);
    }
    _logs.add(entry);
    debugPrint(entry.toFormattedString());
    notifyListeners();
  }

  Future<void> _persistSessionLogs() async {
    if (_logs.isEmpty) return;
    try {
      final content = _logs.map((e) => e.toFormattedString()).join('\n');
      await _fileService.saveLatestSessionLog(content);
    } catch (_) {
      // Best-effort crash-safe flush; ignored if documents directory is unavailable (e.g., headless tests).
    }
  }

  void _failWithError(
    AppError error, {
    FlashingPhase phase = FlashingPhase.failed,
  }) {
    _phase = phase;
    _operationState = PatchOperationState.failed;
    _errorMessage = error.message;
    _lastError = error;
    _addLog(
      LogLevel.error,
      '${error.title}: ${error.message}',
      category: error.category,
      technicalDetails: error.technicalDetails,
    );
    _persistSessionLogs();
    notifyListeners();
  }

  void _updateStepStatus(
    int index,
    StepStatus status, {
    String? errorMessage,
  }) {
    if (index >= 0 && index < _steps.length) {
      _steps[index].status = status;
      _steps[index].errorMessage = errorMessage;
      notifyListeners();
    }
  }

  Future<void> startQuickPatch(
    DeviceProvider deviceProvider,
    VersionProvider versionProvider,
  ) async {
    if (isRunning) return;
    final l10n = appL10n;

    if (_selectedFilePath == null) {
      _failWithError(AppError(
        category: AppErrorCategory.file,
        title: l10n.errTitleNoBootSelected,
        message: l10n.errSelectBootFirst,
        affectedStage: 'Preflight',
        deviceSafe: true,
        nextSteps: l10n.errNextSelectBoot,
        canSafelyRetry: true,
      ));
      return;
    }

    final targetDevice = deviceProvider.selectedTargetDevice;
    final selectedVer = versionProvider.selectedVersion;
    _activeDeviceSerial = targetDevice?.serial;
    _operationId = generateOperationId();
    _operationState = PatchOperationState.running;
    _phase = FlashingPhase.preflight;
    _steps = OperationStep.getQuickPatchSteps();
    _currentStepIndex = -1;
    _logs.clear();
    _errorMessage = null;
    _lastError = null;
    _isCancelling = false;
    deviceProvider.setOperationLocked(true);
    notifyListeners();

    try {
      _currentStepIndex = 0;

      final connectedCount = deviceProvider.hasMultipleDevices
          ? 2
          : (targetDevice != null ? 1 : 0);

      final preflight = await _safetyService.runPreflightChecks(
        bootImagePath: _selectedFilePath!,
        kpimgPath: selectedVer?.kpimgPath ?? AppConfig.fallbackKpimgPath,
        kptoolsPathOverride: selectedVer?.kptoolsPath,
        minKernel: selectedVer?.minKernel ?? '3.18',
        maxKernel: selectedVer?.maxKernel ?? '6.15',
        kpmModules: _selectedKpmModules.toList(growable: false),
        deviceInfo: targetDevice,
        batteryLevel: targetDevice?.batteryLevel,
        checkImageMagic: true,
        requireConnectedDevice: true,
        connectedDeviceCount: connectedCount,
      );
      for (final warning in preflight.warnings) {
        _addLog(LogLevel.warning, warning);
      }
      if (!preflight.passed) {
        final msg = preflight.errors.join('; ');
        _updateStepStatus(0, StepStatus.failed, errorMessage: msg);
        _failWithError(
          preflight.primaryError ??
              AppError(
                category: AppErrorCategory.imageValidation,
                title: l10n.errTitlePreflightFailed,
                message: msg,
                affectedStage: 'Preflight',
                deviceSafe: true,
                nextSteps: l10n.errNextPreflightFailed,
                canSafelyRetry: true,
              ),
        );
        return;
      }

      _updateStepStatus(0, StepStatus.completed);

      if (_isCancelling) {
        _phase = FlashingPhase.idle;
        _operationState = PatchOperationState.cancelled;
        notifyListeners();
        return;
      }

      _phase = FlashingPhase.preparation;
      _currentStepIndex = 1;
      _updateStepStatus(1, StepStatus.inProgress);
      _addLog(LogLevel.info, l10n.logBackingUpBoot);

      final backupDir = await _fileService.getBackupDirectory();
      final timestamp = DateTime.now()
          .toString()
          .replaceAll(':', '-')
          .split('.')
          .first;
      final backupPath = p.join(backupDir, 'boot_backup_$timestamp.img');

      if (deviceProvider.hasFastbootDevice) {
        final backupSuccess = await deviceProvider.backupBoot(
          backupPath,
          onLog: (line) => _addLog(LogLevel.info, line),
        );
        if (backupSuccess) {
          _backupFilePath = backupPath;
          _addLog(LogLevel.success, l10n.logBackupComplete(backupPath));
          _updateStepStatus(1, StepStatus.completed);
        } else {
          _addLog(LogLevel.warning, l10n.logBackupFailed);
          _updateStepStatus(1, StepStatus.completed);
        }
      } else {
        try {
          _backupFilePath = await _fileService.backupBootImage(
            _selectedFilePath!,
          );
          _addLog(LogLevel.info, l10n.logBackupComplete(_backupFilePath!));
        } catch (_) {
          _addLog(LogLevel.warning, l10n.logDeviceNotFastboot);
        }
        _updateStepStatus(1, StepStatus.completed);
      }

      if (_isCancelling) {
        _phase = FlashingPhase.idle;
        _operationState = PatchOperationState.cancelled;
        notifyListeners();
        return;
      }

      _phase = FlashingPhase.patching;
      _currentStepIndex = 2;
      _updateStepStatus(2, StepStatus.inProgress);
      _addLog(LogLevel.info, l10n.logPatchingBoot);

      final outputDir = await _fileService.getOutputDirectory();
      _patchedFilePath = p.join(outputDir, 'boot_patched_$timestamp.img');

      final patchResult = await _kptoolsService.patchBootImage(
        inputPath: _selectedFilePath!,
        outputPath: _patchedFilePath!,
        kpmModules: _selectedKpmModules.toList(),
        kpVersion: selectedVer,
        onLog: (line) => _addLog(LogLevel.info, line),
      );

      if (!patchResult.success) {
        _updateStepStatus(
          2,
          StepStatus.failed,
          errorMessage: patchResult.errorMessage,
        );
        _failWithError(AppError(
          category: AppErrorCategory.process,
          title: l10n.errTitlePatchFailed,
          message: patchResult.errorMessage ?? l10n.errTitlePatchFailed,
          affectedStage: 'Patching',
          deviceSafe: true,
          nextSteps: l10n.errNextPatchFailed,
          canSafelyRetry: true,
          technicalDetails: patchResult.errorMessage,
        ));
        return;
      }

      _addLog(LogLevel.success, l10n.logPatchComplete(_patchedFilePath!));
      _updateStepStatus(2, StepStatus.completed);

      if (_isCancelling) {
        _phase = FlashingPhase.idle;
        _operationState = PatchOperationState.cancelled;
        notifyListeners();
        return;
      }

      _phase = FlashingPhase.validation;
      _currentStepIndex = 3;
      _updateStepStatus(3, StepStatus.inProgress);
      _addLog(LogLevel.info, l10n.logSavingFile);

      final savedPath = await _fileService.savePatchedImage(
        _patchedFilePath!,
        customName: 'boot_patched_$timestamp.img',
      );
      _addLog(LogLevel.success, l10n.logFileSaved(savedPath));
      _updateStepStatus(3, StepStatus.completed);

      if (_isCancelling) {
        _phase = FlashingPhase.idle;
        _operationState = PatchOperationState.cancelled;
        notifyListeners();
        return;
      }

      _phase = FlashingPhase.rebootingToFastboot;
      _currentStepIndex = 4;
      _updateStepStatus(4, StepStatus.inProgress);

      if (deviceProvider.hasFastbootDevice) {
        _addLog(LogLevel.success, l10n.logDeviceInFastboot);
      } else if (deviceProvider.hasAdbDevice) {
        _addLog(LogLevel.info, l10n.logRebootingToFastboot);
        final rebootSuccess = await deviceProvider.rebootToFastboot();
        if (!rebootSuccess) {
          _addLog(LogLevel.warning, l10n.logAutoRebootFailed);
        }
      } else {
        _addLog(LogLevel.warning, l10n.logNoAdbDevice);

        for (int i = 0; i < 30; i++) {
          await Future.delayed(const Duration(seconds: 2));
          if (_isCancelling) {
            _phase = FlashingPhase.idle;
            _operationState = PatchOperationState.cancelled;
            notifyListeners();
            return;
          }
          await deviceProvider.pollDuringOperation();
          if (deviceProvider.hasFastbootDevice) {
            break;
          }
        }
      }

      _phase = FlashingPhase.fastbootDetection;
      if (!deviceProvider.hasFastbootDevice) {
        final found = await deviceProvider.waitForFastboot(
          expectedSerial: _activeDeviceSerial,
        );
        if (!found) {
          _updateStepStatus(
            4,
            StepStatus.failed,
            errorMessage: l10n.logWaitFastbootTimeout,
          );
          final rawAdbErr = deviceProvider.lastRawError;
          if (rawAdbErr != null && rawAdbErr.isNotEmpty) {
            _failWithError(
              DeviceService.classifyAdbError(
                rawAdbErr,
                stage: 'Reboot to Fastboot',
              ),
            );
          } else {
            _failWithError(AppError(
              category: AppErrorCategory.fastboot,
              title: l10n.errTitleFastbootTimeout,
              message: l10n.errMsgFastbootTimeout,
              affectedStage: 'Fastboot Detection',
              deviceSafe: true,
              nextSteps: l10n.errNextFastbootTimeout,
              canSafelyRetry: true,
            ));
          }
          return;
        }
      }

      _addLog(LogLevel.success, l10n.logDeviceInFastboot);
      _updateStepStatus(4, StepStatus.completed);

      if (_isCancelling) {
        _phase = FlashingPhase.idle;
        _operationState = PatchOperationState.cancelled;
        notifyListeners();
        return;
      }

      final activeSlot = await deviceProvider.getActiveSlot(
        onLog: (line) => _addLog(LogLevel.info, line),
      );
      if (activeSlot != null && activeSlot.isNotEmpty) {
        _addLog(LogLevel.info, 'Active Fastboot slot: $activeSlot');
      }

      _phase = FlashingPhase.flashing;
      _currentStepIndex = 5;
      _updateStepStatus(5, StepStatus.inProgress);
      _addLog(LogLevel.info, l10n.logFlashingBoot);
      await _persistSessionLogs();

      final flashSuccess = await deviceProvider.flashBoot(
        _patchedFilePath!,
        onLog: (line) => _addLog(LogLevel.info, line),
      );

      if (!flashSuccess) {
        _updateStepStatus(
          5,
          StepStatus.failed,
          errorMessage: l10n.logFlashFailed,
        );
        final rawFlashErr = deviceProvider.lastRawError ??
            (_logs.isNotEmpty ? _logs.last.message : l10n.errFlashBootFailed);
        final classified = DeviceService.classifyFastbootError(
          rawFlashErr,
          stage: 'Flashing',
          duringFlash: true,
        );
        final isPreWriteSafeFailure =
            classified.category == AppErrorCategory.fastboot &&
                classified.deviceSafe;
        _failWithError(
          classified,
          phase: isPreWriteSafeFailure
              ? FlashingPhase.failed
              : FlashingPhase.uncertain,
        );
        return;
      }

      _addLog(LogLevel.success, l10n.logFlashSuccess);
      _updateStepStatus(5, StepStatus.completed);

      if (_isCancelling) {
        _phase = FlashingPhase.idle;
        _operationState = PatchOperationState.cancelled;
        notifyListeners();
        return;
      }

      _phase = FlashingPhase.rebootingToSystem;
      _currentStepIndex = 6;
      _updateStepStatus(6, StepStatus.inProgress);
      _addLog(LogLevel.info, l10n.logRebootingDevice);

      await Future.delayed(const Duration(seconds: 2));
      final rebootSuccess = await deviceProvider.rebootDevice(
        onLog: (line) => _addLog(LogLevel.info, line),
      );

      _phase = FlashingPhase.verification;
      if (rebootSuccess) {
        _addLog(LogLevel.success, l10n.logRebootSuccess);
      } else {
        _addLog(LogLevel.warning, l10n.logAutoRebootFailed2);
      }
      _updateStepStatus(6, StepStatus.completed);

      _phase = FlashingPhase.completed;
      _operationState = PatchOperationState.completed;
      _addLog(LogLevel.success, l10n.logOneClickComplete);
      await _persistSessionLogs();
      notifyListeners();
    } catch (e) {
      _failWithError(
        AppError(
          category: AppErrorCategory.application,
          title: l10n.errTitleUnexpected,
          message: e.toString(),
          affectedStage: _phase.name,
          deviceSafe: _phase != FlashingPhase.flashing,
          nextSteps: l10n.errNextUnexpected,
          canSafelyRetry: _phase != FlashingPhase.flashing,
          technicalDetails: e.toString(),
        ),
        phase: _phase == FlashingPhase.flashing
            ? FlashingPhase.uncertain
            : FlashingPhase.failed,
      );
    } finally {
      deviceProvider.setOperationLocked(false);
    }
  }

  Future<bool> patchOnly(VersionProvider versionProvider) async {
    if (isRunning) return false;
    final l10n = appL10n;

    if (_selectedFilePath == null) {
      _failWithError(AppError(
        category: AppErrorCategory.file,
        title: l10n.errTitleNoBootSelected,
        message: l10n.errSelectBootFirst,
        affectedStage: 'Preflight',
        deviceSafe: true,
        nextSteps: l10n.errNextSelectBoot,
        canSafelyRetry: true,
      ));
      return false;
    }

    final selectedVer = versionProvider.selectedVersion;
    _operationId = generateOperationId();
    _operationState = PatchOperationState.running;
    _phase = FlashingPhase.preflight;
    _logs.clear();
    _errorMessage = null;
    _lastError = null;
    notifyListeners();

    _addLog(LogLevel.info, l10n.logStartPatching);

    try {
      final preflight = await _safetyService.runPreflightChecks(
        bootImagePath: _selectedFilePath!,
        kpimgPath: selectedVer?.kpimgPath ?? AppConfig.fallbackKpimgPath,
        kptoolsPathOverride: selectedVer?.kptoolsPath,
        minKernel: selectedVer?.minKernel ?? '3.18',
        maxKernel: selectedVer?.maxKernel ?? '6.15',
        kpmModules: _selectedKpmModules.toList(growable: false),
        checkImageMagic: true,
        requireConnectedDevice: false,
      );
      for (final warning in preflight.warnings) {
        _addLog(LogLevel.warning, warning);
      }
      if (!preflight.passed) {
        _failWithError(
          preflight.primaryError ??
              AppError(
                category: AppErrorCategory.imageValidation,
                title: l10n.errTitlePreflightFailed,
                message: preflight.errors.join('; '),
                affectedStage: 'Preflight',
                deviceSafe: true,
                nextSteps: l10n.errNextPreflightFailed,
                canSafelyRetry: true,
              ),
        );
        return false;
      }

      _phase = FlashingPhase.patching;
      final timestamp = DateTime.now()
          .toString()
          .replaceAll(':', '-')
          .split('.')
          .first;
      final outputDir = await _fileService.getOutputDirectory();
      _patchedFilePath = p.join(outputDir, 'boot_patched_$timestamp.img');

      final result = await _kptoolsService.patchBootImage(
        inputPath: _selectedFilePath!,
        outputPath: _patchedFilePath!,
        kpmModules: _selectedKpmModules.toList(),
        kpVersion: selectedVer,
        onLog: (line) => _addLog(LogLevel.info, line),
      );

      if (result.success) {
        _phase = FlashingPhase.completed;
        _operationState = PatchOperationState.completed;
        _addLog(
          LogLevel.success,
          l10n.logPatchComplete(_patchedFilePath!),
        );
        await _persistSessionLogs();
        notifyListeners();
        return true;
      } else {
        _failWithError(AppError(
          category: AppErrorCategory.process,
          title: l10n.errTitlePatchFailed,
          message: result.errorMessage ?? l10n.errTitlePatchFailed,
          affectedStage: 'Patching',
          deviceSafe: true,
          nextSteps: l10n.errNextPatchFailed,
          canSafelyRetry: true,
          technicalDetails: result.errorMessage,
        ));
        return false;
      }
    } catch (e) {
      _failWithError(AppError(
        category: AppErrorCategory.process,
        title: l10n.errTitlePatchFailed,
        message: l10n.logPatchException(e),
        affectedStage: 'Patching',
        deviceSafe: true,
        nextSteps: l10n.errNextUnexpected,
        canSafelyRetry: true,
        technicalDetails: e.toString(),
      ));
      return false;
    }
  }

  void cancelOperation() {
    _isCancelling = true;
    _addLog(LogLevel.warning, appL10n.logCancelling);
    notifyListeners();
  }

  void reset() {
    _selectedFilePath = null;
    _patchedFilePath = null;
    _selectedKpmModules.clear();
    _steps = [];
    _currentStepIndex = -1;
    _operationState = PatchOperationState.idle;
    _phase = FlashingPhase.idle;
    _logs.clear();
    _errorMessage = null;
    _lastError = null;
    _activeDeviceSerial = null;
    _isCancelling = false;
    notifyListeners();
  }

  Future<String> exportLogs() async {
    final content = _logs.map((e) => e.toFormattedString()).join('\n');
    return _fileService.saveLogFile(content);
  }

  Future<String> exportDiagnostics({
    DeviceInfo? deviceInfo,
    bool redact = true,
  }) async {
    return _fileService.exportDiagnosticBundle(
      logs: _logs,
      deviceInfo: deviceInfo,
      redact: redact,
    );
  }

  /// Flashes [patchedFilePath] in Step-by-Step mode with Fastboot classification & logging.
  Future<bool> flashPatchedBootOnDevice(DeviceProvider deviceProvider) async {
    if (isRunning) return false;
    final imagePath = _patchedFilePath;
    if (imagePath == null) return false;
    final l10n = appL10n;

    _activeDeviceSerial = deviceProvider.selectedTargetDevice?.serial;
    _operationId = generateOperationId();
    _operationState = PatchOperationState.running;
    _phase = FlashingPhase.flashing;
    _errorMessage = null;
    _lastError = null;
    deviceProvider.setOperationLocked(true);
    _addLog(LogLevel.info, l10n.logFlashingBoot);
    await _persistSessionLogs();
    notifyListeners();

    try {
      final ok = await deviceProvider.flashBoot(
        imagePath,
        onLog: (line) => _addLog(LogLevel.info, line),
      );
      if (!ok) {
        final rawErr = deviceProvider.lastRawError ??
            (_logs.isNotEmpty ? _logs.last.message : l10n.errFlashBootFailed);
        final classified = DeviceService.classifyFastbootError(
          rawErr,
          stage: 'Step Flash',
          duringFlash: true,
        );
        final isPreWriteSafeFailure =
            classified.category == AppErrorCategory.fastboot &&
                classified.deviceSafe;
        _failWithError(
          classified,
          phase: isPreWriteSafeFailure
              ? FlashingPhase.failed
              : FlashingPhase.uncertain,
        );
        return false;
      }
      _phase = FlashingPhase.completed;
      _operationState = PatchOperationState.completed;
      _addLog(LogLevel.success, l10n.logFlashSuccess);
      await _persistSessionLogs();
      notifyListeners();
      return true;
    } finally {
      deviceProvider.setOperationLocked(false);
    }
  }

  /// Flashes the backed-up stock boot image back to the device in fastboot mode.
  Future<bool> restoreStockBoot(DeviceProvider deviceProvider) async {
    final l10n = appL10n;
    final backupPath = _backupFilePath;
    if (backupPath == null) {
      _addLog(LogLevel.error, l10n.errTitleBootNotFound);
      return false;
    }
    _addLog(LogLevel.info, l10n.logFlashingBootPath(backupPath));
    final ok = await deviceProvider.flashBoot(
      backupPath,
      onLog: (line) => _addLog(LogLevel.info, line),
    );
    _addLog(
      ok ? LogLevel.success : LogLevel.error,
      ok ? l10n.restoreStockBootSuccess : l10n.restoreStockBootFailed,
    );
    return ok;
  }
}