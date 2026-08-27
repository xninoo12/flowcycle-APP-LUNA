import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/insights/insights_screen.dart';
import 'package:flowcycle/features/insights/trends/trends_subscreen.dart';
import 'package:flowcycle/features/insights/trends/widgets/cycle_length_trend_card.dart';
import 'package:flowcycle/features/insights/trends/widgets/period_length_trend_card.dart';
import 'package:flowcycle/features/insights/trends/widgets/trends_header.dart';
import 'package:flowcycle/features/insights/trends/widgets/trends_horizon_selector.dart';
import 'package:flowcycle/features/insights/trends/widgets/trends_insights_metric_grid.dart';

void main() {
  group('Trends Subscreen Tests', () {
    testWidgets(
      'Renders all Trends subscreen components with exact visual fidelity',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const MaterialApp(home: TrendsSubscreen()));
        await tester.pumpAndSettle();

        // 1. Header
        expect(find.byType(TrendsHeader), findsOneWidget);
        expect(find.text('Trends'), findsOneWidget);
        expect(
          find.text('See patterns in your cycle over time'),
          findsOneWidget,
        );

        // 2. Horizon Selector
        expect(find.byType(TrendsHorizonSelector), findsOneWidget);
        expect(find.text('3 months'), findsOneWidget);
        expect(find.text('6 months'), findsOneWidget);
        expect(find.text('12 months'), findsOneWidget);

        // 3. Cycle Length Trend Card
        expect(find.byType(CycleLengthTrendCard), findsOneWidget);
        expect(find.text('Cycle length trend'), findsOneWidget);
        expect(find.text('28 days'), findsOneWidget);
        expect(find.text('▲ 1 day vs last 3 months'), findsOneWidget);
        expect(find.text('Cycle range'), findsOneWidget);
        expect(find.text('26 – 31 days'), findsOneWidget);

        // 4. Metric Grid
        expect(find.byType(TrendsInsightsMetricGrid), findsOneWidget);
        expect(find.text('Cycle insights'), findsOneWidget);
        expect(find.text('Avg period\nlength'), findsOneWidget);
        expect(find.text('Avg cycle\nlength'), findsOneWidget);
        expect(find.text('Avg ovulation\nday'), findsOneWidget);
        expect(find.text('Longest\ncycle'), findsOneWidget);

        // 5. Period Length Trend Card
        expect(find.byType(PeriodLengthTrendCard), findsOneWidget);
        expect(find.text('Period length trend'), findsOneWidget);
        expect(find.text('Days'), findsOneWidget);
        expect(find.text('Average period length'), findsOneWidget);
        expect(find.text('▼ 0.3 day vs last 3 months'), findsOneWidget);
      },
    );

    testWidgets(
      'Tapping Trends tab in Insights transitions to Trends subscreen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const MaterialApp(home: InsightsScreen()));
        await tester.pumpAndSettle();

        expect(find.byType(TrendsSubscreen), findsNothing);

        // Tap on Trends tab
        await tester.tap(find.text('Trends'));
        await tester.pumpAndSettle();

        expect(find.byType(TrendsSubscreen), findsOneWidget);

        // Tap back chevron in TrendsSubscreen -> returns to Insights Overview
        await tester.tap(find.byIcon(Icons.chevron_left_rounded));
        await tester.pumpAndSettle();

        expect(find.byType(TrendsSubscreen), findsNothing);
        expect(find.text('Your current cycle'), findsOneWidget);
      },
    );
  });
}
