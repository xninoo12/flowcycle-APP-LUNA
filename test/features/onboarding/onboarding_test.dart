import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/onboarding/onboarding_screen.dart';
import 'package:flowcycle/features/onboarding/widgets/mode_selection_card.dart';
import 'package:flowcycle/features/onboarding/widgets/onboarding_calendar_picker.dart';
import 'package:flowcycle/features/onboarding/widgets/personalized_multi_select_card.dart';
import 'package:flowcycle/features/onboarding/widgets/personalized_single_select_card.dart';
import 'package:flowcycle/shared/models/app_mode.dart';
import 'package:flowcycle/shared/widgets/buttons/primary_button.dart';

void main() {
  group('Adaptive Onboarding - Full Flow Tests', () {
    testWidgets('Step 1: Goal Selection flow', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));
      await tester.pumpAndSettle();

      expect(find.textContaining("Let's personalize"), findsOneWidget);
      expect(find.textContaining("We'll tailor your experience"), findsOneWidget);
      expect(find.byType(ModeSelectionCard), findsNWidgets(2));

      // Continue starts disabled
      final continueButtonFinder = find.widgetWithText(
        PrimaryButton,
        'Continue',
      );
      final PrimaryButton initialBtn = tester.widget(continueButtonFinder);
      expect(initialBtn.onPressed, isNull);

      // Select Cycle Wellness
      await tester.tap(find.text('Cycle Wellness'));
      await tester.pumpAndSettle();

      final PrimaryButton activeBtn = tester.widget(continueButtonFinder);
      expect(activeBtn.onPressed, isNotNull);

      // Tap Continue -> Advance to Step 2
      await tester.tap(continueButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('When did your last period start?'), findsOneWidget);
      expect(find.byType(OnboardingCalendarPicker), findsOneWidget);
    });

    testWidgets('Step 2: Last Period Date selection and back navigation', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingScreen(initialMode: AppMode.tryingToConceive),
        ),
      );
      await tester.pumpAndSettle();

      // Advance from Step 1 to Step 2
      final continueButtonFinder = find.widgetWithText(
        PrimaryButton,
        'Continue',
      );
      await tester.tap(continueButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('When did your last period start?'), findsOneWidget);

      // Continue is disabled until a date is selected
      PrimaryButton step2Btn = tester.widget(continueButtonFinder);
      expect(step2Btn.onPressed, isNull);

      // Tap a valid date (day 1)
      await tester.tap(find.text('1').first);
      await tester.pumpAndSettle();

      step2Btn = tester.widget(continueButtonFinder);
      expect(step2Btn.onPressed, isNotNull);

      // Advance to Step 3
      await tester.tap(continueButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text("What's your average cycle length?"), findsOneWidget);
      expect(find.text('28'), findsOneWidget);
      expect(find.text('21 – 35 days'), findsOneWidget);
    });

    testWidgets(
      'Step 3 & Step 4: Numeric Stepper controls and value persistence',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            home: OnboardingScreen(
              initialMode: AppMode.cycleAwareness,
              initialLastPeriod: DateTime.now().subtract(
                const Duration(days: 5),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final continueButtonFinder = find.widgetWithText(
          PrimaryButton,
          'Continue',
        );

        // Step 1 -> Step 2
        await tester.tap(continueButtonFinder);
        await tester.pumpAndSettle();

        // Step 2 -> Step 3
        await tester.tap(continueButtonFinder);
        await tester.pumpAndSettle();

        expect(find.text("What's your average cycle length?"), findsOneWidget);
        expect(find.text('28'), findsOneWidget);

        // Increment cycle length to 29
        await tester.tap(find.byIcon(Icons.add_rounded));
        await tester.pumpAndSettle();
        expect(find.text('29'), findsOneWidget);

        // Step 3 -> Step 4
        await tester.tap(continueButtonFinder);
        await tester.pumpAndSettle();

        expect(
          find.text('How long does your period usually last?'),
          findsOneWidget,
        );
        expect(find.text('5'), findsOneWidget);
        expect(find.text('2 – 10 days'), findsOneWidget);

        // Decrement period duration to 4
        await tester.tap(find.byIcon(Icons.remove_rounded));
        await tester.pumpAndSettle();
        expect(find.text('4'), findsOneWidget);

        // Tap Back -> returns to Step 3 and verifies preserved value 29
        await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
        await tester.pumpAndSettle();

        expect(find.text("What's your average cycle length?"), findsOneWidget);
        expect(find.text('29'), findsOneWidget);
      },
    );

    testWidgets(
      'Step 5 (Branch 1 - TTC): Selection and automatic You\'re all set transition',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        bool completed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: OnboardingScreen(
              initialMode: AppMode.tryingToConceive,
              initialLastPeriod: DateTime.now().subtract(
                const Duration(days: 5),
              ),
              transitionDelay: const Duration(milliseconds: 50),
              onComplete: () {
                completed = true;
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        final continueButtonFinder = find.widgetWithText(
          PrimaryButton,
          'Continue',
        );

        // Step 1 -> Step 2
        await tester.tap(continueButtonFinder);
        await tester.pumpAndSettle();

        // Step 2 -> Step 3
        await tester.tap(continueButtonFinder);
        await tester.pumpAndSettle();

        // Step 3 -> Step 4
        await tester.tap(continueButtonFinder);
        await tester.pumpAndSettle();

        // Step 4 -> Step 5 (TTC branch)
        await tester.tap(continueButtonFinder);
        await tester.pumpAndSettle();

        expect(
          find.text('How long have you been trying to conceive?'),
          findsOneWidget,
        );
        expect(
          find.text('This helps us tailor insights for you.'),
          findsOneWidget,
        );
        expect(find.byType(PersonalizedSingleSelectCard), findsNWidgets(5));

        // Select '3–6 months'
        await tester.tap(find.text('3–6 months'));
        await tester.pumpAndSettle();

        // Tap Continue -> triggers "You're all set!" transition
        await tester.tap(continueButtonFinder);
        await tester.pump(const Duration(milliseconds: 10));

        expect(find.text("You're all set!"), findsOneWidget);
        expect(
          find.text('Your FlowCycle experience is ready.'),
          findsOneWidget,
        );

        await tester.pumpAndSettle(const Duration(milliseconds: 100));
        expect(completed, isTrue);
      },
    );

    testWidgets(
      'Step 5 (Branch 2 - Cycle Awareness): Multi-choice and completion transition',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        bool completed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: OnboardingScreen(
              initialMode: AppMode.cycleAwareness,
              initialLastPeriod: DateTime.now().subtract(
                const Duration(days: 5),
              ),
              transitionDelay: const Duration(milliseconds: 50),
              onComplete: () {
                completed = true;
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        final continueButtonFinder = find.widgetWithText(
          PrimaryButton,
          'Continue',
        );

        // Step 1 -> Step 2
        await tester.tap(continueButtonFinder);
        await tester.pumpAndSettle();

        // Step 2 -> Step 3
        await tester.tap(continueButtonFinder);
        await tester.pumpAndSettle();

        // Step 3 -> Step 4
        await tester.tap(continueButtonFinder);
        await tester.pumpAndSettle();

        // Step 4 -> Step 5 (Cycle Awareness branch)
        await tester.tap(continueButtonFinder);
        await tester.pumpAndSettle();

        expect(find.text('What would you like to focus on?'), findsOneWidget);
        expect(find.byType(PersonalizedMultiSelectCard), findsNWidgets(5));

        // Select 'Understand my cycle' and 'Predict my period'
        await tester.tap(find.text('Understand my cycle'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Predict my period'));
        await tester.pumpAndSettle();

        // Tap Continue -> triggers "You're all set!" transition
        await tester.tap(continueButtonFinder);
        await tester.pump(const Duration(milliseconds: 10));

        expect(find.text("You're all set!"), findsOneWidget);
        expect(
          find.text('Your FlowCycle experience is ready.'),
          findsOneWidget,
        );

        await tester.pumpAndSettle(const Duration(milliseconds: 100));
        expect(completed, isTrue);
      },
    );
  });
}
