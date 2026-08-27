import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/dashboard/home_screen.dart';
import 'package:flowcycle/features/dashboard/widgets/ai_companion_card.dart';
import 'package:flowcycle/features/dashboard/widgets/cycle_ring_card.dart';
import 'package:flowcycle/features/dashboard/widgets/dashboard_top_header.dart';
import 'package:flowcycle/features/dashboard/widgets/dual_metrics_row.dart';
import 'package:flowcycle/features/dashboard/widgets/mode_segmented_switcher.dart';
import 'package:flowcycle/features/dashboard/widgets/quick_log_action_strip.dart';
import 'package:flowcycle/features/dashboard/widgets/ttc/ttc_hero_cycle_card.dart';
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

  group('Cycle Awareness & Trying to Conceive Dashboards Tests', () {
    testWidgets(
      'Renders complete Cycle Awareness Dashboard layout and components',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        controller.setAppMode(AppMode.cycleAwareness);

        await tester.pumpWidget(
          buildTestable(
            const HomeScreen(initialMode: AppMode.cycleAwareness),
          ),
        );
        await tester.pumpAndSettle();

        // 1. Top Header with Avatar, Greeting, Notifications
        expect(find.byType(DashboardTopHeader), findsOneWidget);
        expect(find.text('Good morning, Amina'), findsOneWidget);
        expect(find.text('👋'), findsOneWidget);
        expect(find.text("You're in tune with your body ✨"), findsOneWidget);

        // 2. Compact Mode Switcher
        expect(find.byType(ModeSegmentedSwitcher), findsOneWidget);
        expect(find.text('Cycle Awareness'), findsOneWidget);
        expect(find.text('Trying to Conceive'), findsOneWidget);

        // 3. Hero Cycle Ring Dial (Floating in Open Space)
        expect(find.byType(CycleRingCard), findsOneWidget);
        expect(find.text("You're doing great ✨"), findsOneWidget);
        expect(find.text('Today'), findsOneWidget);
        expect(find.text('Period'), findsOneWidget);
        expect(find.text('Follicular'), findsOneWidget);
        expect(find.text('Fertile Window'), findsWidgets);
        expect(find.text('Ovulation'), findsOneWidget);
        expect(find.text('Luteal'), findsOneWidget);

        // 4. Dual Key-Metrics Row (Next Period + Fertile Window)
        expect(find.byType(DualMetricsRow), findsOneWidget);
        expect(find.text('Next Period'), findsOneWidget);

        // 5. 5-Button Quick Log Action Strip
        expect(find.byType(QuickLogActionStrip), findsOneWidget);
        expect(find.text('Quick Log'), findsOneWidget);
        expect(find.text('Edit'), findsOneWidget);
        expect(find.text('Flow'), findsOneWidget);
        expect(find.text('Mood'), findsOneWidget);
        expect(find.text('Symptoms'), findsOneWidget);
        expect(find.text('Sleep'), findsOneWidget);
        expect(find.text('Notes'), findsOneWidget);

        // 6. AI Insight Guidance Card
        expect(find.byType(AiCompanionCard), findsOneWidget);
        expect(find.text('AI Insight'), findsOneWidget);
        expect(find.text('Chat with AI Companion'), findsOneWidget);
      },
    );

    testWidgets(
      'Renders complete Trying to Conceive (TTC) Dashboard layout and components',
      (WidgetTester tester) async {
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

        // 1. Top Header with TTC Subtitle
        expect(find.byType(DashboardTopHeader), findsOneWidget);
        expect(find.text('Good morning, Amina'), findsOneWidget);
        expect(
          find.text("You're one step closer to your goal ✨"),
          findsOneWidget,
        );

        // 2. TTC Hero Conception Dial (Floating in Open Space)
        expect(find.byType(TtcHeroCycleCard), findsOneWidget);
        expect(find.text('Ovulation in'), findsOneWidget);
        expect(find.text('Period'), findsOneWidget);
        expect(find.text('Fertile Window'), findsOneWidget);
        expect(find.text('Ovulation'), findsWidgets);
        expect(find.text('Luteal Phase'), findsOneWidget);

        // 3. Dual Key-Metrics Row (Ovulation + Best Days to Try)
        expect(find.byType(DualMetricsRow), findsOneWidget);
        expect(find.text('Best Days to Try'), findsOneWidget);

        // 4. 5-Button TTC Quick Log Action Strip
        expect(find.byType(QuickLogActionStrip), findsOneWidget);
        expect(find.text('TTC Quick Log'), findsOneWidget);
        expect(find.text('Intercourse'), findsOneWidget);
        expect(find.text('LH Test'), findsOneWidget);
        expect(find.text('BBT'), findsOneWidget);
        expect(find.text('Cervical Mucus'), findsOneWidget);
        expect(find.text('Notes'), findsOneWidget);

        // 5. AI Fertility Guidance Card
        expect(find.byType(AiCompanionCard), findsOneWidget);
        expect(find.text('AI Fertility Guidance'), findsOneWidget);
        expect(find.text('Chat with AI Companion'), findsOneWidget);
      },
    );

    testWidgets(
      'Tapping Mode Switcher smoothly toggles between Cycle Awareness and TTC',
      (WidgetTester tester) async {
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
        expect(find.byType(TtcHeroCycleCard), findsNothing);

        // Tap Trying to Conceive
        await tester.tap(find.text('Trying to Conceive'));
        await tester.pumpAndSettle();

        expect(find.byType(TtcHeroCycleCard), findsOneWidget);
        expect(find.byType(CycleRingCard), findsNothing);

        // Tap back to Cycle Awareness
        await tester.tap(find.text('Cycle Awareness'));
        await tester.pumpAndSettle();

        expect(find.byType(CycleRingCard), findsOneWidget);
        expect(find.byType(TtcHeroCycleCard), findsNothing);
      },
    );
  });
}
