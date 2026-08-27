import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/patterns/patterns_screen.dart';
import 'package:flowcycle/features/patterns/widgets/bbt_thermal_curve_card.dart';
import 'package:flowcycle/features/patterns/widgets/clinical_report_export_sheet.dart';
import 'package:flowcycle/features/patterns/widgets/mood_energy_pattern_card.dart';
import 'package:flowcycle/features/patterns/widgets/symptom_correlation_card.dart';
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

  group('Patterns Screen & Clinical Intelligence Test Suite', () {
    testWidgets(
      '1. Renders PatternsScreen with all subcomponents and high visual fidelity',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(buildTestable(const PatternsScreen()));
        await tester.pumpAndSettle();

        // Top title and icon
        expect(find.text('Patterns & Biomarkers'), findsOneWidget);
        expect(find.text('🔬'), findsOneWidget);

        // Horizon selector
        expect(find.text('Past 3 Cycles'), findsOneWidget);
        expect(find.text('Past 6 Cycles'), findsOneWidget);
        expect(find.text('All Time'), findsOneWidget);

        // Cards
        expect(find.byType(SymptomCorrelationCard), findsOneWidget);
        expect(find.byType(BbtThermalCurveCard), findsOneWidget);
        expect(find.byType(MoodEnergyPatternCard), findsOneWidget);

        // Card details
        expect(find.text('Symptom Correlation Matrix'), findsOneWidget);
        expect(find.text('Uterine Cramps'), findsOneWidget);
        expect(find.text('Biphasic BBT Thermal Shift'), findsOneWidget);
        expect(find.text('Ovulation Confirmed'), findsOneWidget);
        expect(find.text('Mood & Energy Rhythm'), findsOneWidget);
        expect(find.text('Generate Physician Report 📄'), findsOneWidget);

        // Tap 3 Cycles Horizon
        await tester.tap(find.text('Past 3 Cycles'));
        await tester.pumpAndSettle();

        // Tap All Time Horizon
        await tester.tap(find.text('All Time'));
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      '2. Opens Doctor & OB-GYN Clinical Export Sheet and interacts with export actions',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(buildTestable(const PatternsScreen()));
        await tester.pumpAndSettle();

        // Tap Top PDF Action
        await tester.tap(find.byIcon(Icons.picture_as_pdf_outlined));
        await tester.pumpAndSettle();

        expect(find.byType(ClinicalReportExportSheet), findsOneWidget);
        expect(find.text('Doctor / OB-GYN Summary'), findsOneWidget);
        expect(find.text('CLINICAL BIOMARKERS'), findsOneWidget);
        expect(find.text('Average Cycle Length'), findsOneWidget);
        expect(find.text('Copy Text'), findsOneWidget);
        expect(find.text('Download PDF Report'), findsOneWidget);

        // Copy Text summary
        await tester.tap(find.text('Copy Text'));
        await tester.pumpAndSettle();
        expect(
          find.text('📋 Clinical Summary copied to clipboard!'),
          findsOneWidget,
        );

        ScaffoldMessenger.of(
          tester.element(find.byType(PatternsScreen)),
        ).clearSnackBars();
        await tester.pumpAndSettle();

        // Download PDF
        await tester.tap(find.text('Download PDF Report'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();
        expect(
          find.text('📄 Clinical PDF Report generated successfully!'),
          findsOneWidget,
        );
      },
    );
  });
}
