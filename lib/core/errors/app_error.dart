import '../l10n/l10n_helper.dart';

/// Structured error categories for actionable user feedback and diagnostics.
enum AppErrorCategory {
  deviceConnection,
  adb,
  fastboot,
  driver,
  file,
  imageValidation,
  compatibility,
  permission,
  network,
  download,
  extraction,
  process,
  flashing,
  application,
}

/// User-facing, actionable error model preserving technical details for logs.
class AppError implements Exception {
  final AppErrorCategory category;
  final String title;
  final String message;
  final String? reason;
  final String? affectedStage;
  final bool deviceSafe;
  final String nextSteps;
  final bool canSafelyRetry;
  final String? technicalDetails;

  const AppError({
    required this.category,
    required this.title,
    required this.message,
    this.reason,
    this.affectedStage,
    this.deviceSafe = true,
    required this.nextSteps,
    this.canSafelyRetry = true,
    this.technicalDetails,
  });

  String toClipboardText() {
    final buf = StringBuffer()
      ..writeln('[$categoryName] $title')
      ..writeln('What happened: $message');
    if (reason != null) buf.writeln('Reason: $reason');
    if (affectedStage != null) buf.writeln('Stage: $affectedStage');
    buf.writeln('Device Safe: ${deviceSafe ? 'Yes' : 'Uncertain — check device'}');
    buf.writeln('Next steps: $nextSteps');
    if (technicalDetails != null && technicalDetails!.isNotEmpty) {
      buf.writeln('Technical details:\n$technicalDetails');
    }
    return buf.toString();
  }

  String get categoryName {
    final l10n = appL10n;
    switch (category) {
      case AppErrorCategory.deviceConnection:
        return l10n.errCatDeviceConnection;
      case AppErrorCategory.adb:
        return l10n.errCatAdb;
      case AppErrorCategory.fastboot:
        return l10n.errCatFastboot;
      case AppErrorCategory.driver:
        return l10n.errCatDriver;
      case AppErrorCategory.file:
        return l10n.errCatFile;
      case AppErrorCategory.imageValidation:
        return l10n.errCatImageValidation;
      case AppErrorCategory.compatibility:
        return l10n.errCatCompatibility;
      case AppErrorCategory.permission:
        return l10n.errCatPermission;
      case AppErrorCategory.network:
        return l10n.errCatNetwork;
      case AppErrorCategory.download:
        return l10n.errCatDownload;
      case AppErrorCategory.extraction:
        return l10n.errCatExtraction;
      case AppErrorCategory.process:
        return l10n.errCatProcess;
      case AppErrorCategory.flashing:
        return l10n.errCatFlashing;
      case AppErrorCategory.application:
        return l10n.errCatApplication;
    }
  }

  @override
  String toString() => '$title: $message';
}
