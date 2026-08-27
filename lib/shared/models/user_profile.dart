import 'app_mode.dart';

/// Immutable model representing the user profile and cycle configuration.
class UserProfile {
  final String name;
  final int averageCycleLength;
  final int typicalPeriodDuration;
  final DateTime lastPeriodStartDate;
  final AppMode mode;
  final String focusGoal;
  final List<String> cycleGoals;
  final String? ttcDuration;

  const UserProfile({
    this.name = 'Amina',
    this.averageCycleLength = 28,
    this.typicalPeriodDuration = 5,
    required this.lastPeriodStartDate,
    this.mode = AppMode.cycleAwareness,
    this.focusGoal = 'Understand my cycle',
    this.cycleGoals = const ['Understand my cycle'],
    this.ttcDuration,
  });

  /// Factory constructor providing default starting parameters
  factory UserProfile.defaults() {
    return UserProfile(
      name: 'Amina',
      averageCycleLength: 28,
      typicalPeriodDuration: 5,
      lastPeriodStartDate: DateTime.now().subtract(const Duration(days: 13)),
      mode: AppMode.cycleAwareness,
      focusGoal: 'Understand my cycle',
      cycleGoals: const ['Understand my cycle'],
      ttcDuration: 'Just starting',
    );
  }

  UserProfile copyWith({
    String? name,
    int? averageCycleLength,
    int? typicalPeriodDuration,
    DateTime? lastPeriodStartDate,
    AppMode? mode,
    String? focusGoal,
    List<String>? cycleGoals,
    String? ttcDuration,
  }) {
    return UserProfile(
      name: name ?? this.name,
      averageCycleLength: averageCycleLength ?? this.averageCycleLength,
      typicalPeriodDuration:
          typicalPeriodDuration ?? this.typicalPeriodDuration,
      lastPeriodStartDate: lastPeriodStartDate ?? this.lastPeriodStartDate,
      mode: mode ?? this.mode,
      focusGoal: focusGoal ?? this.focusGoal,
      cycleGoals: cycleGoals ?? this.cycleGoals,
      ttcDuration: ttcDuration ?? this.ttcDuration,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'averageCycleLength': averageCycleLength,
      'typicalPeriodDuration': typicalPeriodDuration,
      'lastPeriodStartDate': lastPeriodStartDate.toIso8601String(),
      'mode': mode.name,
      'focusGoal': focusGoal,
      'cycleGoals': cycleGoals,
      'ttcDuration': ttcDuration,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    AppMode parsedMode = AppMode.cycleAwareness;
    if (json['mode'] == 'ttc' ||
        json['mode'] == 'tryingToConceive' ||
        json['mode'] == 'AppMode.tryingToConceive') {
      parsedMode = AppMode.tryingToConceive;
    }

    return UserProfile(
      name: json['name'] as String? ?? 'Amina',
      averageCycleLength: json['averageCycleLength'] as int? ?? 28,
      typicalPeriodDuration: json['typicalPeriodDuration'] as int? ?? 5,
      lastPeriodStartDate: json['lastPeriodStartDate'] != null
          ? DateTime.tryParse(json['lastPeriodStartDate'] as String) ??
              DateTime.now().subtract(const Duration(days: 14))
          : DateTime.now().subtract(const Duration(days: 14)),
      mode: parsedMode,
      focusGoal: json['focusGoal'] as String? ?? 'Understand my cycle',
      cycleGoals: (json['cycleGoals'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['Understand my cycle'],
      ttcDuration: json['ttcDuration'] as String?,
    );
  }

  @override
  String toString() {
    return 'UserProfile(name: $name, averageCycleLength: $averageCycleLength, typicalPeriodDuration: $typicalPeriodDuration, lastPeriodStartDate: $lastPeriodStartDate, mode: $mode, focusGoal: $focusGoal, cycleGoals: $cycleGoals, ttcDuration: $ttcDuration)';
  }
}
