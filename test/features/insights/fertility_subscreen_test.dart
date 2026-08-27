import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/insights/fertility/fertility_subscreen.dart';
import 'package:flowcycle/features/insights/fertility/widgets/fertility_breakdown_card.dart';
import 'package:flowcycle/features/insights/fertility/widgets/fertility_factors_card.dart';
import 'package:flowcycle/features/insights/fertility/widgets/fertility_header.dart';
import 'package:flowcycle/features/insights/fertility/widgets/fertility_today_hero_card.dart';
import 'package:flowcycle/features/insights/insights_screen.dart';
import 'package:flowcycle/shared/models/user_profile.dart';
import 'package:flowcycle/shared/providers/app_scope.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';

void main() {
  group('Fertility Subscreen Tests', () {
    testWidgets(
      'Renders all Fertility subscreen components with exact visual fidelity',
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
            child: const MaterialApp(home: FertilitySubscreen()),
          ),
        );
        await tester.pumpAndSettle();

        // 1. Header
        expect(find.byType(FertilityHeader), findsOneWidget);
        expect(find.text('Fertility'), findsOneWidget);
        expect(
          find.text('Understand your fertile window'),
          findsOneWidget,
        );

        // 2. Today Hero Card (Right-aligned ring)
        expect(find.byType(FertilityTodayHeroCard), findsOneWidget);
        expect(find.text('Fertility chance'), findsOneWidget);
        expect(find.text('Today'), findsOneWidget);
        expect(find.text('Fertile window'), findsOneWidget);
        expect(find.text('Next period expected'), findsOneWidget);

        // 3. Fertility Breakdown Card
        expect(find.byType(FertilityBreakdownCard), findsOneWidget);
        expect(find.text('Fertility breakdown'), findsOneWidget);
        expect(find.text('Low (0–29%)'), findsOneWidget);
        expect(find.text('High (30–69%)'), findsOneWidget);
        expect(find.text('Very high (70–89%)'), findsOneWidget);
        expect(find.text('Peak (90–100%)'), findsOneWidget);

        // 4. What increases your chances Card
        expect(find.byType(FertilityFactorsCard), findsOneWidget);
        expect(find.text('What increases your chances'), findsOneWidget);
        expect(find.text('Have sex'), findsOneWidget);
        expect(find.text('Every 1–2 days'), findsOneWidget);
        expect(find.text('Get good sleep'), findsOneWidget);
        expect(find.text('7–9 hours'), findsOneWidget);
        expect(find.text('Manage stress'), findsOneWidget);
        expect(find.text('Daily relaxation'), findsOneWidget);
        expect(find.text('Stay hydrated'), findsOneWidget);
        expect(find.text('8 cups a day'), findsOneWidget);
      },
    );

    testWidgets(
      'Tapping Fertility tab in Insights transitions to Fertility subscreen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const MaterialApp(home: InsightsScreen()));
        await tester.pumpAndSettle();

        expect(find.byType(FertilitySubscreen), findsNothing);

        // Tap on Fertility tab
        await tester.tap(find.text('Fertility'));
        await tester.pumpAndSettle();

        expect(find.byType(FertilitySubscreen), findsOneWidget);

        // Tap back chevron in FertilitySubscreen -> returns to Insights Overview
        await tester.tap(find.byIcon(Icons.chevron_left_rounded));
        await tester.pumpAndSettle();

        expect(find.byType(FertilitySubscreen), findsNothing);
        expect(find.text('Your current cycle'), findsOneWidget);
      },
    );
  });
}
