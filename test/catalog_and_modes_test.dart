import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:FolkTool/core/process/process_runner.dart';
import 'package:FolkTool/features/device/models/device_info.dart';
import 'package:FolkTool/features/device/providers/device_provider.dart';
import 'package:FolkTool/features/device/services/device_service.dart';
import 'package:FolkTool/features/patching/models/kp_version.dart';
import 'package:FolkTool/features/patching/models/patch_target.dart';
import 'package:FolkTool/features/patching/providers/version_provider.dart';
import 'package:FolkTool/features/patching/services/safety_service.dart';
import 'package:FolkTool/generated/l10n.dart';

class _MockRunner implements ProcessRunner {
  final Future<ProcessResult> Function(String exe, List<String> args) fn;
  _MockRunner(this.fn);

  @override
  Future<ProcessResult> run(
    String executable,
    List<String> arguments, {
    String? workingDirectory,
    Duration? timeout,
  }) =>
      fn(executable, arguments);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Pinned toolchain manifest & independent APatch/FolkPatch catalogues', () {
    test('toolchain_manifest.json defines Platform-Tools 37.0.3 and isolated targets',
        () async {
      final file = File('assets/manifests/toolchain_manifest.json');
      expect(await file.exists(), isTrue);

      final parsed = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      final pt = parsed['platformTools'] as Map<String, dynamic>;
      expect(pt['version'], '37.0.3');
      expect((pt['zipSha256'] as String).length, 64);

      final targets = parsed['targets'] as Map<String, dynamic>;
      expect(targets.keys, containsAll(['folkpatch', 'apatch']));

      final fpReleases =
          (targets['folkpatch'] as Map<String, dynamic>)['releases'] as List;
      final apReleases =
          (targets['apatch'] as Map<String, dynamic>)['releases'] as List;

      expect(fpReleases, isNotEmpty);
      expect(apReleases, isNotEmpty);

      for (final rel in fpReleases.cast<Map<String, dynamic>>()) {
        expect(rel['product'], 'FolkPatch');
        expect((rel['apkSha256'] as String).length, 64);
        expect((rel['kpimgSha256'] as String).length, 64);
      }
      for (final rel in apReleases.cast<Map<String, dynamic>>()) {
        expect(rel['product'], 'APatch');
        expect((rel['apkSha256'] as String).length, 64);
        expect((rel['kpimgSha256'] as String).length, 64);
      }
    });

    test('KpVersion parses KP1158 binary headers accurately and rejects invalid headers',
        () {
      // Header 0.13.9 -> bytes [9]=9, [10]=13, [11]=0
      expect(
        KpVersion.parseKpimgHeaderVersion(
          [0x4B, 0x50, 0x31, 0x31, 0x35, 0x38, 0x00, 0x00, 0x00, 0x09, 0x0D, 0x00],
        ),
        '0.13.9',
      );
      expect(
        KpVersion.parseKpimgHeaderVersion(
          [0x4B, 0x50, 0x31, 0x31, 0x35, 0x38, 0x00, 0x00, 0x00, 0x02, 0x0C, 0x00],
        ),
        '0.12.2',
      );
      expect(
        KpVersion.parseKpimgHeaderVersion([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]),
        isNull,
      );
    });

    test('VersionProvider separates FolkPatch and APatch lists and saved selections',
        () async {
      final provider = VersionProvider();
      await provider.loadVersions();
      expect(provider.currentTarget, PatchTarget.folkpatch);
      expect(
        provider.availableVersions.every((v) => v.source == PatchTarget.folkpatch),
        isTrue,
      );

      provider.setTarget(PatchTarget.apatch);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(provider.currentTarget, PatchTarget.apatch);
      expect(
        provider.availableVersions.every((v) => v.source == PatchTarget.apatch),
        isTrue,
      );
    });
  });

  group('Extended device modes, fastbootd detection & kernel bounds', () {
    test('parses recovery, sideload, unsupported, fastboot, and fastbootd states', () {
      expect(DeviceInfo.fromAdbLine('R1\trecovery').state, DeviceState.recovery);
      expect(DeviceInfo.fromAdbLine('S1\tsideload').state, DeviceState.sideload);
      expect(
        DeviceInfo.fromAdbLine('U1\tauthorizing').state,
        DeviceState.unsupported,
      );
      expect(
        DeviceInfo.fromFastbootLine('F1\tfastboot').state,
        DeviceState.fastboot,
      );
      expect(
        DeviceInfo.fromFastbootLine('FD1\tfastbootd').state,
        DeviceState.fastbootd,
      );
    });

    test('DeviceProvider promotes fastboot device to fastbootd when is-userspace=yes and blocks preflight flash',
        () async {
      final runner = _MockRunner((exe, args) async {
        if (exe.endsWith('adb.exe')) {
          return ProcessResult(1, 0, 'List of devices attached\n', '');
        }
        if (args.contains('devices')) {
          return ProcessResult(1, 0, 'DEV_FBD\tfastboot\n', '');
        }
        if (args.contains('is-userspace')) {
          return ProcessResult(1, 0, '', 'is-userspace: yes\nFinished.');
        }
        if (args.contains('unlocked')) {
          return ProcessResult(1, 0, '', 'unlocked: yes\nFinished.');
        }
        return ProcessResult(1, 0, '', '');
      });

      final provider = DeviceProvider(
        deviceService: DeviceService(
          processRunner: runner,
          skipBinaryExistsCheck: true,
        ),
      );
      await provider.refreshDevices();

      expect(provider.connectionState, DeviceConnectionState.fastbootdConnected);
      expect(provider.hasFastbootdDevice, isTrue);
      expect(provider.hasFastbootDevice, isFalse);

      final tmp = await Directory.systemTemp.createTemp('folktool_fbd_');
      addTearDown(() => tmp.delete(recursive: true));
      final bootImg = File('${tmp.path}/boot.img')
        ..writeAsBytesSync('ANDROID!'.codeUnits + List.filled(32, 0));

      final preflight = await SafetyService().runPreflightChecks(
        bootImagePath: bootImg.path,
        deviceInfo: provider.selectedTargetDevice,
        checkBinaries: false,
        requireConnectedDevice: true,
        connectedDeviceCount: 1,
      );
      expect(preflight.passed, isFalse);
      expect(preflight.primaryError?.deviceSafe, isTrue);
    });

    test('SafetyService respects FolkPatch 6.18 upper kernel limit when configured', () {
      expect(
        SafetyService.isKernelCompatible('6.18.2', maxKernel: '6.15'),
        isFalse,
      );
      expect(
        SafetyService.isKernelCompatible('6.18.2', maxKernel: '6.18'),
        isTrue,
      );
    });

    test('Localization loads clean EN & ZH strings with Samsung Download distinction',
        () async {
      final en = await S.load(const Locale('en'));
      expect(en.deviceConnectionTipsDesc, contains('Samsung Download Mode'));
      expect(en.navDashboard, 'Dashboard');

      final zh = await S.load(const Locale('zh'));
      expect(zh.deviceConnectionTipsDesc, contains('三星 Download 模式'));
      expect(zh.navDashboard, '概览');

      // Reset default back to English for subsequent unit tests
      await S.load(const Locale('en'));
    });
  });
}