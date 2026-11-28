import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/config/app_config.dart';
import '../core/config/app_semantic_colors.dart';
import '../core/updates/update_service.dart';
import '../core/widgets/responsive_layout.dart';
import '../features/device/providers/device_provider.dart';
import '../features/device/widgets/client_check_card.dart';
import '../features/device/widgets/device_status_card.dart';
import '../features/drivers/screens/driver_install_screen.dart';
import '../features/files/services/file_service.dart';
import '../features/patching/providers/patch_provider.dart';
import '../features/patching/providers/version_provider.dart';
import '../features/patching/screens/quick_patch_screen.dart';
import '../features/patching/screens/simple_patch_screen.dart';
import '../features/patching/screens/step_patch_screen.dart';
import '../features/settings/providers/locale_provider.dart';
import '../features/settings/providers/settings_provider.dart';
import '../features/settings/providers/theme_provider.dart';
import '../features/settings/screens/settings_screen.dart';
import '../generated/l10n.dart';

class _SelectNavIntent extends Intent {
  final int index;
  const _SelectNavIntent(this.index);
}

class _NavDestinationSpec {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String shortLabel;

  const _NavDestinationSpec({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.shortLabel,
  });
}

class AppShellScreen extends StatefulWidget {
  const AppShellScreen({super.key});

