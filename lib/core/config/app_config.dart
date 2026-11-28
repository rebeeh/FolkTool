import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

/// Application metadata, execution timeouts, preference keys, and memoized asset paths.
abstract final class AppConfig {
  static const String appVersion =
      String.fromEnvironment('APP_VERSION', defaultValue: '1.7.0');
  static const String appBuildNumber =
      String.fromEnvironment('APP_BUILD_NUMBER', defaultValue: '5');
  static const String appDisplayVersion = '$appVersion+$appBuildNumber';
  static const String appName = 'FolkTool';
  static const String appFullName = 'FolkTool - KernelPatch Auto Flash Tool';
  static const String githubRepoOwner = 'LyraVoid';
  static const String githubRepoName = 'FolkTool';

  static const String apatchPackageName = 'me.bmax.apatch';
  static const String folkpatchPackageName = 'me.yuki.folk';

  static const String toolchainManifestAsset =
      'assets/manifests/toolchain_manifest.json';

  static const String outputDirName = 'FolkTool/patched';
  static const String logsDirName = 'FolkTool/logs';
  static const String backupDirName = 'FolkTool/backup';

  static const int adbTimeoutSeconds = 30;
  static const int fastbootTimeoutSeconds = 60;
  static const int flashTimeoutSeconds = 120;
  static const int rebootWaitSeconds = 5;

  static const int maxRecentFiles = 10;
  static const String recentFilesKey = 'recent_files';

  static const String minVersionWithUnpack = '0.13.0';
  static const String selectedVersionKeyPrefix = 'selected_kp_version_';
  static const String customVersionPathKeyPrefix = 'custom_kp_version_path_';
  static const String selectedVersionKey = 'selected_kp_version';
  static const String customVersionPathKey = 'custom_kp_version_path';
  static const String patchTargetKey = 'patch_target';

  /// Default fallback KernelPatch version when reading an untagged local slot.
  static const String defaultKpVersion = '0.13.9';

  static String get _exeDir => File(Platform.resolvedExecutable).parent.path;

  static bool? _cachedIsReleaseMode;
  static String? _cachedProjectRoot;
  static String? _cachedKpVersionsBasePath;

  /// Clears memoized filesystem root resolutions (primarily for tests).
  @visibleForTesting
  static void resetPathCache() {
    _cachedIsReleaseMode = null;
    _cachedProjectRoot = null;
    _cachedKpVersionsBasePath = null;
  }

