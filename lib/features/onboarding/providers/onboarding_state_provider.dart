import 'package:flutter/foundation.dart';
import '../../../shared/models/app_mode.dart';
import '../models/onboarding_state.dart';

/// State controller for managing the progressive Adaptive Onboarding flow.
class OnboardingController extends ChangeNotifier {
  OnboardingState _state;

  OnboardingController({
    AppMode? initialMode,
    DateTime? initialLastPeriod,
    int? initialCycleLength,
    int? initialPeriodDuration,
    String? initialTtcDuration,
    List<String>? initialCycleGoals,
    bool initialCompleted = false,
  }) : _state = OnboardingState(
         selectedMode: initialMode,
         lastPeriodStartDate: initialLastPeriod,
         averageCycleLength: initialCycleLength ?? 28,
         typicalPeriodDuration: initialPeriodDuration ?? 5,
         tryingToConceiveDuration: initialTtcDuration,
         cycleAwarenessGoals: initialCycleGoals ?? const [],
         hasCompletedOnboarding: initialCompleted,
       );

  OnboardingState get state => _state;
  AppMode? get selectedMode => _state.selectedMode;
  DateTime? get lastPeriodStartDate => _state.lastPeriodStartDate;
  int get averageCycleLength => _state.averageCycleLength ?? 28;
  int get typicalPeriodDuration => _state.typicalPeriodDuration ?? 5;
  String? get tryingToConceiveDuration => _state.tryingToConceiveDuration;
  List<String> get cycleAwarenessGoals => _state.cycleAwarenessGoals;
  int get currentStep => _state.currentStep;
  bool get canProceed => _state.canProceed;
  bool get hasCompletedOnboarding => _state.hasCompletedOnboarding;

  void selectMode(AppMode mode) {
    if (_state.selectedMode != mode) {
      _state = _state.copyWith(selectedMode: mode);
      notifyListeners();
    }
  }

  void setLastPeriodStartDate(DateTime date) {
    _state = _state.copyWith(lastPeriodStartDate: date);
    notifyListeners();
  }

  void setAverageCycleLength(int days) {
    final clamped = days.clamp(18, 60);
    if (_state.averageCycleLength != clamped) {
      _state = _state.copyWith(averageCycleLength: clamped);
      notifyListeners();
    }
  }

  void setTypicalPeriodDuration(int days) {
    final clamped = days.clamp(1, 14);
    if (_state.typicalPeriodDuration != clamped) {
      _state = _state.copyWith(typicalPeriodDuration: clamped);
      notifyListeners();
    }
  }

  void setTtcDuration(String duration) {
    if (_state.tryingToConceiveDuration != duration) {
      _state = _state.copyWith(tryingToConceiveDuration: duration);
      notifyListeners();
    }
  }

  void toggleCycleAwarenessGoal(String goal) {
    final currentGoals = List<String>.from(_state.cycleAwarenessGoals);
    if (currentGoals.contains(goal)) {
      currentGoals.remove(goal);
    } else {
      currentGoals.add(goal);
    }
    _state = _state.copyWith(cycleAwarenessGoals: currentGoals);
    notifyListeners();
  }

  void setCycleAwarenessGoals(List<String> goals) {
    _state = _state.copyWith(cycleAwarenessGoals: List<String>.from(goals));
    notifyListeners();
  }

  void completeOnboarding() {
    _state = _state.copyWith(hasCompletedOnboarding: true);
    notifyListeners();
  }

  void goToStep(int step) {
    if (step >= 1 && step <= _state.totalSteps) {
      _state = _state.copyWith(currentStep: step);
      notifyListeners();
    }
  }

  void nextStep() {
    if (_state.currentStep < _state.totalSteps) {
      _state = _state.copyWith(currentStep: _state.currentStep + 1);
      notifyListeners();
    }
  }

  void previousStep() {
    if (_state.currentStep > 1) {
      _state = _state.copyWith(currentStep: _state.currentStep - 1);
      notifyListeners();
    }
  }

  void reset() {
    _state = const OnboardingState();
    notifyListeners();
  }
}
