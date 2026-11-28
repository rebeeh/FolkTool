import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../generated/l10n.dart';
import '../models/patch_target.dart';
import '../providers/version_provider.dart';

class PatchTargetSelector extends StatelessWidget {
  const PatchTargetSelector({super.key});

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
                Icon(Icons.shield_outlined,
                    color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.patchTarget,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        l10n.patchTargetDesc,
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
            Selector<VersionProvider, PatchTarget>(
              selector: (_, p) => p.currentTarget,
              builder: (context, currentTarget, _) {
                final summary = context.select<VersionProvider, String?>(
                  (vp) => vp.summaryForTarget(currentTarget)?.kptoolsVersion,
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<PatchTarget>(
                        segments: PatchTarget.values.map((target) {
                          return ButtonSegment<PatchTarget>(
                            value: target,
                            label: Text(target.displayName),
                            icon: Icon(
                              target == PatchTarget.folkpatch
                                  ? Icons.extension_outlined
                                  : Icons.security_outlined,
                              size: 18,
                            ),
                          );
                        }).toList(),
                        selected: {currentTarget},
                        onSelectionChanged: (selection) {
                          if (selection.isNotEmpty) {
                            context
                                .read<VersionProvider>()
                                .setTarget(selection.first);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 14,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${currentTarget.localizedSubtitle(l10n)}'
                            '${summary != null ? ' • ${l10n.versionKptoolsLabel}: $summary' : ''}',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}