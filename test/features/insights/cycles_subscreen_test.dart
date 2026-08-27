import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/insights/cycles/cycles_subscreen.dart';
import 'package:flowcycle/features/insights/cycles/widgets/cycle_history_table_card.dart';
import 'package:flowcycle/features/insights/cycles/widgets/cycle_phases_timeline_card.dart';
import 'package:flowcycle/features/insights/cycles/widgets/cycles_consistency_banner.dart';
import 'package:flowcycle/features/insights/cycles/widgets/cycles_current_hero_card.dart';
import 'package:flowcycle/features/insights/cycles/widgets/cycles_header.dart';
import 'package:flowcycle/features/insights/cycles/widgets/cycles_sub_tabs.dart';
import 'package:flowcycle/features/insights/insights_screen.dart';
import 'package:flowcycle/shared/providers/app_scope.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';

void main() {
  group('Cycles Subscreen Tests', () {
    testWidgets(
      'Renders all Cycles subscreen components with exact visual fidelity',
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
            child: const MaterialApp(home: CyclesSubscreen()),
          ),
        );
        await tester.pumpAndSettle();

        // 1. Header
        expect(find.byType(CyclesHeader), findsOneWidget);
        expect(find.text('Cycles'), findsOneWidget);
        expect(
          find.text('View and manage your cycle history'),
          findsOneWidget,
        );

        // 2. Sub-Tabs
        expect(find.byType(CyclesSubTabs), findsOneWidget);
        expect(find.text('Current cycle'), findsOneWidget);
        expect(find.text('History'), findsOneWidget);
        expect(find.text('Predictions'), findsOneWidget);

        // 3. Current Cycle Hero Card (Right-aligned ring)
        expect(find.byType(CyclesCurrentHeroCard), findsOneWidget);
        expect(find.text('Cycle day'), findsOneWidget);
        expect(find.text('Fertile window'), findsOneWidget);
        expect(find.text('Ovulation'), findsWidgets);
        expect(find.text('Next period expected'), findsOneWidget);

        // 4. Cycle Phases Timeline Card
        expect(find.byType(CyclePhasesTimelineCard), findsOneWidget);
        expect(find.text('Cycle phases'), findsOneWidget);
        expect(find.text('Learn more'), findsOneWidget);
        expect(find.text('Period'), findsOneWidget);
        expect(find.text('Follicular'), findsOneWidget);
        expect(find.text('Luteal'), findsOneWidget);
        expect(
          find.text(
            'Ovulation is the day your body is most likely to release an egg.',
          ),
          findsOneWidget,
        );

        // 5. Cycle History Table Card (Clean empty state)
        expect(find.byType(CycleHistoryTableCard), findsOneWidget);
        expect(find.text('Cycle history'), findsOneWidget);
        expect(find.text('Cycle 1 in progress 🌸'), findsOneWidget);

        // 6. Consistency Banner
        expect(find.byType(CyclesConsistencyBanner), findsOneWidget);
        expect(
          find.text('Your cycles are looking consistent!'),
          findsOneWidget,
        );
        expect(
          find.text('Keep logging to get more accurate insights.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Tapping Cycles tab in Insights transitions to Cycles subscreen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const MaterialApp(home: InsightsScreen()));
        await tester.pumpAndSettle();

        expect(find.byType(CyclesSubscreen), findsNothing);

        // Tap on Cycles tab
        await tester.tap(find.text('Cycles'));
        await tester.pumpAndSettle();

        expect(find.byType(CyclesSubscreen), findsOneWidget);

        // Tap back chevron in CyclesSubscreen -> returns to Insights Overview
        await tester.tap(find.byIcon(Icons.chevron_left_rounded));
        await tester.pumpAndSettle();

        expect(find.byType(CyclesSubscreen), findsNothing);
        expect(find.text('Your current cycle'), findsOneWidget);
      },
    );
  });
}
