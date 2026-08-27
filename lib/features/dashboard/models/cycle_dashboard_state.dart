/// Cycle phase enumeration.
enum CyclePhase { menstrual, follicular, ovulation, luteal }

/// Calculated cycle state model consumed by the Cycle Awareness and TTC Dashboards.
class CycleDashboardState {
  final int currentDay;
  final int totalDays;
  final int periodDuration;
  final DateTime? lastPeriodStartDate;
  final CyclePhase phase;
  final String phaseName;
  final String phaseDescription;
  final int daysUntilNextPeriod;
  final String nextPeriodText;
  final String fertilityChance;
  final String fertilityStatus;
  final String selectedFlowIntensity;
  final Set<String> selectedSymptoms;

  const CycleDashboardState({
    required this.currentDay,
    required this.totalDays,
    required this.periodDuration,
    this.lastPeriodStartDate,
    required this.phase,
    required this.phaseName,
    required this.phaseDescription,
    required this.daysUntilNextPeriod,
    required this.nextPeriodText,
    required this.fertilityChance,
    required this.fertilityStatus,
    this.selectedFlowIntensity = 'Medium',
    this.selectedSymptoms = const {'Bloating', 'Cramps'},
  });

  /// Factory calculating real cycle metrics from user onboarding data.
  factory CycleDashboardState.calculate({
    DateTime? lastPeriodStartDate,
    int averageCycleLength = 28,
    int typicalPeriodDuration = 5,
    String selectedFlow = 'Medium',
    Set<String> symptoms = const {'Bloating', 'Cramps'},
  }) {
    final totalDays = averageCycleLength > 0 ? averageCycleLength : 28;
    final periodDuration = typicalPeriodDuration > 0
        ? typicalPeriodDuration
        : 5;

    // Calculate current cycle day from last period start date
    int day;
    final now = DateTime.now();
    final effectivePeriodStart = lastPeriodStartDate ?? now.subtract(const Duration(days: 12));

    final diff = DateTime(now.year, now.month, now.day)
        .difference(
          DateTime(
            effectivePeriodStart.year,
            effectivePeriodStart.month,
            effectivePeriodStart.day,
          ),
        )
        .inDays;
    day = (diff >= 0 ? (diff % totalDays) + 1 : 1);

    // Determine Phase
    CyclePhase phase;
    String phaseName;
    String phaseDescription;
    String fertilityChance;
    String fertilityStatus;

    if (day <= periodDuration) {
      phase = CyclePhase.menstrual;
      phaseName = 'Menstrual Phase';
      phaseDescription = 'Your body is resetting for a new cycle.';
      fertilityChance = 'Low';
      fertilityStatus = 'Not fertile';
    } else if (day <= (totalDays ~/ 2) - 1) {
      phase = CyclePhase.follicular;
      phaseName = 'Follicular Phase';
      phaseDescription = 'Your energy is rising and follicles are maturing.';
      fertilityChance = day >= 10 ? 'Medium' : 'Low';
      fertilityStatus = day >= 10
          ? 'Approaching fertile window'
          : 'Not fertile';
    } else if (day <= (totalDays ~/ 2) + 3) {
      phase = CyclePhase.ovulation;
      phaseName = 'Ovulation Phase';
      phaseDescription = 'Your fertility is at its peak.';
      fertilityChance = 'High';
      fertilityStatus = 'Peak fertile window';
    } else {
      phase = CyclePhase.luteal;
      phaseName = 'Luteal Phase';
      phaseDescription = 'Your body is preparing for a new cycle.';
      fertilityChance = 'Low';
      fertilityStatus = 'Not fertile';
    }

    // Calculate next period days
    final daysUntil = (totalDays - day + 1) % totalDays;
    final String nextPeriodText = daysUntil == 0
        ? 'Expected today'
        : (daysUntil == 1 ? 'Expected tomorrow' : 'In $daysUntil days');

    return CycleDashboardState(
      currentDay: day,
      totalDays: totalDays,
      periodDuration: periodDuration,
      lastPeriodStartDate: effectivePeriodStart,
      phase: phase,
      phaseName: phaseName,
      phaseDescription: phaseDescription,
      daysUntilNextPeriod: daysUntil,
      nextPeriodText: nextPeriodText,
      fertilityChance: fertilityChance,
      fertilityStatus: fertilityStatus,
      selectedFlowIntensity: selectedFlow,
      selectedSymptoms: symptoms,
    );
  }

