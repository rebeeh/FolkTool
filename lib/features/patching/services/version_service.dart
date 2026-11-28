import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import '../../../core/config/app_config.dart';
import '../models/kp_version.dart';
import '../models/patch_target.dart';

class TargetToolchainSummary {
  final PatchTarget target;
  final String packageName;
  final String repoUrl;
  final String latestManagerVersion;
  final String latestKpVersion;
  final String kptoolsVersion;
  final String kptoolsPath;
  final bool kptoolsAvailable;
  final bool defaultApkAvailable;

  const TargetToolchainSummary({
    required this.target,
    required this.packageName,
    required this.repoUrl,
    required this.latestManagerVersion,
    required this.latestKpVersion,
    required this.kptoolsVersion,
    required this.kptoolsPath,
    required this.kptoolsAvailable,
    required this.defaultApkAvailable,
  });
}

class VersionService {
  Map<String, dynamic>? _cachedManifest;
  Future<Map<String, dynamic>?>? _manifestFuture;

  Future<Map<String, dynamic>?> loadManifest() {
    if (_cachedManifest != null) return Future.value(_cachedManifest);
    return _manifestFuture ??= _loadManifestUncached().whenComplete(() {
      _manifestFuture = null;
    });
  }

  Future<Map<String, dynamic>?> _loadManifestUncached() async {
    // Check adjacent/project/flutter_assets manifest files first so both pure
    // Dart tests and widget tests resolve deterministically without stalling on
    // platform binary-messenger asset loads.
    final exeDir = File(Platform.resolvedExecutable).parent.path;
    final diskCandidates = <String>[
      p.join(
        Directory(AppConfig.kpVersionsBasePath).parent.path,
        'assets',
        'manifests',
        'toolchain_manifest.json',
      ),
      p.join(exeDir, 'assets', 'manifests', 'toolchain_manifest.json'),
      p.join(
        exeDir,
        'data',
        'flutter_assets',
        'assets',
        'manifests',
        'toolchain_manifest.json',
      ),
    ];

    for (final candidate in diskCandidates) {
      try {
        final f = File(candidate);
        if (await f.exists()) {
          final parsed = jsonDecode(await f.readAsString());
          if (parsed is Map<String, dynamic>) {
            _cachedManifest = parsed;
            return parsed;
          }
        }
      } catch (e) {
        debugPrint('[VersionService] Manifest read skipped ($candidate): $e');
      }
    }

    // Fallback to Flutter asset bundle (packaged builds where assets live only
    // in the compiled bundle).
    try {
      final raw = await rootBundle
          .loadString(AppConfig.toolchainManifestAsset)
          .timeout(const Duration(seconds: 3));
      final parsed = jsonDecode(raw);
      if (parsed is Map<String, dynamic>) {
        _cachedManifest = parsed;
        return parsed;
      }
    } catch (_) {
      // Headless or unbundled environments fall back cleanly to local slots.
    }

    return null;
  }