  static bool get _isReleaseMode {
    final cached = _cachedIsReleaseMode;
    if (cached != null) return cached;

    final exeFile = File(Platform.resolvedExecutable);
    final exePath = exeFile.parent.path.toLowerCase();

    var isRelease = false;
    if (!exePath.contains(r'\debug') &&
        !exePath.contains('/debug') &&
        !exePath.contains(r'\build\') &&
        !exePath.contains('/build/')) {
      final binDir = Directory(p.join(exeFile.parent.path, 'bin'));
      final kpVersionsDir =
          Directory(p.join(exeFile.parent.path, 'kp_versions'));
      isRelease = binDir.existsSync() && kpVersionsDir.existsSync();
    }

    _cachedIsReleaseMode = isRelease;
    return isRelease;
  }

  static String get _assetsRoot => _isReleaseMode ? _exeDir : _projectRoot;

  static String get _projectRoot =>
      _cachedProjectRoot ??= _resolveProjectRoot();

  static String _resolveProjectRoot() {
    var dir = Directory.current;
    for (int i = 0; i < 15; i++) {
      final pubspecFile = File(p.join(dir.path, 'pubspec.yaml'));
      final kpVersionsDir = Directory(p.join(dir.path, 'kp_versions'));
      if (pubspecFile.existsSync() && kpVersionsDir.existsSync()) {
        return dir.path;
      }
      if (dir.parent.path == dir.path) break;
      dir = dir.parent;
    }

    dir = Directory.current;
    for (int i = 0; i < 5; i++) {
      final hasLayout = Directory(p.join(dir.path, 'bin')).existsSync() &&
          Directory(p.join(dir.path, 'apk')).existsSync() &&
          Directory(p.join(dir.path, 'kp_versions')).existsSync();
      if (hasLayout) return dir.path;
      if (dir.parent.path == dir.path) break;
      dir = dir.parent;
    }

    dir = File(Platform.resolvedExecutable).parent;
    for (int i = 0; i < 10; i++) {
      if (!dir.existsSync()) break;
      final baseName = p.basename(dir.path).toLowerCase();
      if (baseName == 'folktool_app' ||
          baseName == 'folktool-windows-release') {
        return dir.path;
      }
      final parent = dir.parent;
      if (parent.path == dir.path) break;
      dir = parent;
    }

    return _exeDir;
  }

  static String get kpVersionsBasePath =>
      _cachedKpVersionsBasePath ??= _resolveKpVersionsBasePath();

  static String _resolveKpVersionsBasePath() {
    if (_isReleaseMode) {
      return p.join(_assetsRoot, 'kp_versions');
    }

    final potentialPaths = <String>[
      p.join(_projectRoot, 'kp_versions'),
      p.join(Directory.current.path, 'kp_versions'),
    ];

    try {
      final parentPath = Directory.current.parent.path;
      if (parentPath != Directory.current.path) {
        potentialPaths.add(p.join(parentPath, 'kp_versions'));
      }
      final grandParentPath = Directory.current.parent.parent.path;
      if (grandParentPath != parentPath) {
        potentialPaths.add(p.join(grandParentPath, 'kp_versions'));
      }
    } catch (e) {
      debugPrint('[AppConfig] Parent directory probe skipped: $e');
    }

    try {
      var dir = Directory.current;
      for (int i = 0; i < 10; i++) {
        if (File(p.join(dir.path, 'pubspec.yaml')).existsSync()) {
          final kpPath = p.join(dir.path, 'kp_versions');
          if (!potentialPaths.contains(kpPath)) {
            potentialPaths.add(kpPath);
          }
          break;
        }
        if (dir.parent.path == dir.path) break;
        dir = dir.parent;
      }
    } catch (e) {
      debugPrint('[AppConfig] Pubspec root probe skipped: $e');
    }

    for (final path in potentialPaths) {
      if (Directory(path).existsSync()) {
        return path;
      }
    }

    return potentialPaths.first;
  }

  static String get kptoolsPath => sharedKptoolsPath;
  static String get adbPath => p.join(_assetsRoot, 'bin', 'adb.exe');
  static String get fastbootPath => p.join(_assetsRoot, 'bin', 'fastboot.exe');
  static String get platformToolsPropertiesPath =>
      p.join(_assetsRoot, 'bin', 'platform-tools.source.properties');
  static String get fallbackKpimgPath => p.join(_assetsRoot, 'assets', 'kpimg');
  static String get apatchApkPath => p.join(_assetsRoot, 'apk', 'APatch.apk');
  static String get folkpatchApkPath =>
      p.join(_assetsRoot, 'apk', 'FolkPatch.apk');

  static String get sharedKptoolsPath =>
      p.join(kpVersionsBasePath, 'windows', 'kptools.exe');
  static String get folkpatchVersionsPath =>
      p.join(kpVersionsBasePath, 'folkpatch');
  static String get apatchVersionsPath =>
      p.join(kpVersionsBasePath, 'apatch');

  static String kptoolsPathForSource(String sourceDirectoryName) {
    final targetSpecific =
        p.join(kpVersionsBasePath, sourceDirectoryName, 'windows', 'kptools.exe');
    if (File(targetSpecific).existsSync()) {
      return targetSpecific;
    }
    return sharedKptoolsPath;
  }

  static String kpimgFilePathForSource(String sourceDirectoryName) =>
      p.join(kpVersionsBasePath, sourceDirectoryName, 'kpimg');

  static String kpimgFilePathForRelPath(String relPath) {
    final normalized = relPath.replaceAll('/', Platform.pathSeparator);
    return p.join(kpVersionsBasePath, normalized);
  }
}
