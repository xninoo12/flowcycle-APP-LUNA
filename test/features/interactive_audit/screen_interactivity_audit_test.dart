import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/ai_companion/ai_companion_screen.dart';
import 'package:flowcycle/features/calendar/calendar_screen.dart';
import 'package:flowcycle/features/daily_log/daily_log_screen.dart';
import 'package:flowcycle/features/dashboard/home_screen.dart';
import 'package:flowcycle/features/dashboard/widgets/cycle_ring_card.dart';
import 'package:flowcycle/features/dashboard/widgets/ttc/ttc_hero_cycle_card.dart';
import 'package:flowcycle/features/insights/insights_screen.dart';
import 'package:flowcycle/features/onboarding/onboarding_screen.dart';
import 'package:flowcycle/features/profile/profile_screen.dart';
import 'package:flowcycle/features/splash/widgets/splash_action_area.dart';
import 'package:flowcycle/shared/models/app_mode.dart';
import 'package:flowcycle/shared/widgets/buttons/primary_button.dart';

void main() {
  group('Comprehensive Screen Interactivity Audit Tests', () {
    testWidgets('1. Splash Action Area Interactivity Audit', (
      WidgetTester tester,
    ) async {
      bool started = false;
      bool signedIn = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SplashActionArea(
              onGetStarted: () => started = true,
              onSignIn: () => signedIn = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Get Started'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);

      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();
      expect(started, isTrue);

      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      expect(signedIn, isTrue);
    });

    testWidgets(
      '2. Onboarding Flow Fine-Grained Controls Interactivity Audit',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));
        await tester.pumpAndSettle();

        final continueButtonFinder = find.widgetWithText(
          PrimaryButton,
          'Continue',
        );

        // Step 1: Goal Selection
        await tester.tap(find.text('Cycle Wellness'));
        await tester.pumpAndSettle();
        await tester.tap(continueButtonFinder);
        await tester.pumpAndSettle();

        // Step 2: Date Picker
        expect(find.text('When did your last period start?'), findsOneWidget);
        await tester.tap(find.text('1').first);
        await tester.pumpAndSettle();
        await tester.tap(continueButtonFinder);
        await tester.pumpAndSettle();

        // Step 3: Cycle Length Stepper
        expect(find.text("What's your average cycle length?"), findsOneWidget);
        expect(find.text('28'), findsOneWidget);
        await tester.tap(find.byIcon(Icons.add_rounded));
        await tester.pumpAndSettle();
        expect(find.text('29'), findsOneWidget);
        await tester.tap(continueButtonFinder);
        await tester.pumpAndSettle();

        // Step 4: Period Length Stepper
        expect(
          find.text('How long does your period usually last?'),
          findsOneWidget,
        );
        expect(find.text('5'), findsOneWidget);
        await tester.tap(find.byIcon(Icons.add_rounded));
        await tester.pumpAndSettle();
        expect(find.text('6'), findsOneWidget);
        await tester.tap(continueButtonFinder);
        await tester.pumpAndSettle();

        // Step 5: Multi-Choice Goal Selection
        expect(find.text('What would you like to focus on?'), findsOneWidget);
        await tester.tap(find.text('Understand my cycle'));
        await tester.pumpAndSettle();
      },
    );

    testWidgets('3. Home Dashboard Dual-Mode & Actions Interactivity Audit', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(initialMode: AppMode.cycleAwareness),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CycleRingCard), findsOneWidget);
      expect(find.byType(TtcHeroCycleCard), findsNothing);

      // Switch to Trying to Conceive
      await tester.tap(find.text('Trying to Conceive'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byType(TtcHeroCycleCard), findsOneWidget);
      expect(find.byType(CycleRingCard), findsNothing);

      // Switch back to Cycle Awareness
      await tester.tap(find.text('Cycle Awareness'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byType(CycleRingCard), findsOneWidget);
      expect(find.byType(TtcHeroCycleCard), findsNothing);
    });

    testWidgets('4. Calendar Day Selection & Timeframe Interactivity Audit', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: CalendarScreen()));
      await tester.pumpAndSettle();

      // Switch to Cycle Awareness
      await tester.tap(find.text('Cycle Awareness'), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Tap Today button in timeframe switcher
      await tester.tap(find.text('Today'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('May'), findsWidgets);
      expect(find.text('14'), findsWidgets);
    });

    testWidgets(
      '5. Insights Subscreens & Horizon Switcher Interactivity Audit',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const MaterialApp(home: InsightsScreen()));
        await tester.pumpAndSettle();

        // Scroll to and tap Trends Subscreen tab
        await tester.ensureVisible(find.text('Trends'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Trends'));
        await tester.pumpAndSettle();

        expect(find.text('Trends'), findsWidgets);

        // Tap 6 months horizon
        await tester.tap(find.text('6 months'));
        await tester.pumpAndSettle();

        // Tap Back to Overview
        await tester.tap(find.byIcon(Icons.chevron_left_rounded));
        await tester.pumpAndSettle();
        expect(find.text('Overview'), findsOneWidget);
      },
    );

    testWidgets(
      '6. Daily Log Modal Every Fine-Grained Option Interactivity Audit',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const MaterialApp(home: DailyLogScreen()));
        await tester.pumpAndSettle();

        // 1. Tap Mood (Great)
        await tester.tap(find.text('Great'));
        await tester.pumpAndSettle();

        // 2. Tap Flow (Medium)
        await tester.tap(find.text('Medium').first);
        await tester.pumpAndSettle();

        // 3. Toggle Symptoms (Headache, Acne)
        await tester.tap(find.text('Headache'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Acne'));
        await tester.pumpAndSettle();

        // 4. Tap Energy Level (High)
        await tester.tap(find.text('High'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // 5. Tap Save Today's Log
        final saveBtn = find.text("Save Today's Log");
        await tester.ensureVisible(saveBtn);
        await tester.pumpAndSettle();
        await tester.tap(saveBtn);
        await tester.pumpAndSettle();

        // Verify AI Cycle Harmony Post-Log View
        expect(find.textContaining('Log Recorded'), findsOneWidget);
        expect(find.text('AI Cycle Harmony & Wellness Analysis'), findsOneWidget);
        expect(find.text('Return to Dashboard'), findsOneWidget);
      },
    );

    testWidgets('7. AI Companion & Learning Hub Interactivity Audit', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: AiCompanionScreen()));
      await tester.pumpAndSettle();

      // Tap on Understanding Your Cycle wisdom card to open reader modal
      await tester.tap(find.textContaining('Understanding'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('AI Key Takeaways'), findsOneWidget);

      // Close modal
      await tester.tap(
        find.text('Ask AI About This Topic'),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
    });

    testWidgets(
      '8. Profile Screen Settings Toggles & Mode Selection Interactivity Audit',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
        await tester.pumpAndSettle();

        // 1. Current Mode toggle in metrics row
        await tester.tap(find.text('Current Mode'), warnIfMissed: false);
        await tester.pumpAndSettle();
        expect(find.byType(SnackBar), findsOneWidget);

        // 2. Open Passcode & Biometrics PIN Dialog
        await tester.tap(find.text('Passcode & Biometrics'), warnIfMissed: false);
        await tester.pumpAndSettle();
        expect(find.text('Set Up 4-Digit PIN'), findsOneWidget);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // 3. Open Rate FlowCycle Dialog
        await tester.tap(find.text('Rate FlowCycle'), warnIfMissed: false);
        await tester.pumpAndSettle();
        expect(find.text('Enjoying FlowCycle?'), findsOneWidget);
        await tester.tap(find.text('Maybe Later'));
        await tester.pumpAndSettle();
      },
    );
  });
}
