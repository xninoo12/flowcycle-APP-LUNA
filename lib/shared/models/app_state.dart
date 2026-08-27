import 'package:flutter/material.dart';
import 'app_mode.dart';

/// Immutable model representing the overarching application and session state.
class AppState {
  final bool isFirstLaunch;
  final bool isAuthenticated;
  final bool hasCompletedOnboarding;
  final AppMode currentMode;
  final bool isPremium;
  final ThemeMode themeMode;

  const AppState({
    this.isFirstLaunch = true,
    this.isAuthenticated = false,
    this.hasCompletedOnboarding = false,
    this.currentMode = AppMode.cycleAwareness,
    this.isPremium = false,
    this.themeMode = ThemeMode.light,
  });

  AppState copyWith({
    bool? isFirstLaunch,
    bool? isAuthenticated,
    bool? hasCompletedOnboarding,
    AppMode? currentMode,
    bool? isPremium,
    ThemeMode? themeMode,
  }) {
    return AppState(
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      currentMode: currentMode ?? this.currentMode,
      isPremium: isPremium ?? this.isPremium,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  String toString() {
    return 'AppState(isFirstLaunch: $isFirstLaunch, isAuthenticated: $isAuthenticated, hasCompletedOnboarding: $hasCompletedOnboarding, currentMode: $currentMode, isPremium: $isPremium, themeMode: $themeMode)';
  }
}
