import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/daily_log/daily_log_screen.dart';
import 'package:flowcycle/features/daily_log/widgets/bbt_temperature_field.dart';
import 'package:flowcycle/features/daily_log/widgets/cervical_mucus_selector.dart';
import 'package:flowcycle/features/daily_log/widgets/intimacy_section.dart';
import 'package:flowcycle/features/daily_log/widgets/lh_and_pregnancy_test_section.dart';
import 'package:flowcycle/features/daily_log/widgets/log_insights_analysis_sheet.dart';
import 'package:flowcycle/features/daily_log/widgets/nutrition_and_cravings_section.dart';
import 'package:flowcycle/features/daily_log/widgets/self_care_section.dart';
import 'package:flowcycle/features/daily_log/widgets/symptom_glossary_sheet.dart';
import 'package:flowcycle/features/daily_log/widgets/symptoms_chips_selector.dart';
import 'package:flowcycle/features/daily_log/widgets/workout_chips_selector.dart';
import 'package:flowcycle/shared/models/app_mode.dart';
import 'package:flowcycle/shared/models/daily_log_entry.dart';
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

  group('Daily Log Dual-Mode Features & Clinical Selectors Suite', () {
    testWidgets(
      '1. CervicalMucusSelector: renders 5 fluid states & fires callback',
      (tester) async {
        String selected = 'Creamy';
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CervicalMucusSelector(
                selectedMucus: selected,
                onMucusChanged: (val) => selected = val,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Cervical Fluid / Mucus'), findsOneWidget);
        expect(find.text('Dry / None'), findsOneWidget);
        expect(find.text('Sticky'), findsOneWidget);
        expect(find.text('Creamy'), findsOneWidget);
        expect(find.text('Egg-white'), findsOneWidget);
        expect(find.text('Watery'), findsOneWidget);

        await tester.tap(find.text('Egg-white'));
        expect(selected, 'Egg-white');
      },
    );

    testWidgets(
      '2. BbtTemperatureField: steppers increment/decrement properly',
      (tester) async {
        double? temp = 97.8;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (ctx, setState) => BbtTemperatureField(
                  temperature: temp,
                  onTemperatureChanged: (val) => setState(() => temp = val),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Basal Body Temperature (BBT)'), findsOneWidget);
        expect(find.text('97.8 °F'), findsOneWidget);
        expect(find.text('Baseline Follicular'), findsOneWidget);

        // Tap + button 5 times to trigger thermal shift
        for (int i = 0; i < 5; i++) {
          await tester.tap(find.byIcon(Icons.add_circle_outline_rounded));
          await tester.pumpAndSettle();
        }
        expect(find.text('98.3 °F'), findsOneWidget);
        expect(find.text('Thermal Shift ☀️'), findsOneWidget);
      },
    );

    testWidgets('3. LhAndPregnancyTestSection: choices select accurately', (
      tester,
    ) async {
      String lh = 'Negative';
      String hcg = 'Not Tested';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LhAndPregnancyTestSection(
              lhResult: lh,
              hcgResult: hcg,
              onLhChanged: (val) => lh = val,
              onHcgChanged: (val) => hcg = val,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Ovulation Test (LH Strip)'), findsOneWidget);
      expect(find.text('Pregnancy Test (HCG)'), findsOneWidget);

      await tester.tap(find.text('Peak Surge ➕'));
      expect(lh, 'Peak Surge ➕');

      await tester.tap(find.text('Positive 🤰'));
      expect(hcg, 'Positive 🤰');
    });

    testWidgets('4. IntimacySection: updates intimacy status & supplements', (
      tester,
    ) async {
      String intimacy = 'None';
      Set<String> supplements = {'Prenatal Vitamin'};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IntimacySection(
              intimacyStatus: intimacy,
              selectedSupplements: supplements,
              onIntimacyChanged: (val) => intimacy = val,
              onToggleSupplement: (sup) {
                if (supplements.contains(sup)) {
                  supplements.remove(sup);
                } else {
                  supplements.add(sup);
                }
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Intimacy & Timing'), findsOneWidget);
      expect(find.text('Fertility Supplements'), findsOneWidget);

      await tester.tap(find.text('Unprotected (Trying) 💕'));
      expect(intimacy, 'Unprotected (Trying) 💕');

      await tester.tap(find.text('CoQ10'));
      expect(supplements.contains('CoQ10'), isTrue);
    });

    testWidgets('5. WorkoutChipsSelector: cycle-synced workouts selection', (
      tester,
    ) async {
      String workout = 'Yoga / Stretch';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WorkoutChipsSelector(
              selectedWorkout: workout,
              onWorkoutChanged: (val) => workout = val,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Cycle-Synced Workout & Movement'), findsOneWidget);
      expect(find.text('HIIT / Strength'), findsOneWidget);

      await tester.tap(find.text('Pilates'));
      expect(workout, 'Pilates');
    });

    testWidgets(
      '6. NutritionAndCravingsSection: water glasses & cravings chips',
      (tester) async {
        int water = 6;
        Set<String> cravings = {};

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (ctx, setState) => NutritionAndCravingsSection(
                  waterGlasses: water,
                  selectedCravings: cravings,
                  onWaterChanged: (val) => setState(() => water = val),
                  onToggleCraving: (crav) => setState(() => cravings.add(crav)),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Hydration (Water Intake)'), findsOneWidget);
        expect(find.text('6 glasses'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.add_circle_outline_rounded));
        await tester.pumpAndSettle();
        expect(find.text('7 glasses'), findsOneWidget);

        await tester.tap(find.text('Chocolate / Sweets 🍫'));
        await tester.pumpAndSettle();
        expect(cravings.contains('Chocolate / Sweets 🍫'), isTrue);
      },
    );

    testWidgets('7. SelfCareSection: mindfulness chips toggle accurately', (
      tester,
    ) async {
      Set<String> selfCare = {'Meditation / Breathwork 🧘'};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelfCareSection(
              selectedSelfCare: selfCare,
              onToggleSelfCare: (item) {
                if (selfCare.contains(item)) {
                  selfCare.remove(item);
                } else {
                  selfCare.add(item);
                }
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Self-Care & Mindfulness'), findsOneWidget);
      expect(find.text('Meditation / Breathwork 🧘'), findsOneWidget);

      await tester.tap(find.text('Warm Bath / Rest 🛁'));
      expect(selfCare.contains('Warm Bath / Rest 🛁'), isTrue);
    });

    testWidgets(
      '8. SymptomsChipsSelector: includes categorized + custom symptom adder',
      (tester) async {
        Set<String> symptoms = {'Cramps'};

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (ctx, setState) => SymptomsChipsSelector(
                  selectedSymptoms: symptoms,
                  onToggleSymptom: (sym) => setState(() => symptoms.add(sym)),
                  onAddCustomSymptom: (newSym) =>
                      setState(() => symptoms.add(newSym)),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Symptoms & Biomarkers'), findsOneWidget);
        expect(find.text('Cramps'), findsOneWidget);
        expect(find.text('Custom'), findsOneWidget);

        // Open custom symptom dialog
        await tester.tap(find.text('Custom'));
        await tester.pumpAndSettle();
        expect(find.text('Add Custom Symptom'), findsOneWidget);

        await tester.enterText(find.byType(TextField), 'Ovarian Flutter');
        await tester.tap(find.text('Add'));
        await tester.pumpAndSettle();

        expect(symptoms.contains('Ovarian Flutter'), isTrue);
        expect(find.text('Ovarian Flutter'), findsOneWidget);
      },
    );

    testWidgets('9. LogInsightsAnalysisSheet: renders AI log interpretation', (
      tester,
    ) async {
      final entry = DailyLogEntry(
        date: DateTime.now(),
        mood: 'Great',
        flow: 'Spotting',
        cervicalMucus: 'Egg-white',
        bbtTemperature: 97.4,
        lhTestResult: 'Peak Surge ➕',
        symptoms: const ['Ovulation Twinge', 'High Libido'],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LogInsightsAnalysisSheet(
              entry: entry,
              mode: AppMode.tryingToConceive,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('AI Conception & Biomarker Analysis'), findsOneWidget);
      expect(find.text('🎯 Peak Conception Window Active'), findsOneWidget);
      expect(find.text('Egg-white'), findsOneWidget);
      expect(find.text('97.4°F'), findsOneWidget);
      expect(find.text("Ask AI About Today's Log ✦"), findsOneWidget);
    });

    testWidgets('10. SymptomGlossarySheet: search filters glossary items', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SymptomGlossarySheet())),
      );
      await tester.pumpAndSettle();

      expect(find.text('Symptom & Biomarker Guide'), findsOneWidget);
      expect(
        find.text('Egg-white Cervical Mucus (Spinnbarkeit)'),
        findsOneWidget,
      );

      // Search for mastalgia
      await tester.enterText(find.byType(TextField), 'Mastalgia');
      await tester.pumpAndSettle();

      expect(find.text('Breast Tenderness (Mastalgia)'), findsOneWidget);
      expect(
        find.text('Egg-white Cervical Mucus (Spinnbarkeit)'),
        findsNothing,
      );
    });

    testWidgets(
      '11. DailyLogScreen TTC Mode: renders TTC fields & saves reactive log',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        controller.setAppMode(AppMode.tryingToConceive);

        await tester.pumpWidget(buildTestable(const DailyLogScreen()));
        await tester.pumpAndSettle();

        expect(
          find.text('Trying to Conceive Mode • Peak Fertile Tracking'),
          findsOneWidget,
        );
        expect(find.text('Cervical Fluid / Mucus'), findsOneWidget);
        expect(find.text('Basal Body Temperature (BBT)'), findsOneWidget);
        expect(find.text('Ovulation Test (LH Strip)'), findsOneWidget);
        expect(find.text('Intimacy & Timing'), findsOneWidget);
        expect(find.text('Personal Notes & Reflections'), findsOneWidget);

        // Scroll to Save button and tap
        final saveBtn = find.text('Save Log');
        await tester.scrollUntilVisible(
          saveBtn,
          200,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(saveBtn);
        await tester.pumpAndSettle();

        expect(find.text('All Set!'), findsOneWidget);
      },
    );

    testWidgets(
      '12. DailyLogScreen Cycle Awareness Mode: renders holistic fields',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        controller.setAppMode(AppMode.cycleAwareness);

        await tester.pumpWidget(buildTestable(const DailyLogScreen()));
        await tester.pumpAndSettle();

        expect(
          find.text('Cycle Awareness Mode • Daily Energy & Syncing'),
          findsOneWidget,
        );
        expect(find.text('Cycle-Synced Workout & Movement'), findsOneWidget);
        expect(find.text('Hydration (Water Intake)'), findsOneWidget);
        expect(find.text('Food Cravings & Appetite'), findsOneWidget);
        expect(find.text('Self-Care & Mindfulness'), findsOneWidget);

        // Scroll to Save button and tap
        final saveBtn = find.text('Save Log');
        await tester.scrollUntilVisible(
          saveBtn,
          200,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(saveBtn);
        await tester.pumpAndSettle();

        expect(find.text('All Set!'), findsOneWidget);
      },
    );
  });
}
