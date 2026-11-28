import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../../core/process/process_runner.dart';

class DriverInfo {
  final String name;
  final String description;
  final String executableName;
  final String icon;
  final String publisher;
  final String supportedModes;
  final String? officialUrl;
  final bool isExternalOfficialDownload;

  const DriverInfo({
    required this.name,
    required this.description,
    required this.executableName,
    required this.icon,
    required this.publisher,
    required this.supportedModes,
    this.officialUrl,
    this.isExternalOfficialDownload = false,
  });
}

class DriverSignatureResult {
  final bool checked;
  final bool isValid;
  final String status;
  final String? signer;
  final String? signatureAlgorithm;

  const DriverSignatureResult({
    required this.checked,
    required this.isValid,
    required this.status,
    this.signer,
    this.signatureAlgorithm,
  });
}

class DriverInstallResult {
  final bool launched;
  final int? exitCode;
  final bool rebootRequired;
  final String? errorMessage;
  final DriverSignatureResult? signature;

  const DriverInstallResult({
    required this.launched,
    this.exitCode,
    this.rebootRequired = false,
    this.errorMessage,
    this.signature,
  });
}

class DriverService {
  final ProcessRunner _processRunner;
  final Future<String> Function(String executableName)? _driverPathOverride;

  DriverService({
    ProcessRunner? processRunner,
    Future<String> Function(String executableName)? driverPathOverride,
  })  : _processRunner = processRunner ?? const DefaultProcessRunner(),
        _driverPathOverride = driverPathOverride;

  static const DriverInfo samsungDriver = DriverInfo(
    name: 'Samsung USB Driver for Mobile Phones',
    description:
        'Official Samsung Electronics USB driver for Galaxy devices (ADB & Download/Odin mode). Opens the official Samsung Developers download page.',
    executableName: '',
    icon: 'smartphone',
    publisher: 'Samsung Electronics Co., Ltd.',
    supportedModes: 'ADB / MTP / Download Mode',
    officialUrl: 'https://developer.samsung.com/android-usb-driver',
    isExternalOfficialDownload: true,
  );

  static const List<DriverInfo> drivers = [
    DriverInfo(
      name: 'qualcommDriver64',
      description: 'qualcommDriver64Desc',
      executableName: 'fastboot_driver_64.exe',
      icon: 'memory',
      publisher: 'Kingsoft-wrapped Fastboot Driver (Legacy SHA-1, 64-bit)',
      supportedModes: 'Fastboot (64-bit)',
    ),
    DriverInfo(
      name: 'qualcommDriver32',
      description: 'qualcommDriver32Desc',
      executableName: 'fastboot_driver_32.exe',
      icon: 'memory',
      publisher: 'Kingsoft-wrapped Fastboot Driver (Legacy SHA-1, 32-bit)',
      supportedModes: 'Fastboot (32-bit)',
    ),
    DriverInfo(
      name: 'mediatekDriver',
      description: 'mediatekDriverDesc',
      executableName: 'MTK_USB_All_v1.0.8.exe',
      icon: 'developer_board',
      publisher: 'MediaTek Inc. (Bundled, Unsigned)',
      supportedModes: 'ADB / Fastboot / VCOM',
    ),
    DriverInfo(
      name: 'oneplusAdbDriver',
      description: 'oneplusAdbDriverDesc',
      executableName: 'adb_driver.exe',
      icon: 'phone_android',
      publisher: 'OnePlus Technology (Bundled, Unsigned)',
      supportedModes: 'ADB / Fastboot',
    ),
    DriverInfo(
      name: 'oppoAdbDriver',
      description: 'oppoAdbDriverDesc',
      executableName: 'Oppo+USB+Driver+Setup+V4.0.1.6.exe',
      icon: 'smartphone',
      publisher: 'Guangdong OPPO Mobile Telecommunications Corp., Ltd.',
      supportedModes: 'ADB / Fastboot',
    ),
  ];

  Future<String> _getDriverPath(String executableName) async {
    if (_driverPathOverride != null) {
      return _driverPathOverride(executableName);
    }
    final appDir = await getApplicationDocumentsDirectory();
    final driverDir = p.join(appDir.path, 'FolkTool', 'drivers');
    final driverPath = p.join(driverDir, executableName);

    final file = File(driverPath);
    if (!await file.exists()) {
      await file.parent.create(recursive: true);
      final assetPath = 'drive/$executableName';
      final data = await rootBundle.load(assetPath);
      await file.writeAsBytes(data.buffer.asUint8List());
    }

    return driverPath;
  }

  /// Checks Windows Authenticode signature for an extracted driver installer.
  Future<DriverSignatureResult> verifySignature(String filePath) async {
    return verifySignatureOnPlatform(
      filePath,
      isWindowsOverride: Platform.isWindows,
    );
  }

