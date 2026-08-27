import 'package:flutter/foundation.dart';
import '../models/app_mode.dart';

/// Dedicated controller for switching and observing the active app experience mode.
class AppModeController extends ChangeNotifier {
  AppMode _mode = AppMode.cycleAwareness;

  AppMode get currentMode => _mode;
  bool get isTTC => _mode == AppMode.tryingToConceive;
  bool get isCycleAwareness => _mode == AppMode.cycleAwareness;

  void switchMode(AppMode newMode) {
    if (_mode != newMode) {
      _mode = newMode;
      notifyListeners();
    }
  }

  void toggleMode() {
    _mode = _mode == AppMode.cycleAwareness
        ? AppMode.tryingToConceive
        : AppMode.cycleAwareness;
    notifyListeners();
  }
}
