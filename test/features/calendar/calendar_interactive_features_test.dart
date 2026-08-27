import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/calendar/calendar_screen.dart';
import 'package:flowcycle/features/calendar/widgets/calendar_privacy_sheet.dart';
import 'package:flowcycle/features/calendar/widgets/intercourse_history_sheet.dart';
import 'package:flowcycle/features/calendar/widgets/logging_summary_sheet.dart';
import 'package:flowcycle/features/calendar/widgets/quick_day_action_sheet.dart';
import 'package:flowcycle/shared/models/app_mode.dart';
import 'package:flowcycle/shared/providers/app_scope.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';

void main() {
  late CycleDataController controller;

  setUp(() {
    controller = CycleDataController();
  });

  Widget buildTestable(Widget child) {
    return MaterialApp(
      home: AppScope(controller: controller, child: child),
    );
  }

  group('Calendar Interactive Features & Modal Suites Tests', () {
    testWidgets('1. Long-pressing day cell opens QuickDayActionSheet & saves flow', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestable(const CalendarScreen(initialMode: AppMode.cycleAwareness)),
      );
      await tester.pumpAndSettle();

      // Long press Day 18 (Ovulation)
      await tester.longPress(find.text('OVULATION'));
      await tester.pumpAndSettle();

      expect(find.byType(QuickDayActionSheet), findsOneWidget);
      expect(find.text('Log Menstrual Flow'), findsOneWidget);
      expect(find.text('Log Sexual Intercourse (Private 💜🔒)'), findsOneWidget);

      // Tap Spotting flow
      await tester.tap(find.text('Spotting'));
      await tester.pumpAndSettle();

      // Tap Protected Intimacy
      await tester.tap(find.text('Protected'));
      await tester.pumpAndSettle();

      expect(find.text('Open Full Daily Log & Symptoms'), findsOneWidget);
    });

    testWidgets('2. Tapping Sexual Intercourse Logged opens IntercourseHistorySheet', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestable(const CalendarScreen(initialMode: AppMode.cycleAwareness)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sexual Intercourse Logged'));
      await tester.pumpAndSettle();

      expect(find.byType(IntercourseHistorySheet), findsOneWidget);
      expect(find.text('Sexual Intercourse Log'), findsOneWidget);
      expect(find.textContaining('Recorded Intimacy Events'), findsOneWidget);
      expect(find.textContaining('Log Sexual Intercourse for Today'), findsOneWidget);
    });

    testWidgets('3. Tapping Days Logged opens LoggingSummarySheet with streak & categories', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestable(const CalendarScreen(initialMode: AppMode.cycleAwareness)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Days Logged'));
      await tester.pumpAndSettle();

      expect(find.byType(LoggingSummarySheet), findsOneWidget);
      expect(find.text('Logging Streak & Insights'), findsOneWidget);
      expect(find.textContaining('Active Streak'), findsOneWidget);
      expect(find.text('Biomarkers Tracked'), findsOneWidget);
      expect(find.text('Log Daily Biomarkers Today'), findsOneWidget);
    });

    testWidgets('4. Tapping Privacy Tip box opens CalendarPrivacySheet', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestable(const CalendarScreen(initialMode: AppMode.cycleAwareness)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('Tap & hold a day'));
      await tester.pumpAndSettle();

      expect(find.byType(CalendarPrivacySheet), findsOneWidget);
      expect(find.text('Reproductive Privacy Guarantee'), findsOneWidget);
      expect(find.text('Configure PIN & Privacy Settings'), findsOneWidget);
    });

    testWidgets('5. Navigating months updates month title and grid dynamically', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestable(const CalendarScreen(initialMode: AppMode.cycleAwareness)),
      );
      await tester.pumpAndSettle();

      expect(find.text('May 2025'), findsOneWidget);

      // Tap Next Month (June 2025)
      await tester.tap(find.byIcon(Icons.chevron_right_rounded));
      await tester.pumpAndSettle();

      expect(find.text('June 2025'), findsOneWidget);

      // Tap Previous Month (May 2025)
      await tester.tap(find.byIcon(Icons.chevron_left_rounded).last);
      await tester.pumpAndSettle();

      expect(find.text('May 2025'), findsOneWidget);
    });
  });
}
