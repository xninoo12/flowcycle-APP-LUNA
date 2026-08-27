import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/router/route_names.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/flow_cycle_theme_extension.dart';
import '../../shared/providers/app_scope.dart';
import 'models/pattern_models.dart';
import 'widgets/bbt_thermal_curve_card.dart';
import 'widgets/clinical_report_export_sheet.dart';
import 'widgets/mood_energy_pattern_card.dart';
import 'widgets/symptom_correlation_card.dart';

class PatternsScreen extends StatefulWidget {
  const PatternsScreen({super.key});

  @override
  State<PatternsScreen> createState() => _PatternsScreenState();
}

class _PatternsScreenState extends State<PatternsScreen> {
  int _selectedHorizonIndex = 1; // 0: 3 Cycles, 1: 6 Cycles, 2: All Time

  final List<String> _horizonLabels = [
    'Past 3 Cycles',
    'Past 6 Cycles',
    'All Time',
  ];

  final List<SymptomPhaseCorrelation> _sampleCorrelations = const [
    SymptomPhaseCorrelation(
      symptomName: 'Uterine Cramps',
      icon: '⚡',
      themeColor: Color(0xFFFF5252),
      dominantPhase: 'Menstrual Phase',
      recurrencePercentage: 85,
      phaseDistribution: {
        'Menstrual': 0.85,
        'Follicular': 0.05,
        'Ovulatory': 0.02,
        'Luteal': 0.08,
      },
      clinicalInsight:
          'Correlates with uterine prostaglandin release on Days 1–3.',
    ),
    SymptomPhaseCorrelation(
      symptomName: 'Abdominal Bloating',
      icon: '🎈',
      themeColor: Color(0xFFF59E0B),
      dominantPhase: 'Luteal Phase',
      recurrencePercentage: 70,
      phaseDistribution: {
        'Menstrual': 0.25,
        'Follicular': 0.05,
        'Ovulatory': 0.10,
        'Luteal': 0.60,
      },
      clinicalInsight:
          'Linked to elevated progesterone causing slower digestion.',
    ),
    SymptomPhaseCorrelation(
      symptomName: 'Carb & Sweet Cravings',
      icon: '🍫',
      themeColor: Color(0xFF8B5CF6),
      dominantPhase: 'Late Luteal',
      recurrencePercentage: 80,
      phaseDistribution: {
        'Menstrual': 0.10,
        'Follicular': 0.05,
        'Ovulatory': 0.05,
        'Luteal': 0.80,
      },
      clinicalInsight:
          'Brain requests serotonin precursors as estrogen drops pre-period.',
    ),
    SymptomPhaseCorrelation(
      symptomName: 'Peak Vitality & Energy',
      icon: '✨',
      themeColor: Color(0xFF10B981),
      dominantPhase: 'Ovulatory Phase',
      recurrencePercentage: 75,
      phaseDistribution: {
        'Menstrual': 0.05,
        'Follicular': 0.40,
        'Ovulatory': 0.50,
        'Luteal': 0.05,
      },
      clinicalInsight: 'Estrogen surge peaks cognitive sharpness and stamina.',
    ),
  ];

  final List<BbtDataPoint> _sampleBbtPoints = const [
    BbtDataPoint(cycleDay: 1, temperature: 97.3),
    BbtDataPoint(cycleDay: 3, temperature: 97.4),
    BbtDataPoint(cycleDay: 5, temperature: 97.3),
    BbtDataPoint(cycleDay: 7, temperature: 97.4),
    BbtDataPoint(cycleDay: 9, temperature: 97.2),
    BbtDataPoint(cycleDay: 11, temperature: 97.4),
    BbtDataPoint(cycleDay: 13, temperature: 97.2), // Pre-ovulatory dip
    BbtDataPoint(cycleDay: 14, temperature: 97.5), // Ovulation
    BbtDataPoint(
      cycleDay: 15,
      temperature: 97.8,
      isPostOvulation: true,
    ), // Thermal shift
    BbtDataPoint(cycleDay: 17, temperature: 98.1, isPostOvulation: true),
    BbtDataPoint(cycleDay: 19, temperature: 98.3, isPostOvulation: true),
    BbtDataPoint(cycleDay: 21, temperature: 98.2, isPostOvulation: true),
    BbtDataPoint(cycleDay: 23, temperature: 98.4, isPostOvulation: true),
    BbtDataPoint(cycleDay: 25, temperature: 98.2, isPostOvulation: true),
    BbtDataPoint(cycleDay: 27, temperature: 97.9, isPostOvulation: true),
    BbtDataPoint(cycleDay: 28, temperature: 97.5, isPostOvulation: true),
  ];

