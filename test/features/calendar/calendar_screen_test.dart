import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/calendar/calendar_screen.dart';
import 'package:flowcycle/features/calendar/widgets/calendar_header.dart';
import 'package:flowcycle/features/calendar/widgets/calendar_metrics_cards.dart';
import 'package:flowcycle/features/calendar/widgets/calendar_privacy_tip_card.dart';
import 'package:flowcycle/features/calendar/widgets/day_details_modal.dart';
import 'package:flowcycle/features/calendar/widgets/fertile_window_hero_widget.dart';
import 'package:flowcycle/features/calendar/widgets/month_grid_card.dart';
import 'package:flowcycle/features/dashboard/widgets/mode_segmented_switcher.dart';
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

  group('Calendar Screen Redesign Multi-Mode Tests', () {
    testWidgets('1. Renders complete redesigned Calendar Screen layout and components', (
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

      // 1. Header
      expect(find.byType(CalendarHeader), findsOneWidget);
      expect(find.text('Calendar'), findsOneWidget);
      expect(
        find.text('Track your cycle & fertile window'),
        findsOneWidget,
      );

      // 2. Mode Switcher
      expect(find.byType(ModeSegmentedSwitcher), findsOneWidget);
      expect(find.text('Cycle Awareness'), findsOneWidget);
      expect(find.text('Trying to Conceive'), findsOneWidget);

      // 3. Month Grid Card
      expect(find.byType(MonthGridCard), findsOneWidget);
      expect(find.text('May 2025'), findsOneWidget);
      expect(find.text('Mon'), findsOneWidget);
      expect(find.text('Wed'), findsOneWidget);
      expect(find.text('Fri'), findsOneWidget);
      expect(find.text('OVULATION'), findsOneWidget);

      // Legend items
      expect(find.text('Period'), findsOneWidget);
      expect(find.text('Fertile window'), findsOneWidget);
      expect(find.text('Ovulation'), findsOneWidget);
      expect(find.text('Luteal phase'), findsOneWidget);
      expect(find.text('Logged period'), findsOneWidget);
      expect(find.text('Sex logged'), findsOneWidget);

      // 4. Fertile Window Hero Widget (in empty space)
      expect(find.byType(FertileWindowHeroWidget), findsOneWidget);
      expect(find.text('FERTILE WINDOW'), findsOneWidget);
      expect(find.text('High fertility chance'), findsOneWidget);

      // 5. Dual Key-Metrics Cards
      expect(find.byType(CalendarMetricsCards), findsOneWidget);
      expect(find.text('Sexual Intercourse Logged'), findsOneWidget);
      expect(find.text('Days Logged'), findsOneWidget);

      // 6. Privacy & Tip Card
      expect(find.byType(CalendarPrivacyTipCard), findsOneWidget);
      expect(find.text('Sex Logged (Private)'), findsOneWidget);
      expect(find.textContaining('Tap & hold a day'), findsOneWidget);
    });

    testWidgets('2. Toggles between Cycle Awareness and TTC modes smoothly', (
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

      // Tap Trying to Conceive tab
      await tester.tap(find.text('Trying to Conceive'));
      await tester.pumpAndSettle();

      expect(
        find.text('Track your fertility & conception window'),
        findsOneWidget,
      );

      // Tap Cycle Awareness tab
      await tester.tap(find.text('Cycle Awareness'));
      await tester.pumpAndSettle();

      expect(
        find.text('Track your cycle & fertile window'),
        findsOneWidget,
      );
    });

    testWidgets('3. Tapping a day opens DayDetailsModal', (
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

      // Tap day 18 (Ovulation)
      await tester.tap(find.text('OVULATION'));
      await tester.pumpAndSettle();

      expect(find.byType(DayDetailsModal), findsOneWidget);
    });
  });
}
