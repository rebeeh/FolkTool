import 'dart:io';
import '../../../core/config/app_config.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/l10n/l10n_helper.dart';
import '../../device/models/device_info.dart';

/// Result of pre-flight safety checks executed before patching/flashing.
class PreflightResult {
  final bool passed;
  final List<String> warnings;
  final List<String> errors;
  final AppError? primaryError;

  const PreflightResult({
    required this.passed,
    this.warnings = const [],
    this.errors = const [],
    this.primaryError,
  });
}

/// Validates environment, binary presence, image magic, device readiness,
/// kernel compatibility range, and battery level.
class SafetyService {
  static const int minRecommendedBatteryPercent = 20;
  static const List<int> _androidBootMagic = [
    0x41, 0x4E, 0x44, 0x52, 0x4F, 0x49, 0x44, 0x21, // "ANDROID!"
  ];

  /// Checks whether the Linux kernel version falls within [minKernel] – [maxKernel].
  static bool isKernelCompatible(
    String? kernelVersion, {
    String minKernel = '3.18',
    String maxKernel = '6.15',
  }) {
    if (kernelVersion == null || kernelVersion.trim().isEmpty) {
      return false;
    }
    final match = RegExp(r'^(\d+)\.(\d+)').firstMatch(kernelVersion.trim());
    if (match == null) return false;
    final major = int.tryParse(match.group(1) ?? '');
    final minor = int.tryParse(match.group(2) ?? '');
    if (major == null || minor == null) return false;

    final minParts = minKernel.split('.').map(int.tryParse).toList();
    final maxParts = maxKernel.split('.').map(int.tryParse).toList();
    final minMajor = minParts[0] ?? 3;
    final minMinor = minParts.length > 1 ? (minParts[1] ?? 18) : 0;
    final maxMajor = maxParts[0] ?? 6;
    final maxMinor = maxParts.length > 1 ? (maxParts[1] ?? 15) : 99;

    final cur = major * 1000 + minor;
    final low = minMajor * 1000 + minMinor;
    final high = maxMajor * 1000 + maxMinor;
    return cur >= low && cur <= high;
  }

