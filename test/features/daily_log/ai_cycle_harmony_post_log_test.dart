import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/daily_log/widgets/ai_cycle_harmony_post_log_view.dart';
import 'package:flowcycle/shared/models/app_mode.dart';
import 'package:flowcycle/shared/models/daily_log_entry.dart';
import 'package:flowcycle/shared/providers/app_scope.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';

void main() {
  group('AiCycleHarmonyPostLogView Comprehensive Test Suite', () {
    late CycleDataController controller;

    setUp(() {
      controller = CycleDataController.instance;
      controller.updateUserProfile(
        name: 'Amina',
        mode: AppMode.tryingToConceive,
        averageCycleLength: 28,
        typicalPeriodDuration: 5,
        lastPeriodStartDate: DateTime.now().subtract(const Duration(days: 13)),
      );
    });

    testWidgets(
      '1. Renders TTC Ovulatory post-log view with snapshot chips, Groq AI analysis, and calendar/insights reroute buttons',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final entry = DailyLogEntry(
          date: DateTime.now(),
          mood: 'Great',
          flow: 'None',
          symptoms: const ['Ovulation Twinge', 'High Energy'],
          sleepRating: 5,
          energyLevel: 'High',
          cervicalMucus: 'Egg-white',
          bbtTemperature: 97.6,
          lhTestResult: 'Peak Surge ➕',
          intimacyStatus: 'Unprotected (Trying) 💕',
          notes: 'High libido and peak egg white mucus today!',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: AppScope(
              controller: controller,
              child: Scaffold(
                body: AiCycleHarmonyPostLogView(logEntry: entry),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // 1. Title & Header
        expect(find.text('Log Recorded, Amina! ✨'), findsOneWidget);
        expect(find.textContaining('Day 14 • Ovulation Phase'), findsOneWidget);

        // 2. Snapshot Chips
        expect(find.text("TODAY'S LOG SNAPSHOT"), findsOneWidget);
        expect(find.text('Mood: Great'), findsOneWidget);
        expect(find.text('Flow: None'), findsOneWidget);
        expect(find.text('97.6°F'), findsOneWidget);
        expect(find.text('Egg-white'), findsOneWidget);

        // 3. AI Cycle Harmony Card
        expect(
          find.text('AI Cycle Harmony & Wellness Analysis'),
          findsOneWidget,
        );

        // 4. Smart Next Actions
        expect(find.text('SMART NEXT ACTIONS'), findsOneWidget);
        expect(
          find.text('View Fertile Window on Calendar 🗓️'),
          findsOneWidget,
        );
        expect(find.text('Return to Dashboard'), findsOneWidget);
      },
    );

    testWidgets(
      '2. Renders Menstrual/Luteal post-log view with symptom relief smart rerouting',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        controller.updateUserProfile(
          name: 'Amina',
          mode: AppMode.cycleAwareness,
          averageCycleLength: 28,
          typicalPeriodDuration: 5,
          lastPeriodStartDate: DateTime.now().subtract(const Duration(days: 1)),
        );

        final entry = DailyLogEntry(
          date: DateTime.now(),
          mood: 'Low',
          flow: 'Heavy',
          symptoms: const ['Cramps', 'Fatigue', 'Backache'],
          sleepRating: 3,
          energyLevel: 'Low',
          workoutType: 'Rest Day',
          waterGlasses: 6,
          notes: 'Severe pelvic cramping today.',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: AppScope(
              controller: controller,
              child: Scaffold(
                body: AiCycleHarmonyPostLogView(logEntry: entry),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // 1. Header
        expect(find.text('Log Recorded, Amina! ✨'), findsOneWidget);

        // 2. Symptoms chip
        expect(find.textContaining('Cramps'), findsOneWidget);

        // 3. Smart Comfort Relief Action
        expect(
          find.text('Ask Luna AI for Comfort & Relief ✨'),
          findsOneWidget,
        );
        expect(find.text('Return to Dashboard'), findsOneWidget);
      },
    );
  });
}