  @override
  State<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState extends State<AppShellScreen> {
  final FileService _fileService = FileService();
  final UpdateService _updateService = UpdateService();
  List<RecentFileEntry> _recentFiles = [];
  ReleaseInfo? _availableUpdate;
  int _selectedNavIndex = 0;
  bool _sidebarCollapsed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _initData();
    });
  }

  Future<void> _initData() async {
    final deviceProvider = context.read<DeviceProvider>();
    final settingsProvider = context.read<SettingsProvider>();
    final versionProvider = context.read<VersionProvider>();

    await Future.wait([
      settingsProvider.ensureLoaded(),
      deviceProvider.checkDriver(),
      versionProvider.ensureLoaded(),
    ]);
    if (!mounted) return;

    if (settingsProvider.autoMonitorDevices) {
      deviceProvider.startMonitoring();
    } else {
      await deviceProvider.refreshDevices();
    }

    await _loadRecentFiles();
    if (settingsProvider.checkUpdatesOnLaunch) {
      _checkForUpdates();
    }
  }

  Future<void> _checkForUpdates() async {
    final release = await _updateService.checkForUpdate();
    if (!mounted || release == null) return;
    setState(() {
      _availableUpdate = release;
    });
  }

  Future<void> _loadRecentFiles() async {
    final files = await _fileService.getRecentFileDetails();
    if (mounted) {
      setState(() {
        _recentFiles = files;
      });
    }
  }

  Future<void> _confirmClearRecentFiles() async {
    final l10n = S.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.clearRecentFilesTitle),
        content: Text(l10n.clearRecentFilesDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.clearAll),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _fileService.clearRecentFiles();
      await _loadRecentFiles();
    }
  }

  IconData _themeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode_outlined;
      case ThemeMode.dark:
        return Icons.dark_mode_outlined;
      case ThemeMode.system:
        return Icons.brightness_auto_outlined;
    }
  }

  void _selectNav(int index) {
    if (index == _selectedNavIndex) return;
    final l10n = S.of(context);
    final patchProvider = context.read<PatchProvider>();
    if (patchProvider.isRunning) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.operationInProgressNavBlocked)),
      );
      return;
    }
    setState(() => _selectedNavIndex = index);
    if (index == 0) {
      _loadRecentFiles();
    }
  }

  List<_NavDestinationSpec> _navSpecs(S l10n) => [
        _NavDestinationSpec(
          icon: Icons.dashboard_outlined,
          selectedIcon: Icons.dashboard_rounded,
          label: l10n.navDashboard,
          shortLabel: l10n.home,
        ),
        _NavDestinationSpec(
          icon: Icons.flash_on_outlined,
          selectedIcon: Icons.flash_on_rounded,
          label: l10n.quickPatch,
          shortLabel: l10n.navQuickShort,
        ),
        _NavDestinationSpec(
          icon: Icons.list_alt_outlined,
          selectedIcon: Icons.list_alt_rounded,
          label: l10n.stepPatch,
          shortLabel: l10n.navStepShort,
        ),
        _NavDestinationSpec(
          icon: Icons.build_circle_outlined,
          selectedIcon: Icons.build_circle_rounded,
          label: l10n.simplePatch,
          shortLabel: l10n.navLocalShort,
        ),
        _NavDestinationSpec(
          icon: Icons.usb_outlined,
          selectedIcon: Icons.usb_rounded,
          label: l10n.driverInstall,
          shortLabel: l10n.navDriversShort,
        ),
        _NavDestinationSpec(
          icon: Icons.settings_outlined,
          selectedIcon: Icons.settings_rounded,
          label: l10n.navSettings,
          shortLabel: l10n.navSettings,
        ),
      ];

  Future<void> _showCompactMoreSheet(
    BuildContext context,
    List<_NavDestinationSpec> specs,
  ) async {
    final l10n = S.of(context);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final idx in const [3, 4, 5])
                  ListTile(
                    leading: Icon(
                      _selectedNavIndex == idx
                          ? specs[idx].selectedIcon
                          : specs[idx].icon,
                      color: _selectedNavIndex == idx
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    title: Text(specs[idx].label),
                    selected: _selectedNavIndex == idx,
                    onTap: () {
                      Navigator.pop(ctx);
                      _selectNav(idx);
                    },
                  ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.about),
                  onTap: () {
                    Navigator.pop(ctx);
                    _showAboutDialog();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactDrawer(
    BuildContext context,
    List<_NavDestinationSpec> specs,
    S l10n,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return NavigationDrawer(
      selectedIndex: _selectedNavIndex,
      onDestinationSelected: (idx) {
        Navigator.of(context).pop();
        _selectNav(idx);
      },
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 16, 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.phonelink_setup_rounded,
                  color: colorScheme.onPrimaryContainer,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.appName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'v${AppConfig.appVersion}',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 16, indent: 16, endIndent: 16),
        for (final spec in specs)
          NavigationDrawerDestination(
            icon: Icon(spec.icon),
            selectedIcon: Icon(spec.selectedIcon),
            label: Text(spec.label),
          ),
      ],
    );
  }

  Widget _buildActivePage(BuildContext context) {
    switch (_selectedNavIndex) {
      case 1:
        return const QuickPatchScreen(key: ValueKey('nav_quick'));
      case 2:
        return const StepPatchScreen(key: ValueKey('nav_step'));
      case 3:
        return const SimplePatchScreen(key: ValueKey('nav_simple'));
      case 4:
        return const DriverInstallScreen(key: ValueKey('nav_driver'));
      case 5:
        return const SettingsScreen(key: ValueKey('nav_settings'));
      default:
        return _buildDashboard(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final isZh = context.select<LocaleProvider, bool>((p) => p.isZh);
    final themeMode = context.select<ThemeProvider, ThemeMode>((p) => p.themeMode);
    final colorScheme = Theme.of(context).colorScheme;
    final specs = _navSpecs(l10n);

    return Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.digit1, control: true):
            _SelectNavIntent(0),
        SingleActivator(LogicalKeyboardKey.digit2, control: true):
            _SelectNavIntent(1),
        SingleActivator(LogicalKeyboardKey.digit3, control: true):
            _SelectNavIntent(2),
        SingleActivator(LogicalKeyboardKey.digit4, control: true):
            _SelectNavIntent(3),
        SingleActivator(LogicalKeyboardKey.digit5, control: true):
            _SelectNavIntent(4),
        SingleActivator(LogicalKeyboardKey.comma, control: true):
            _SelectNavIntent(5),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _SelectNavIntent: CallbackAction<_SelectNavIntent>(
            onInvoke: (intent) {
              _selectNav(intent.index);
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final sizeClass = WindowSizeClass.fromWidth(constraints.maxWidth);
              final isCompact = sizeClass == WindowSizeClass.compact;
              final isExpanded = sizeClass == WindowSizeClass.expanded;

              return Scaffold(
                drawer: isCompact
                    ? _buildCompactDrawer(context, specs, l10n)
                    : null,
                appBar: AppBar(
                  title: Text(l10n.appName),
                  leading: isCompact
                      ? null
                      : IconButton(
                          icon: Icon(
                            _sidebarCollapsed || !isExpanded
                                ? Icons.menu_open_rounded
                                : Icons.menu_rounded,
                          ),
                          tooltip: l10n.toggleNavigation,
                          onPressed: () => setState(
                              () => _sidebarCollapsed = !_sidebarCollapsed),
                        ),
                  actions: [
                    PopupMenuButton<ThemeMode>(
                      icon: Icon(_themeIcon(themeMode)),
                      tooltip: l10n.switchTheme,
                      initialValue: themeMode,
                      onSelected: (mode) =>
                          context.read<ThemeProvider>().setThemeMode(mode),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: ThemeMode.system,
                          child: Row(
                            children: [
                              const Icon(Icons.brightness_auto_outlined,
                                  size: 18),
                              const SizedBox(width: 10),
                              Text(l10n.themeSystem),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: ThemeMode.light,
                          child: Row(
                            children: [
                              const Icon(Icons.light_mode_outlined, size: 18),
                              const SizedBox(width: 10),
                              Text(l10n.themeLight),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: ThemeMode.dark,
                          child: Row(
                            children: [
                              const Icon(Icons.dark_mode_outlined, size: 18),
                              const SizedBox(width: 10),
                              Text(l10n.themeDark),
                            ],
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.language),
                      onPressed: () =>
                          context.read<LocaleProvider>().toggleLanguage(),
                      tooltip:
                          isZh ? l10n.switchToEnglish : l10n.switchToChinese,
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      onPressed: () => _selectNav(5),
                      tooltip: l10n.settingsShortcutTooltip,
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: _showAboutDialog,
                      tooltip: l10n.aboutTooltip,
                    ),
                  ],
                ),
                body: Row(
                  children: [
                    if (!isCompact) ...[
                      NavigationRail(
                        extended: isExpanded && !_sidebarCollapsed,
                        selectedIndex: _selectedNavIndex,
                        onDestinationSelected: _selectNav,
                        labelType: isExpanded && !_sidebarCollapsed
                            ? NavigationRailLabelType.none
                            : NavigationRailLabelType.all,
                        leading: isExpanded && !_sidebarCollapsed
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    top: 4, bottom: 12, left: 12, right: 12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer
                                        .withValues(alpha: 0.55),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.verified_user_outlined,
                                        size: 16,
                                        color: colorScheme.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'v${AppConfig.appVersion}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : null,
                        destinations: specs
                            .map(
                              (spec) => NavigationRailDestination(
                                icon: Icon(spec.icon),
                                selectedIcon: Icon(spec.selectedIcon),
                                label: Text(
                                  isExpanded && !_sidebarCollapsed
                                      ? spec.label
                                      : spec.shortLabel,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: colorScheme.outlineVariant,
                      ),
                    ],
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 160),
                        child: _buildActivePage(context),
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: isCompact
                    ? NavigationBar(
                        selectedIndex:
                            _selectedNavIndex >= 3 ? 3 : _selectedNavIndex,
                        onDestinationSelected: (idx) {
                          if (idx < 3) {
                            _selectNav(idx);
                          } else {
                            _showCompactMoreSheet(context, specs);
                          }
                        },
                        destinations: [
                          NavigationDestination(
                            icon: Icon(specs[0].icon),
                            selectedIcon: Icon(specs[0].selectedIcon),
                            label: specs[0].shortLabel,
                          ),
                          NavigationDestination(
                            icon: Icon(specs[1].icon),
                            selectedIcon: Icon(specs[1].selectedIcon),
                            label: specs[1].shortLabel,
                          ),
                          NavigationDestination(
                            icon: Icon(specs[2].icon),
                            selectedIcon: Icon(specs[2].selectedIcon),
                            label: specs[2].shortLabel,
                          ),
                          NavigationDestination(
                            icon: const Icon(Icons.apps_rounded),
                            selectedIcon: const Icon(Icons.apps_rounded),
                            label: l10n.navMore,
                          ),
                        ],
                      )
                    : null,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context) {
    final l10n = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 560;
        final pad = isCompact ? 14.0 : 20.0;

        return Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(pad),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 980),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_availableUpdate != null) ...[
                      Card(
                        color:
                            colorScheme.primaryContainer.withValues(alpha: 0.45),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.system_update_alt,
                                color: colorScheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  l10n.newVersionAvailable(
                                    _availableUpdate!.tagName,
                                  ),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => launchUrl(
                                  Uri.parse(_availableUpdate!.htmlUrl),
                                  mode: LaunchMode.externalApplication,
                                ),
                                child: Text(l10n.download),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                tooltip: l10n.dismiss,
                                onPressed: () => setState(() {
                                  _availableUpdate = null;
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    const DeviceStatusCard(),
                    const ClientCheckCard(),
                    const SizedBox(height: 20),
                    _buildModeSelection(context),
                    if (_recentFiles.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.recentFiles,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _confirmClearRecentFiles,
                            icon: const Icon(Icons.clear_all, size: 16),
                            label: Text(l10n.clearAll),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildRecentFiles(context),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModeSelection(BuildContext context) {
    final l10n = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.selectMode,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        ResponsivePairGrid(
          breakpoint: 580,
          first: _buildModeCard(
            context: context,
            title: l10n.quickPatch,
            subtitle: l10n.quickPatchSubtitle,
            icon: Icons.flash_on,
            color: Colors.blue,
            onTap: () => _selectNav(1),
          ),
          second: _buildModeCard(
            context: context,
            title: l10n.stepPatch,
            subtitle: l10n.stepPatchSubtitle,
            icon: Icons.list_alt,
            color: context.semantic.success,
            onTap: () => _selectNav(2),
          ),
        ),
        const SizedBox(height: 14),
        ResponsivePairGrid(
          breakpoint: 580,
          first: _buildModeCard(
            context: context,
            title: l10n.simplePatch,
            subtitle: l10n.simplePatchSubtitle,
            icon: Icons.build_circle,
            color: Colors.orange,
            onTap: () => _selectNav(3),
          ),
          second: _buildModeCard(
            context: context,
            title: l10n.driverInstall,
            subtitle: l10n.driverInstallSubtitle,
            icon: Icons.usb,
            color: Colors.purple,
            onTap: () => _selectNav(4),
          ),
        ),
      ],
    );
  }

  Widget _buildModeCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        hoverColor: color.withValues(alpha: 0.06),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentFiles(BuildContext context) {
    final l10n = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: _recentFiles.take(5).map((entry) {
          return ListTile(
            leading: Icon(
              entry.exists
                  ? Icons.insert_drive_file_outlined
                  : Icons.broken_image_outlined,
              color: entry.exists
                  ? colorScheme.onSurfaceVariant
                  : colorScheme.error,
            ),
            title: Row(
              children: [
                Flexible(
                  child: Text(
                    entry.fileName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: entry.exists
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                      decoration:
                          entry.exists ? null : TextDecoration.lineThrough,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: (entry.exists
                            ? colorScheme.primary
                            : colorScheme.error)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: Text(
                    entry.exists ? entry.formattedSize : l10n.fileMissingBadge,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: entry.exists
                          ? colorScheme.primary
                          : colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Text(
              entry.path,
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurfaceVariant,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (entry.exists)
                  IconButton(
                    icon: const Icon(Icons.folder_open_outlined, size: 18),
                    tooltip: l10n.openFileLocation,
                    onPressed: () => _fileService.openFileLocation(entry.path),
                  ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  tooltip: l10n.removeFromList,
                  onPressed: () async {
                    await _fileService.removeRecentFile(entry.path);
                    await _loadRecentFiles();
                  },
                ),
              ],
            ),
            onTap: entry.exists
                ? () {
                    context.read<PatchProvider>().setSelectedFile(entry.path);
                    _selectNav(1);
                  }
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.recentFileMissingHint)),
                    );
                  },
          );
        }).toList(),
      ),
    );
  }

  Future<void> _launchGitHub(BuildContext context) async {
    final l10n = S.of(context);
    final Uri url = Uri.parse('https://github.com/LyraVoid/FolkTool');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.unableToOpenLink(e.toString()))),
        );
      }
    }
  }

  void _showAboutDialog() {
    final l10n = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final semantic = context.semantic;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CircleAvatar(
                  radius: 44,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  child: ClipOval(
                    child: Image.network(
                      'http://q.qlogo.cn/headimg_dl?dst_uin=3231515355&spec=640&img_type=jpg',
                      width: 88,
                      height: 88,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          size: 44,
                          color: colorScheme.onSurfaceVariant,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  l10n.matsuzakaYuki,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.appVersionWithBuild(
                    AppConfig.appVersion,
                    AppConfig.appBuildNumber,
                  ),
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () => _launchGitHub(context),
                  icon: const Icon(Icons.link, size: 18),
                  label: Text(l10n.github),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.aboutTitle,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.aboutDescription,
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.aboutDescription2,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: semantic.warning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: semantic.warning.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_outlined,
                        size: 18,
                        color: semantic.warning,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.backupWarning,
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child:
                        Text(MaterialLocalizations.of(context).okButtonLabel),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
