import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/config/app_semantic_colors.dart';
import '../../../generated/l10n.dart';
import '../providers/device_provider.dart';

class DeviceStatusCard extends StatelessWidget {
  final bool showRefreshButton;
  final VoidCallback? onRefresh;

  const DeviceStatusCard({
    super.key,
    this.showRefreshButton = true,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return RepaintBoundary(
      child: Consumer<DeviceProvider>(
        builder: (context, deviceProvider, child) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.devices,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              l10n.deviceStatus,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            _buildStatusPill(context, deviceProvider, l10n),
                          ],
                        ),
                      ),
                      if (showRefreshButton)
                        SizedBox(
                          height: 32,
                          child: deviceProvider.isManualChecking
                              ? Center(
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                )
                              : TextButton.icon(
                                  onPressed: deviceProvider.isChecking
                                      ? null
                                      : () {
                                          if (onRefresh != null) {
                                            onRefresh!();
                                          } else {
                                            deviceProvider
                                                .manualRefreshDevices();
                                          }
                                        },
                                  icon: const Icon(Icons.refresh, size: 18),
                                  label: Text(l10n.refresh),
                                  style: TextButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                        ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildStatusContent(context, deviceProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusPill(
    BuildContext context,
    DeviceProvider provider,
    S l10n,
  ) {
    final semantic = context.semantic;
    final colorScheme = Theme.of(context).colorScheme;
    Color dotColor;
    String label;
    switch (provider.connectionState) {
      case DeviceConnectionState.adbConnected:
        dotColor = semantic.success;
        label = l10n.deviceStateAdb;
        break;
      case DeviceConnectionState.fastbootConnected:
        dotColor = semantic.success;
        label = l10n.deviceStateFastboot;
        break;
      case DeviceConnectionState.fastbootdConnected:
        dotColor = semantic.warning;
        label = l10n.deviceStateFastbootd;
        break;
      case DeviceConnectionState.adbUnauthorized:
        dotColor = semantic.warning;
        label = l10n.deviceStateUnauthorized;
        break;
      case DeviceConnectionState.adbOffline:
        dotColor = semantic.warning;
        label = l10n.deviceStateOffline;
        break;
      case DeviceConnectionState.multipleDevices:
        dotColor = semantic.warning;
        label = l10n.deviceStateMultiple;
        break;
      case DeviceConnectionState.unsupportedMode:
        dotColor = semantic.warning;
        label = l10n.deviceStateUnsupported;
        break;
      case DeviceConnectionState.error:
        dotColor = colorScheme.error;
        label = l10n.deviceStateError;
        break;
      case DeviceConnectionState.checking:
        dotColor = colorScheme.primary;
        label = l10n.checking;
        break;
      case DeviceConnectionState.disconnected:
        dotColor = colorScheme.outline;
        label = l10n.deviceStateDisconnected;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: dotColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: dotColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusContent(BuildContext context, DeviceProvider provider) {
    final l10n = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    if (!provider.driverInstalled) {
      return _buildWarningItem(
        context,
        l10n.checkingDriver,
        l10n.checkingDriverDesc,
        context.semantic.warning,
      );
    }

    switch (provider.connectionState) {
      case DeviceConnectionState.disconnected:
        return _buildDisconnected(context);
      case DeviceConnectionState.adbConnected:
        return _buildAdbConnected(context, provider);
      case DeviceConnectionState.adbUnauthorized:
        final dev = provider.unauthorizedAdbDevices.first;
        return _buildWarningItem(
          context,
          l10n.usbUnauthorizedTitle(dev.serial),
          l10n.usbUnauthorizedDesc,
          context.semantic.warning,
        );
      case DeviceConnectionState.adbOffline:
        final dev = provider.offlineAdbDevices.first;
        return _buildWarningItem(
          context,
          l10n.adbOfflineTitle(dev.serial),
          l10n.adbOfflineDesc,
          context.semantic.warning,
        );
      case DeviceConnectionState.fastbootdConnected:
        final dev = provider.selectedTargetDevice ?? provider.fastbootDevices.first;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWarningItem(
              context,
              l10n.fastbootdDetectedTitle(dev.serial),
              l10n.fastbootdDetectedDesc,
              context.semantic.warning,
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.tonalIcon(
                onPressed: () => provider.rebootFastbootdToBootloader(),
                icon: const Icon(Icons.restart_alt, size: 18),
                label: Text(l10n.rebootToFastboot),
              ),
            ),
          ],
        );
      case DeviceConnectionState.unsupportedMode:
        final dev = provider.unsupportedDevices.first;
        return _buildWarningItem(
          context,
          l10n.unsupportedModeTitle(dev.localizedStateText(l10n), dev.serial),
          l10n.unsupportedModeDesc,
          context.semantic.warning,
        );
      case DeviceConnectionState.error:
        return _buildWarningItem(
          context,
          l10n.deviceErrorTitle,
          provider.errorMessage ?? l10n.noDeviceDetectedDesc,
          colorScheme.error,
        );
      case DeviceConnectionState.multipleDevices:
        return _buildMultipleDevices(context, provider);
      case DeviceConnectionState.fastbootConnected:
        return _buildFastbootConnected(context, provider);
      case DeviceConnectionState.checking:
        return _buildChecking(context);
    }
  }

  Widget _buildDisconnected(BuildContext context) {
    final l10n = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        _buildStatusItem(
          context,
          l10n.noDeviceDetected,
          l10n.noDeviceDetectedDesc,
          colorScheme.outline,
          Icons.usb_off,
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.25),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.help_outline,
                      size: 16, color: colorScheme.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      l10n.deviceConnectionTips,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                l10n.deviceConnectionTipsDesc,
                style: TextStyle(
                  fontSize: 11.5,
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMultipleDevices(BuildContext context, DeviceProvider provider) {
    final l10n = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final semantic = context.semantic;
    final candidates = [
      ...provider.fastbootDevices,
      ...provider.authorizedAdbDevices,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWarningItem(
          context,
          l10n.multipleDevicesTitle,
          l10n.multipleDevicesDesc,
          semantic.warning,
        ),
        if (candidates.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: candidates.map((d) {
              final selected = provider.selectedSerial == d.serial;
              return ChoiceChip(
                label: Text('${d.model ?? d.serial} (${d.localizedStateText(l10n)})'),
                selected: selected,
                selectedColor: colorScheme.primaryContainer,
                onSelected: (_) => provider.selectDevice(d.serial),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildAdbConnected(BuildContext context, DeviceProvider provider) {
    final l10n = S.of(context);
    final device =
        provider.selectedTargetDevice ?? provider.authorizedAdbDevices.first;
    final details = <String>[
      l10n.serial(device.serial),
      if (device.model != null && device.model!.isNotEmpty) device.model!,
      if (device.androidVersion != null && device.androidVersion!.isNotEmpty)
        l10n.androidVersionLabel(device.androidVersion!),
      if (device.batteryLevel != null)
        l10n.batteryLevelLabel(device.batteryLevel!),
    ].join(' • ');

    return _buildStatusItem(
      context,
      l10n.adbConnected,
      details,
      context.semantic.success,
      Icons.android,
    );
  }

  Widget _buildFastbootConnected(BuildContext context, DeviceProvider provider) {
    final l10n = S.of(context);
    final device =
        provider.selectedTargetDevice ?? provider.fastbootDevices.first;
    final lockText = device.bootloaderUnlocked == null
        ? ''
        : (device.bootloaderUnlocked!
            ? ' • ${l10n.bootloaderUnlockedLabel}'
            : ' • ${l10n.bootloaderLockedLabel}');
    return _buildStatusItem(
      context,
      l10n.fastbootConnected,
      '${l10n.serial(device.serial)}$lockText',
      context.semantic.success,
      Icons.phone_android,
    );
  }

  Widget _buildChecking(BuildContext context) {
    final l10n = S.of(context);
    return _buildStatusItem(
      context,
      l10n.checking,
      l10n.scanning,
      Theme.of(context).colorScheme.primary,
      Icons.search,
    );
  }

  Widget _buildStatusItem(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    IconData icon,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningItem(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
  ) {
    return _buildStatusItem(
      context,
      title,
      subtitle,
      color,
      Icons.warning_amber_outlined,
    );
  }
}