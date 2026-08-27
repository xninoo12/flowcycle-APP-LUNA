import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/insights/cycles/cycles_subscreen.dart';
import 'package:flowcycle/features/insights/cycles/widgets/cycle_entry_detail_sheet.dart';
import 'package:flowcycle/features/insights/cycles/widgets/cycle_history_table_card.dart';
import 'package:flowcycle/features/insights/cycles/widgets/phase_detail_sheet.dart';
import 'package:flowcycle/features/insights/fertility/fertility_subscreen.dart';
import 'package:flowcycle/features/insights/fertility/widgets/daily_fertility_detail_sheet.dart';
import 'package:flowcycle/features/insights/fertility/widgets/fertility_breakdown_card.dart';
import 'package:flowcycle/features/insights/fertility/widgets/fertility_factor_detail_sheet.dart';
import 'package:flowcycle/features/insights/insights_screen.dart';
import 'package:flowcycle/features/insights/trends/trends_subscreen.dart';
import 'package:flowcycle/features/insights/widgets/cycle_highlights_detail_sheet.dart';
import 'package:flowcycle/features/insights/widgets/fertility_month_detail_sheet.dart';
import 'package:flowcycle/shared/models/app_mode.dart';
import 'package:flowcycle/shared/providers/app_scope.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';

