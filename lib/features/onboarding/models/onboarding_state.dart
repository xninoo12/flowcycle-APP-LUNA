import 'package:flutter/foundation.dart';
import '../../../shared/models/app_mode.dart';

/// Immutable state representation for the Adaptive Onboarding flow.
class OnboardingState {
  final AppMode? selectedMode;
  final DateTime? lastPeriodStartDate;
  final int? averageCycleLength;
  final int? typicalPeriodDuration;
  final String? tryingToConceiveDuration;
  final List<String> cycleAwarenessGoals;
  final int currentStep;
  final int totalSteps;
  final bool isSubmitting;
  final bool hasCompletedOnboarding;

  const OnboardingState({
    this.selectedMode,
    this.lastPeriodStartDate,
    this.averageCycleLength = 28,
    this.typicalPeriodDuration = 5,
    this.tryingToConceiveDuration,
    this.cycleAwarenessGoals = const [],
    this.currentStep = 1,
    this.totalSteps = 5,
    this.isSubmitting = false,
    this.hasCompletedOnboarding = false,
  });

  bool get canProceed {
    if (isSubmitting) return false;
    switch (currentStep) {
      case 1:
        return selectedMode != null;
      case 2:
        return lastPeriodStartDate != null;
      case 3:
        return averageCycleLength != null &&
            averageCycleLength! >= 18 &&
            averageCycleLength! <= 60;
      case 4:
        return typicalPeriodDuration != null &&
            typicalPeriodDuration! >= 1 &&
            typicalPeriodDuration! <= 14;
      case 5:
        if (selectedMode == AppMode.tryingToConceive) {
          return tryingToConceiveDuration != null &&
              tryingToConceiveDuration!.isNotEmpty;
        } else if (selectedMode == AppMode.cycleAwareness) {
          return cycleAwarenessGoals.isNotEmpty;
        }
        return true;
      default:
        return true;
    }
  }

  double get progress =>
      totalSteps > 0 ? (currentStep / totalSteps).clamp(0.0, 1.0) : 0.0;

  OnboardingState copyWith({
    AppMode? selectedMode,
    bool clearMode = false,
    DateTime? lastPeriodStartDate,
    bool clearLastPeriod = false,
    int? averageCycleLength,
    int? typicalPeriodDuration,
    String? tryingToConceiveDuration,
    bool clearTtcDuration = false,
    List<String>? cycleAwarenessGoals,
    int? currentStep,
    int? totalSteps,
    bool? isSubmitting,
    bool? hasCompletedOnboarding,
  }) {
    return OnboardingState(
      selectedMode: clearMode ? null : (selectedMode ?? this.selectedMode),
      lastPeriodStartDate: clearLastPeriod
          ? null
          : (lastPeriodStartDate ?? this.lastPeriodStartDate),
      averageCycleLength: averageCycleLength ?? this.averageCycleLength,
      typicalPeriodDuration:
          typicalPeriodDuration ?? this.typicalPeriodDuration,
      tryingToConceiveDuration: clearTtcDuration
          ? null
          : (tryingToConceiveDuration ?? this.tryingToConceiveDuration),
      cycleAwarenessGoals: cycleAwarenessGoals ?? this.cycleAwarenessGoals,
      currentStep: currentStep ?? this.currentStep,
      totalSteps: totalSteps ?? this.totalSteps,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingState &&
          runtimeType == other.runtimeType &&
          selectedMode == other.selectedMode &&
          lastPeriodStartDate == other.lastPeriodStartDate &&
          averageCycleLength == other.averageCycleLength &&
          typicalPeriodDuration == other.typicalPeriodDuration &&
          tryingToConceiveDuration == other.tryingToConceiveDuration &&
          listEquals(cycleAwarenessGoals, other.cycleAwarenessGoals) &&
          currentStep == other.currentStep &&
          totalSteps == other.totalSteps &&
          isSubmitting == other.isSubmitting &&
          hasCompletedOnboarding == other.hasCompletedOnboarding;

  @override
  int get hashCode =>
      selectedMode.hashCode ^
      lastPeriodStartDate.hashCode ^
      averageCycleLength.hashCode ^
      typicalPeriodDuration.hashCode ^
      tryingToConceiveDuration.hashCode ^
      Object.hashAll(cycleAwarenessGoals) ^
      currentStep.hashCode ^
      totalSteps.hashCode ^
      isSubmitting.hashCode ^
      hasCompletedOnboarding.hashCode;
}