  // ---------------------------------------------------------------------------
  // Dynamic Calculated Dates & Formatted Strings
  // ---------------------------------------------------------------------------

  DateTime get calculatedLastPeriodStartDate {
    if (lastPeriodStartDate != null) return lastPeriodStartDate!;
    return DateTime.now().subtract(Duration(days: currentDay - 1));
  }

  DateTime get calculatedNextPeriodStartDate {
    return calculatedLastPeriodStartDate.add(Duration(days: totalDays));
  }

  DateTime get calculatedOvulationDate {
    final ovulationDayNumber = (totalDays - 14).clamp(periodDuration + 1, totalDays - 1);
    return calculatedLastPeriodStartDate.add(Duration(days: ovulationDayNumber - 1));
  }

  DateTime get calculatedFertileWindowStartDate {
    return calculatedOvulationDate.subtract(const Duration(days: 5));
  }

  DateTime get calculatedFertileWindowEndDate {
    return calculatedOvulationDate.add(const Duration(days: 1));
  }

  String get nextPeriodDateText {
    return _formatMonthDayYear(calculatedNextPeriodStartDate);
  }

  String get nextPeriodDatesRangeText {
    final start = calculatedNextPeriodStartDate;
    final end = start.add(Duration(days: periodDuration - 1));
    return _formatDateRange(start, end);
  }

  String get fertileWindowDatesText {
    return _formatDateRange(
      calculatedFertileWindowStartDate,
      calculatedFertileWindowEndDate,
    );
  }

  String get ovulationDateText {
    return _formatMonthDay(calculatedOvulationDate);
  }