  /// Loads only versions belonging strictly to [source] (APatch vs FolkPatch).
  Future<List<KpVersion>> getAvailableVersions({
    required PatchTarget source,
  }) async {
    final versions = <KpVersion>[];
    final manifest = await loadManifest();
    final targetMap = manifest?['targets'] as Map<String, dynamic>?;
    final section = targetMap?[source.directoryName] as Map<String, dynamic>?;
    final kptoolsMeta = section?['kptools'] as Map<String, dynamic>?;
    final kptoolsVersion = kptoolsMeta?['version'] as String?;
    final kptoolsPath = AppConfig.kptoolsPathForSource(source.directoryName);
    final defaultKpimgPath =
        AppConfig.kpimgFilePathForSource(source.directoryName);
    final hasDefaultKpimg = await File(defaultKpimgPath).exists();

    final rawReleases = section?['releases'] as List<dynamic>?;
    if (rawReleases != null && rawReleases.isNotEmpty) {
      for (final item in rawReleases) {
        if (item is! Map<String, dynamic>) continue;
        final relPath = item['kpimgRelPath'] as String? ?? '';
        final specificKpimgPath = relPath.isNotEmpty
            ? AppConfig.kpimgFilePathForRelPath(relPath)
            : defaultKpimgPath;
        final specificExists = await File(specificKpimgPath).exists();

        // Only expose entries whose kpimg binary exists on disk (either
        // release-specific path or legacy/recommended default slot).
        final isRecommended = item['recommended'] as bool? ?? false;
        final resolvedKpimgPath = specificExists
            ? specificKpimgPath
            : (isRecommended && hasDefaultKpimg ? defaultKpimgPath : '');
        if (resolvedKpimgPath.isEmpty) continue;

        final headerVer =
            await KpVersion.readKpimgHeaderVersion(resolvedKpimgPath);
        final kpVer = item['kernelPatchVersion'] as String? ??
            headerVer ??
            AppConfig.defaultKpVersion;

        versions.add(
          KpVersion(
            id: item['id'] as String?,
            version: kpVer,
            managerVersion: item['managerVersion'] as String? ?? kpVer,
            kpimgPath: resolvedKpimgPath,
            isCustom: false,
            supportsUnpack: item['supportsUnpack'] as bool?,
            source: source,
            releaseDate: item['releaseDate'] as String? ?? '',
            channel: item['channel'] as String? ?? 'stable',
            recommended: isRecommended,
            androidSupport: item['androidSupport'] as String? ?? '',
            minKernel: item['minKernel'] as String? ?? '3.18',
            maxKernel: item['maxKernel'] as String? ?? '6.15',
            notesKey: item['notesKey'] as String?,
            sha256: item['kpimgSha256'] as String?,
            apkAssetName: item['apkAssetName'] as String?,
            apkSha256: item['apkSha256'] as String?,
            kptoolsPath: kptoolsPath,
            kptoolsVersion: kptoolsVersion,
            verifiedOnDisk: true,
          ),
        );
      }
    }

    // Also probe standalone legacy `kp_versions/<source>/kpimg` when no manifest
    // entries resolved on disk (e.g., offline checkout before toolchain fetch).
    if (versions.isEmpty && hasDefaultKpimg) {
      final headerVer = await KpVersion.readKpimgHeaderVersion(defaultKpimgPath);
      final resolvedVer = headerVer ?? AppConfig.defaultKpVersion;
      versions.add(
        KpVersion(
          id: '${source.directoryName}-local',
          version: resolvedVer,
          managerVersion: source.displayName,
          kpimgPath: defaultKpimgPath,
          isCustom: false,
          source: source,
          recommended: true,
          channel: 'stable',
          kptoolsPath: kptoolsPath,
          kptoolsVersion: kptoolsVersion,
          verifiedOnDisk: headerVer != null,
        ),
      );
    }

    return versions;
  }

  Future<TargetToolchainSummary> getTargetSummary(PatchTarget source) async {
    final manifest = await loadManifest();
    final targetMap = manifest?['targets'] as Map<String, dynamic>?;
    final section = targetMap?[source.directoryName] as Map<String, dynamic>?;
    final kptoolsMeta = section?['kptools'] as Map<String, dynamic>?;
    final releases = section?['releases'] as List<dynamic>?;
    final topRelease = (releases != null && releases.isNotEmpty)
        ? releases.first as Map<String, dynamic>
        : null;

    final kptoolsPath = AppConfig.kptoolsPathForSource(source.directoryName);
    final apkPath = source == PatchTarget.apatch
        ? AppConfig.apatchApkPath
        : AppConfig.folkpatchApkPath;

    return TargetToolchainSummary(
      target: source,
      packageName:
          (section?['packageName'] as String?) ?? source.packageName,
      repoUrl: (section?['repoUrl'] as String?) ?? source.repoUrl,
      latestManagerVersion:
          (topRelease?['managerVersion'] as String?) ?? source.displayName,
      latestKpVersion: (topRelease?['kernelPatchVersion'] as String?) ??
          AppConfig.defaultKpVersion,
      kptoolsVersion:
          (kptoolsMeta?['version'] as String?) ?? AppConfig.defaultKpVersion,
      kptoolsPath: kptoolsPath,
      kptoolsAvailable: await File(kptoolsPath).exists(),
      defaultApkAvailable: await File(apkPath).exists(),
    );
  }

  Future<KpVersion?> validateCustomVersion(
    String filePath, {
    required PatchTarget source,
  }) async {
    final file = File(filePath);
    if (!await file.exists() || await file.length() == 0) {
      return null;
    }

    final headerVer = await KpVersion.readKpimgHeaderVersion(filePath);
    if (headerVer == null) {
      // Custom file lacks standard KP1158 binary magic header.
      return null;
    }

    final kptoolsPath = AppConfig.kptoolsPathForSource(source.directoryName);
    return KpVersion(
      id: 'custom-${source.directoryName}-$filePath',
      version: headerVer,
      managerVersion: 'Custom',
      kpimgPath: filePath,
      isCustom: true,
      source: source,
      channel: 'custom',
      kptoolsPath: kptoolsPath,
      verifiedOnDisk: true,
    );
  }

  bool isVersionSupportsUnpack(String version) =>
      KpVersion.compareVersions(version, AppConfig.minVersionWithUnpack) >= 0;
}
