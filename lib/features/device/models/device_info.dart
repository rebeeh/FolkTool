import '../../../core/l10n/l10n_helper.dart';
import '../../../generated/l10n.dart';

enum DeviceState {
  disconnected,
  adb,
  unauthorized,
  offline,
  recovery,
  sideload,
  fastboot,
  fastbootd,
  unsupported,
  error,
  unknown,
}

class DeviceInfo {
  final String serial;
  final DeviceState state;
  final String? rawState;
  final String? model;
  final String? androidVersion;
  final String? kernelVersion;
  final int? batteryLevel;
  final bool? bootloaderUnlocked;

  DeviceInfo({
    required this.serial,
    required this.state,
    this.rawState,
    this.model,
    this.androidVersion,
    this.kernelVersion,
    this.batteryLevel,
    this.bootloaderUnlocked,
  });

  bool get isAuthorizedAdb => state == DeviceState.adb;
  bool get isFastboot => state == DeviceState.fastboot;
  bool get isFastbootd => state == DeviceState.fastbootd;
  bool get isAnyFastboot => isFastboot || isFastbootd;
  bool get isReadyForOperation => isAuthorizedAdb || isFastboot;

  DeviceInfo copyWith({
    String? serial,
    DeviceState? state,
    String? rawState,
    String? model,
    String? androidVersion,
    String? kernelVersion,
    int? batteryLevel,
    bool? bootloaderUnlocked,
  }) {
    return DeviceInfo(
      serial: serial ?? this.serial,
      state: state ?? this.state,
      rawState: rawState ?? this.rawState,
      model: model ?? this.model,
      androidVersion: androidVersion ?? this.androidVersion,
      kernelVersion: kernelVersion ?? this.kernelVersion,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      bootloaderUnlocked: bootloaderUnlocked ?? this.bootloaderUnlocked,
    );
  }

  String localizedStateText(S l10n) {
    switch (state) {
      case DeviceState.disconnected:
        return l10n.deviceStateDisconnected;
      case DeviceState.adb:
        return l10n.deviceStateAdb;
      case DeviceState.unauthorized:
        return l10n.deviceStateUnauthorized;
      case DeviceState.offline:
        return l10n.deviceStateOffline;
      case DeviceState.recovery:
        return l10n.deviceStateRecovery;
      case DeviceState.sideload:
        return l10n.deviceStateSideload;
      case DeviceState.fastboot:
        return l10n.deviceStateFastboot;
      case DeviceState.fastbootd:
        return l10n.deviceStateFastbootd;
      case DeviceState.unsupported:
        return rawState ?? l10n.deviceStateUnsupported;
      case DeviceState.error:
        return l10n.deviceStateError;
      case DeviceState.unknown:
        return l10n.unknown;
    }
  }

  String get stateText => localizedStateText(appL10n);

  factory DeviceInfo.fromAdbLine(String line) {
    final parts = line.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      final serial = parts[0];
      final rawToken = parts[1].toLowerCase();
      DeviceState state;
      switch (rawToken) {
        case 'device':
          state = DeviceState.adb;
          break;
        case 'unauthorized':
          state = DeviceState.unauthorized;
          break;
        case 'offline':
          state = DeviceState.offline;
          break;
        case 'recovery':
          state = DeviceState.recovery;
          break;
        case 'sideload':
          state = DeviceState.sideload;
          break;
        case 'authorizing':
        case 'connecting':
        case 'bootloader':
        case 'rescue':
          state = DeviceState.unsupported;
          break;
        default:
          state = DeviceState.unsupported;
          break;
      }
      String? model;
      for (final token in parts.skip(2)) {
        if (token.startsWith('model:')) {
          model = token.substring(6).replaceAll('_', ' ');
          break;
        }
      }
      return DeviceInfo(
        serial: serial,
        state: state,
        rawState: rawToken,
        model: model,
      );
    }
    return DeviceInfo(serial: '', state: DeviceState.unknown);
  }

  factory DeviceInfo.fromFastbootLine(String line) {
    final parts = line.trim().split(RegExp(r'\s+'));
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      final serial = parts[0];
      final rawToken = parts.length >= 2 ? parts[1].toLowerCase() : 'fastboot';
      final isUserspaceToken = rawToken == 'fastbootd';
      return DeviceInfo(
        serial: serial,
        state: isUserspaceToken ? DeviceState.fastbootd : DeviceState.fastboot,
        rawState: rawToken,
      );
    }
    return DeviceInfo(serial: '', state: DeviceState.unknown);
  }
}