  String get ovulationCountdownText {
    final diff = DateTime(
      calculatedOvulationDate.year,
      calculatedOvulationDate.month,
      calculatedOvulationDate.day,
    ).difference(
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
    ).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff > 1) return 'In $diff days';
    if (diff == -1) return 'Yesterday';
    return '${diff.abs()} days ago';
  }

  String get bestDaysRangeText {
    final start = calculatedOvulationDate.subtract(const Duration(days: 3));
    final end = calculatedOvulationDate;
    return _formatDateRange(start, end);
  }

  String get bestDaysChanceText => 'High Chance';

  /// Generates a dynamic 5-day structured fertile breakdown surrounding ovulation
  List<Map<String, dynamic>> get fertileBreakdownDays {
    final List<Map<String, dynamic>> days = [];
    final ovulation = calculatedOvulationDate;

    // 5 days: ovulation - 3, ovulation - 2, ovulation - 1, ovulation, ovulation + 1
    for (int offset = -3; offset <= 1; offset++) {
      final date = ovulation.add(Duration(days: offset));
      int percent;
      String rating;

      if (offset == -3) {
        percent = 25;
        rating = 'Low (25%)';
      } else if (offset == -2) {
        percent = 65;
        rating = 'High (65%)';
      } else if (offset == -1) {
        percent = 85;
        rating = 'Very High (85%)';
      } else if (offset == 0) {
        percent = 100;
        rating = 'Peak Fertility 💗 (100%)';
      } else {
        percent = 60;
        rating = 'High (60%)';
      }

      days.add({
        'day': 'Day ${(totalDays - 14) + offset}',
        'dayName': _weekdayShort(date),
        'date': _formatMonthDay(date),
        'fullDate': date,
        'chance': rating,
        'chancePercent': percent,
        'isPeak': offset == 0,
      });
    }

    return days;
  }

  /// Generates the 4 cycle phases with calculated date ranges for the current cycle
  List<Map<String, dynamic>> get cyclePhasesTimeline {
    final pStart = calculatedLastPeriodStartDate;
    final pEnd = pStart.add(Duration(days: periodDuration - 1));

    final fStart = pEnd.add(const Duration(days: 1));
    final fEnd = calculatedFertileWindowStartDate.subtract(const Duration(days: 1));

    final oStart = calculatedFertileWindowStartDate;
    final oEnd = calculatedFertileWindowEndDate;

    final lStart = oEnd.add(const Duration(days: 1));
    final lEnd = pStart.add(Duration(days: totalDays - 1));

    return [
      {
        'phase': 'Period',
        'title': 'Period',
        'dates': _formatDateRange(pStart, pEnd),
        'dayRange': 'Days 1–$periodDuration',
        'color': 0xFFE84855,
        'emoji': '🩸',
      },
      {
        'phase': 'Follicular',
        'title': 'Follicular',
        'dates': _formatDateRange(fStart, fEnd.isBefore(fStart) ? fStart : fEnd),
        'dayRange': 'Days ${periodDuration + 1}–${(totalDays ~/ 2) - 1}',
        'color': 0xFF10B981,
        'emoji': '🌱',
      },
      {
        'phase': 'Ovulation',
        'title': 'Ovulation',
        'dates': _formatDateRange(oStart, oEnd),
        'dayRange': 'Days ${(totalDays ~/ 2)}–${(totalDays ~/ 2) + 3}',
        'color': 0xFF8B5CF6,
        'emoji': '💧',
      },
      {
        'phase': 'Luteal',
        'title': 'Luteal',
        'dates': _formatDateRange(lStart, lEnd.isBefore(lStart) ? lStart : lEnd),
        'dayRange': 'Days ${(totalDays ~/ 2) + 4}–$totalDays',
        'color': 0xFFF59E0B,
        'emoji': '🛡️',
      },
    ];
  }

  // ---------------------------------------------------------------------------
  // Date Formatting Utilities
  // ---------------------------------------------------------------------------

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  static const List<String> _weekdays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];

  static String _formatMonthDay(DateTime dt) {
    final month = _months[dt.month - 1];
    return '$month ${dt.day}';
  }

  static String _formatMonthDayYear(DateTime dt) {
    final month = _months[dt.month - 1];
    return '$month ${dt.day}, ${dt.year}';
  }

  static String _formatDateRange(DateTime start, DateTime end) {
    final startMonth = _months[start.month - 1];
    final endMonth = _months[end.month - 1];

    if (start.month == end.month) {
      return '$startMonth ${start.day} – ${end.day}';
    } else {
      return '$startMonth ${start.day} – $endMonth ${end.day}';
    }
  }

  static String _weekdayShort(DateTime dt) {
    return _weekdays[dt.weekday - 1];
  }

  CycleDashboardState copyWith({
    int? currentDay,
    int? totalDays,
    int? periodDuration,
    DateTime? lastPeriodStartDate,
    CyclePhase? phase,
    String? phaseName,
    String? phaseDescription,
    int? daysUntilNextPeriod,
    String? nextPeriodText,
    String? fertilityChance,
    String? fertilityStatus,
    String? selectedFlowIntensity,
    Set<String>? selectedSymptoms,
  }) {
    return CycleDashboardState(
      currentDay: currentDay ?? this.currentDay,
      totalDays: totalDays ?? this.totalDays,
      periodDuration: periodDuration ?? this.periodDuration,
      lastPeriodStartDate: lastPeriodStartDate ?? this.lastPeriodStartDate,
      phase: phase ?? this.phase,
      phaseName: phaseName ?? this.phaseName,
      phaseDescription: phaseDescription ?? this.phaseDescription,
      daysUntilNextPeriod: daysUntilNextPeriod ?? this.daysUntilNextPeriod,
      nextPeriodText: nextPeriodText ?? this.nextPeriodText,
      fertilityChance: fertilityChance ?? this.fertilityChance,
      fertilityStatus: fertilityStatus ?? this.fertilityStatus,
      selectedFlowIntensity:
          selectedFlowIntensity ?? this.selectedFlowIntensity,
      selectedSymptoms: selectedSymptoms ?? this.selectedSymptoms,
    );
  }
}
