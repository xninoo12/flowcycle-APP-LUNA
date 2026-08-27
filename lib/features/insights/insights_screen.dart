import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_names.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/models/app_mode.dart';
import '../../shared/providers/app_scope.dart';
import 'cycles/cycles_subscreen.dart';
import 'cycles/widgets/phase_detail_sheet.dart';
import 'fertility/fertility_subscreen.dart';
import 'trends/trends_subscreen.dart';
import 'widgets/current_cycle_hero_card.dart';
import 'widgets/cycle_highlights_detail_sheet.dart';
import 'widgets/cycle_highlights_row.dart';
import 'widgets/fertility_year_chart_card.dart';
import 'widgets/insights_category_tabs.dart';
import 'widgets/insights_header.dart';
import 'widgets/intercourse_and_symptoms_row.dart';

/// Insights Main Screen for FlowCycle.
///
/// Features AI-driven analytics adaptable across both Cycle Awareness
/// and Trying to Conceive (TTC) modes with category tab switching to
/// dedicated subscreens (like Cycles, Fertility, and Trends subscreens).
class InsightsScreen extends StatefulWidget {
  final AppMode currentMode;
  final String initialCategoryTabId;

  const InsightsScreen({
    super.key,
    this.currentMode = AppMode.tryingToConceive,
    this.initialCategoryTabId = 'overview',
  });

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  late String _selectedCategoryTabId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryTabId = widget.initialCategoryTabId;
  }

  void _handleCategoryTabSelected(String tabId) {
    setState(() {
      _selectedCategoryTabId = tabId;
    });
  }

  void _openHighlightsDetail({
    required int avgCycleLength,
    required int avgPeriodLength,
    required String avgOvulationDay,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CycleHighlightsDetailSheet(
        avgCycleLength: avgCycleLength,
        avgPeriodLength: avgPeriodLength,
        avgOvulationDay: avgOvulationDay,
      ),
    );
  }

  void _openPhaseDetail(String phaseName) {
    String dayRange = 'Days 14–16';
    String emoji = '💧';
    Color color = const Color(0xFF8B5CF6);
    String hormone = 'LH (Luteinizing Hormone) surge triggers egg release.';
    String signals =
        'Stretchy clear cervical mucus, mild unilateral pelvic twinge (Mittelschmerz), heightened libido.';
    List<String> tips = [
      'Optimal timing for intercourse if trying to conceive.',
      'Stay hydrated to support fertile cervical mucus production.',
      'Moderate aerobic exercise and light yoga.',
    ];

    if (phaseName == 'Period') {
      dayRange = 'Days 1–5';
      emoji = '🩸';
      color = const Color(0xFFE84855);
      hormone =
          'Estrogen and progesterone drop to baseline as endometrium sheds.';
      signals =
          'Menstrual flow, mild lower back tension, lower energy baseline.';
      tips = [
        'Prioritize warm, iron-rich foods (lentils, spinach, broth).',
        'Gentle restorative movement or stretching.',
        'Target 8+ hours of deep, restful sleep.',
      ];
    } else if (phaseName == 'Follicular') {
      dayRange = 'Days 6–13';
      emoji = '🌱';
      color = const Color(0xFF10B981);
      hormone =
          'FSH stimulates follicle growth; estradiol climbs steadily toward peak.';
      signals = 'Surging physical energy, elevated mental focus, lighter mood.';
      tips = [
        'Incorporate high-intensity interval training or strength work.',
        'Complex carbs and fresh cruciferous vegetables.',
        'Great time for creative problem-solving and social engagements.',
      ];
    } else if (phaseName == 'Luteal') {
      dayRange = 'Days 15–28';
      emoji = '🛡️';
      color = const Color(0xFFF59E0B);
      hormone =
          'Corpus luteum secretes progesterone to thicken endometrium and calm the uterus.';
      signals =
          'Basal body temperature rises 0.5–1.0°F, appetite increases slightly, calmer demeanor.';
      tips = [
        'Magnesium and vitamin B6 to support progesterone synthesis.',
        'Moderate-intensity workouts (Pilates, brisk walking).',
        'Limit caffeine to support adrenal stability.',
      ];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PhaseDetailSheet(
        phaseName: phaseName,
        dayRange: dayRange,
        emoji: emoji,
        themeColor: color,
        hormoneOverview: hormone,
        bodySignals: signals,
        wellnessTips: tips,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If Cycles subscreen tab is selected, show CyclesSubscreen
    if (_selectedCategoryTabId == 'cycles') {
      return CyclesSubscreen(
        onBack: () {
          setState(() {
            _selectedCategoryTabId = 'overview';
          });
        },
      );
    }

    // If Fertility subscreen tab is selected, show FertilitySubscreen
    if (_selectedCategoryTabId == 'fertility') {
      return FertilitySubscreen(
        onBack: () {
          setState(() {
            _selectedCategoryTabId = 'overview';
          });
        },
      );
    }

    // If Trends subscreen tab is selected, show TrendsSubscreen
    if (_selectedCategoryTabId == 'trends') {
      return TrendsSubscreen(
        onBack: () {
          setState(() {
            _selectedCategoryTabId = 'overview';
          });
        },
      );
    }

    final controller = AppScope.of(context);
    final userProfile = controller.userProfile;
    final cycleState = controller.calculateCurrentCycleState();
    final totalDays = cycleState.totalDays;
    final currentCycleDay = cycleState.currentDay;

    // Compute dynamic cycle statistics
    final logEntries = controller.logEntries;
    final cycleLogs = logEntries.values.where((entry) =>
      entry.date.isAfter(userProfile.lastPeriodStartDate.subtract(const Duration(days: 1))) &&
      entry.date.isBefore(userProfile.lastPeriodStartDate.add(Duration(days: totalDays + 1)))
    ).toList();
    final loggedIntercourse = cycleLogs.where((l) => l.intercourse == true).length;
    final displayIntercourse = loggedIntercourse;

    final loggedDaysCount = cycleLogs.length;
    final int displayConsistency = currentCycleDay > 0
        ? ((loggedDaysCount / currentCycleDay) * 100).clamp(0, 100).toInt()
        : 0;

    final todayLog = controller.getLogForDate(DateTime.now());
    final symptomsSummary = todayLog?.symptoms.isNotEmpty == true
        ? todayLog!.symptoms.first
        : (todayLog != null ? 'Logged' : 'No logs yet');

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Insights Header (Title ✦ 🌸, Subtitle, Calendar, Profile)
                InsightsHeader(
                  onCalendarTap: () {
                    try {
                      context.go(AppRoutes.calendarPath);
                    } catch (_) {}
                  },
                  onProfileTap: () {
                    try {
                      context.push(AppRoutes.profilePath);
                    } catch (_) {}
                  },
                ),

                const SizedBox(height: 10.0),

                // 2. Category Navigation Tabs (Overview, Cycles, Fertility, Trends)
                InsightsCategoryTabs(
                  selectedTabId: _selectedCategoryTabId,
                  onTabSelected: _handleCategoryTabSelected,
                ),

                const SizedBox(height: 10.0),

                // 3. "Your current cycle ✦" Hero Card (Right-Aligned Cycle Ring + Floating layout)
                CurrentCycleHeroCard(
                  currentDay: currentCycleDay,
                  totalDays: totalDays,
                  fertileWindowDates: cycleState.fertileWindowDatesText,
                  predictedOvulationDate: cycleState.ovulationDateText,
                  nextPeriodDates: cycleState.nextPeriodDatesRangeText,
                  energyPhaseTitle: '${cycleState.phaseName} Peak ✦',
                  energyPhaseSubtitle: cycleState.phaseDescription,
                  onLearnMore: () => _openPhaseDetail(cycleState.phaseName),
                  onFertileWindowTap: () => _openPhaseDetail('Follicular'),
                  onOvulationTap: () => _openPhaseDetail('Ovulation'),
                  onNextPeriodTap: () => _openPhaseDetail('Period'),
                  onRingTap: () => _openHighlightsDetail(
                    avgCycleLength: totalDays,
                    avgPeriodLength: userProfile.typicalPeriodDuration,
                    avgOvulationDay: 'Day ${(totalDays - 14)}',
                  ),
                ),

                const SizedBox(height: 10.0),

                // 4. "Cycle highlights ✦" 4-Card Grid Row
                CycleHighlightsRow(
                  avgCycleLength: totalDays,
                  avgPeriodLength: userProfile.typicalPeriodDuration,
                  avgOvulationDay: cycleState.ovulationDateText,
                  longestCycle: totalDays + 3,
                  onTap: () => _openHighlightsDetail(
                    avgCycleLength: totalDays,
                    avgPeriodLength: userProfile.typicalPeriodDuration,
                    avgOvulationDay: 'Day ${(totalDays - 14)}',
                  ),
                ),

                const SizedBox(height: 10.0),

                // 5. "Fertility this year ✦" 12-Month Bar Chart Card
                FertilityYearChartCard(
                  onAiCalloutTap: () {
                    try {
                      context.push(
                        AppRoutes.aiChatPath,
                        extra: {
                          'prompt':
                              'May is my most fertile month this year. How can I prepare and optimize conception timing?',
                        },
                      );
                    } catch (_) {
                      context.push(AppRoutes.aiCompanionPath);
                    }
                  },
                ),

                const SizedBox(height: 10.0),

                // 6. Split Row: Intercourse, Consistency & Body Balance (3 Cards)
                IntercourseAndSymptomsRow(
                  intercourseTimes: displayIntercourse,
                  intercourseDiff: 1,
                  consistencyPercent: displayConsistency,
                  symptomsStatus: symptomsSummary,
                  onIntercourseTap: () {
                    try {
                      context.go(AppRoutes.dailyLogPath);
                    } catch (_) {}
                  },
                  onConsistencyTap: () {
                    try {
                      context.go(AppRoutes.dailyLogPath);
                    } catch (_) {}
                  },
                  onSymptomsTap: () => _openPhaseDetail('Follicular'),
                ),

                const SizedBox(height: 10.0),

                // 7. Reproductive Privacy Matters Banner
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 9.0,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF0F5), Color(0xFFFFEEF3)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: const Color(0xFFFFDEE6),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Purple Lock Icon
                      Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: const BoxDecoration(
                          color: Color(0xFF8B5CF6),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.lock_outline_rounded,
                            color: Colors.white,
                            size: 17.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),

                      // Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Your privacy matters',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E1A3C),
                              ),
                            ),
                            SizedBox(height: 1.0),
                            Text(
                              'Your data is private, encrypted and never shared.',
                              style: TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF7A708A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 4.0),

                      // Learn more button
                      InkWell(
                        onTap: () {
                          try {
                            context.push(AppRoutes.privacySecurityPath);
                          } catch (_) {}
                        },
                        borderRadius: BorderRadius.circular(14.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14.0),
                            border: Border.all(
                              color: const Color(0xFFFFCCD5),
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'Learn more',
                                style: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFE84855),
                                ),
                              ),
                              SizedBox(width: 2.0),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 10.0,
                                color: Color(0xFFE84855),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
