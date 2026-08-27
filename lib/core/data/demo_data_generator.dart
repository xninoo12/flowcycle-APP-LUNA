import 'dart:math';
import '../../shared/models/app_mode.dart';
import '../../shared/models/daily_log_entry.dart';
import '../../shared/models/user_profile.dart';
import '../database/local_database_service.dart';
import 'app_data_manager.dart';

/// Service that generates realistic 6-month historical cycle data,
/// biphasic BBT curves, cervical mucus progressions, and symptoms for testing and demonstration.
class DemoDataGenerator {
  static final DemoDataGenerator instance = DemoDataGenerator._internal();
  DemoDataGenerator._internal();

  /// Populates the database with 6 realistic historical cycles spanning ~180 days.
  Future<void> populate6MonthDemoHistory() async {
    final now = DateTime.now();
    final random = Random(42); // Fixed seed for reproducible demo data

    // 1. Setup rich demo user profile
    final demoProfile = UserProfile(
      name: 'Amina',
      averageCycleLength: 28,
      typicalPeriodDuration: 5,
      mode: AppMode.cycleAwareness,
      lastPeriodStartDate: now.subtract(const Duration(days: 13)), // Day 13 today
      focusGoal: 'Understand my cycle',
      cycleGoals: const ['Understand my cycle', 'Track fertility'],
    );

    await LocalDatabaseService.instance.saveProfile(demoProfile);

    // 2. Generate 6 cycles of daily logs (180 days backwards)
    final cycleLengths = [28, 29, 28, 27, 28, 28];
    int currentDayOffset = 13; // Days elapsed in current cycle

    DateTime cycleStartDate = now.subtract(Duration(days: currentDayOffset));
    final allEntries = <DailyLogEntry>[];

    for (int cycleIdx = 0; cycleIdx < cycleLengths.length; cycleIdx++) {
      final cycleLen = cycleLengths[cycleIdx];
      final ovulationDay = cycleLen - 14;

      for (int dayInCycle = 1; dayInCycle <= cycleLen; dayInCycle++) {
        final logDate = cycleStartDate.add(Duration(days: dayInCycle - 1));
        if (logDate.isAfter(now)) break;

        // Flow intensity
        String flow = 'None';
        if (dayInCycle == 1) flow = 'Medium';
        if (dayInCycle == 2) flow = 'Heavy';
        if (dayInCycle == 3) flow = 'Medium';
        if (dayInCycle == 4) flow = 'Light';
        if (dayInCycle == 5) flow = 'Spotting';

        // Symptoms
        final symptoms = <String>[];
        if (dayInCycle <= 3) {
          symptoms.addAll(['Cramps', 'Fatigue', 'Bloating']);
        } else if (dayInCycle >= ovulationDay - 2 && dayInCycle <= ovulationDay + 1) {
          symptoms.addAll(['High Energy', 'Increased Libido']);
        } else if (dayInCycle >= cycleLen - 4) {
          symptoms.addAll(['Tender Breasts', 'Mood Swings', 'Food Cravings']);
        } else {
          if (random.nextBool()) symptoms.add('Clear Skin');
        }

        // Moods
        String mood = 'Calm';
        if (dayInCycle <= 2) mood = 'Sensitive';
        if (dayInCycle >= 6 && dayInCycle <= 14) mood = 'Energetic';
        if (dayInCycle == ovulationDay) mood = 'Happy';
        if (dayInCycle >= cycleLen - 3) mood = 'Irritable';

        // Biphasic BBT: ~97.4-97.6 in follicular, ~98.1-98.5 in luteal
        double baseBbt = (dayInCycle < ovulationDay)
            ? 97.4 + (random.nextDouble() * 0.25)
            : 98.1 + (random.nextDouble() * 0.35);
        final bbtFormatted = double.parse(baseBbt.toStringAsFixed(2));

        // Cervical mucus
        String mucus = 'None';
        if (dayInCycle >= 6 && dayInCycle <= 9) mucus = 'Sticky';
        if (dayInCycle >= 10 && dayInCycle <= 11) mucus = 'Creamy';
        if (dayInCycle >= 12 && dayInCycle <= ovulationDay + 1) mucus = 'Egg White';
        if (dayInCycle > ovulationDay + 1) mucus = 'Creamy';

        // Intercourse
        bool intercourse = false;
        String intimacyStatus = 'None';
        if (dayInCycle >= ovulationDay - 3 && dayInCycle <= ovulationDay + 1) {
          if (dayInCycle % 2 == 0) {
            intercourse = true;
            intimacyStatus = 'Protected';
          }
        }

        final entry = DailyLogEntry(
          date: logDate,
          flow: flow,
          symptoms: symptoms,
          mood: mood,
          bbtTemperature: bbtFormatted,
          cervicalMucus: mucus,
          intercourse: intercourse,
          intimacyStatus: intimacyStatus,
          waterGlasses: 6 + random.nextInt(3),
          sleepDuration: '${7 + random.nextInt(2)}h ${random.nextInt(40)}m',
          supplements: const ['Prenatal Vitamin'],
          notes: dayInCycle == 1
              ? 'Cycle started on time, drinking chamomile tea.'
              : dayInCycle == ovulationDay
                  ? 'Peak ovulation energy today!'
                  : '',
        );

        allEntries.add(entry);
      }

      // Move to previous cycle start
      if (cycleIdx + 1 < cycleLengths.length) {
        final prevCycleLen = cycleLengths[cycleIdx + 1];
        cycleStartDate = cycleStartDate.subtract(Duration(days: prevCycleLen));
      }
    }

    await LocalDatabaseService.instance.saveAllDailyLogs(allEntries);

    // 3. Notify AppDataManager and CycleDataController to reload from DB
    await AppDataManager.instance.handleAuthUserSession(null);
  }
}