  /// Checks whether [path] starts with the standard `ANDROID!` boot image magic.
  static Future<bool> hasAndroidBootMagic(String path) async {
    try {
      final header = await _readFileHeader(path, 8);
      if (header.length < 8) return false;
      for (var i = 0; i < 8; i++) {
        if (header[i] != _androidBootMagic[i]) return false;
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<List<int>> _readFileHeader(String path, int length) async {
    final raf = await File(path).open(mode: FileMode.read);
    try {
      return await raf.read(length);
    } finally {
      await raf.close();
    }
  }

  /// Runs pre-flight checks on required files, device state, and environment.
  Future<PreflightResult> runPreflightChecks({
    required String bootImagePath,
    String? kpimgPath,
    String? kptoolsPathOverride,
    String minKernel = '3.18',
    String maxKernel = '6.15',
    List<String> kpmModules = const [],
    DeviceInfo? deviceInfo,
    int? batteryLevel,
    bool checkBinaries = true,
    bool checkImageMagic = false,
    bool requireConnectedDevice = false,
    int connectedDeviceCount = 1,
  }) async {
    final l10n = appL10n;
    final errors = <String>[];
    final warnings = <String>[];
    AppError? primaryError;

    void addError(String msg, AppError err) {
      errors.add(msg);
      primaryError ??= err;
    }

    final bootFile = File(bootImagePath);
    if (!await bootFile.exists()) {
      addError(
        l10n.errInputNotExist(bootImagePath),
        AppError(
          category: AppErrorCategory.file,
          title: l10n.errTitleBootNotFound,
          message: l10n.errMsgBootNotFound,
          affectedStage: 'Preflight',
          deviceSafe: true,
          nextSteps: l10n.errNextSelectBoot,
          canSafelyRetry: true,
          technicalDetails: bootImagePath,
        ),
      );
    } else {
      final length = await bootFile.length();
      if (length == 0) {
        addError(
          l10n.errMsgEmptyBoot,
          AppError(
            category: AppErrorCategory.imageValidation,
            title: l10n.errTitleEmptyBoot,
            message: l10n.errMsgEmptyBoot,
            affectedStage: 'Validation',
            deviceSafe: true,
            nextSteps: l10n.errNextEmptyBoot,
            canSafelyRetry: true,
            technicalDetails: bootImagePath,
          ),
        );
      } else {
        try {
          final header = await _readFileHeader(bootImagePath, 8);
          if (checkImageMagic) {
            final matchesMagic = header.length >= 8 &&
                List.generate(8, (i) => header[i] == _androidBootMagic[i])
                    .every((matched) => matched);
            if (!matchesMagic) {
              warnings.add(l10n.warnNonStandardBootMagic);
            }
          }
        } catch (e) {
          addError(
            l10n.errMsgCannotReadBoot,
            AppError(
              category: AppErrorCategory.permission,
              title: l10n.errTitleCannotReadBoot,
              message: l10n.errMsgCannotReadBoot,
              affectedStage: 'Validation',
              deviceSafe: true,
              nextSteps: l10n.errNextCannotReadBoot,
              canSafelyRetry: true,
              technicalDetails: e.toString(),
            ),
          );
        }
      }
    }

    if (kpimgPath != null && kpimgPath.isNotEmpty) {
      final kpFile = File(kpimgPath);
      if (!await kpFile.exists() || await kpFile.length() == 0) {
        addError(
          l10n.errKpimgNotExist(kpimgPath),
          AppError(
            category: AppErrorCategory.file,
            title: l10n.errTitleMissingKpimg,
            message: l10n.errMsgMissingKpimg,
            affectedStage: 'Preflight',
            deviceSafe: true,
            nextSteps: l10n.errNextMissingKpimg,
            canSafelyRetry: true,
            technicalDetails: kpimgPath,
          ),
        );
      }
    }

    for (final kpmPath in kpmModules) {
      final kpmFile = File(kpmPath);
      if (!await kpmFile.exists() || await kpmFile.length() == 0) {
        addError(
          l10n.errMsgInvalidKpm(kpmPath),
          AppError(
            category: AppErrorCategory.file,
            title: l10n.errTitleInvalidKpm,
            message: l10n.errMsgInvalidKpm(kpmPath),
            affectedStage: 'Preflight',
            deviceSafe: true,
            nextSteps: l10n.errNextInvalidKpm,
            canSafelyRetry: true,
            technicalDetails: kpmPath,
          ),
        );
      }
    }

    if (checkBinaries) {
      final effectiveKptools =
          (kptoolsPathOverride != null &&
                  kptoolsPathOverride.isNotEmpty &&
                  await File(kptoolsPathOverride).exists())
              ? kptoolsPathOverride
              : AppConfig.kptoolsPath;
      final requiredBins = <String, String>{
        'kptools': effectiveKptools,
        'adb': AppConfig.adbPath,
        'fastboot': AppConfig.fastbootPath,
      };
      for (final entry in requiredBins.entries) {
        if (!await File(entry.value).exists()) {
          addError(
            l10n.errMsgMissingTool(entry.key),
            AppError(
              category: AppErrorCategory.file,
              title: l10n.errTitleMissingTool(entry.key),
              message: l10n.errMsgMissingTool(entry.key),
              affectedStage: 'Preflight',
              deviceSafe: true,
              nextSteps: l10n.errNextMissingTool,
              canSafelyRetry: false,
              technicalDetails: entry.value,
            ),
          );
        }
      }
    }

    if (requireConnectedDevice) {
      if (connectedDeviceCount > 1) {
        addError(
          l10n.errMsgMultipleDevices,
          AppError(
            category: AppErrorCategory.deviceConnection,
            title: l10n.errTitleMultipleDevices,
            message: l10n.errMsgMultipleDevices,
            affectedStage: 'Preflight',
            deviceSafe: true,
            nextSteps: l10n.errNextMultipleDevices,
            canSafelyRetry: true,
          ),
        );
      } else if (deviceInfo == null ||
          deviceInfo.state == DeviceState.disconnected) {
        addError(
          l10n.errMsgNoDevice,
          AppError(
            category: AppErrorCategory.deviceConnection,
            title: l10n.errTitleNoDevice,
            message: l10n.errMsgNoDevice,
            affectedStage: 'Preflight',
            deviceSafe: true,
            nextSteps: l10n.errNextNoDevice,
            canSafelyRetry: true,
          ),
        );
      } else if (deviceInfo.state == DeviceState.unauthorized) {
        addError(
          l10n.errMsgUnauthorized(deviceInfo.serial),
          AppError(
            category: AppErrorCategory.adb,
            title: l10n.errTitleUnauthorized,
            message: l10n.errMsgUnauthorized(deviceInfo.serial),
            affectedStage: 'Preflight',
            deviceSafe: true,
            nextSteps: l10n.errNextUnauthorized,
            canSafelyRetry: true,
          ),
        );
      } else if (deviceInfo.state == DeviceState.offline) {
        addError(
          l10n.errMsgOffline(deviceInfo.serial),
          AppError(
            category: AppErrorCategory.deviceConnection,
            title: l10n.errTitleOffline,
            message: l10n.errMsgOffline(deviceInfo.serial),
            affectedStage: 'Preflight',
            deviceSafe: true,
            nextSteps: l10n.errNextOffline,
            canSafelyRetry: true,
          ),
        );
      } else if (deviceInfo.state == DeviceState.fastbootd) {
        addError(
          l10n.errMsgFastbootdBlocked(deviceInfo.serial),
          AppError(
            category: AppErrorCategory.fastboot,
            title: l10n.errTitleFastbootdBlocked,
            message: l10n.errMsgFastbootdBlocked(deviceInfo.serial),
            affectedStage: 'Preflight',
            deviceSafe: true,
            nextSteps: l10n.fastbootdDetectedDesc,
            canSafelyRetry: true,
          ),
        );
      } else if (deviceInfo.state == DeviceState.recovery ||
          deviceInfo.state == DeviceState.sideload ||
          deviceInfo.state == DeviceState.unsupported) {
        addError(
          l10n.unsupportedModeDesc,
          AppError(
            category: AppErrorCategory.deviceConnection,
            title: l10n.unsupportedModeTitle(
              deviceInfo.localizedStateText(l10n),
              deviceInfo.serial,
            ),
            message: l10n.unsupportedModeDesc,
            affectedStage: 'Preflight',
            deviceSafe: true,
            nextSteps: l10n.errNextNoDevice,
            canSafelyRetry: true,
          ),
        );
      } else if (deviceInfo.bootloaderUnlocked == false) {
        addError(
          l10n.errMsgBootloaderLocked,
          AppError(
            category: AppErrorCategory.fastboot,
            title: l10n.errTitleBootloaderLocked,
            message: l10n.errMsgBootloaderLocked,
            affectedStage: 'Preflight',
            deviceSafe: true,
            nextSteps: l10n.errNextBootloaderLocked,
            canSafelyRetry: false,
          ),
        );
      }
    }

    if (deviceInfo != null &&
        deviceInfo.kernelVersion != null &&
        deviceInfo.kernelVersion!.isNotEmpty &&
        !isKernelCompatible(
          deviceInfo.kernelVersion,
          minKernel: minKernel,
          maxKernel: maxKernel,
        )) {
      warnings.add(
        l10n.warnKernelOutOfRange(
          deviceInfo.kernelVersion!,
          '$minKernel - $maxKernel',
        ),
      );
    }

    final effectiveBattery = batteryLevel ?? deviceInfo?.batteryLevel;
    if (effectiveBattery != null &&
        effectiveBattery < minRecommendedBatteryPercent) {
      warnings.add(
        l10n.warnLowBattery(effectiveBattery, minRecommendedBatteryPercent),
      );
    }

    return PreflightResult(
      passed: errors.isEmpty,
      warnings: warnings,
      errors: errors,
      primaryError: primaryError,
    );
  }
}