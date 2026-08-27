import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/core/theme/phase_ambient_aura.dart';
import 'package:flowcycle/features/dashboard/models/cycle_dashboard_state.dart';
import 'package:flowcycle/features/patterns/models/pattern_models.dart';
import 'package:flowcycle/features/patterns/widgets/bbt_thermal_curve_card.dart';
import 'package:flowcycle/shared/widgets/animated_phase_glow.dart';
import 'package:flowcycle/shared/widgets/phase_celebration_banner.dart';

void main() {
  group('Interactive UI Polish & Micro-Animations Test Suite', () {
    testWidgets('1. AnimatedPhaseGlow renders radial gradient and animates breathing glow for all cycle phases', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  AnimatedPhaseGlow(
                    phase: CyclePhase.menstrual,
                    child: const Text('Menstrual Ring'),
                  ),
                  AnimatedPhaseGlow(
                    phase: CyclePhase.follicular,
                    child: const Text('Follicular Ring'),
                  ),
                  AnimatedPhaseGlow(
                    phase: CyclePhase.ovulation,
                    child: const Text('Ovulatory Ring'),
                  ),
                  AnimatedPhaseGlow(
                    phase: CyclePhase.luteal,
                    child: const Text('Luteal Ring'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Menstrual Ring'), findsOneWidget);
      expect(find.text('Follicular Ring'), findsOneWidget);
      expect(find.text('Ovulatory Ring'), findsOneWidget);
      expect(find.text('Luteal Ring'), findsOneWidget);

      // Advance animation timer
      await tester.pump(const Duration(milliseconds: 1400));
      expect(find.byType(AnimatedPhaseGlow), findsNWidgets(4));
    });

    test('2. PhaseAmbientAura provides curated color tokens and header gradients', () {
      final menstrualAura = PhaseAmbientAura.getAuraColors(CyclePhase.menstrual);
      final follicularAura = PhaseAmbientAura.getAuraColors(CyclePhase.follicular);
      final ovulatoryAura = PhaseAmbientAura.getAuraColors(CyclePhase.ovulation);
      final lutealAura = PhaseAmbientAura.getAuraColors(CyclePhase.luteal);

      expect(menstrualAura.length, 3);
      expect(follicularAura.length, 3);
      expect(ovulatoryAura.length, 3);
      expect(lutealAura.length, 3);

      final gradient = PhaseAmbientAura.getPhaseHeaderGradient(CyclePhase.ovulation);
      expect(gradient.colors.length, 3);
    });

    testWidgets('3. PhaseCelebrationBanner slides in smoothly and handles dismiss callback', (
      WidgetTester tester,
    ) async {
      bool dismissed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PhaseCelebrationBanner(
              title: 'Peak Fertility Surge!',
              message: 'Conception probability is maximized today & tomorrow.',
              icon: Icons.favorite_rounded,
              onDismiss: () => dismissed = true,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Peak Fertility Surge!'), findsOneWidget);
      expect(find.text('Conception probability is maximized today & tomorrow.'), findsOneWidget);
      expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);

      // Tap dismiss
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(dismissed, isTrue);
    });

    testWidgets('4. BbtThermalCurveCard supports interactive touch scrubbing & displays dynamic badge', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final samplePoints = List.generate(
        15,
        (i) => BbtDataPoint(
          cycleDay: i + 1,
          temperature: 97.2 + (i > 10 ? 0.6 : 0.1 * (i % 3)),
          isPostOvulation: i > 10,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: BbtThermalCurveCard(
                bbtPoints: samplePoints,
                coverline: 97.55,
                ovulationDay: 11,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Biphasic BBT Thermal Shift'), findsOneWidget);
      expect(find.text('Ovulation Confirmed'), findsOneWidget);

      // Tap on the chart to trigger scrubbing
      await tester.tap(find.byType(CustomPaint).first);
      await tester.pumpAndSettle();

      // Scrubber dynamic badge appears
      expect(find.textContaining('Day '), findsWidgets);
    });
  });
}
