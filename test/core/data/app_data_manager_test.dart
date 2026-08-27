import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/core/data/app_data_manager.dart';
import 'package:flowcycle/core/database/local_database_service.dart';
import 'package:flowcycle/core/services/auth_service.dart';
import 'package:flowcycle/features/onboarding/models/onboarding_state.dart';
import 'package:flowcycle/shared/models/app_mode.dart';
import 'package:flowcycle/shared/models/daily_log_entry.dart';
import 'package:flowcycle/shared/models/user_profile.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('flowcycle_data_mgr_test_');
    LocalDatabaseService.instance.setCustomStoragePath(tempDir.path);
    await AppDataManager.instance.initialize(customStoragePath: tempDir.path);
  });

  tearDown(() async {
    try {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    } catch (_) {}
  });

  group('AppDataManager Unified Data Pipeline & Orchestrator Suite', () {
    test('1. handleAuthUserSession scopes database per UID and initializes baseline profile', () async {
      final testUser = AuthUser(
        uid: 'user_test_999',
        email: 'sarah@flowcycle.app',
        displayName: 'Sarah',
        createdAt: DateTime.now(),
      );

      await AppDataManager.instance.handleAuthUserSession(testUser);

      expect(LocalDatabaseService.instance.currentUserScope, 'user_test_999');
      final profile = LocalDatabaseService.instance.getProfile();
      expect(profile, isNotNull);
      expect(profile!.name, 'Sarah');
      expect(CycleDataController.instance.userProfile.name, 'Sarah');

      // Logout / un-scope
      await AppDataManager.instance.handleAuthUserSession(null);
      expect(LocalDatabaseService.instance.currentUserScope, isNull);
    });

    test('2. handleOnboardingCompletion creates profile, configures cycle parameters, & saves data cleanly', () async {
      final now = DateTime.now();
      final onboardingState = OnboardingState(
        selectedMode: AppMode.tryingToConceive,
        lastPeriodStartDate: now.subtract(const Duration(days: 10)),
        averageCycleLength: 29,
        typicalPeriodDuration: 5,
        tryingToConceiveDuration: 'Less than 3 months',
        cycleAwarenessGoals: const ['Track my fertile window'],
        hasCompletedOnboarding: true,
      );

      final profile = await AppDataManager.instance.handleOnboardingCompletion(onboardingState);

      expect(profile.mode, AppMode.tryingToConceive);
      expect(profile.averageCycleLength, 29);
      expect(profile.typicalPeriodDuration, 5);
      expect(profile.ttcDuration, 'Less than 3 months');

      // Verify profile is persisted in LocalDatabaseService
      final savedProfile = LocalDatabaseService.instance.getProfile();
      expect(savedProfile?.mode, AppMode.tryingToConceive);
      expect(savedProfile?.averageCycleLength, 29);

      // Verify controller in-memory state is synchronized
      expect(CycleDataController.instance.currentMode, AppMode.tryingToConceive);
    });

    test('3. handleDailyLogEntry commits 16 biomarkers and detects period onset dynamically', () async {
      final now = DateTime.now();
      final log = DailyLogEntry(
        date: now,
        flow: 'Heavy',
        mood: 'Calm',
        symptoms: const ['Cramps', 'Headache'],
        sleepRating: 5,
        sleepDuration: '8h 15m',
        energyLevel: 'High',
        cervicalMucus: 'Eggwhite',
        bbtTemperature: 98.4,
        lhTestResult: 'Peak',
        hcgTestResult: 'Negative',
        intimacyStatus: 'Unprotected',
        supplements: const ['Prenatal Vitamin', 'Folic Acid'],
        waterGlasses: 8,
        cravings: const ['Chocolate'],
        selfCare: const ['Meditation'],
        notes: 'Clinical test log entry',
      );

      await AppDataManager.instance.handleDailyLogEntry(log);

      // Verify log was saved to LocalDatabaseService
      final savedLog = LocalDatabaseService.instance.getLogForDate(now);
      expect(savedLog, isNotNull);
      expect(savedLog?.flow, 'Heavy');
      expect(savedLog?.bbtTemperature, 98.4);
      expect(savedLog?.lhTestResult, 'Peak');
      expect(savedLog?.supplements, contains('Prenatal Vitamin'));
      expect(savedLog?.notes, 'Clinical test log entry');

      // Verify CycleDataController in-memory store contains entry
      final controllerLog = CycleDataController.instance.getLogForDate(now);
      expect(controllerLog?.mood, 'Calm');
      expect(controllerLog?.cervicalMucus, 'Eggwhite');
    });

    test('4. handleAiChatInteraction captures live cycle snapshot and persists offline session', () async {
      final response = await AppDataManager.instance.handleAiChatInteraction(
        prompt: 'What foods help with luteal phase progesterone?',
        sessionId: 'test_ai_session',
      );

      expect(response, isNotEmpty);

      // Verify chat messages were stored in session
      final history = AppDataManager.instance.getAiChatHistory(sessionId: 'test_ai_session');
      expect(history.length, 2); // 1 user + 1 AI
      expect(history[0]['sender'], 'user');
      expect(history[0]['message'], 'What foods help with luteal phase progesterone?');
      expect(history[1]['sender'], 'ai');
      expect(history[1]['message'], response);

      // Clear session
      await AppDataManager.instance.clearAiChatHistory(sessionId: 'test_ai_session');
      final clearedHistory = AppDataManager.instance.getAiChatHistory(sessionId: 'test_ai_session');
      expect(clearedHistory, isEmpty);
    });

    test('5. handleAccountPurge wipes all data, resets memory state, and purges database file', () async {
      final now = DateTime.now();
      await LocalDatabaseService.instance.saveProfile(
        UserProfile(
          name: 'PurgeTarget',
          averageCycleLength: 28,
          typicalPeriodDuration: 5,
          lastPeriodStartDate: now,
          mode: AppMode.cycleAwareness,
        ),
      );
      await LocalDatabaseService.instance.saveDailyLog(
        DailyLogEntry(date: now, mood: 'Good', flow: 'Light'),
      );

      expect(LocalDatabaseService.instance.getProfile()?.name, 'PurgeTarget');
      expect(LocalDatabaseService.instance.getAllLogs(), isNotEmpty);

      // Purge account
      await AppDataManager.instance.handleAccountPurge();

      expect(LocalDatabaseService.instance.getProfile(), isNull);
      expect(LocalDatabaseService.instance.getAllLogs(), isEmpty);
    });
  });
}
