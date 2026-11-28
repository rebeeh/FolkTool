import '../../generated/l10n.dart';

/// Resolves the active [S] localization instance when initialized, or returns
/// a default English fallback when invoked in headless unit tests without
/// calling `S.load(...)`.
S get appL10n => S.maybeCurrent ?? S();
