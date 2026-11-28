import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/config/app_config.dart';
import '../../../core/providers/safe_change_notifier.dart';
import '../models/kp_version.dart';
import '../models/patch_target.dart';
import '../services/version_service.dart';

class VersionProvider extends ChangeNotifier with SafeChangeNotifierMixin {
  final VersionService _versionService;

  VersionProvider({VersionService? versionService})
      : _versionService = versionService ?? VersionService();

  List<KpVersion> _availableVersions = [];
  KpVersion? _selectedVersion;
  String? _customVersionPath;
  bool _isLoading = false;
  bool _hasLoaded = false;
  bool _targetLoaded = false;

  PatchTarget _currentTarget = PatchTarget.folkpatch;
  final Map<PatchTarget, TargetToolchainSummary> _summaries = {};

  PatchTarget get currentTarget => _currentTarget;
  List<KpVersion> get availableVersions =>
      List.unmodifiable(_availableVersions);
  KpVersion? get selectedVersion => _selectedVersion;
  String? get customVersionPath => _customVersionPath;
  bool get isLoading => _isLoading;
  bool get hasLoaded => _hasLoaded;
  TargetToolchainSummary? get currentTargetSummary =>
      _summaries[_currentTarget];

  TargetToolchainSummary? summaryForTarget(PatchTarget target) =>
      _summaries[target];

  void setTarget(PatchTarget target) {
    if (_currentTarget != target) {
      _currentTarget = target;
      _targetLoaded = true;
      _selectedVersion = null;
      _customVersionPath = null;
      _saveTarget();
      loadVersions(reloadSavedTarget: false);
    }
  }

  Future<void> _saveTarget() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.patchTargetKey, _currentTarget.name);
  }

  Future<void> _loadTarget() async {
    if (_targetLoaded) return;
    final prefs = await SharedPreferences.getInstance();
    final targetName = prefs.getString(AppConfig.patchTargetKey);
    if (targetName != null) {
      _currentTarget = PatchTarget.values.firstWhere(
        (t) => t.name == targetName,
        orElse: () => PatchTarget.folkpatch,
      );
    }
    _targetLoaded = true;
  }

  String _versionPrefKey(PatchTarget target) =>
      '${AppConfig.selectedVersionKeyPrefix}${target.directoryName}';

  String _customPathPrefKey(PatchTarget target) =>
      '${AppConfig.customVersionPathKeyPrefix}${target.directoryName}';

  Future<void> ensureLoaded() async {
    if (_hasLoaded || _isLoading) return;
    await loadVersions();
  }

  Future<void> loadVersions({bool reloadSavedTarget = true}) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (reloadSavedTarget) {
        await _loadTarget();
      }

      final summaries = await Future.wait([
        _versionService.getTargetSummary(PatchTarget.folkpatch),
        _versionService.getTargetSummary(PatchTarget.apatch),
      ]);
      for (final s in summaries) {
        _summaries[s.target] = s;
      }

      _availableVersions =
          await _versionService.getAvailableVersions(source: _currentTarget);

      if (_availableVersions.isNotEmpty) {
        _selectedVersion = _availableVersions.firstWhere(
          (v) => v.recommended,
          orElse: () => _availableVersions.first,
        );
      } else {
        _selectedVersion = null;
      }

      await _loadSavedVersion();
    } finally {
      _hasLoaded = true;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadSavedVersion() async {
    final prefs = await SharedPreferences.getInstance();
    final targetKey = _versionPrefKey(_currentTarget);
    final customKey = _customPathPrefKey(_currentTarget);

    final customPath = prefs.getString(customKey);
    if (customPath != null && customPath.isNotEmpty) {
      final customVersion = await _versionService.validateCustomVersion(
        customPath,
        source: _currentTarget,
      );
      if (customVersion != null) {
        _selectedVersion = customVersion;
        _customVersionPath = customPath;
        return;
      }
    }

    final savedIdOrVer =
        prefs.getString(targetKey) ?? prefs.getString(AppConfig.selectedVersionKey);
    if (savedIdOrVer != null && savedIdOrVer.isNotEmpty) {
      final matched = _availableVersions
              .where((v) => v.id == savedIdOrVer)
              .firstOrNull ??
          _availableVersions
              .where((v) => v.version == savedIdOrVer)
              .firstOrNull;
      if (matched != null) {
        _selectedVersion = matched;
      }
    }
  }

  Future<void> selectVersion(KpVersion version) async {
    if (version.source != _currentTarget) return;
    _selectedVersion = version;
    if (!version.isCustom) {
      _customVersionPath = null;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_versionPrefKey(_currentTarget), version.id);
    if (!version.isCustom) {
      await prefs.remove(_customPathPrefKey(_currentTarget));
    }

    notifyListeners();
  }

  Future<bool> selectCustomVersion(String filePath) async {
    final customVersion = await _versionService.validateCustomVersion(
      filePath,
      source: _currentTarget,
    );
    if (customVersion == null) {
      return false;
    }

    _selectedVersion = customVersion;
    _customVersionPath = filePath;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_customPathPrefKey(_currentTarget), filePath);
    await prefs.setString(_versionPrefKey(_currentTarget), customVersion.id);

    notifyListeners();
    return true;
  }

  Future<void> clearCustomVersion() async {
    _customVersionPath = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_customPathPrefKey(_currentTarget));

    if (_availableVersions.isNotEmpty) {
      _selectedVersion = _availableVersions.firstWhere(
        (v) => v.recommended,
        orElse: () => _availableVersions.first,
      );
      await prefs.setString(
        _versionPrefKey(_currentTarget),
        _selectedVersion!.id,
      );
    }

    notifyListeners();
  }

  String? getKpimgPath() => _selectedVersion?.kpimgPath;

  String? getKptoolsPath() => _selectedVersion?.kptoolsPath;
}
