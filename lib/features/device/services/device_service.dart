import 'dart:io';
import 'package:path/path.dart' as p;
import '../../../core/config/app_config.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/l10n/l10n_helper.dart';
import '../../../core/process/process_runner.dart';
import '../models/device_info.dart';

typedef LogCallback = void Function(String line);

class ToolchainDiagnostics {
  final String adbPath;
  final bool adbExists;
  final String? adbVersion;
  final String fastbootPath;
  final bool fastbootExists;
  final String? fastbootVersion;
  final String? platformToolsRevision;
  final bool kptoolsFolkpatchExists;
  final bool kptoolsApatchExists;
  final bool kptoolsSharedExists;

  const ToolchainDiagnostics({
    required this.adbPath,
    required this.adbExists,
    this.adbVersion,
    required this.fastbootPath,
    required this.fastbootExists,
    this.fastbootVersion,
    this.platformToolsRevision,
    required this.kptoolsFolkpatchExists,
    required this.kptoolsApatchExists,
    required this.kptoolsSharedExists,
  });

  bool get toolsReady =>
      adbExists &&
      adbVersion != null &&
      fastbootExists &&
      fastbootVersion != null &&
      (kptoolsFolkpatchExists || kptoolsApatchExists || kptoolsSharedExists);
}

class DeviceService {
  final ProcessRunner _processRunner;
  final bool _skipBinaryExistsCheck;
  String? _lastRawError;

  /// Raw stdout/stderr or exception text from the most recent failed ADB/Fastboot call.
  String? get lastRawError => _lastRawError;

  DeviceService({
    ProcessRunner? processRunner,
    bool skipBinaryExistsCheck = false,
  })  : _processRunner = processRunner ?? const DefaultProcessRunner(),
        _skipBinaryExistsCheck = skipBinaryExistsCheck;

  /// Parses battery percentage from `adb shell dumpsys battery` output.
  static int? parseBatteryLevel(String dumpsysOutput) {
    final match = RegExp(r'level:\s*(\d+)').firstMatch(dumpsysOutput);
    if (match == null) return null;
    return int.tryParse(match.group(1) ?? '');
  }

  /// Extracts a concise Platform-Tools / ADB / Fastboot version string from CLI output.
  static String? parseToolVersionLine(String output) {
    for (final raw in output.split(RegExp(r'\r?\n'))) {
      final trimmed = raw.trim();
      if (trimmed.isEmpty) continue;
      final versionMatch =
          RegExp(r'(?:version\s+|Version\s+)([0-9]+\.[0-9]+\.[0-9]+[^\s]*)')
              .firstMatch(trimmed);
      if (versionMatch != null) return versionMatch.group(1);
    }
    return null;
  }

  Future<List<DeviceInfo>> getAdbDevices({LogCallback? onLog}) async {
    try {
      if (!_skipBinaryExistsCheck && !await File(AppConfig.adbPath).exists()) {
        onLog?.call(appL10n.errAdbNotExist(AppConfig.adbPath));
        return [];
      }
      final result = await _runAdb(['devices'], onLog: onLog);
      if (result.exitCode != 0) return [];
      final lines = result.stdout.toString().split('\n');
      final devices = <DeviceInfo>[];

      for (var line in lines) {
        line = line.trim();
        if (line.isEmpty ||
            line.startsWith('List of devices') ||
            line.startsWith('* daemon')) {
          continue;
        }
        if (line.contains('\t') || RegExp(r'\s+').hasMatch(line)) {
          final device = DeviceInfo.fromAdbLine(line);
          if (device.serial.isNotEmpty) {
            devices.add(device);
          }
        }
      }

      return devices;
    } catch (e) {
      onLog?.call(appL10n.errGetAdbFailed(e));
      return [];
    }
  }

