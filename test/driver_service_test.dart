import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:FolkTool/core/process/process_runner.dart';
import 'package:FolkTool/features/drivers/services/driver_service.dart';

class _ScriptedDriverRunner implements ProcessRunner {
  final String signatureOutput;
  final int installerExitCode;
  final String installerStderr;
  final List<(String exe, List<String> args)> invocations = [];

  _ScriptedDriverRunner({
    required this.signatureOutput,
    this.installerExitCode = 0,
    this.installerStderr = '',
  });

  @override
  Future<ProcessResult> run(
    String executable,
    List<String> arguments, {
    String? workingDirectory,
    Duration? timeout,
  }) async {
    invocations.add((executable, List<String>.from(arguments)));
    final cmd = arguments.join(' ');
    if (cmd.contains('Get-AuthenticodeSignature')) {
      return ProcessResult(1, 0, signatureOutput, '');
    }
    return ProcessResult(1, installerExitCode, '', installerStderr);
  }
}

void main() {
  group('DriverService signature & on-demand UAC elevation', () {
    late Directory tmpDir;
    late File dummyInstaller;

    setUp(() async {
      tmpDir = await Directory.systemTemp.createTemp('folktool_drv_test_');
      dummyInstaller = File('${tmpDir.path}/driver_setup.exe');
      await dummyInstaller.writeAsBytes([0x4D, 0x5A, 0x90, 0x00]);
    });

    tearDown(() async {
      if (await tmpDir.exists()) {
        await tmpDir.delete(recursive: true);
      }
    });

    test('blocks unsigned driver installer before requesting UAC', () async {
      final runner = _ScriptedDriverRunner(
        signatureOutput: 'NotSigned||',
      );
      final service = DriverService(
        processRunner: runner,
        driverPathOverride: (_) async => dummyInstaller.path,
      );

      final res = await service.installDriverDetailed(
        'driver_setup.exe',
        isWindowsOverride: true,
      );

      expect(res.launched, isFalse);
      expect(res.signature?.checked, isTrue);
      expect(res.signature?.isValid, isFalse);
      expect(res.errorMessage, contains('NotSigned'));
      expect(runner.invocations.length, 1);
      expect(
        runner.invocations.single.$2.join(' '),
        contains('Get-AuthenticodeSignature'),
      );
      expect(
        await service.installDriver(
          'driver_setup.exe',
          isWindowsOverride: true,
        ),
        isFalse,
      );
    });

    test('elevates signed installer via -Verb RunAs and verifies exit 0',
        () async {
      final runner = _ScriptedDriverRunner(
        signatureOutput: 'Valid|CN=OPPO Corp|sha256RSA',
        installerExitCode: 0,
      );
      final service = DriverService(
        processRunner: runner,
        driverPathOverride: (_) async => dummyInstaller.path,
      );

      final res = await service.installDriverDetailed(
        'driver_setup.exe',
        isWindowsOverride: true,
      );

      expect(res.launched, isTrue);
      expect(res.exitCode, 0);
      expect(res.rebootRequired, isFalse);
      expect(res.signature?.signatureAlgorithm, 'sha256RSA');
      expect(runner.invocations.length, 2);
      expect(runner.invocations[1].$1, 'powershell');
      expect(runner.invocations[1].$2.join(' '), contains('-Verb RunAs'));
    });

    test('recognizes exit code 3010 as success with rebootRequired', () async {
      final runner = _ScriptedDriverRunner(
        signatureOutput: 'Valid|CN=OPPO Corp|sha256RSA',
        installerExitCode: 3010,
      );
      final service = DriverService(
        processRunner: runner,
        driverPathOverride: (_) async => dummyInstaller.path,
      );

      final res = await service.installDriverDetailed(
        'driver_setup.exe',
        isWindowsOverride: true,
      );

      expect(res.launched, isTrue);
      expect(res.exitCode, 3010);
      expect(res.rebootRequired, isTrue);
    });

    test('handles UAC cancellation (1223) and installer failures honestly',
        () async {
      final cancelRunner = _ScriptedDriverRunner(
        signatureOutput: 'Valid|CN=OPPO Corp|sha256RSA',
        installerExitCode: 1223,
      );
      final cancelService = DriverService(
        processRunner: cancelRunner,
        driverPathOverride: (_) async => dummyInstaller.path,
      );

      final cancelRes = await cancelService.installDriverDetailed(
        'driver_setup.exe',
        isWindowsOverride: true,
      );
      expect(cancelRes.launched, isFalse);
      expect(cancelRes.exitCode, 1223);
      expect(cancelRes.errorMessage, contains('cancelled'));

      final failRunner = _ScriptedDriverRunner(
        signatureOutput: 'Valid|CN=OPPO Corp|sha256RSA',
        installerExitCode: 1603,
        installerStderr: 'Fatal error during installation',
      );
      final failService = DriverService(
        processRunner: failRunner,
        driverPathOverride: (_) async => dummyInstaller.path,
      );

      final failRes = await failService.installDriverDetailed(
        'driver_setup.exe',
        isWindowsOverride: true,
      );
      expect(failRes.launched, isFalse);
      expect(failRes.exitCode, 1603);
      expect(failRes.errorMessage, contains('1603'));
    });
  });
}
