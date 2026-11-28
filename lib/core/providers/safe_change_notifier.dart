import 'package:flutter/foundation.dart';

/// Guards asynchronous [ChangeNotifier] subclasses against calling
/// [notifyListeners] after [dispose] has run.
mixin SafeChangeNotifierMixin on ChangeNotifier {
  bool _disposed = false;

  /// Whether [dispose] has been called on this notifier.
  bool get isDisposed => _disposed;

  @override
  void notifyListeners() {
    if (_disposed) return;
    super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