  Future<List<DeviceInfo>> getFastbootDevices({LogCallback? onLog}) async {
    try {
      if (!_skipBinaryExistsCheck &&
          !await File(AppConfig.fastbootPath).exists()) {
        onLog?.call(appL10n.errFastbootNotExist(AppConfig.fastbootPath));
        return [];
      }
      final result = await _runFastboot(['devices'], onLog: onLog);
      if (result.exitCode != 0) return [];
      final lines = result.stdout.toString().split('\n');
      final devices = <DeviceInfo>[];

      for (var line in lines) {
        line = line.trim();
        if (line.isEmpty) continue;
        if (line.toLowerCase().contains('fastboot')) {
          final device = DeviceInfo.fromFastbootLine(line);
          if (device.serial.isNotEmpty) {
            devices.add(device);
          }
        }
      }

      return devices;
    } catch (e) {
      onLog?.call(appL10n.errGetFastbootFailed(e));
      return [];
    }
  }

  Future<String?> _readAdbProp(
    String serial,
    List<String> shellArgs, {
    LogCallback? onLog,
  }) async {
    try {
      final res = await _runAdb(['-s', serial, ...shellArgs], onLog: onLog);
      if (res.exitCode == 0) {
        final value = res.stdout.toString().trim();
        if (value.isNotEmpty) return value;
      }
    } catch (_) {
      // Property probes are optional diagnostics; keep remaining fields available.
    }
    return null;
  }

  /// Queries model, Android version, kernel version, and battery concurrently.
  ///
  /// When [includeStaticProperties] is `false`, only battery level is refreshed.
  Future<DeviceInfo> queryAdbDeviceDetails(
    DeviceInfo base, {
    bool includeStaticProperties = true,
    LogCallback? onLog,
  }) async {
    if (!base.isAuthorizedAdb) return base;

    if (!includeStaticProperties) {
      final battery = await getBatteryLevel(serial: base.serial, onLog: onLog);
      return base.copyWith(batteryLevel: battery);
    }

    final results = await Future.wait([
      _readAdbProp(
        base.serial,
        ['shell', 'getprop', 'ro.product.model'],
        onLog: onLog,
      ),
      _readAdbProp(
        base.serial,
        ['shell', 'getprop', 'ro.build.version.release'],
        onLog: onLog,
      ),
      _readAdbProp(base.serial, ['shell', 'uname', '-r'], onLog: onLog),
      getBatteryLevel(serial: base.serial, onLog: onLog),
    ]);

    return base.copyWith(
      model: (results[0] as String?) ?? base.model,
      androidVersion: (results[1] as String?) ?? base.androidVersion,
      kernelVersion: (results[2] as String?) ?? base.kernelVersion,
      batteryLevel: results[3] as int?,
    );
  }

  /// Queries whether fastboot device is running inside userspace (`fastbootd`).
  Future<bool> isUserspaceFastbootd({
    String? serial,
    LogCallback? onLog,
  }) async {
    final val = await getFastbootVar('is-userspace', serial: serial, onLog: onLog);
    if (val == null) return false;
    final lower = val.toLowerCase();
    return lower == 'yes' || lower == 'true' || lower == '1';
  }

  /// Queries whether bootloader is unlocked in Fastboot mode (`yes` -> true, `no` -> false).
  Future<bool?> queryBootloaderUnlocked({
    String? serial,
    LogCallback? onLog,
  }) async {
    final val = await getFastbootVar('unlocked', serial: serial, onLog: onLog);
    if (val == null) return null;
    final lower = val.toLowerCase();
    if (lower == 'yes' || lower == 'true' || lower == '1') return true;
    if (lower == 'no' || lower == 'false' || lower == '0') return false;
    return null;
  }

