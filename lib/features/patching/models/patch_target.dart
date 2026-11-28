import '../../../core/config/app_config.dart';
import '../../../generated/l10n.dart';

enum PatchTarget {
  folkpatch,
  apatch;

  String get displayName {
    switch (this) {
      case PatchTarget.folkpatch:
        return 'FolkPatch';
      case PatchTarget.apatch:
        return 'APatch';
    }
  }

  String get directoryName {
    switch (this) {
      case PatchTarget.folkpatch:
        return 'folkpatch';
      case PatchTarget.apatch:
        return 'apatch';
    }
  }

  String get packageName {
    switch (this) {
      case PatchTarget.folkpatch:
        return AppConfig.folkpatchPackageName;
      case PatchTarget.apatch:
        return AppConfig.apatchPackageName;
    }
  }

  String get repoUrl {
    switch (this) {
      case PatchTarget.folkpatch:
        return 'https://github.com/LyraVoid/FolkPatch';
      case PatchTarget.apatch:
        return 'https://github.com/bmax121/APatch';
    }
  }

  String localizedSubtitle(S l10n) {
    switch (this) {
      case PatchTarget.folkpatch:
        return l10n.folkpatchSubtitle;
      case PatchTarget.apatch:
        return l10n.apatchSubtitle;
    }
  }
}