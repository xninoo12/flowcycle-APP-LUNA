import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/core/database/local_database_service.dart';
import 'package:flowcycle/shared/models/app_mode.dart';
import 'package:flowcycle/shared/models/daily_log_entry.dart';
import 'package:flowcycle/shared/models/user_profile.dart';

void main() {
  late Directory tempDir;
  late LocalDatabaseService dbService;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('flowcycle_db_test_');
    dbService = LocalDatabaseService.instance;
    dbService.setCustomStoragePath(tempDir.path);
    await dbService.initialize();
  });

  tearDown(() async {
    await dbService.wipeAllData();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('LocalDatabaseService Comprehensive Test Suite', () {
    test('1. Saves, persists and retrieves UserProfile accurately', () async {
      final sampleProfile = UserProfile(
        name: 'Fatima',
        averageCycleLength: 30,
        typicalPeriodDuration: 6,
        lastPeriodStartDate: DateTime(2026, 8, 10),
        mode: AppMode.tryingToConceive,
        focusGoal: 'Conception 2026',
        cycleGoals: const ['Track ovulation', 'Monitor LH peak'],
        ttcDuration: '6 months',
      );

      await dbService.saveProfile(sampleProfile);
      final retrieved = dbService.getProfile();

      expect(retrieved, isNotNull);
      expect(retrieved?.name, 'Fatima');
      expect(retrieved?.averageCycleLength, 30);
      expect(retrieved?.mode, AppMode.tryingToConceive);
      expect(retrieved?.focusGoal, 'Conception 2026');
    });

    test('2. Saves, indexes by date, and deletes DailyLogEntry items', () async {
      final logDate1 = DateTime(2026, 8, 15);
      final logDate2 = DateTime(2026, 8, 16);

      final log1 = DailyLogEntry(
        date: logDate1,
        mood: 'Great',
        flow: 'Light',
        symptoms: const ['Bloating'],
        sleepRating: 5,
        energyLevel: 'High',
        bbtTemperature: 36.65,
        intercourse: true,
      );

      final log2 = DailyLogEntry(
        date: logDate2,
        mood: 'Calm',
        flow: 'None',
        symptoms: const ['Cramps', 'Headache'],
        sleepRating: 4,
        energyLevel: 'Medium',
        bbtTemperature: 36.85,
        intercourse: false,
      );

      await dbService.saveDailyLog(log1);
      await dbService.saveDailyLog(log2);

      expect(dbService.getAllLogs().length, 2);
      expect(dbService.getLogForDate(logDate1)?.mood, 'Great');
      expect(dbService.getLogForDate(logDate2)?.bbtTemperature, 36.85);

      // Delete log 1
      await dbService.deleteDailyLog(logDate1);
      expect(dbService.getAllLogs().length, 1);
      expect(dbService.getLogForDate(logDate1), isNull);
      expect(dbService.getLogForDate(logDate2), isNotNull);
    });

    test('3. Manages app settings key-value entries', () async {
      await dbService.saveSetting('theme_mode', 'dark');
      await dbService.saveSetting('haptics_enabled', true);
      await dbService.saveSetting('security_pin_hash', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08');

      expect(dbService.getSetting('theme_mode'), 'dark');
      expect(dbService.getSetting('haptics_enabled'), isTrue);
      expect(dbService.getSetting('non_existent', defaultValue: 'default_val'), 'default_val');
    });

    test('4. Generates bi-weekly bulk analytics payload for AI Companion twice-weekly insights', () async {
      final now = DateTime.now();

      // Seed 5 logs within 14-day window
      for (int i = 0; i < 5; i++) {
        final date = now.subtract(Duration(days: i));
        await dbService.saveDailyLog(
          DailyLogEntry(
            date: date,
            mood: i % 2 == 0 ? 'Energetic' : 'Calm',
            flow: i == 0 ? 'Light' : 'None',
            symptoms: i == 0 ? const ['Tender breasts', 'Cramps'] : const ['Bloating'],
            bbtTemperature: 36.5 + (i * 0.1),
            intercourse: i % 2 == 0,
          ),
        );
      }

      final payload = dbService.fetchBiweeklyBulkAnalysisPayload(days: 14);

      expect(payload['analysis_window_days'], 14);
      expect(payload['total_logs_in_window'], 5);
      expect(payload['summary_metrics']['days_with_flow'], 1);
      expect(payload['summary_metrics']['days_with_intercourse'], 3);
      expect(payload['summary_metrics']['bbt_readings_count'], 5);
      expect(payload['daily_chronological_logs'].length, 5);
      expect(payload['summary_metrics']['top_symptoms'], isNotEmpty);
    });

    test('5. Hydrates state accurately from atomic disk persistence', () async {
      final testProfile = UserProfile(
        name: 'Zara Disk Test',
        averageCycleLength: 27,
        typicalPeriodDuration: 4,
        lastPeriodStartDate: DateTime(2026, 8, 5),
        mode: AppMode.cycleAwareness,
      );

      final testLog = DailyLogEntry(
        date: DateTime(2026, 8, 18),
        mood: 'Reflective',
        symptoms: const ['Fatigue'],
      );

      await dbService.saveProfile(testProfile);
      await dbService.saveDailyLog(testLog);

      // Create a fresh instance reading from the same disk path
      final freshDb = LocalDatabaseService();
      freshDb.setCustomStoragePath(tempDir.path);
      await freshDb.initialize();

      expect(freshDb.getProfile()?.name, 'Zara Disk Test');
      expect(freshDb.getAllLogs().length, 1);
      expect(freshDb.getLogForDate(DateTime(2026, 8, 18))?.mood, 'Reflective');
    });

    test('6. Wipes all data completely on purge / GDPR reset', () async {
      await dbService.saveProfile(UserProfile(
        name: 'Wipe Me',
        lastPeriodStartDate: DateTime(2026, 8, 1),
      ));
      await dbService.saveDailyLog(DailyLogEntry(date: DateTime.now()));

      expect(dbService.getProfile(), isNotNull);
      expect(dbService.getAllLogs().length, 1);

      await dbService.wipeAllData();

      expect(dbService.getProfile(), isNull);
      expect(dbService.getAllLogs(), isEmpty);
    });
  });
}
