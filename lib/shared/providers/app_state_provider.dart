import 'package:flutter/foundation.dart';
import '../models/app_mode.dart';
import '../models/app_state.dart';

/// Foundation state controller managing top-level application state.
///
/// Pre-structured for direct conversion to Riverpod `Notifier<AppState>` or `StateNotifier<AppState>`.
class AppStateController extends ChangeNotifier {
  AppState _state = const AppState();

  AppState get state => _state;

  void markFirstLaunchComplete() {
    _state = _state.copyWith(isFirstLaunch: false);
    notifyListeners();
  }

  void setAuthenticated(bool isAuthenticated) {
    _state = _state.copyWith(isAuthenticated: isAuthenticated);
    notifyListeners();
  }

  void completeOnboarding() {
    _state = _state.copyWith(hasCompletedOnboarding: true);
    notifyListeners();
  }

  void setAppMode(AppMode mode) {
    if (_state.currentMode != mode) {
      _state = _state.copyWith(currentMode: mode);
      notifyListeners();
    }
  }

  void setPremiumStatus(bool isPremium) {
    _state = _state.copyWith(isPremium: isPremium);
    notifyListeners();
  }

  void logout() {
    _state = _state.copyWith(
      isAuthenticated: false,
      hasCompletedOnboarding: false,
    );
    notifyListeners();
  }
}
