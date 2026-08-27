import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/insights/insights_screen.dart';
import 'package:flowcycle/features/insights/widgets/current_cycle_hero_card.dart';
import 'package:flowcycle/features/insights/widgets/cycle_highlights_row.dart';
import 'package:flowcycle/features/insights/widgets/fertility_year_chart_card.dart';
import 'package:flowcycle/features/insights/widgets/insights_category_tabs.dart';
import 'package:flowcycle/features/insights/widgets/insights_header.dart';
import 'package:flowcycle/features/insights/widgets/intercourse_and_symptoms_row.dart';
import 'package:flowcycle/shared/providers/app_scope.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';

void main() {
  group('Insights Main Screen Tests', () {
    testWidgets(
      'Renders all Insights screen components with high visual fidelity',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final controller = CycleDataController();
        controller.updateUserProfile(
          name: 'Amina',
          lastPeriodStartDate: DateTime.now().subtract(const Duration(days: 7)),
          averageCycleLength: 28,
          typicalPeriodDuration: 5,
        );

        await tester.pumpWidget(
          AppScope(
            controller: controller,
            child: const MaterialApp(home: InsightsScreen()),
          ),
        );
        await tester.pumpAndSettle();

        // 1. Header with lotus logo
        expect(find.byType(InsightsHeader), findsOneWidget);
        expect(find.text('Insights'), findsOneWidget);
        expect(find.text('✦'), findsWidgets);
        expect(
          find.text('Understand your body. Plan your future.'),
          findsOneWidget,
        );

        // 2. Category Tabs
        expect(find.byType(InsightsCategoryTabs), findsOneWidget);
        expect(find.text('Overview'), findsOneWidget);
        expect(find.text('Cycles'), findsOneWidget);
        expect(find.text('Fertility'), findsOneWidget);
        expect(find.text('Trends'), findsOneWidget);

        // 3. Current Cycle Hero Card (Right-aligned ring)
        expect(find.byType(CurrentCycleHeroCard), findsOneWidget);
        expect(find.text('Your current cycle'), findsOneWidget);
        expect(find.text('Cycle day'), findsOneWidget);
        expect(find.text('Fertile window'), findsOneWidget);
        expect(find.text('Predicted ovulation'), findsOneWidget);
        expect(find.text('Next period'), findsOneWidget);
        expect(find.text('Learn more'), findsWidgets);

        // 4. Cycle Highlights Row
        expect(find.byType(CycleHighlightsRow), findsOneWidget);
        expect(find.text('Cycle highlights'), findsOneWidget);
        expect(find.text('vs. last 6 cycles'), findsOneWidget);
        expect(find.text('28'), findsWidgets);
        expect(find.text('5'), findsOneWidget);
        expect(find.text('31'), findsOneWidget);

        // 5. Fertility This Year Chart Card
        expect(find.byType(FertilityYearChartCard), findsOneWidget);
        expect(find.text('Fertility this year'), findsOneWidget);
        expect(find.text('Fertile days'), findsOneWidget);
        expect(find.text('Ovulation'), findsOneWidget);
        expect(find.text('High'), findsWidgets);
        expect(find.text('Medium'), findsOneWidget);
        expect(find.text('Low'), findsOneWidget);
        expect(
          find.text('May is your most fertile month this year.'),
          findsOneWidget,
        );
        expect(
          find.text('You had high chances of conception for 6 days.'),
          findsOneWidget,
        );

        // 6. Split Row: Intercourse, Consistency & Body balance (3 Cards)
        expect(find.byType(IntercourseAndSymptomsRow), findsOneWidget);
        expect(find.text('Intercourse'), findsOneWidget);
        expect(find.textContaining('times'), findsOneWidget);
        expect(find.text('Consistency'), findsOneWidget);
        expect(find.textContaining('%'), findsWidgets);
        expect(find.text('Body balance'), findsOneWidget);

        // 7. Privacy matters banner
        expect(find.text('Your privacy matters'), findsOneWidget);
        expect(
          find.text('Your data is private, encrypted and never shared.'),
          findsOneWidget,
        );
      },
    );

    testWidgets('Tapping category tabs updates selection smoothly', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: InsightsScreen()));
      await tester.pumpAndSettle();

      // Tap on Cycles tab
      await tester.tap(find.text('Cycles'));
      await tester.pumpAndSettle();
      expect(find.text('Current cycle'), findsWidgets);
    });
  });
}
