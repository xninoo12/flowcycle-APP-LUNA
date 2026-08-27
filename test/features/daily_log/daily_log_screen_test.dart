import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/daily_log/daily_log_screen.dart';
import 'package:flowcycle/features/daily_log/widgets/all_set_success_dialog.dart';
import 'package:flowcycle/features/daily_log/widgets/flow_intensity_selector.dart';
import 'package:flowcycle/features/daily_log/widgets/log_date_field.dart';
import 'package:flowcycle/features/daily_log/widgets/log_modal_header.dart';
import 'package:flowcycle/features/daily_log/widgets/mood_selector_row.dart';
import 'package:flowcycle/features/daily_log/widgets/sleep_and_energy_section.dart';
import 'package:flowcycle/features/daily_log/widgets/symptoms_chips_selector.dart';

void main() {
  group('Daily Log Screen / Modal Tests', () {
    testWidgets('Renders all Log Modal components with exact visual fidelity', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: DailyLogScreen()));
      await tester.pumpAndSettle();

      // 1. Header
      expect(find.byType(LogModalHeader), findsOneWidget);
      expect(find.text('Log Your Day'), findsOneWidget);

      // 2. Date Field
      expect(find.byType(LogDateField), findsOneWidget);
      expect(find.text('Date'), findsOneWidget);
      expect(find.text('May 24, 2025'), findsOneWidget);

      // 3. Mood Selector
      expect(find.byType(MoodSelectorRow), findsOneWidget);
      expect(find.text('How are you feeling?'), findsOneWidget);
      expect(find.text('Great'), findsOneWidget);
      expect(find.text('Good'), findsOneWidget);
      expect(find.text('Okay'), findsOneWidget);
      expect(find.text('Low'), findsWidgets); // Mood & Energy
      expect(find.text('Awful'), findsOneWidget);

      // 4. Flow Selector
      expect(find.byType(FlowIntensitySelector), findsOneWidget);
      expect(find.text('Flow'), findsOneWidget);
      expect(find.text('None'), findsWidgets);
      expect(find.text('Spotting'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Medium'), findsWidgets); // Flow & Energy
      expect(find.text('Heavy'), findsOneWidget);

      // 5. Symptoms Chips
      expect(find.byType(SymptomsChipsSelector), findsOneWidget);
      expect(find.text('Symptoms & Biomarkers'), findsOneWidget);
      expect(find.text('Select all that apply'), findsOneWidget);
      expect(find.text('Cramps'), findsOneWidget);
      expect(find.text('Bloating'), findsOneWidget);
      expect(find.text('Headache'), findsOneWidget);
      expect(find.text('Backache'), findsOneWidget);
      expect(find.text('Fatigue'), findsOneWidget);

      // 6. Sleep & Energy
      expect(find.byType(SleepAndEnergySection), findsOneWidget);
      expect(find.text('Sleep'), findsOneWidget);
      expect(find.text('How is your energy today?'), findsOneWidget);

      // 7. Save Log Button
      expect(find.text('Save Log'), findsOneWidget);
    });

    testWidgets(
      'Tapping Save Log displays All Set! popup dialog with summary',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const MaterialApp(home: DailyLogScreen()));
        await tester.pumpAndSettle();

        final saveButton = find.text('Save Log');
        expect(saveButton, findsOneWidget);
        await tester.scrollUntilVisible(
          saveButton,
          200,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(saveButton);
        await tester.pumpAndSettle();

        // Verify All Set! Dialog
        expect(find.byType(AllSetSuccessDialog), findsOneWidget);
        expect(find.text('All Set!'), findsOneWidget);
        expect(
          find.text('Your log has been saved\nsuccessfully.'),
          findsOneWidget,
        );
        expect(find.text('View Log'), findsOneWidget);
        expect(find.text('Done'), findsOneWidget);

        // Tapping Done closes dialog
        await tester.tap(find.text('Done'));
        await tester.pumpAndSettle();
        expect(find.byType(AllSetSuccessDialog), findsNothing);
      },
    );
  });
}