  /// Checks Windows Authenticode signature with an optional Windows platform override for tests.
  Future<DriverSignatureResult> verifySignatureOnPlatform(
    String filePath, {
    required bool isWindowsOverride,
  }) async {
    if (!isWindowsOverride) {
      return const DriverSignatureResult(
        checked: false,
        isValid: true,
        status: 'Non-Windows host',
      );
    }
    try {
      final result = await _processRunner.run(
        'powershell',
        [
          '-NoProfile',
          '-NonInteractive',
          '-Command',
          r'$sig = Get-AuthenticodeSignature -LiteralPath $args[0]; '
              r'$alg = if ($sig.SignerCertificate) { $sig.SignerCertificate.SignatureAlgorithm.FriendlyName } else { "" }; '
              r'Write-Output "$($sig.Status)|$($sig.SignerCertificate.Subject)|$alg"',
          filePath,
        ],
        timeout: const Duration(seconds: 15),
      );
      if (result.exitCode != 0) {
        return const DriverSignatureResult(
          checked: true,
          isValid: false,
          status: 'VerificationError',
        );
      }
      final out = result.stdout.toString().trim();
      final parts = out.split('|');
      final status = parts.isNotEmpty ? parts[0].trim() : 'Unknown';
      final signer = parts.length > 1 ? parts[1].trim() : null;
      final sigAlg = parts.length > 2 ? parts[2].trim() : null;
      return DriverSignatureResult(
        checked: true,
        isValid: status == 'Valid',
        status: status,
        signer: (signer != null && signer.isNotEmpty) ? signer : null,
        signatureAlgorithm:
            (sigAlg != null && sigAlg.isNotEmpty) ? sigAlg : null,
      );
    } catch (e) {
      return DriverSignatureResult(
        checked: true,
        isValid: false,
        status: 'Error: $e',
      );
    }
  }

  /// Verifies Authenticode signature, requests on-demand UAC elevation on Windows,
  /// and inspects the driver installer's actual exit code.
  Future<DriverInstallResult> installDriverDetailed(
    String executableName, {
    bool allowUnsigned = false,
    bool? isWindowsOverride,
  }) async {
    final isWindows = isWindowsOverride ?? Platform.isWindows;
    try {
      final driverPath = await _getDriverPath(executableName);
      final file = File(driverPath);

      if (!await file.exists()) {
        return const DriverInstallResult(
          launched: false,
          errorMessage: 'Driver executable not found after extraction.',
        );
      }

      final sig = await verifySignatureOnPlatform(
        driverPath,
        isWindowsOverride: isWindows,
      );
      if (sig.checked && !sig.isValid && !allowUnsigned) {
        return DriverInstallResult(
          launched: false,
          signature: sig,
          errorMessage:
              'Authenticode signature status is "${sig.status}". Refusing to run unverified installer automatically.',
        );
      }

      final result = isWindows
          ? await _processRunner.run(
              'powershell',
              [
                '-NoProfile',
                '-NonInteractive',
                '-Command',
                r'try { '
                    r'$p = Start-Process -FilePath $args[0] -Verb RunAs -Wait -PassThru -ErrorAction Stop; '
                    r'if ($null -eq $p) { exit 1 }; exit $p.ExitCode '
                    r'} catch [System.ComponentModel.Win32Exception] { '
                    r'if ($_.Exception.NativeErrorCode -ne 0) { exit $_.Exception.NativeErrorCode }; '
                    r'exit 1 }',
                driverPath,
              ],
              timeout: const Duration(minutes: 10),
            )
          : await _processRunner.run(
              driverPath,
              const [],
              timeout: const Duration(minutes: 10),
            );

      final code = result.exitCode;
      if (code == 0 || code == 3010) {
        return DriverInstallResult(
          launched: true,
          exitCode: code,
          rebootRequired: code == 3010,
          signature: sig,
        );
      }

      if (code == 1223) {
        return DriverInstallResult(
          launched: false,
          exitCode: code,
          signature: sig,
          errorMessage:
              'Administrator permission (UAC) prompt was cancelled by the user.',
        );
      }

      final stderr = result.stderr.toString().trim();
      return DriverInstallResult(
        launched: false,
        exitCode: code,
        signature: sig,
        errorMessage: stderr.isNotEmpty
            ? 'Driver installer failed (exit code $code): $stderr'
            : 'Driver installer failed with exit code $code.',
      );
    } catch (e) {
      return DriverInstallResult(
        launched: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> installDriver(
    String executableName, {
    bool? isWindowsOverride,
  }) async {
    final res = await installDriverDetailed(
      executableName,
      isWindowsOverride: isWindowsOverride,
    );
    return res.launched;
  }
}
