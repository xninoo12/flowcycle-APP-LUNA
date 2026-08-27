/// Immutable model representing a single daily log entry for symptoms, flow, mood, and clinical biomarkers.
class DailyLogEntry {
  final DateTime date;
  final String mood; // 'Great', 'Good', 'Okay', 'Low', 'Awful'
  final String flow; // 'None', 'Spotting', 'Light', 'Medium', 'Heavy'
  final List<String> symptoms; // e.g. ['Cramps', 'Bloating']
  final int sleepRating; // 1..5
  final String sleepDuration; // e.g. '7h 30m'
  final String energyLevel; // 'Low', 'Medium', 'High'
  final bool intercourse;

  // TTC Biomarkers
  final String
  cervicalMucus; // 'None', 'Sticky', 'Creamy', 'Egg-white', 'Watery'
  final double? bbtTemperature; // e.g. 97.8
  final String lhTestResult; // 'Not Tested', 'Negative', 'Low', 'Peak Surge'
  final String hcgTestResult; // 'Not Tested', 'Negative', 'Positive', 'Faint'
  final String
  intimacyStatus; // 'None', 'Unprotected', 'Protected', 'High Libido'
  final List<String> supplements; // e.g. ['Prenatal', 'CoQ10']

  // Cycle Awareness Biomarkers
  final String
  workoutType; // 'None', 'Yoga', 'Pilates', 'Strength', 'Cardio', 'Walking'
  final int waterGlasses; // e.g. 8
  final List<String> cravings; // e.g. ['Sweets', 'Salty', 'Carbs']
  final List<String> selfCare; // e.g. ['Meditation', 'Rest']

  // Notes
  final String notes;

  const DailyLogEntry({
    required this.date,
    this.mood = 'Good',
    this.flow = 'Light',
    this.symptoms = const [],
    this.sleepRating = 4,
    this.sleepDuration = '7h 30m',
    this.energyLevel = 'Medium',
    this.intercourse = false,
    this.cervicalMucus = 'None',
    this.bbtTemperature,
    this.lhTestResult = 'Not Tested',
    this.hcgTestResult = 'Not Tested',
    this.intimacyStatus = 'None',
    this.supplements = const [],
    this.workoutType = 'None',
    this.waterGlasses = 6,
    this.cravings = const [],
    this.selfCare = const [],
    this.notes = '',
  });

  DailyLogEntry copyWith({
    DateTime? date,
    String? mood,
    String? flow,
    List<String>? symptoms,
    int? sleepRating,
    String? sleepDuration,
    String? energyLevel,
    bool? intercourse,
    String? cervicalMucus,
    double? bbtTemperature,
    String? lhTestResult,
    String? hcgTestResult,
    String? intimacyStatus,
    List<String>? supplements,
    String? workoutType,
    int? waterGlasses,
    List<String>? cravings,
    List<String>? selfCare,
    String? notes,
  }) {
    return DailyLogEntry(
      date: date ?? this.date,
      mood: mood ?? this.mood,
      flow: flow ?? this.flow,
      symptoms: symptoms ?? this.symptoms,
      sleepRating: sleepRating ?? this.sleepRating,
      sleepDuration: sleepDuration ?? this.sleepDuration,
      energyLevel: energyLevel ?? this.energyLevel,
      intercourse: intercourse ?? this.intercourse,
      cervicalMucus: cervicalMucus ?? this.cervicalMucus,
      bbtTemperature: bbtTemperature ?? this.bbtTemperature,
      lhTestResult: lhTestResult ?? this.lhTestResult,
      hcgTestResult: hcgTestResult ?? this.hcgTestResult,
      intimacyStatus: intimacyStatus ?? this.intimacyStatus,
      supplements: supplements ?? this.supplements,
      workoutType: workoutType ?? this.workoutType,
      waterGlasses: waterGlasses ?? this.waterGlasses,
      cravings: cravings ?? this.cravings,
      selfCare: selfCare ?? this.selfCare,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'mood': mood,
      'flow': flow,
      'symptoms': symptoms,
      'sleepRating': sleepRating,
      'sleepDuration': sleepDuration,
      'energyLevel': energyLevel,
      'intercourse': intercourse,
      'cervicalMucus': cervicalMucus,
      'bbtTemperature': bbtTemperature,
      'lhTestResult': lhTestResult,
      'hcgTestResult': hcgTestResult,
      'intimacyStatus': intimacyStatus,
      'supplements': supplements,
      'workoutType': workoutType,
      'waterGlasses': waterGlasses,
      'cravings': cravings,
      'selfCare': selfCare,
      'notes': notes,
    };
  }

  factory DailyLogEntry.fromJson(Map<String, dynamic> json) {
    return DailyLogEntry(
      date: json['date'] != null
          ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
          : DateTime.now(),
      mood: json['mood'] as String? ?? 'Good',
      flow: json['flow'] as String? ?? 'Light',
      symptoms: (json['symptoms'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      sleepRating: json['sleepRating'] as int? ?? 4,
      sleepDuration: json['sleepDuration'] as String? ?? '7h 30m',
      energyLevel: json['energyLevel'] as String? ?? 'Medium',
      intercourse: json['intercourse'] as bool? ?? false,
      cervicalMucus: json['cervicalMucus'] as String? ?? 'None',
      bbtTemperature: (json['bbtTemperature'] as num?)?.toDouble(),
      lhTestResult: json['lhTestResult'] as String? ?? 'Not Tested',
      hcgTestResult: json['hcgTestResult'] as String? ?? 'Not Tested',
      intimacyStatus: json['intimacyStatus'] as String? ?? 'None',
      supplements: (json['supplements'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      workoutType: json['workoutType'] as String? ?? 'None',
      waterGlasses: json['waterGlasses'] as int? ?? 6,
      cravings: (json['cravings'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      selfCare: (json['selfCare'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      notes: json['notes'] as String? ?? '',
    );
  }

  @override
  String toString() {
    return 'DailyLogEntry(date: $date, mood: $mood, flow: $flow, symptoms: $symptoms, mucus: $cervicalMucus, bbt: $bbtTemperature, lh: $lhTestResult)';
  }
}
