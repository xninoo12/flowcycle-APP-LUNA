import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/daily_log/daily_log_screen.dart';
import 'package:flowcycle/features/daily_log/widgets/ai_cycle_harmony_post_log_view.dart';
import 'package:flowcycle/features/daily_log/widgets/flow_intensity_selector.dart';
import 'package:flowcycle/features/daily_log/widgets/mood_selector_row.dart';
import 'package:flowcycle/features/daily_log/widgets/symptoms_chips_selector.dart';
import 'package:flowcycle/shared/models/app_mode.dart';
import 'package:flowcycle/shared/providers/app_scope.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';

void main() {
  group('Daily Log Screen / Modal Tests', () {
    late CycleDataController controller;

    setUp(() {
      controller = CycleDataController.instance;
      controller.updateUserProfile(
        name: 'Amina',
        mode: AppMode.cycleAwareness,
        averageCycleLength: 28,
        typicalPeriodDuration: 5,
        lastPeriodStartDate: DateTime.now().subtract(const Duration(days: 13)),
      );
    });

    Widget buildTestable(Widget child) {
      return MaterialApp(
        home: AppScope(controller: controller, child: child),
      );
    }

    testWidgets('1. Renders all Log Modal components with exact visual fidelity', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestable(const DailyLogScreen()));
      await tester.pumpAndSettle();

      // 1. Header
      expect(find.text('Log Your Day'), findsOneWidget);
      expect(find.text('Track how you feel and care for your body'), findsOneWidget);
      expect(find.byIcon(Icons.menu_book_rounded), findsOneWidget);

      // 2. Mode Banner & Date Field
      expect(find.textContaining('Cycle Awareness Mode'), findsOneWidget);
      expect(find.text('Date'), findsOneWidget);
      expect(find.text('May 24, 2025'), findsOneWidget);

      // 3. Section Dividers
      expect(find.text('TODAY'), findsOneWidget);
      expect(find.text('BODY'), findsOneWidget);
      expect(find.text('LIFESTYLE'), findsOneWidget);
      expect(find.text('NOTES'), findsOneWidget);

      // 4. Mood Selector
      expect(find.byType(MoodSelectorRow), findsOneWidget);
      expect(find.text('How are you feeling?'), findsOneWidget);
      expect(find.text('Great'), findsOneWidget);
      expect(find.text('Good'), findsOneWidget);
      expect(find.text('Okay'), findsOneWidget);

      // 5. Flow Selector
      expect(find.byType(FlowIntensitySelector), findsOneWidget);
      expect(find.text('Flow'), findsOneWidget);
      expect(find.text('Spotting'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Heavy'), findsOneWidget);

      // 6. Symptoms Chips
      expect(find.byType(SymptomsChipsSelector), findsOneWidget);
      expect(find.text('Symptoms & Biomarkers'), findsOneWidget);
      expect(find.text('Cramps'), findsOneWidget);
      expect(find.text('Bloating'), findsOneWidget);
      expect(find.text('Headache'), findsOneWidget);

      // 7. Lifestyle & Notes
      expect(find.textContaining('Workout & Movement'), findsOneWidget);
      expect(find.textContaining('Hydration'), findsOneWidget);
      expect(find.text('NOTES / JOURNAL'), findsOneWidget);

      // 8. Save Today's Log Button
      expect(find.text("Save Today's Log"), findsOneWidget);
    });

    testWidgets(
      '2. Tapping Save Today’s Log directly triggers AI Cycle Harmony & Wellness Analysis view',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(buildTestable(const DailyLogScreen()));
        await tester.pumpAndSettle();

        final saveButton = find.text("Save Today's Log");
        expect(saveButton, findsOneWidget);
        await tester.scrollUntilVisible(
          saveButton,
          200,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(saveButton);
        await tester.pumpAndSettle();

        // Verify Direct Transition to AI Cycle Harmony & Wellness Post Log View
        expect(find.byType(AiCycleHarmonyPostLogView), findsOneWidget);
        expect(find.textContaining('Log Recorded, Amina!'), findsOneWidget);
        expect(find.text("TODAY'S LOG SNAPSHOT"), findsOneWidget);
        expect(find.text('AI Cycle Harmony & Wellness Analysis'), findsOneWidget);
        expect(find.text('SMART NEXT ACTIONS'), findsOneWidget);
        expect(find.text('Return to Dashboard'), findsOneWidget);
      },
    );
  });
}
