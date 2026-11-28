import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/config/app_semantic_colors.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../generated/l10n.dart';
import '../../device/providers/device_provider.dart';
import '../services/driver_service.dart';

class DriverInstallScreen extends StatefulWidget {
  const DriverInstallScreen({super.key});

  @override
  State<DriverInstallScreen> createState() => _DriverInstallScreenState();
}

class _DriverInstallScreenState extends State<DriverInstallScreen> {
  final DriverService _driverService = DriverService();
  String? _installingDriver;
  String? _installedDriver;
  DriverInstallResult? _lastInstallResult;

  Future<void> _installDriver(DriverInfo driver) async {
    final l10n = S.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.driverInstallConfirmTitle(driver.name)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.driverPublisherLabel(driver.publisher)),
            const SizedBox(height: AppSpacing.xs),
            Text(l10n.driverSupportedModesLabel(driver.supportedModes)),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.driverSignatureNotice),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.verifyAndInstall),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() {
      _installingDriver = driver.executableName;
      _lastInstallResult = null;
    });

    final result =
        await _driverService.installDriverDetailed(driver.executableName);

    if (!mounted) return;
    setState(() {
      _installingDriver = null;
      _lastInstallResult = result;
      if (result.launched) {
        _installedDriver = driver.executableName;
      }
    });

    final semantic = context.semantic;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.launched
              ? l10n.installDriverSuccessReconnect(l10n.installDriverSuccess)
              : (result.errorMessage ?? l10n.installDriverFailed('')),
        ),
        backgroundColor: result.launched
            ? semantic.success
            : Theme.of(context).colorScheme.error,
      ),
    );
  }

  Future<void> _openOfficialSamsungDriver() async {
    final l10n = S.of(context);
    final uri = Uri.parse(DriverService.samsungDriver.officialUrl!);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.unableOpenSamsungPage(e))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.driverInstallPage),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 560;
          final pad = isCompact ? 14.0 : 20.0;

          return SingleChildScrollView(
            padding: EdgeInsets.all(pad),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildDriverStatusAndTroubleshooting(context, l10n),
                    const SizedBox(height: 16),
                    _buildSamsungDriverCard(context, l10n),
                    const SizedBox(height: 14),
                    ResponsivePairGrid(
                      breakpoint: 680,
                      first: _buildDriverCard(
                        driver: DriverService.drivers[0],
                        title: l10n.qualcommDriver64,
                        description: l10n.qualcommDriver64Desc,
                        color: Colors.blue,
                      ),
                      second: _buildDriverCard(
                        driver: DriverService.drivers[1],
                        title: l10n.qualcommDriver32,
                        description: l10n.qualcommDriver32Desc,
                        color: context.semantic.success,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ResponsivePairGrid(
                      breakpoint: 680,
                      first: _buildDriverCard(
                        driver: DriverService.drivers[2],
                        title: l10n.mediatekDriver,
                        description: l10n.mediatekDriverDesc,
                        color: Colors.purple,
                      ),
                      second: _buildDriverCard(
                        driver: DriverService.drivers[3],
                        title: l10n.oneplusAdbDriver,
                        description: l10n.oneplusAdbDriverDesc,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildDriverCard(
                      driver: DriverService.drivers[4],
                      title: l10n.oppoAdbDriver,
                      description: l10n.oppoAdbDriverDesc,
                      color: Colors.teal,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDriverStatusAndTroubleshooting(BuildContext context, S l10n) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final semantic = context.semantic;
    final deviceProvider = context.watch<DeviceProvider>();
    final driverInstalled = deviceProvider.driverInstalled;
    final diag = deviceProvider.toolchainDiagnostics;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  driverInstalled
                      ? Icons.verified_outlined
                      : Icons.build_circle_outlined,
                  color: driverInstalled ? semantic.success : semantic.warning,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    driverInstalled
                        ? l10n.toolsAvailableTitle
                        : l10n.toolsMissingTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => deviceProvider.checkDriver(),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: Text(l10n.recheck),
                ),
              ],
            ),
            if (diag != null) ...[
              const SizedBox(height: 6),
              Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  if (diag.adbVersion != null)
                    Text(
                      'ADB: ${diag.adbVersion}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (diag.fastbootVersion != null)
                    Text(
                      'Fastboot: ${diag.fastbootVersion}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.driverHelpGuide,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            if (_lastInstallResult != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                _lastInstallResult!.launched
                    ? l10n.driverLaunchedResult(
                        _lastInstallResult!.signature?.status.name ??
                            l10n.versionVerifiedBadge,
                      )
                    : (_lastInstallResult!.errorMessage ??
                        l10n.installDriverFailed('')),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _lastInstallResult!.launched
                      ? semantic.success
                      : colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSamsungDriverCard(BuildContext context, S l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final samsung = DriverService.samsungDriver;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.phone_android_rounded,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.samsungDriverName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${samsung.publisher} • ${l10n.samsungDriverModes}',
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
            const SizedBox(height: 12),
            Text(
              l10n.samsungDriverDesc,
              style: TextStyle(
                fontSize: 12.5,
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: _openOfficialSamsungDriver,
                icon: const Icon(Icons.open_in_new, size: 18),
                label: Text(l10n.downloadOfficialSamsungDriver),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverCard({
    required DriverInfo driver,
    required String title,
    required String description,
    required Color color,
  }) {
    final l10n = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final semantic = context.semantic;
    final isInstalling = _installingDriver == driver.executableName;
    final isInstalled = _installedDriver == driver.executableName;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                  child: Icon(
                    Icons.usb,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
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
            const SizedBox(height: 14),
            if (isInstalled)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: semantic.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: semantic.success.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: semantic.success, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.installDriverSuccess,
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: isInstalling ? null : () => _installDriver(driver),
                  icon: isInstalling
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download, size: 18),
                  label: Text(
                    isInstalling ? l10n.installing : l10n.installDriver,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}