  void _openDoctorExportSheet(BuildContext context) {
    final userProfile = AppScope.of(context).userProfile;
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final formattedDate = '${months[now.month - 1]} ${now.day}, ${now.year}';

    final summary = ClinicalReportSummary(
      patientName: userProfile.name,
      generatedDate: formattedDate,
      dateRange: _horizonLabels[_selectedHorizonIndex],
      totalCyclesAnalyzed: _selectedHorizonIndex == 0
          ? 3
          : (_selectedHorizonIndex == 1 ? 6 : 12),
      averageCycleLength: userProfile.averageCycleLength.toDouble(),
      cycleVariationDays: 1.2,
      averagePeriodDuration: userProfile.typicalPeriodDuration.toDouble(),
      biphasicShiftConfirmed: true,
      estimatedOvulationDay: (userProfile.averageCycleLength - 14).clamp(10, 20),
      topRecurringSymptoms: const [
        'Uterine Cramps (85%)',
        'Abdominal Bloating (70%)',
        'Carb Cravings (80%)',
        'High Energy (75%)',
      ],
      clinicalNotes:
          'Patient demonstrates consistent ovulatory cycles with robust luteal phase length (14 days) and classic biphasic thermal elevation. Symptom patterns are physiological and predictable.',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ClinicalReportExportSheet(summary: summary),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.flowTheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: theme.textPrimary,
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.homePath);
            }
          },
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                'Patterns & Biomarkers',
                style: AppTextStyles.title.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: const Color(0xFF1E1A3C),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            const Text('🔬', style: TextStyle(fontSize: 17)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.picture_as_pdf_outlined,
              color: Color(0xFF7C5CE7),
              size: 22,
            ),
            tooltip: 'Export Doctor Report',
            onPressed: () => _openDoctorExportSheet(context),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Horizon Selector Pill Row
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFE8F6),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Row(
                  children: List.generate(_horizonLabels.length, (index) {
                    final isSelected = _selectedHorizonIndex == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _selectedHorizonIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.06,
                                      ),
                                      blurRadius: 4.0,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              _horizonLabels[index],
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: isSelected
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: isSelected
                                    ? const Color(0xFF7C5CE7)
                                    : const Color(0xFF6E687A),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Overview Intelligence Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C5CE7), Color(0xFF9F7AEA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppRadius.large,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C5CE7).withValues(alpha: 0.25),
                      blurRadius: 12.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.insights_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Cycle Intelligence Detected',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'High Accuracy',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Your symptoms show 94% phase consistency. Progesterone and estrogen transitions occur on scheduled clinical intervals.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // 1. Symptom Correlation Matrix
              SymptomCorrelationCard(correlations: _sampleCorrelations),

              const SizedBox(height: AppSpacing.lg),

              // 2. Biphasic BBT Thermal Shift Curve
              BbtThermalCurveCard(bbtPoints: _sampleBbtPoints),

              const SizedBox(height: AppSpacing.lg),

              // 3. Mood & Energy Rhythm
              const MoodEnergyPatternCard(),

              const SizedBox(height: AppSpacing.lg),

              // 4. Clinical Export Button CTA
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.large,
                  border: Border.all(color: const Color(0xFFEAE2F3)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🩺', style: TextStyle(fontSize: 17)),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Visiting Your Doctor or Gynecologist?',
                            style: const TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E1A3C),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Export your complete cycle variance, BBT biphasic curve, and symptom recurrence history as a certified clinical summary.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.grey.shade600,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _openDoctorExportSheet(context),
                        icon: const Icon(
                          Icons.picture_as_pdf_rounded,
                          size: 16,
                        ),
                        label: const Text(
                          'Generate Physician Report 📄',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C5CE7),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
