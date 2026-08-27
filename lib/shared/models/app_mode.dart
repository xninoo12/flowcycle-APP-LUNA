/// Represents the primary functional mode of the FlowCycle application.
enum AppMode {
  /// General cycle tracking, period prediction, wellness & hormone awareness.
  cycleAwareness,

  /// Enhanced ovulation tracking, basal body temperature, fertile window optimization, intercourse logging.
  tryingToConceive;

  bool get isTTC => this == AppMode.tryingToConceive;
  bool get isCycleAwareness => this == AppMode.cycleAwareness;

  String get displayName {
    switch (this) {
      case AppMode.cycleAwareness:
        return 'Cycle Awareness';
      case AppMode.tryingToConceive:
        return 'Trying to Conceive';
    }
  }

  String get shortName {
    switch (this) {
      case AppMode.cycleAwareness:
        return 'Track Cycle';
      case AppMode.tryingToConceive:
        return 'TTC';
    }
  }

  String get description {
    switch (this) {
      case AppMode.cycleAwareness:
        return 'Track your period, predict upcoming cycles, and understand your body’s daily rhythm.';
      case AppMode.tryingToConceive:
        return 'Pinpoint your fertile window, track ovulation biomarkers, and optimize conception chances.';
    }
  }
}