void main() {
  late CycleDataController controller;

  setUp(() {
    controller = CycleDataController();
    controller.updateUserProfile(
      name: 'Sarah',
      averageCycleLength: 28,
      typicalPeriodDuration: 5,
      lastPeriodStartDate: DateTime.now().subtract(const Duration(days: 12)),
      mode: AppMode.tryingToConceive,
      focusGoal: 'Conception Optimization',
    );
  });

  Widget buildTestable(Widget child) {
    return MaterialApp(
      home: AppScope(controller: controller, child: child),
    );
  }

  group('Insights Features & Clinical Modals Comprehensive Suite', () {
    testWidgets('1. CycleHighlightsDetailSheet renders all clinical metrics', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestable(
          const Scaffold(
            body: CycleHighlightsDetailSheet(
              avgCycleLength: 28,
              avgPeriodLength: 5,
              avgOvulationDay: 'Day 14',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Cycle Highlights Breakdown'), findsOneWidget);
      expect(find.text('Highly Consistent Cycle Pattern'), findsOneWidget);
      expect(find.text('Follicular Phase'), findsOneWidget);
      expect(find.text('Luteal Phase'), findsOneWidget);
      expect(find.text('14 days'), findsWidgets);
      expect(
        find.text('Clinical Insights & Luteal Sufficiency'),
        findsOneWidget,
      );
      expect(find.text('Ask AI About My Cycle Highlights ✦'), findsOneWidget);
    });

    testWidgets('2. CycleEntryDetailSheet renders historical cycle summary', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestable(
          const Scaffold(
            body: CycleEntryDetailSheet(
              dateRange: 'Apr 6 – May 3',
              cycleLength: 28,
              periodDuration: 5,
              ovulationDay: 'Apr 20',
              symptoms: ['Bloating', 'Mild Cramps', 'Egg-white fluid'],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Cycle Details'), findsOneWidget);
      expect(find.text('Apr 6 – May 3'), findsOneWidget);
      expect(find.text('Normal • Regular'), findsOneWidget);
      expect(find.text('28 days'), findsOneWidget);
      expect(find.text('Egg-white fluid'), findsOneWidget);
      expect(find.text('Cycle Regularity Diagnosis'), findsOneWidget);
      expect(find.text('Ask AI About This Cycle ✦'), findsOneWidget);
    });

    testWidgets(
      '3. PhaseDetailSheet renders hormonal and biological guidance',
      (tester) async {
        await tester.pumpWidget(
          buildTestable(
            const Scaffold(
              body: PhaseDetailSheet(
                phaseName: 'Follicular Phase',
                dayRange: 'Days 6–13',
                emoji: '🌱',
                themeColor: Color(0xFF059669),
                hormoneOverview:
                    'FSH stimulates follicle growth; estradiol climbs.',
                bodySignals: 'Surging physical energy, elevated mental focus.',
                wellnessTips: [
                  'Incorporate strength training',
                  'Fresh vegetables',
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Follicular Phase (Days 6–13)'), findsOneWidget);
        expect(find.text('Hormone Profile'), findsOneWidget);
        expect(
          find.text('FSH stimulates follicle growth; estradiol climbs.'),
          findsOneWidget,
        );
        expect(find.text('Incorporate strength training'), findsOneWidget);
        expect(find.text('Ask AI About Follicular Phase ✦'), findsOneWidget);
      },
    );

    testWidgets(
      '4. DailyFertilityDetailSheet renders 5-day daily gauge details',
      (tester) async {
        await tester.pumpWidget(
          buildTestable(
            const Scaffold(
              body: DailyFertilityDetailSheet(
                dayLabel: 'Thu',
                dateText: 'May 14',
                chancePercent: 85,
                chanceRating: 'Peak Fertility 💗',
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Thu • May 14'), findsOneWidget);
        expect(find.text('85%'), findsOneWidget);
        expect(find.text('Peak Fertility 💗'), findsOneWidget);
        expect(find.text('Cervical Fluid State'), findsOneWidget);
        expect(find.text('Basal Body Temperature (BBT)'), findsOneWidget);
        expect(find.text('Conception Timing Strategy'), findsOneWidget);
        expect(find.text("Ask AI About Today's Fertility ✦"), findsOneWidget);
      },
    );

    testWidgets(
      '5. FertilityFactorDetailSheet renders factor checklist and score',
      (tester) async {
        await tester.pumpWidget(
          buildTestable(
            const Scaffold(
              body: FertilityFactorDetailSheet(
                title: 'Timing & Frequency',
                impact: 'High Impact • +35% Success Rate',
                description: 'Timing intercourse during the fertile window.',
                icon: Icons.favorite_rounded,
                color: Color(0xFFE84855),
                actionableTips: [
                  'Intercourse every 1–2 days',
                  'Morning intimacy optimal',
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Timing & Frequency'), findsOneWidget);
        expect(find.text('High Impact • +35% Success Rate'), findsOneWidget);
        expect(find.text('Intercourse every 1–2 days'), findsOneWidget);
        expect(find.text('Ask AI About This Factor ✦'), findsOneWidget);
      },
    );

    testWidgets('6. Main InsightsScreen: Tapping highlights opens sheet', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestable(const InsightsScreen()));
      await tester.pumpAndSettle();

      // Tap on Cycle Highlights
      final avgCycleCard = find.textContaining('Avg cycle length');
      expect(avgCycleCard, findsWidgets);
      await tester.tap(avgCycleCard.first);
      await tester.pumpAndSettle();

      // Verify modal sheet appeared
      expect(find.text('Cycle Highlights Breakdown'), findsOneWidget);
    });

    testWidgets(
      '7. CyclesSubscreen: Tapping history row and phase node opens sheets',
      (tester) async {
        await tester.pumpWidget(buildTestable(const CyclesSubscreen()));
        await tester.pumpAndSettle();

        // Tap on a phase node: "Follicular"
        final follicularNode = find.text('Follicular');
        expect(follicularNode, findsOneWidget);
        await tester.tap(follicularNode);
        await tester.pumpAndSettle();
        expect(find.byType(PhaseDetailSheet), findsOneWidget);
        expect(find.text('Follicular (Days 6–13)'), findsOneWidget);

        // Close sheet
        await tester.tap(find.byIcon(Icons.close_rounded));
        await tester.pumpAndSettle();

        // Scroll to Cycle History and tap See all
        await tester.scrollUntilVisible(
          find.text('Cycle history'),
          200,
          scrollable: find.byType(Scrollable).first,
        );
        final cycleHistoryTable = find.byType(CycleHistoryTableCard);
        expect(cycleHistoryTable, findsOneWidget);
        await tester.tap(find.text('See all'));
        await tester.pumpAndSettle();
        expect(find.byType(CycleEntryDetailSheet), findsOneWidget);
        expect(find.text('Cycle Details'), findsOneWidget);
      },
    );

    testWidgets(
      '8. FertilitySubscreen: Tapping day gauge and factor opens sheets',
      (tester) async {
        await tester.pumpWidget(buildTestable(const FertilitySubscreen()));
        await tester.pumpAndSettle();

        // Tap on breakdown card
        final breakdownCard = find.byType(FertilityBreakdownCard);
        expect(breakdownCard, findsOneWidget);
        await tester.tap(breakdownCard);
        await tester.pumpAndSettle();
        expect(find.byType(DailyFertilityDetailSheet), findsOneWidget);

        // Close sheet
        await tester.tap(find.byIcon(Icons.close_rounded));
        await tester.pumpAndSettle();

        // Scroll to factors and tap "Manage stress"
        await tester.scrollUntilVisible(
          find.text('Manage stress'),
          200,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(find.text('Manage stress'));
        await tester.pumpAndSettle();
        expect(find.byType(FertilityFactorDetailSheet), findsOneWidget);
        expect(
          find.text('Moderate Impact • Cortisol Modulation'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      '9. TrendsSubscreen: Horizon selector recalculates dynamic metrics',
      (tester) async {
        await tester.pumpWidget(buildTestable(const TrendsSubscreen()));
        await tester.pumpAndSettle();

        // Default is 3 months
        expect(find.text('▲ 1 day vs last 3 months'), findsOneWidget);

        // Select 6 months
        await tester.tap(find.text('6 months'));
        await tester.pumpAndSettle();
        expect(find.text('▲ 0.8 day vs last 6 months'), findsOneWidget);

        // Select 12 months
        await tester.tap(find.text('12 months'));
        await tester.pumpAndSettle();
        expect(find.text('▲ 1.4 days vs last 12 months'), findsOneWidget);
      },
    );

    testWidgets(
      '10. FertilityMonthDetailSheet: Renders clinical breakdown & AI trigger',
      (tester) async {
        await tester.pumpWidget(
          buildTestable(
            const FertilityMonthDetailSheet(
              monthName: 'May',
              fertileRange: 'May 12 – May 17',
              peakOvulationDay: 'May 14',
              conceptionProbabilityPercent: 95,
              conceptionRating: 'Peak Conception Potential 💗',
              isPeakMonth: true,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('May Fertility Outlook'), findsOneWidget);
        expect(find.text('Peak Conception Potential 💗'), findsOneWidget);
        expect(find.text('95%'), findsOneWidget);
        expect(find.textContaining('May 12 – May 17'), findsWidgets);
        expect(find.textContaining('Date: May 14'), findsOneWidget);
        expect(find.text('Ask AI About May Fertility ✦'), findsOneWidget);
      },
    );

    testWidgets(
      '11. Main InsightsScreen: Tapping hero milestones opens phase sheets',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(buildTestable(const InsightsScreen()));
        await tester.pumpAndSettle();

        // Tap Fertile window milestone
        await tester.tap(find.text('Fertile window').first);
        await tester.pumpAndSettle();
        expect(find.byType(PhaseDetailSheet), findsOneWidget);
        expect(find.text('Follicular (Days 6–13)'), findsOneWidget);

        // Close
        await tester.tap(find.byIcon(Icons.close_rounded));
        await tester.pumpAndSettle();

        // Tap Predicted ovulation milestone
        await tester.tap(find.text('Predicted ovulation'));
        await tester.pumpAndSettle();
        expect(find.byType(PhaseDetailSheet), findsOneWidget);
        expect(find.text('Ovulation (Days 14–16)'), findsOneWidget);
      },
    );

    testWidgets(
      '12. FertilityYearChartCard: Tapping a month bar opens FertilityMonthDetailSheet',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(buildTestable(const InsightsScreen()));
        await tester.pumpAndSettle();

        // Scroll to Fertility Year Chart Card and tap month "May"
        final mayMonth = find.text('May');
        expect(mayMonth, findsWidgets);
        await tester.tap(mayMonth.first);
        await tester.pumpAndSettle();

        expect(find.byType(FertilityMonthDetailSheet), findsOneWidget);
        expect(find.text('May Fertility Outlook'), findsOneWidget);
      },
    );
  });
}
