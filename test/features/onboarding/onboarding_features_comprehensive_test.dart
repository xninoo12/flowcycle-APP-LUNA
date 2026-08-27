import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/onboarding/onboarding_screen.dart';
import 'package:flowcycle/features/onboarding/widgets/onboarding_algorithm_calibration_card.dart';
import 'package:flowcycle/features/onboarding/widgets/onboarding_calendar_picker.dart';
import 'package:flowcycle/features/onboarding/widgets/onboarding_irregular_cycle_sheet.dart';
import 'package:flowcycle/features/onboarding/widgets/onboarding_why_we_ask_sheet.dart';
import 'package:flowcycle/shared/models/app_mode.dart';
import 'package:flowcycle/shared/providers/app_scope.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';
import 'package:flowcycle/shared/widgets/buttons/primary_button.dart';

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

  group('Onboarding Features & Data Pipeline Comprehensive Test Suite', () {
    testWidgets(
      '1. OnboardingWhyWeAskSheet: renders clinical rationale and privacy',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: OnboardingWhyWeAskSheet(step: 2)),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Why Last Period Start Date?'), findsOneWidget);
        expect(find.text('HOW WE USE THIS INFORMATION'), findsOneWidget);
        expect(
          find.textContaining('Your Last Menstrual Period (LMP) is Day 1'),
          findsOneWidget,
        );
        expect(
          find.textContaining('Your health data is encrypted'),
          findsOneWidget,
        );
        expect(find.text('Got it, thanks!'), findsOneWidget);
      },
    );

    testWidgets(
      '2. OnboardingIrregularCycleSheet: renders adaptation advice and baseline button',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        bool baselineApplied = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: OnboardingIrregularCycleSheet(
                onUseDefaultEstimate: () => baselineApplied = true,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Irregular or Uncertain Cycles'), findsOneWidget);
        expect(find.text('Dynamic Rolling Averages'), findsOneWidget);
        expect(find.text('Biomarker-Driven Ovulation'), findsOneWidget);
        expect(find.text('Use 28-Day Baseline & Continue'), findsOneWidget);

        await tester.tap(find.text('Use 28-Day Baseline & Continue'));
        await tester.pumpAndSettle();

        expect(baselineApplied, isTrue);
      },
    );

    testWidgets(
      '3. OnboardingAlgorithmCalibrationCard: renders 3-step setup and mode badge',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: OnboardingAlgorithmCalibrationCard(
                mode: AppMode.tryingToConceive,
                cycleLength: 30,
                periodDuration: 6,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('ALGORITHM CALIBRATION'), findsOneWidget);
        expect(find.text('Complete'), findsOneWidget);
        expect(find.text('30-day cycle • 6-day period'), findsOneWidget);
        expect(find.text('Conception & Ovulation Gauge'), findsOneWidget);
        expect(find.text('AI Companion & Insights'), findsOneWidget);
        expect(find.text('Trying to Conceive Mode Active'), findsOneWidget);
      },
    );

    testWidgets(
      '4. OnboardingCalendarPicker: quick date shortcuts trigger onDateSelected',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        DateTime? selected;
        bool notSureTapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: OnboardingCalendarPicker(
                selectedDate: null,
                onDateSelected: (d) => selected = d,
                onNotSureTap: () => notSureTapped = true,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Today'), findsOneWidget);
        expect(find.text('1 Week Ago'), findsOneWidget);
        expect(find.text('2 Weeks Ago'), findsOneWidget);
        expect(find.textContaining('Not Sure'), findsOneWidget);

        await tester.tap(find.text('Today'));
        await tester.pumpAndSettle();
        expect(selected != null, isTrue);

        await tester.tap(find.textContaining('Not Sure'));
        await tester.pumpAndSettle();
        expect(notSureTapped, isTrue);
      },
    );

    testWidgets(
      '5. Onboarding Full Pipeline: binds TTC data as initial app functioning state',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        bool completionTriggered = false;

        final testDate = DateTime.now().subtract(const Duration(days: 10));

        await tester.pumpWidget(
          buildTestable(
            OnboardingScreen(
              initialMode: AppMode.tryingToConceive,
              initialLastPeriod: testDate,
              initialCycleLength: 30,
              initialPeriodDuration: 6,
              initialTtcDuration: 'Less than 3 months',
              transitionDelay: const Duration(milliseconds: 100),
              onComplete: () => completionTriggered = true,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final continueBtn = find.widgetWithText(PrimaryButton, 'Continue');

        // Step 1 to Step 4
        for (int i = 0; i < 4; i++) {
          await tester.tap(continueBtn);
          await tester.pumpAndSettle();
        }

        // Step 5 -> Tap Continue to trigger completion
        await tester.tap(continueBtn);
        await tester.pump(const Duration(milliseconds: 50));

        // Verify completion view renders calibration
        expect(find.text("You're all set!"), findsOneWidget);
        expect(find.byType(OnboardingAlgorithmCalibrationCard), findsOneWidget);

        // Verify controller state is populated with Onboarding data as active initial state
        expect(controller.currentMode, AppMode.tryingToConceive);
        expect(controller.userProfile.averageCycleLength, 30);
        expect(controller.userProfile.typicalPeriodDuration, 6);
        expect(controller.userProfile.ttcDuration, 'Less than 3 months');
        expect(controller.userProfile.mode, AppMode.tryingToConceive);

        // Verify profile parameters are configured cleanly
        expect(controller.userProfile.lastPeriodStartDate, testDate);

        // Wait for transition delay
        await tester.pump(const Duration(milliseconds: 200));
        expect(completionTriggered, isTrue);
      },
    );

    testWidgets(
      '6. Onboarding Full Pipeline: binds Cycle Awareness data and multiple goals',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final testDate = DateTime.now().subtract(const Duration(days: 5));

        await tester.pumpWidget(
          buildTestable(
            OnboardingScreen(
              initialMode: AppMode.cycleAwareness,
              initialLastPeriod: testDate,
              initialCycleLength: 26,
              initialPeriodDuration: 4,
              initialCycleGoals: const [
                'Understand my cycle',
                'Track symptoms',
              ],
              transitionDelay: const Duration(milliseconds: 100),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final continueBtn = find.widgetWithText(PrimaryButton, 'Continue');

        // Step 1 to Step 4 progression
        for (int i = 0; i < 4; i++) {
          await tester.tap(continueBtn);
          await tester.pumpAndSettle();
        }

        // Step 5 -> Tap Continue
        await tester.tap(continueBtn);
        await tester.pump(const Duration(milliseconds: 50));

        expect(controller.currentMode, AppMode.cycleAwareness);
        expect(controller.userProfile.averageCycleLength, 26);
        expect(controller.userProfile.typicalPeriodDuration, 4);
        expect(
          controller.userProfile.cycleGoals.contains('Track symptoms'),
          isTrue,
        );
      },
    );
  });
}