  Future<bool> checkAdbConnection({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    try {
      final devices = await getAdbDevices().timeout(timeout);
      return devices.any((d) => d.state == DeviceState.adb);
    } catch (_) {
      return false;
    }
  }

  Future<bool> checkFastbootConnection({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    try {
      final devices = await getFastbootDevices().timeout(timeout);
      return devices.any((d) => d.state == DeviceState.fastboot);
    } catch (_) {
      return false;
    }
  }

  Future<bool> rebootToFastboot({String? serial, LogCallback? onLog}) async {
    _lastRawError = null;
    try {
      onLog?.call(appL10n.logRebootingToFastboot);
      final args = <String>[
        if (serial != null) ...['-s', serial],
        'reboot',
        'bootloader',
      ];
      final result = await _runAdb(args, onLog: onLog);

      if (result.exitCode == 0) {
        onLog?.call(appL10n.logRebootCmdSent);
        return true;
      } else {
        final raw = '${result.stderr}\n${result.stdout}'.trim();
        _lastRawError =
            raw.isNotEmpty ? raw : 'adb exited with code ${result.exitCode}';
        onLog?.call(appL10n.errRebootFailed(result.stderr));
        return false;
      }
    } catch (e) {
      _lastRawError = e.toString();
      onLog?.call(appL10n.errRebootException(e));
      return false;
    }
  }

  /// Reboots a device in `fastbootd` userspace back to bootloader `fastboot`.
  Future<bool> rebootFastbootdToBootloader({
    String? serial,
    LogCallback? onLog,
  }) async {
    try {
      final args = <String>[
        if (serial != null) ...['-s', serial],
        'reboot-bootloader',
      ];
      final result = await _runFastboot(args, onLog: onLog);
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  Future<DeviceInfo?> waitForFastbootDevice({
    Duration timeout = const Duration(seconds: 60),
    String? expectedSerial,
    LogCallback? onLog,
  }) async {
    final endTime = DateTime.now().add(timeout);

    onLog?.call(appL10n.logWaitFastboot(timeout.inSeconds));

    while (DateTime.now().isBefore(endTime)) {
      final devices = await getFastbootDevices();
      if (devices.isNotEmpty) {
        final match = expectedSerial != null
            ? devices.where((d) => d.serial == expectedSerial).firstOrNull
            : (devices.length == 1 ? devices.first : null);
        if (match != null) {
          onLog?.call(appL10n.logFastbootDetected(match.serial));
          return match;
        }
      }
      await Future.delayed(const Duration(seconds: 2));
    }

    onLog?.call(appL10n.logWaitFastbootTimeout);
    return null;
  }

  Future<bool> flashBoot(
    String imagePath, {
    String? serial,
    LogCallback? onLog,
  }) async {
    _lastRawError = null;
    try {
      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        _lastRawError = 'Boot image file not found: $imagePath';
        onLog?.call(_lastRawError!);
        return false;
      }

      if (serial == null) {
        final devices = await getFastbootDevices(onLog: onLog);
        if (devices.length != 1) {
          _lastRawError =
              'Expected 1 fastboot device, found ${devices.length}.';
          onLog?.call('Refusing to flash: $_lastRawError');
          return false;
        }
      }

      final absolutePath = imageFile.absolute.path;
      onLog?.call(appL10n.logFlashingBootPath(absolutePath));

      final args = <String>[
        if (serial != null) ...['-s', serial],
        'flash',
        'boot',
        absolutePath,
      ];
      final result = await _runFastboot(
        args,
        timeout: const Duration(seconds: AppConfig.flashTimeoutSeconds),
        onLog: onLog,
      );

      if (result.exitCode == 0) {
        onLog?.call(appL10n.logFlashBootSuccess);
        return true;
      } else {
        final errText = '${result.stderr}\n${result.stdout}'.trim();
        _lastRawError = errText.isNotEmpty
            ? errText
            : 'fastboot exited with code ${result.exitCode}';
        onLog?.call(appL10n.errFlashFailed(errText));
        return false;
      }
    } catch (e) {
      _lastRawError = e.toString();
      onLog?.call(appL10n.errFlashException(e));
      return false;
    }
  }

  Future<bool> backupBoot(
    String outputPath, {
    String? serial,
    LogCallback? onLog,
  }) async {
    try {
      onLog?.call(appL10n.logBackingUpPartition);

      final args = <String>[
        if (serial != null) ...['-s', serial],
        'fetch',
        'boot',
        outputPath,
      ];
      final result = await _runFastboot(args, onLog: onLog);

      if (result.exitCode == 0 && await File(outputPath).exists()) {
        onLog?.call(appL10n.logBackupSuccess(outputPath));
        return true;
      } else {
        onLog?.call(appL10n.logBackupFailedTryAlt);
        return await _backupBootAlternative(
          outputPath,
          serial: serial,
          onLog: onLog,
        );
      }
    } catch (e) {
      onLog?.call(appL10n.errBackupException(e));
      return false;
    }
  }

  Future<bool> _backupBootAlternative(
    String outputPath, {
    String? serial,
    LogCallback? onLog,
  }) async {
    try {
      final tempDir = p.dirname(outputPath);
      final tempFile = p.join(tempDir, 'boot_backup.img');

      final args = <String>[
        if (serial != null) ...['-s', serial],
        'oem',
        'save',
        'boot',
        tempFile,
      ];
      final result = await _runFastboot(args, onLog: onLog);

      if (result.exitCode == 0 && await File(tempFile).exists()) {
        await File(tempFile).rename(outputPath);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> rebootDevice({String? serial, LogCallback? onLog}) async {
    try {
      onLog?.call(appL10n.logRebootingDevice);
      final args = <String>[
        if (serial != null) ...['-s', serial],
        'reboot',
      ];
      final result = await _runFastboot(args, onLog: onLog);

      if (result.exitCode == 0) {
        onLog?.call(appL10n.logDeviceRebooting);
        return true;
      } else {
        onLog?.call(appL10n.errRebootFailed(result.stderr));
        return false;
      }
    } catch (e) {
      onLog?.call(appL10n.errRebootException(e));
      return false;
    }
  }

  Future<String?> getFastbootVar(
    String varName, {
    String? serial,
    LogCallback? onLog,
  }) async {
    try {
      final args = <String>[
        if (serial != null) ...['-s', serial],
        'getvar',
        varName,
      ];
      final result = await _runFastboot(args, onLog: onLog);
      // Fastboot prints getvar output to stderr on most devices.
      final combined = '${result.stdout}\n${result.stderr}';
      final match = RegExp('$varName:\\s*(\\S+)').firstMatch(combined);
      return match?.group(1);
    } catch (_) {
      return null;
    }
  }

  /// Queries the active A/B slot (`a`/`b`) if the device supports slots, otherwise `null`.
  Future<String?> getActiveSlot({String? serial, LogCallback? onLog}) =>
      getFastbootVar('current-slot', serial: serial, onLog: onLog);

  /// Ensures the ADB server daemon can start cleanly.
  Future<bool> ensureAdbServerStarted({LogCallback? onLog}) async {
    _lastRawError = null;
    try {
      if (!_skipBinaryExistsCheck && !await File(AppConfig.adbPath).exists()) {
        _lastRawError = appL10n.errAdbNotExist(AppConfig.adbPath);
        onLog?.call(_lastRawError!);
        return false;
      }
      final res = await _runAdb(['start-server'], onLog: onLog);
      if (res.exitCode != 0) {
        final raw = '${res.stderr}\n${res.stdout}'.trim();
        _lastRawError =
            raw.isNotEmpty ? raw : 'adb start-server exited ${res.exitCode}';
        return false;
      }
      return true;
    } catch (e) {
      _lastRawError = e.toString();
      return false;
    }
  }

  Future<bool> checkAdbExists() async => File(AppConfig.adbPath).exists();

  Future<bool> checkFastbootExists() async =>
      File(AppConfig.fastbootPath).exists();

  Future<ToolchainDiagnostics> getToolchainDiagnostics() async {
    final adbExists = await File(AppConfig.adbPath).exists();
    final fastbootExists = await File(AppConfig.fastbootPath).exists();

    String? adbVer;
    if (adbExists) {
      try {
        final res = await _processRunner.run(
          AppConfig.adbPath,
          ['version'],
          timeout: const Duration(seconds: 5),
        );
        if (res.exitCode == 0) {
          adbVer = parseToolVersionLine('${res.stdout}\n${res.stderr}') ??
              res.stdout.toString().split('\n').first.trim();
        }
      } catch (_) {}
    }

    String? fbVer;
    if (fastbootExists) {
      try {
        final res = await _processRunner.run(
          AppConfig.fastbootPath,
          ['--version'],
          timeout: const Duration(seconds: 5),
        );
        if (res.exitCode == 0) {
          fbVer = parseToolVersionLine('${res.stdout}\n${res.stderr}') ??
              res.stdout.toString().split('\n').first.trim();
        }
      } catch (_) {}
    }

    String? rev;
    try {
      final propsFile = File(AppConfig.platformToolsPropertiesPath);
      if (await propsFile.exists()) {
        final content = await propsFile.readAsString();
        rev = RegExp(r'Pkg\.Revision=([^\r\n]+)').firstMatch(content)?.group(1);
      }
    } catch (_) {}

    return ToolchainDiagnostics(
      adbPath: AppConfig.adbPath,
      adbExists: adbExists,
      adbVersion: adbVer,
      fastbootPath: AppConfig.fastbootPath,
      fastbootExists: fastbootExists,
      fastbootVersion: fbVer,
      platformToolsRevision: rev,
      kptoolsFolkpatchExists:
          await File(AppConfig.kptoolsPathForSource('folkpatch')).exists(),
      kptoolsApatchExists:
          await File(AppConfig.kptoolsPathForSource('apatch')).exists(),
      kptoolsSharedExists: await File(AppConfig.sharedKptoolsPath).exists(),
    );
  }

  Future<bool> checkDriverInstalled({LogCallback? onLog}) async {
    try {
      onLog?.call(appL10n.logCheckAdb);

      if (!await File(AppConfig.adbPath).exists()) {
        onLog?.call(appL10n.errAdbNotExist(AppConfig.adbPath));
        return false;
      }

      final adbResult = await _runAdb(['version'], onLog: onLog);

      if (adbResult.exitCode != 0) {
        onLog?.call(appL10n.errAdbNotAvailable);
        return false;
      }

      onLog?.call(appL10n.logCheckFastboot);

      if (!await File(AppConfig.fastbootPath).exists()) {
        onLog?.call(appL10n.errFastbootNotExist(AppConfig.fastbootPath));
        return false;
      }

      final fastbootResult = await _runFastboot(['--version'], onLog: onLog);

      if (fastbootResult.exitCode != 0) {
        onLog?.call(appL10n.errFastbootNotAvailable);
        return false;
      }

      onLog?.call(appL10n.logDriverCheckPassed);
      return true;
    } catch (e) {
      onLog?.call(appL10n.errDriverCheckFailed(e));
      return false;
    }
  }

  Future<ProcessResult> _runAdb(
    List<String> args, {
    Duration? timeout,
    LogCallback? onLog,
  }) async {
    final executable = AppConfig.adbPath;
    onLog?.call(appL10n.logExecuteCmd('adb ${args.join(' ')}'));

    final result = await _processRunner.run(
      executable,
      args,
      timeout: timeout ?? const Duration(seconds: AppConfig.adbTimeoutSeconds),
    );

    if (result.stdout.toString().isNotEmpty) {
      onLog?.call(result.stdout.toString().trim());
    }
    if (result.stderr.toString().isNotEmpty && result.exitCode != 0) {
      onLog?.call('[STDERR] ${result.stderr}'.trim());
    }

    return result;
  }

  Future<ProcessResult> _runFastboot(
    List<String> args, {
    Duration? timeout,
    LogCallback? onLog,
  }) async {
    final executable = AppConfig.fastbootPath;
    onLog?.call(appL10n.logExecuteCmd('fastboot ${args.join(' ')}'));

    final result = await _processRunner.run(
      executable,
      args,
      timeout:
          timeout ?? const Duration(seconds: AppConfig.fastbootTimeoutSeconds),
    );

    if (result.stdout.toString().isNotEmpty) {
      onLog?.call(result.stdout.toString().trim());
    }
    if (result.stderr.toString().isNotEmpty && result.exitCode != 0) {
      onLog?.call('[STDERR] ${result.stderr}'.trim());
    }

    return result;
  }

  /// Classifies raw ADB output/exceptions into an actionable [AppError].
  static AppError classifyAdbError(String rawError, {String? stage}) {
    final l10n = appL10n;
    final lower = rawError.toLowerCase();
    if (lower.contains('unauthorized')) {
      return AppError(
        category: AppErrorCategory.adb,
        title: l10n.errTitleUnauthorized,
        message: l10n.errMsgUnauthorized('-'),
        affectedStage: stage,
        deviceSafe: true,
        nextSteps: l10n.errNextUnauthorized,
        canSafelyRetry: true,
        technicalDetails: rawError,
      );
    }
    if (lower.contains('offline')) {
      return AppError(
        category: AppErrorCategory.deviceConnection,
        title: l10n.errTitleOffline,
        message: l10n.errMsgOffline('-'),
        affectedStage: stage,
        deviceSafe: true,
        nextSteps: l10n.errNextOffline,
        canSafelyRetry: true,
        technicalDetails: rawError,
      );
    }
    if (lower.contains('more than one device')) {
      return AppError(
        category: AppErrorCategory.deviceConnection,
        title: l10n.errTitleMultipleDevices,
        message: l10n.errMsgMultipleDevices,
        affectedStage: stage,
        deviceSafe: true,
        nextSteps: l10n.errNextMultipleDevices,
        canSafelyRetry: true,
        technicalDetails: rawError,
      );
    }
    if (lower.contains('address already in use') ||
        lower.contains('cannot bind') ||
        lower.contains('daemon')) {
      return AppError(
        category: AppErrorCategory.adb,
        title: l10n.errTitleAdbPortConflict,
        message: l10n.errMsgAdbPortConflict,
        affectedStage: stage,
        deviceSafe: true,
        nextSteps: l10n.errNextAdbPortConflict,
        canSafelyRetry: true,
        technicalDetails: rawError,
      );
    }
    if (lower.contains('timeout')) {
      return AppError(
        category: AppErrorCategory.process,
        title: l10n.errTitleAdbTimeout,
        message: l10n.errMsgAdbTimeout,
        affectedStage: stage,
        deviceSafe: true,
        nextSteps: l10n.errNextNoDevice,
        canSafelyRetry: true,
        technicalDetails: rawError,
      );
    }
    return AppError(
      category: AppErrorCategory.adb,
      title: l10n.errTitleAdbFailed,
      message: l10n.errMsgAdbFailed,
      affectedStage: stage,
      deviceSafe: true,
      nextSteps: l10n.errNextPreflightFailed,
      canSafelyRetry: true,
      technicalDetails: rawError,
    );
  }

  /// Classifies raw Fastboot output/exceptions into an actionable [AppError].
  static AppError classifyFastbootError(
    String rawError, {
    String? stage,
    bool duringFlash = false,
  }) {
    final l10n = appL10n;
    final lower = rawError.toLowerCase();
    if (lower.contains('locked') ||
        lower.contains('unlock') ||
        lower.contains('lock state')) {
      return AppError(
        category: AppErrorCategory.fastboot,
        title: l10n.errTitleBootloaderLocked,
        message: l10n.errMsgBootloaderLocked,
        affectedStage: stage,
        deviceSafe: true,
        nextSteps: l10n.errNextBootloaderLocked,
        canSafelyRetry: false,
        technicalDetails: rawError,
      );
    }
    if (lower.contains('partition') &&
        (lower.contains('not found') || lower.contains('doesn\'t exist'))) {
      return AppError(
        category: AppErrorCategory.fastboot,
        title: l10n.errTitlePartitionNotFound,
        message: l10n.errMsgPartitionNotFound,
        affectedStage: stage,
        deviceSafe: !duringFlash,
        nextSteps: l10n.errNextFastbootTimeout,
        canSafelyRetry: false,
        technicalDetails: rawError,
      );
    }
    if (lower.contains('permission') || lower.contains('access is denied')) {
      return AppError(
        category: AppErrorCategory.permission,
        title: l10n.errTitleFastbootPermission,
        message: l10n.errMsgFastbootPermission,
        affectedStage: stage,
        deviceSafe: !duringFlash,
        nextSteps: l10n.driverHelpGuide,
        canSafelyRetry: !duringFlash,
        technicalDetails: rawError,
      );
    }
    if (lower.contains('timeout')) {
      return AppError(
        category: AppErrorCategory.fastboot,
        title: l10n.errTitleFastbootTimeoutCmd,
        message: l10n.errMsgFastbootTimeoutCmd,
        affectedStage: stage,
        deviceSafe: !duringFlash,
        nextSteps: l10n.errNextFastbootTimeout,
        canSafelyRetry: !duringFlash,
        technicalDetails: rawError,
      );
    }
    return AppError(
      category:
          duringFlash ? AppErrorCategory.flashing : AppErrorCategory.fastboot,
      title: duringFlash ? l10n.errFlashBootFailed : l10n.errTitleFastbootFailed,
      message: duringFlash
          ? l10n.errFlashBootFailed
          : l10n.errTitleFastbootFailed,
      affectedStage: stage,
      deviceSafe: !duringFlash,
      nextSteps: l10n.errNextFastbootTimeout,
      canSafelyRetry: !duringFlash,
      technicalDetails: rawError,
    );
  }

  /// Checks multiple package IDs in a single `adb shell pm list packages` invocation.
  Future<Set<String>> checkInstalledPackages(
    Set<String> packageNames, {
    String? serial,
    LogCallback? onLog,
  }) async {
    if (packageNames.isEmpty) return const {};
    try {
      final args = <String>[
        if (serial != null) ...['-s', serial],
        'shell',
        'pm',
        'list',
        'packages',
      ];
      final result = await _runAdb(args, onLog: onLog);
      if (result.exitCode != 0) return const {};
      final installed = <String>{};
      for (final rawLine in result.stdout.toString().split('\n')) {
        final line = rawLine.trim();
        if (!line.startsWith('package:')) continue;
        final pkg = line.substring(8);
        if (packageNames.contains(pkg)) {
          installed.add(pkg);
        }
      }
      return installed;
    } catch (e) {
      onLog?.call(appL10n.errCheckClientFailed(e));
      return const {};
    }
  }

  /// Checks whether [packageName] is installed on the target ADB device.
  Future<bool> checkAppInstalled(
    String packageName, {
    String? serial,
    LogCallback? onLog,
  }) async {
    final installed = await checkInstalledPackages(
      {packageName},
      serial: serial,
      onLog: onLog,
    );
    return installed.contains(packageName);
  }

  Future<bool> checkAPatchInstalled({String? serial, LogCallback? onLog}) =>
      checkAppInstalled(
        AppConfig.apatchPackageName,
        serial: serial,
        onLog: onLog,
      );

  Future<bool> checkFolkPatchInstalled({String? serial, LogCallback? onLog}) =>
      checkAppInstalled(
        AppConfig.folkpatchPackageName,
        serial: serial,
        onLog: onLog,
      );

  Future<bool> installApk(
    String apkPath, {
    String? serial,
    LogCallback? onLog,
  }) async {
    try {
      if (!await File(apkPath).exists()) {
        onLog?.call(appL10n.errApkNotFound(apkPath));
        return false;
      }

      onLog?.call(appL10n.logInstallingApk(apkPath));
      final args = <String>[
        if (serial != null) ...['-s', serial],
        'install',
        '-r',
        apkPath,
      ];
      final result = await _runAdb(args, onLog: onLog);

      if (result.exitCode == 0) {
        final output = result.stdout.toString().toLowerCase();
        if (output.contains('success')) {
          onLog?.call(appL10n.logInstallApkSuccess);
          return true;
        }
      }

      onLog?.call(appL10n.errInstallApkFailed(result.stderr));
      return false;
    } catch (e) {
      onLog?.call(appL10n.errInstallApkException(e));
      return false;
    }
  }

  Future<bool> installAPatch({String? serial, LogCallback? onLog}) async =>
      installApk(AppConfig.apatchApkPath, serial: serial, onLog: onLog);

  /// Queries current battery percentage over ADB.
  Future<int?> getBatteryLevel({String? serial, LogCallback? onLog}) async {
    try {
      final args = <String>[
        if (serial != null) ...['-s', serial],
        'shell',
        'dumpsys',
        'battery',
      ];
      final result = await _runAdb(args, onLog: onLog);
      if (result.exitCode != 0) return null;
      return parseBatteryLevel(result.stdout.toString());
    } catch (_) {
      return null;
    }
  }

  Future<bool> installFolkPatch({String? serial, LogCallback? onLog}) async =>
      installApk(AppConfig.folkpatchApkPath, serial: serial, onLog: onLog);
}
