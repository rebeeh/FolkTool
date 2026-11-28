import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/config/app_config.dart';
import '../../../core/config/app_semantic_colors.dart';
import '../../../generated/l10n.dart';
import '../../device/providers/device_provider.dart';
import '../../files/services/file_service.dart';
import '../../patching/providers/patch_provider.dart';
import '../../patching/providers/version_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/theme_provider.dart';

/// Application settings screen for appearance, toolchain diagnostics, safety, and maintenance.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<bool> _confirmAction(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final l10n = S.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result == true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final semantic = context.semantic;
    final l10n = S.of(context);
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final settings = context.watch<SettingsProvider>();
    final deviceProvider = context.watch<DeviceProvider>();
    final patchProvider = context.read<PatchProvider>();
    final versionProvider = context.watch<VersionProvider>();
    final diag = deviceProvider.toolchainDiagnostics;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navSettings),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 560;
          final pad = isCompact ? 14.0 : AppSpacing.xxl;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: ListView(
                padding: EdgeInsets.all(pad),
                children: [
                  _SectionHeader(
                    icon: Icons.palette_outlined,
                    title: l10n.settingsAppearanceSection,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.settingsThemeLabel,
                            style: theme.textTheme.titleSmall,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          SizedBox(
                            width: isCompact ? double.infinity : null,
                            child: SegmentedButton<ThemeMode>(
                              segments: [
                                ButtonSegment(
                                  value: ThemeMode.system,
                                  icon: const Icon(Icons.brightness_auto_outlined),
                                  label: Text(l10n.settingsThemeSystem),
                                ),
                                ButtonSegment(
                                  value: ThemeMode.light,
                                  icon: const Icon(Icons.light_mode_outlined),
                                  label: Text(l10n.settingsThemeLight),
                                ),
                                ButtonSegment(
                                  value: ThemeMode.dark,
                                  icon: const Icon(Icons.dark_mode_outlined),
                                  label: Text(l10n.settingsThemeDark),
                                ),
                              ],
                              selected: {themeProvider.themeMode},
                              onSelectionChanged: (selection) {
                                themeProvider.setThemeMode(selection.first);
                              },
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            l10n.language,
                            style: theme.textTheme.titleSmall,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(value: 'en', label: Text('English')),
                              ButtonSegment(value: 'zh', label: Text('中文')),
                            ],
                            selected: {localeProvider.locale.languageCode},
                            onSelectionChanged: (selection) {
                              localeProvider.setLocale(selection.first);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  _SectionHeader(
                    icon: Icons.verified_user_outlined,
                    title: l10n.settingsMonitoringSection,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Card(
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: Text(l10n.settingsAutoMonitorTitle),
                          subtitle: Text(l10n.settingsAutoMonitorDesc),
                          value: settings.autoMonitorDevices,
                          onChanged: (value) async {
                            await settings.setAutoMonitorDevices(value);
                            if (value) {
                              deviceProvider.startMonitoring();
                            } else {
                              deviceProvider.stopMonitoring();
                            }
                          },
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          title: Text(l10n.settingsConfirmFlashTitle),
                          subtitle: Text(l10n.settingsConfirmFlashDesc),
                          value: settings.confirmBeforeFlash,
                          onChanged: settings.setConfirmBeforeFlash,
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          title: Text(l10n.settingsRedactDiagTitle),
                          subtitle: Text(l10n.settingsRedactDiagDesc),
                          value: settings.redactDiagnostics,
                          onChanged: settings.setRedactDiagnostics,
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          title: Text(l10n.settingsCheckUpdatesTitle),
                          subtitle: Text(l10n.settingsCheckUpdatesDesc),
                          value: settings.checkUpdatesOnLaunch,
                          onChanged: settings.setCheckUpdatesOnLaunch,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  _SectionHeader(
                    icon: Icons.build_outlined,
                    title: l10n.settingsToolchainSection,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      l10n.settingsPlatformToolsTitle,
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: (diag?.toolsReady == true
                                                ? semantic.success
                                                : semantic.warning)
                                            .withValues(alpha: 0.14),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        diag?.toolsReady == true
                                            ? l10n.settingsToolchainReady
                                            : l10n.settingsToolchainMissing,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: diag?.toolsReady == true
                                              ? semantic.success
                                              : semantic.warning,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              OutlinedButton.icon(
                                onPressed: () =>
                                    deviceProvider.refreshToolchainDiagnostics(),
                                icon: const Icon(Icons.refresh, size: 16),
                                label: Text(l10n.settingsRefreshToolchain),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _DiagRow(
                            label: l10n.settingsAdbVersionLabel,
                            value: diag?.adbVersion ??
                                (diag?.adbExists == true ? l10n.installed : l10n.fileMissingBadge),
                          ),
                          _DiagRow(
                            label: l10n.settingsFastbootVersionLabel,
                            value: diag?.fastbootVersion ??
                                (diag?.fastbootExists == true ? l10n.installed : l10n.fileMissingBadge),
                          ),
                          if (diag?.platformToolsRevision != null)
                            _DiagRow(
                              label: l10n.settingsPlatformToolsRevLabel,
                              value: diag!.platformToolsRevision!,
                            ),
                          _DiagRow(
                            label: l10n.settingsKptoolsVersionLabel,
                            value: versionProvider
                                    .currentTargetSummary?.kptoolsVersion ??
                                ((diag?.kptoolsSharedExists == true)
                                    ? AppConfig.defaultKpVersion
                                    : l10n.fileMissingBadge),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  _SectionHeader(
                    icon: Icons.cleaning_services_outlined,
                    title: l10n.settingsStorageSection,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Card(
                    child: Column(
                      children: [
                        _ResponsiveActionTile(
                          isCompact: isCompact,
                          icon: const Icon(Icons.history),
                          title: l10n.settingsClearRecentTitle,
                          subtitle: l10n.settingsClearRecentDesc,
                          actions: [
                            OutlinedButton(
                              onPressed: () async {
                                final ok = await _confirmAction(
                                  context,
                                  title: l10n.clearRecentFilesTitle,
                                  message: l10n.clearRecentFilesDesc,
                                  confirmLabel: l10n.clearList,
                                );
                                if (!ok) return;
                                await FileService().clearRecentFiles();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.recentFilesCleared),
                                    ),
                                  );
                                }
                              },
                              child: Text(l10n.clear),
                            ),
                          ],
                        ),
                        const Divider(height: 1),
                        _ResponsiveActionTile(
                          isCompact: isCompact,
                          icon: const Icon(Icons.article_outlined),
                          title: l10n.settingsClearSessionLogsTitle,
                          subtitle: l10n.settingsClearSessionLogsDesc,
                          actions: [
                            OutlinedButton(
                              onPressed: () async {
                                final ok = await _confirmAction(
                                  context,
                                  title: l10n.clearLogsDialogTitle,
                                  message: l10n.clearSessionLogsConfirmBody,
                                  confirmLabel: l10n.clearLogs,
                                );
                                if (!ok) return;
                                patchProvider.clearLogs();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.sessionLogsCleared),
                                    ),
                                  );
                                }
                              },
                              child: Text(l10n.clear),
                            ),
                          ],
                        ),
                        const Divider(height: 1),
                        _ResponsiveActionTile(
                          isCompact: isCompact,
                          icon: const Icon(Icons.folder_outlined),
                          title: l10n.settingsOpenFoldersTitle,
                          subtitle: l10n.settingsOpenFoldersDesc,
                          actions: [
                            OutlinedButton(
                              onPressed: () async {
                                final fs = FileService();
                                final dir = await fs.getLogsDirectory();
                                await fs.openDirectory(dir);
                              },
                              child: Text(l10n.folderLogsButton),
                            ),
                            OutlinedButton(
                              onPressed: () async {
                                final fs = FileService();
                                final dir = await fs.getBackupDirectory();
                                await fs.openDirectory(dir);
                              },
                              child: Text(l10n.folderBackupsButton),
                            ),
                          ],
                        ),
                        const Divider(height: 1),
                        _ResponsiveActionTile(
                          isCompact: isCompact,
                          icon: const Icon(Icons.delete_sweep_outlined),
                          title: l10n.settingsClearDiskLogsTitle,
                          subtitle: l10n.settingsClearDiskLogsDesc,
                          actions: [
                            OutlinedButton(
                              onPressed: () async {
                                final ok = await _confirmAction(
                                  context,
                                  title: l10n.deleteDiskLogsConfirmTitle,
                                  message: l10n.deleteDiskLogsConfirmBody,
                                  confirmLabel: l10n.deleteLogsButton,
                                );
                                if (!ok) return;
                                final count =
                                    await FileService().clearSavedLogs();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        count == 0
                                            ? l10n.noSavedLogsToDelete
                                            : l10n.deletedSavedLogsCount(count),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text(l10n.delete),
                            ),
                          ],
                        ),
                        const Divider(height: 1),
                        _ResponsiveActionTile(
                          isCompact: isCompact,
                          icon: Icon(
                            Icons.restart_alt_rounded,
                            color: colorScheme.error,
                          ),
                          title: l10n.settingsResetDefaultsTitle,
                          subtitle: l10n.settingsResetDefaultsDesc,
                          actions: [
                            OutlinedButton(
                              onPressed: () async {
                                final ok = await _confirmAction(
                                  context,
                                  title: l10n.resetAllSettingsConfirmTitle,
                                  message: l10n.resetAllSettingsConfirmBody,
                                  confirmLabel: l10n.reset,
                                );
                                if (!ok) return;
                                await settings.resetToDefaults();
                                deviceProvider.startMonitoring();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.settingsRestoredNotice),
                                    ),
                                  );
                                }
                              },
                              child: Text(l10n.reset),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Card(
                    color: colorScheme.surfaceContainerLow,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Row(
                        children: [
                          Icon(Icons.shield_outlined, color: colorScheme.primary),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              l10n.settingsFooterSummary(
                                AppConfig.appName,
                                AppConfig.appDisplayVersion,
                              ),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DiagRow extends StatelessWidget {
  final String label;
  final String value;

  const _DiagRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: SelectableText(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponsiveActionTile extends StatelessWidget {
  final bool isCompact;
  final Widget icon;
  final String title;
  final String subtitle;
  final List<Widget> actions;

  const _ResponsiveActionTile({
    required this.isCompact,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (isCompact) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: icon,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: actions,
            ),
          ],
        ),
      );
    }

    return ListTile(
      leading: icon,
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Wrap(
        spacing: AppSpacing.xs,
        children: actions,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
