import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/config/app_semantic_colors.dart';
import '../../../generated/l10n.dart';
import '../models/kp_version.dart';
import '../providers/version_provider.dart';

class VersionSelector extends StatelessWidget {
  const VersionSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.settings_system_daydream,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.kernelPatchVersion,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        l10n.selectVersionDesc,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Consumer<VersionProvider>(
              builder: (context, versionProvider, child) {
                if (versionProvider.isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (versionProvider.availableVersions.isEmpty &&
                    versionProvider.selectedVersion?.isCustom != true) {
                  return _buildNoVersions(context);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildVersionDropdown(context, versionProvider),
                    if (versionProvider.selectedVersion != null) ...[
                      const SizedBox(height: 12),
                      _buildVersionDetailsCard(
                        context,
                        versionProvider.selectedVersion!,
                        l10n,
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionDropdown(
    BuildContext context,
    VersionProvider versionProvider,
  ) {
    final l10n = S.of(context);
    final selected = versionProvider.selectedVersion;

    final items = <DropdownMenuItem<KpVersion>>[
      for (final version in versionProvider.availableVersions)
        DropdownMenuItem<KpVersion>(
          value: version,
          child: _buildVersionItem(context, version),
        ),
      if (selected?.isCustom == true)
        DropdownMenuItem<KpVersion>(
          value: selected,
          child: _buildVersionItem(context, selected!),
        )
      else
        DropdownMenuItem<KpVersion>(
          value: null,
          child: Row(
            children: [
              Icon(Icons.add_circle_outline,
                  color: Colors.orange[600], size: 18),
              const SizedBox(width: 8),
              Text(l10n.customVersion, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
    ];

    return DropdownButtonFormField<KpVersion>(
      key: ValueKey('${versionProvider.currentTarget.name}_${selected?.id}'),
      initialValue: selected,
      isExpanded: true,
      items: items,
      onChanged: (KpVersion? version) async {
        if (version == null) {
          await _selectCustomVersion(context, versionProvider);
        } else {
          versionProvider.selectVersion(version);
        }
      },
    );
  }

  Widget _buildVersionItem(BuildContext context, KpVersion version) {
    final l10n = S.of(context);
    return Text(
      version.displayTitle(l10n),
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildVersionDetailsCard(
    BuildContext context,
    KpVersion v,
    S l10n,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final semantic = context.semantic;
    final notes = v.localizedNotes(l10n);

    final channelLabel = v.isPrerelease
        ? l10n.versionChannelPrerelease
        : (v.isLegacyChannel
            ? l10n.versionChannelLegacy
            : l10n.versionChannelStable);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (v.recommended)
                _chip(
                  l10n.versionRecommended,
                  semantic.success,
                  semantic.onSuccess,
                ),
              _chip(
                v.isCustom ? l10n.versionCustom : channelLabel,
                colorScheme.primaryContainer,
                colorScheme.onPrimaryContainer,
              ),
              if (v.supportsUnpack)
                _chip(
                  l10n.versionSupportUnpack,
                  colorScheme.secondaryContainer,
                  colorScheme.onSecondaryContainer,
                ),
              if (v.sha256 != null && v.verifiedOnDisk)
                _chip(
                  l10n.versionVerifiedBadge,
                  semantic.success.withValues(alpha: 0.14),
                  semantic.success,
                ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              _metaItem(context, l10n.versionManagerLabel,
                  '${v.source.displayName} ${v.managerVersion}'),
              _metaItem(context, l10n.versionKpLabel, v.version),
              if (v.releaseDate.isNotEmpty)
                _metaItem(context, l10n.versionReleaseDateLabel, v.releaseDate),
              if (v.kptoolsVersion != null)
                _metaItem(context, l10n.versionKptoolsLabel, v.kptoolsVersion!),
            ],
          ),
          if (v.androidSupport.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              '${l10n.versionCompatLabel}: ${v.androidSupport}',
              style: TextStyle(
                fontSize: 11.5,
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          if (notes.isNotEmpty && notes != v.androidSupport) ...[
            const SizedBox(height: 4),
            Text(
              notes,
              style: TextStyle(
                fontSize: 11.5,
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
          if (!v.supportsUnpack || v.isLegacyChannel) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: semantic.warning.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: semantic.warning.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: semantic.warning,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.versionUnpackUnsupportedWarn(v.version),
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _chip(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }

  Widget _metaItem(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildNoVersions(BuildContext context) {
    final l10n = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.error.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colorScheme.error, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.noVersionsAvailable,
              style:
                  TextStyle(fontSize: 12, color: colorScheme.onErrorContainer),
            ),
          ),
          TextButton(
            onPressed: () => _selectCustomVersion(
              context,
              context.read<VersionProvider>(),
            ),
            child: Text(l10n.customVersion),
          ),
        ],
      ),
    );
  }

  Future<void> _selectCustomVersion(
    BuildContext context,
    VersionProvider versionProvider,
  ) async {
    final l10n = S.of(context);

    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      dialogTitle: l10n.selectCustomVersion,
    );

    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final success = await versionProvider.selectCustomVersion(filePath);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? l10n.customVersionSaved : l10n.invalidVersionFile,
            ),
          ),
        );
      }
    }
  }
}