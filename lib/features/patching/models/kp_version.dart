import 'dart:io';
import '../../../generated/l10n.dart';
import 'patch_target.dart';

class KpVersion {
  final String id;
  final String version;
  final String managerVersion;
  final String kpimgPath;
  final bool isCustom;
  final bool supportsUnpack;
  final PatchTarget source;
  final String releaseDate;
  final String channel;
  final bool recommended;
  final String androidSupport;
  final String minKernel;
  final String maxKernel;
  final String? notesKey;
  final String? sha256;
  final String? apkAssetName;
  final String? apkSha256;
  final String? kptoolsPath;
  final String? kptoolsVersion;
  final bool verifiedOnDisk;

  KpVersion({
    String? id,
    required this.version,
    String? managerVersion,
    required this.kpimgPath,
    this.isCustom = false,
    bool? supportsUnpack,
    required this.source,
    this.releaseDate = '',
    this.channel = 'stable',
    this.recommended = false,
    this.androidSupport = '',
    this.minKernel = '3.18',
    this.maxKernel = '6.15',
    this.notesKey,
    this.sha256,
    this.apkAssetName,
    this.apkSha256,
    this.kptoolsPath,
    this.kptoolsVersion,
    this.verifiedOnDisk = true,
  })  : id = id ?? '${source.directoryName}-$version-$kpimgPath',
        managerVersion = managerVersion ?? version,
        supportsUnpack = supportsUnpack ?? _checkUnpackSupport(version);

  static bool _checkUnpackSupport(String version) {
    return compareVersions(version, '0.13.0') >= 0;
  }

  static int compareVersions(String v1, String v2) {
    final clean1 = v1.replaceAll(RegExp(r'^[^0-9]*'), '');
    final clean2 = v2.replaceAll(RegExp(r'^[^0-9]*'), '');
    final parts1 =
        clean1.split('.').map((p) => int.tryParse(p) ?? 0).toList();
    final parts2 =
        clean2.split('.').map((p) => int.tryParse(p) ?? 0).toList();

    final maxLen =
        parts1.length > parts2.length ? parts1.length : parts2.length;

    for (var i = 0; i < maxLen; i++) {
      final p1 = i < parts1.length ? parts1[i] : 0;
      final p2 = i < parts2.length ? parts2[i] : 0;
      if (p1 != p2) return p1.compareTo(p2);
    }
    return 0;
  }

  /// Parses standard KernelPatch `KP1158` binary header (bytes 11.10.9 = major.minor.patch).
  static String? parseKpimgHeaderVersion(List<int> bytes) {
    if (bytes.length < 12) return null;
    // "KP1158" header prefix
    if (bytes[0] != 0x4B ||
        bytes[1] != 0x50 ||
        bytes[2] != 0x31 ||
        bytes[3] != 0x31 ||
        bytes[4] != 0x35 ||
        bytes[5] != 0x38) {
      return null;
    }
    final major = bytes[11];
    final minor = bytes[10];
    final patch = bytes[9];
    return '$major.$minor.$patch';
  }

  /// Reads up to 16 bytes from [kpimgPath] and extracts its KernelPatch version if valid.
  static Future<String?> readKpimgHeaderVersion(String kpimgPath) async {
    try {
      final file = File(kpimgPath);
      if (!await file.exists()) return null;
      final raf = await file.open(mode: FileMode.read);
      try {
        final bytes = await raf.read(16);
        return parseKpimgHeaderVersion(bytes);
      } finally {
        await raf.close();
      }
    } catch (_) {
      return null;
    }
  }

  bool get isNewerThan013 => supportsUnpack;
  bool get isLegacyChannel => channel == 'legacy' || !supportsUnpack;
  bool get isPrerelease => channel == 'prerelease';

  String localizedNotes(S l10n) {
    switch (notesKey) {
      case 'catalogNotesFolkpatch115404':
        return l10n.catalogNotesFolkpatch115404;
      case 'catalogNotesFolkpatch115357':
        return l10n.catalogNotesFolkpatch115357;
      case 'catalogNotesFolkpatch0138':
        return l10n.catalogNotesFolkpatch0138;
      case 'catalogNotesApatch11282':
        return l10n.catalogNotesApatch11282;
      case 'catalogNotesApatch11224':
        return l10n.catalogNotesApatch11224;
      case 'catalogNotesApatch11142':
        return l10n.catalogNotesApatch11142;
      default:
        return androidSupport;
    }
  }

  String displayTitle(S l10n) {
    if (isCustom) {
      return version == 'custom'
          ? '${source.displayName} ${l10n.versionCustom}'
          : '${source.displayName} ${l10n.versionCustom} (KP $version)';
    }
    if (managerVersion.isNotEmpty && managerVersion != version) {
      return '${source.displayName} $managerVersion · KP $version';
    }
    return '${source.displayName} $version';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KpVersion &&
        other.id == id &&
        other.version == version &&
        other.kpimgPath == kpimgPath &&
        other.source == source;
  }

  @override
  int get hashCode => Object.hash(id, version, kpimgPath, source);

  @override
  String toString() =>
      'KpVersion(id: $id, version: $version, manager: $managerVersion, source: ${source.name})';
}