import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/dashboard/home_screen.dart';
import 'package:flowcycle/features/dashboard/widgets/cycle_ring_card.dart';
import 'package:flowcycle/features/dashboard/widgets/cycle_ring_detail_sheet.dart';
import 'package:flowcycle/features/dashboard/widgets/dual_metrics_row.dart';
import 'package:flowcycle/features/dashboard/widgets/period_forecast_sheet.dart';
import 'package:flowcycle/features/dashboard/widgets/today_insight_detail_sheet.dart';
import 'package:flowcycle/features/dashboard/widgets/ttc/ttc_conception_window_sheet.dart';
import 'package:flowcycle/features/dashboard/widgets/ttc/ttc_fertility_chance_sheet.dart';
import 'package:flowcycle/features/dashboard/widgets/ttc/ttc_hero_cycle_card.dart';
import 'package:flowcycle/shared/models/app_mode.dart';
import 'package:flowcycle/shared/providers/app_scope.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';

void main() {
  late CycleDataController controller;

  setUp(() {
    controller = CycleDataController();
    controller.setAppMode(AppMode.cycleAwareness);
  });

  Widget buildTestable(Widget child) {
    return MaterialApp(
      home: AppScope(controller: controller, child: child),
    );
  }

  group(
    'Dashboard Features & Clinical Modals Comprehensive Test Suite (Both Modes)',
    () {
      testWidgets(
        '1. CycleRingDetailSheet: renders hormone curves & 4-phase breakdown',
        (tester) async {
          tester.view.physicalSize = const Size(1080, 2400);
          tester.view.devicePixelRatio = 2.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: CycleRingDetailSheet(
                  currentDay: 13,
                  totalDays: 28,
                  phaseName: 'Luteal Phase',
                  phaseDescription: 'Your body is preparing for a new cycle.',
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text('Cycle Phase & Hormone Curve'), findsOneWidget);
          expect(find.text('Luteal Phase'), findsWidgets);
          expect(find.text('Day 13 of 28'), findsOneWidget);
          expect(find.text('DAILY HORMONE CONCENTRATIONS'), findsOneWidget);
          expect(find.text('Progesterone'), findsOneWidget);
          expect(find.text('Estrogen'), findsOneWidget);
          expect(find.text('Luteinizing Hormone (LH)'), findsOneWidget);
          expect(find.text('Follicle-Stimulating (FSH)'), findsOneWidget);
          expect(find.text('4-PHASE CYCLE ARCHITECTURE'), findsOneWidget);
          expect(find.text('Menstrual Phase'), findsOneWidget);
          expect(find.text('Follicular Phase'), findsOneWidget);
          expect(find.text('Ovulation Phase'), findsOneWidget);
        },
      );

      testWidgets(
        '2. PeriodForecastSheet: renders countdown & preparedness tips',
        (tester) async {
          tester.view.physicalSize = const Size(1080, 2400);
          tester.view.devicePixelRatio = 2.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: PeriodForecastSheet(
                  daysRemaining: 3,
                  statusText: 'Expected in 3 days',
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text('Period Forecast & Preparedness'), findsOneWidget);
          expect(find.text('Period in 3 Days'), findsOneWidget);
          expect(find.text('98% Regular'), findsOneWidget);
          expect(find.text('CYCLE PREPAREDNESS TIPS'), findsOneWidget);
          expect(find.text('Hydration & Cramp Relief'), findsOneWidget);
          expect(find.text('Menstrual Care Supplies'), findsOneWidget);
          expect(find.text('Log Period / Flow Started'), findsOneWidget);
        },
      );

      testWidgets(
        '3. TodayInsightDetailSheet: renders cycle-synced pillars and AI CTA',
        (tester) async {
          tester.view.physicalSize = const Size(1080, 2400);
          tester.view.devicePixelRatio = 2.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: TodayInsightDetailSheet(
                  title: "Today's Insight ✨",
                  message: 'Your sleep quality improved 15% in this cycle.',
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text('AI Cycle Harmony & Lifestyle'), findsOneWidget);
          expect(find.text("Today's Insight ✨"), findsOneWidget);
          expect(find.text('CYCLE-SYNCED RECOMMENDATIONS'), findsOneWidget);
          expect(find.text('🥑 Nutrition & Metabolism'), findsOneWidget);
          expect(find.text('🧘‍♀️ Movement & Workouts'), findsOneWidget);
          expect(find.text('🌙 Sleep & Mental Focus'), findsOneWidget);
          expect(find.text('Ask AI Companion About Today ✦'), findsOneWidget);
        },
      );

      testWidgets(
        '4. TtcConceptionWindowSheet: renders 6-day fertile window breakdown',
        (tester) async {
          tester.view.physicalSize = const Size(1080, 2400);
          tester.view.devicePixelRatio = 2.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: TtcConceptionWindowSheet(
                  currentDay: 13,
                  totalDays: 28,
                  statusHeading: 'Fertile Window',
                  bestDaysText: 'Today & Tomorrow',
                  ovulationCountdownText: '1 day',
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(
            find.text('Fertile Window & Conception Timing'),
            findsOneWidget,
          );
          expect(find.text('6-DAY FERTILE WINDOW BREAKDOWN'), findsOneWidget);
          expect(find.textContaining('Day 14'), findsWidgets);
        },
      );

      testWidgets(
        '5. TtcFertilityChanceSheet: renders probability and biomarker checklist',
        (tester) async {
          tester.view.physicalSize = const Size(1080, 2400);
          tester.view.devicePixelRatio = 2.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: TtcFertilityChanceSheet(
                  percentage: 85,
                  level: 'High',
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text("Today's Fertility Probability"), findsOneWidget);
          expect(find.text('85%'), findsOneWidget);
          expect(find.text('High Conception Probability'), findsOneWidget);
          expect(find.text('BIOLOGICAL INDICATOR ANALYSIS'), findsOneWidget);
          expect(find.textContaining('Cervical Fluid'), findsOneWidget);
          expect(find.textContaining('LH Ovulation Surge'), findsOneWidget);
          expect(find.textContaining('Basal Body Temperature'), findsOneWidget);
        },
      );

      testWidgets(
        '6. HomeScreen (Cycle Awareness): tapping hero card opens CycleRingDetailSheet',
        (tester) async {
          tester.view.physicalSize = const Size(1080, 2400);
          tester.view.devicePixelRatio = 2.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(
            buildTestable(
              const HomeScreen(initialMode: AppMode.cycleAwareness),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.byType(CycleRingCard), findsOneWidget);
          await tester.tap(find.byType(CycleRingCard));
          await tester.pumpAndSettle();

          expect(find.byType(CycleRingDetailSheet), findsOneWidget);
          expect(find.text('Cycle Phase & Hormone Curve'), findsOneWidget);
        },
      );

      testWidgets(
        '7. HomeScreen (Cycle Awareness): tapping next period opens PeriodForecastSheet',
        (tester) async {
          tester.view.physicalSize = const Size(1080, 2400);
          tester.view.devicePixelRatio = 2.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(
            buildTestable(
              const HomeScreen(initialMode: AppMode.cycleAwareness),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.byType(DualMetricsRow), findsOneWidget);
          await tester.tap(find.text('Next Period'));
          await tester.pumpAndSettle();

          expect(find.byType(PeriodForecastSheet), findsOneWidget);
          expect(find.text('Period Forecast & Preparedness'), findsOneWidget);
        },
      );

      testWidgets(
        '8. HomeScreen (TTC): tapping hero card opens TtcConceptionWindowSheet',
        (tester) async {
          tester.view.physicalSize = const Size(1080, 2400);
          tester.view.devicePixelRatio = 2.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          controller.setAppMode(AppMode.tryingToConceive);

          await tester.pumpWidget(
            buildTestable(
              const HomeScreen(initialMode: AppMode.tryingToConceive),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.byType(TtcHeroCycleCard), findsOneWidget);
          await tester.tap(find.byType(TtcHeroCycleCard));
          await tester.pumpAndSettle();

          expect(find.byType(TtcConceptionWindowSheet), findsOneWidget);
          expect(
            find.text('Fertile Window & Conception Timing'),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        '9. HomeScreen (TTC): tapping Best Days opens TtcFertilityChanceSheet',
        (tester) async {
          tester.view.physicalSize = const Size(1080, 2400);
          tester.view.devicePixelRatio = 2.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          controller.setAppMode(AppMode.tryingToConceive);

          await tester.pumpWidget(
            buildTestable(
              const HomeScreen(initialMode: AppMode.tryingToConceive),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.byType(DualMetricsRow), findsOneWidget);
          await tester.tap(find.text('Best Days to Try'));
          await tester.pumpAndSettle();

          expect(find.byType(TtcFertilityChanceSheet), findsOneWidget);
          expect(find.text('Today\'s Fertility Probability'), findsOneWidget);
        },
      );
    },
  );
}
