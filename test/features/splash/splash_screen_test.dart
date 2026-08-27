import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/splash/splash_screen.dart';
import 'package:flowcycle/features/splash/widgets/lotus_petal_pulse.dart';
import 'package:flowcycle/features/splash/widgets/splash_action_area.dart';
import 'package:flowcycle/features/splash/widgets/splash_branding.dart';
import 'package:flowcycle/features/splash/widgets/splash_breathing_aura.dart';
import 'package:flowcycle/features/splash/widgets/splash_feature_cards.dart';
import 'package:flowcycle/features/splash/widgets/splash_hero_visual.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Splash & Welcome Screen Redesign Test Suite', () {
    testWidgets('1. LotusPetalPulse animates breathing and shimmering petal glows without error',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: LotusPetalPulse(flowerSize: 40.0),
            ),
          ),
        ),
      );

      expect(find.byType(LotusPetalPulse), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);

      // Animate frame forward
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 1200));
    });

    testWidgets('2. SplashBreathingAura renders custom canvas floating petals',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SplashBreathingAura(
                size: 200.0,
                child: Icon(Icons.spa),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SplashBreathingAura), findsOneWidget);
      expect(find.byIcon(Icons.spa), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 800));
    });

    testWidgets('3. SplashHeroVisual renders seamless hero with lotus pulse',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SplashHeroVisual(maxHeight: 280.0),
            ),
          ),
        ),
      );

      expect(find.byType(SplashHeroVisual), findsOneWidget);
      expect(find.byType(LotusPetalPulse), findsOneWidget);
      expect(find.byType(SplashBreathingAura), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 300));
    });

    testWidgets('4. SplashBranding renders FlowCycle typography, tagline & platform sub-brand',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SplashBranding(),
            ),
          ),
        ),
      );

      expect(find.text('AI HEALTH PLATFORM'), findsOneWidget);
      expect(find.text('Understand. Track. Thrive.'), findsOneWidget);
      expect(find.text('A personalized wellness companion\nfor your cycle & fertility'), findsOneWidget);
    });

    testWidgets('5. SplashFeatureCards renders 3 core feature pillars',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SplashFeatureCards(),
            ),
          ),
        ),
      );

      expect(find.text('Track'), findsOneWidget);
      expect(find.text('Your cycle'), findsOneWidget);
      expect(find.text('Predict'), findsOneWidget);
      expect(find.text('Your patterns'), findsOneWidget);
      expect(find.text('Feel in Control'), findsOneWidget);
      expect(find.text('Every day'), findsOneWidget);
    });

    testWidgets('6. SplashActionArea renders Get Started, Sign In, and Privacy Lock',
        (tester) async {
      bool getStartedTapped = false;
      bool signInTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SplashActionArea(
                onGetStarted: () => getStartedTapped = true,
                onSignIn: () => signInTapped = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Get Started'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Your data is private and secure.'), findsOneWidget);
      expect(find.byIcon(Icons.lock_rounded), findsOneWidget);

      await tester.tap(find.text('Get Started'));
      expect(getStartedTapped, isTrue);

      await tester.tap(find.text('Sign In'));
      expect(signInTapped, isTrue);
    });

    testWidgets('7. SplashScreen renders complete layout smoothly and responds without overflow',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: SplashScreen(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));

      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.byType(SplashHeroVisual), findsOneWidget);
      expect(find.byType(SplashBranding), findsOneWidget);
      expect(find.byType(SplashFeatureCards), findsOneWidget);
      expect(find.byType(SplashActionArea), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
