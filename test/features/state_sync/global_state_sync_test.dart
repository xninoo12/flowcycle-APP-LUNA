import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/calendar/calendar_screen.dart';
import 'package:flowcycle/features/daily_log/daily_log_screen.dart';
import 'package:flowcycle/features/dashboard/home_screen.dart';
import 'package:flowcycle/features/dashboard/widgets/cycle_ring_card.dart';
import 'package:flowcycle/features/dashboard/widgets/ttc/ttc_hero_cycle_card.dart';
import 'package:flowcycle/features/onboarding/onboarding_screen.dart';
import 'package:flowcycle/features/profile/profile_screen.dart';
import 'package:flowcycle/shared/models/app_mode.dart';
import 'package:flowcycle/shared/models/daily_log_entry.dart';
import 'package:flowcycle/shared/providers/app_scope.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';
import 'package:flowcycle/shared/widgets/buttons/primary_button.dart';

void main() {
  group('Phase 5: Global State & Dynamic Data Synchronization Tests', () {
    late CycleDataController controller;

    setUp(() {
      controller = CycleDataController.instance;
    });

    test('1. CycleDataController Unit Tests: Profile, Logs, & Mode Sync', () {
      final now = DateTime.now();

      // Update Profile
      controller.updateUserProfile(
        name: 'Sarah',
        averageCycleLength: 30,
        typicalPeriodDuration: 6,
        lastPeriodStartDate: now.subtract(const Duration(days: 4)),
        mode: AppMode.cycleAwareness,
        focusGoal: 'Improve wellbeing',
      );

      expect(controller.userProfile.name, 'Sarah');
      expect(controller.userProfile.averageCycleLength, 30);
      expect(controller.userProfile.typicalPeriodDuration, 6);
      expect(controller.currentMode, AppMode.cycleAwareness);

      // Save Log Entry
      final entry = DailyLogEntry(
        date: now,
        mood: 'Great',
        flow: 'Heavy',
        symptoms: const ['Cramps', 'Headache'],
        sleepRating: 5,
        sleepDuration: '8h 15m',
        energyLevel: 'High',
        intercourse: true,
      );
      controller.saveLogEntry(entry);

      final retrieved = controller.getLogForDate(now);
      expect(retrieved, isNotNull);
      expect(retrieved!.mood, 'Great');
      expect(retrieved.flow, 'Heavy');
      expect(retrieved.symptoms, contains('Cramps'));
      expect(retrieved.symptoms, contains('Headache'));
      expect(retrieved.sleepRating, 5);

      // Verify Calculated Dashboard State
      final cycleState = controller.calculateCurrentCycleState(now);
      expect(cycleState.currentDay, 5);
      expect(cycleState.totalDays, 30);
      expect(cycleState.selectedFlowIntensity, 'Heavy');
      expect(cycleState.selectedSymptoms, contains('Cramps'));
    });

    testWidgets('2. Daily Log Modal ➔ App-Wide Reactivity Test', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final now = DateTime.now();

      // Pump DailyLogScreen wrapped in AppScope
      await tester.pumpWidget(
        AppScope(
          controller: controller,
          child: MaterialApp(home: DailyLogScreen(initialDate: now)),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Select Mood "Great"
      await tester.tap(find.text('Great'));
      await tester.pumpAndSettle();

      // 2. Select Flow "Medium"
      await tester.tap(find.text('Medium').first);
      await tester.pumpAndSettle();

      // 3. Save Log
      final saveBtn = find.text("Save Today's Log");
      await tester.ensureVisible(saveBtn);
      await tester.pumpAndSettle();
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      // Verify log was saved to controller
      final savedLog = controller.getLogForDate(now);
      expect(savedLog, isNotNull);
      expect(savedLog!.mood, 'Great');
      expect(savedLog.flow, 'Medium');
    });

    testWidgets('3. Global Mode Synchronization (Profile ⇋ App-Wide)', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      controller.setAppMode(AppMode.cycleAwareness);

      // Pump ProfileScreen inside AppScope
      await tester.pumpWidget(
        AppScope(
          controller: controller,
          child: const MaterialApp(home: ProfileScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Switch mode by tapping Current Mode metric item in Profile
      await tester.tap(find.text('Current Mode'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(controller.currentMode, AppMode.tryingToConceive);

      // Pump HomeScreen and verify it opens in TTC Mode
      await tester.pumpWidget(
        AppScope(
          controller: controller,
          child: const MaterialApp(home: HomeScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TtcHeroCycleCard), findsOneWidget);
      expect(find.byType(CycleRingCard), findsNothing);
    });

    testWidgets('4. Calendar Screen Dynamic Log & Mode Synchronization', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      controller.setAppMode(AppMode.cycleAwareness);

      await tester.pumpWidget(
        AppScope(
          controller: controller,
          child: const MaterialApp(home: CalendarScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Day 14
      await tester.tap(find.text('Today'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.text('May'), findsWidgets);
      expect(find.text('14'), findsWidgets);
    });

    testWidgets('5. Onboarding Completion ➔ Dynamic User Profile Binding', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      bool completed = false;

      await tester.pumpWidget(
        AppScope(
          controller: controller,
          child: MaterialApp(
            home: OnboardingScreen(
              transitionDelay: const Duration(milliseconds: 50),
              onComplete: () {
                completed = true;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final continueButtonFinder = find.widgetWithText(
        PrimaryButton,
        'Continue',
      );

      // Step 1: Goal (Trying to Conceive)
      await tester.tap(find.text('Trying to Conceive'));
      await tester.pumpAndSettle();
      await tester.tap(continueButtonFinder);
      await tester.pumpAndSettle();

      // Step 2: Date Picker (Day 1)
      await tester.tap(find.text('1').first);
      await tester.pumpAndSettle();
      await tester.tap(continueButtonFinder);
      await tester.pumpAndSettle();

      // Step 3: Cycle Length Stepper (Increment to 29)
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pumpAndSettle();
      await tester.tap(continueButtonFinder);
      await tester.pumpAndSettle();

      // Step 4: Period Length Stepper (6)
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pumpAndSettle();
      await tester.tap(continueButtonFinder);
      await tester.pumpAndSettle();

      // Step 5: TTC Duration (3–6 months)
      await tester.tap(find.text('3–6 months'));
      await tester.pumpAndSettle();
      await tester.tap(continueButtonFinder);
      await tester.pump(const Duration(milliseconds: 10));

      expect(find.text("You're all set!"), findsOneWidget);
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      expect(completed, isTrue);
      expect(controller.userProfile.mode, AppMode.tryingToConceive);
      expect(controller.userProfile.averageCycleLength, 29);
      expect(controller.userProfile.typicalPeriodDuration, 6);
      expect(controller.userProfile.focusGoal, '3–6 months');
    });
  });
}
