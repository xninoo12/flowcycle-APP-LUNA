import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/calendar/calendar_screen.dart';
import 'package:flowcycle/features/calendar/widgets/calendar_filter_sheet.dart';
import 'package:flowcycle/features/calendar/widgets/calendar_legend_sheet.dart';
import 'package:flowcycle/features/calendar/widgets/day_details_modal.dart';
import 'package:flowcycle/features/calendar/widgets/jump_to_date_modal.dart';
import 'package:flowcycle/features/calendar/widgets/year_overview_grid.dart';
import 'package:flowcycle/shared/models/app_mode.dart';
import 'package:flowcycle/shared/models/daily_log_entry.dart';
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

  group('Calendar Screen Features & Subsystems Comprehensive Test Suite', () {
    testWidgets(
      '1. CalendarFilterSheet: toggles overlay layers & applies filters',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        Map<String, bool> currentFilters = {
          'period': true,
          'fertileWindow': true,
          'cervicalFluid': true,
          'intimacy': true,
          'symptoms': true,
        };

        Map<String, bool>? applied;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CalendarFilterSheet(
                currentFilters: currentFilters,
                onApplyFilters: (val) => applied = val,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Calendar Overlays & Filters'), findsOneWidget);
        expect(find.text('Period & Flow Intensity'), findsOneWidget);
        expect(find.text('Fertile Window & Ovulation'), findsOneWidget);
        expect(find.text('Cervical Fluid & BBT'), findsOneWidget);
        expect(find.text('Intimacy & Intercourse'), findsOneWidget);
        expect(find.text('Symptoms & Biomarkers'), findsOneWidget);

        // Clear all
        await tester.tap(find.text('Clear All'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Apply Filters'));
        await tester.pumpAndSettle();

        expect(applied != null, isTrue);
        expect(applied!['period'], isFalse);
      },
    );

    testWidgets('2. CalendarLegendSheet: renders clinical symbol guides', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CalendarLegendSheet())),
      );
      await tester.pumpAndSettle();

      expect(find.text('Calendar Symbols & Legend'), findsOneWidget);
      expect(find.text('Logged Menstrual Flow'), findsOneWidget);
      expect(find.text('Peak Ovulation Day'), findsOneWidget);
      expect(find.text('Logged Intercourse'), findsOneWidget);
    });

    testWidgets(
      '3. YearOverviewGrid: renders 12 mini-month cards and handles selection',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        int? selectedMonth;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: YearOverviewGrid(
                  selectedYear: 2025,
                  onMonthSelected: (m) => selectedMonth = m,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('2025 Annual Forecast'), findsOneWidget);
        expect(find.text('January'), findsOneWidget);
        expect(find.text('May'), findsOneWidget);
        expect(find.text('December'), findsOneWidget);

        await tester.tap(find.text('June'));
        expect(selectedMonth, 6);
      },
    );

    testWidgets(
      '4. DayDetailsModal: displays cycle day number, biomarkers, & symptoms',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final log = DailyLogEntry(
          date: DateTime(2025, 5, 14),
          mood: 'Great',
          flow: 'Spotting',
          cervicalMucus: 'Egg-white',
          bbtTemperature: 97.8,
          symptoms: const ['Mild Cramps', 'High Libido'],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DayDetailsModal(
                date: DateTime(2025, 5, 14),
                cycleDayNumber: 14,
                phaseName: 'Ovulation Peak',
                conceptionChance: 'High chance (38%)',
                logEntry: log,
                mode: AppMode.tryingToConceive,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('May 14, 2025'), findsOneWidget);
        expect(find.text('Cycle Day 14 • Ovulation Peak'), findsOneWidget);
        expect(
          find.text('Fertility Chance: High chance (38%)'),
          findsOneWidget,
        );
        expect(find.text('Great'), findsOneWidget);
        expect(find.text('Spotting'), findsOneWidget);
        expect(find.text('Egg-white'), findsOneWidget);
        expect(find.text('97.8°F'), findsOneWidget);
        expect(find.text('Mild Cramps'), findsOneWidget);
        expect(find.text('Edit Log For This Day'), findsOneWidget);
      },
    );

    testWidgets(
      '5. JumpToDateModal: selects month/year and triggers jump callback',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        int? targetMonth;
        int? targetYear;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: JumpToDateModal(
                initialMonth: 5,
                initialYear: 2025,
                onDateSelected: (m, y) {
                  targetMonth = m;
                  targetYear = y;
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Jump to Specific Date'), findsOneWidget);
        expect(find.text('2026'), findsOneWidget);

        await tester.tap(find.text('2026'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Aug'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Jump to Selected Date'));
        await tester.pumpAndSettle();

        expect(targetMonth, 8);
        expect(targetYear, 2026);
      },
    );

    testWidgets(
      '6. CalendarScreen: Header calendar button opens JumpToDateModal',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(buildTestable(const CalendarScreen()));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.calendar_today_rounded), findsWidgets);
        await tester.tap(find.byIcon(Icons.calendar_today_rounded).first);
        await tester.pumpAndSettle();

        expect(find.byType(JumpToDateModal), findsOneWidget);
        expect(find.text('Jump to Specific Date'), findsOneWidget);
      },
    );

    testWidgets(
      '7. CalendarScreen: Header more button opens options and legend modal',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(buildTestable(const CalendarScreen()));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.more_vert_rounded), findsOneWidget);
        await tester.tap(find.byIcon(Icons.more_vert_rounded));
        await tester.pumpAndSettle();

        expect(find.text('Calendar Legend & Color Guide'), findsOneWidget);
        expect(find.text('Jump to Specific Date'), findsOneWidget);

        await tester.tap(find.text('Calendar Legend & Color Guide'));
        await tester.pumpAndSettle();

        expect(find.byType(CalendarLegendSheet), findsOneWidget);
      },
    );

    testWidgets(
      '8. CalendarScreen: Year timeframe switches to YearOverviewGrid',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(buildTestable(const CalendarScreen()));
        await tester.pumpAndSettle();

        expect(find.text('Year'), findsOneWidget);
        await tester.tap(find.text('Year'));
        await tester.pumpAndSettle();

        expect(find.byType(YearOverviewGrid), findsOneWidget);
        expect(find.text('2025 Annual Forecast'), findsOneWidget);

        // Tapping a month returns to Month view
        await tester.tap(find.text('August'));
        await tester.pumpAndSettle();

        expect(find.byType(YearOverviewGrid), findsNothing);
      },
    );

    testWidgets(
      '9. CalendarScreen: Mode switcher smoothly toggles TTC and Cycle Awareness',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(buildTestable(const CalendarScreen()));
        await tester.pumpAndSettle();

        expect(find.text('Cycle Awareness'), findsOneWidget);
        expect(find.text('Trying to Conceive'), findsOneWidget);

        // Switch to TTC mode
        await tester.tap(find.text('Trying to Conceive'));
        await tester.pumpAndSettle();

        expect(
          find.text('Track your fertility & conception window'),
          findsOneWidget,
        );
      },
    );
  });
}
