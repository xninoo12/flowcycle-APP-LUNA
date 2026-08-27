import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/providers/app_scope.dart';
import '../../dashboard/models/cycle_dashboard_state.dart';
import 'widgets/cycle_entry_detail_sheet.dart';
import 'widgets/cycle_history_table_card.dart';
import 'widgets/cycle_phases_timeline_card.dart';
import 'widgets/cycles_consistency_banner.dart';
import 'widgets/cycles_current_hero_card.dart';
import 'widgets/cycles_header.dart';
import 'widgets/cycles_sub_tabs.dart';
import 'widgets/phase_detail_sheet.dart';

/// Cycles Subscreen under Insights feature matching the exact mockup.
class CyclesSubscreen extends StatefulWidget {
  final VoidCallback? onBack;

  const CyclesSubscreen({super.key, this.onBack});

  @override
  State<CyclesSubscreen> createState() => _CyclesSubscreenState();
}

class _CyclesSubscreenState extends State<CyclesSubscreen> {
  String _selectedSubTabId = 'current_cycle';

  void _handleSubTabSelected(String tabId) {
    if (tabId == 'calendar') {
      try {
        context.go(AppRoutes.calendarPath);
      } catch (_) {}
      return;
    }
    setState(() {
      _selectedSubTabId = tabId;
    });
  }

  void _openCycleEntryDetail(PastCycleEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CycleEntryDetailSheet(
        dateRange: entry.dateRange,
        cycleLength: entry.lengthDays,
        periodDuration: 5,
        ovulationDay: entry.ovulationDate,
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
    final controller = AppScope.of(context);
    final userProfile = controller.userProfile;
    final cycleState = controller.calculateCurrentCycleState();
    final totalDays = cycleState.totalDays;
    final currentCycleDay = cycleState.currentDay;

    final pastCycles = CycleHistoryTableCard.generatePastCycles(
      lastPeriodStartDate: userProfile.lastPeriodStartDate,
      averageCycleLength: userProfile.averageCycleLength,
    );

    const phaseNames = ['Period', 'Follicular', 'Ovulation', 'Luteal'];

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
                // 1. Cycles Header (Back ←, "Cycles ✦ 🌸", Calendar, More ⋮)
                CyclesHeader(
                  onBackTap: () {
                    if (widget.onBack != null) {
                      widget.onBack!();
                    } else {
                      try {
                        if (Navigator.of(context).canPop()) {
                          context.pop();
                        } else {
                          context.go(AppRoutes.insightsPath);
                        }
                      } catch (_) {
                        context.go(AppRoutes.insightsPath);
                      }
                    }
                  },
                  onCalendarTap: () {
                    try {
                      context.go(AppRoutes.calendarPath);
                    } catch (_) {}
                  },
                  onMoreTap: () {},
                ),

                const SizedBox(height: 10.0),

                // 2. Horizontal Sub-Tabs (Current cycle, History, Predictions)
                CyclesSubTabs(
                  selectedTabId: _selectedSubTabId,
                  onTabSelected: _handleSubTabSelected,
                ),

                const SizedBox(height: 10.0),

                // 3. "Current cycle" Hero Card (Right-Aligned Ring + Open Space)
                if (_selectedSubTabId == 'current_cycle' || _selectedSubTabId == 'predictions')
                  CyclesCurrentHeroCard(
                    currentDay: currentCycleDay,
                    totalDays: totalDays,
                    fertileWindowDates: cycleState.fertileWindowDatesText,
                    ovulationDate: cycleState.ovulationDateText,
                    periodExpectedDates: cycleState.nextPeriodDatesRangeText,
                    bannerTitle: cycleState.phase == CyclePhase.ovulation
                        ? "You're in your fertile window"
                        : "Current phase: ${cycleState.phaseName}",
                    bannerSubtitle: cycleState.phaseDescription,
                    onBannerTap: () {
                      try {
                        context.push(
                          AppRoutes.aiChatPath,
                          extra: {
                            'prompt':
                                "I'm in my ${cycleState.phaseName}. What should I know about optimizing my wellness and symptoms?",
                          },
                        );
                      } catch (_) {
                        context.push(AppRoutes.aiCompanionPath);
                      }
                    },
                    onFertileWindowTap: () => _openPhaseDetail('Follicular'),
                    onOvulationTap: () => _openPhaseDetail('Ovulation'),
                    onNextPeriodTap: () => _openPhaseDetail('Period'),
                    onRingTap: () => _openPhaseDetail(cycleState.phaseName),
                  ),

                if (_selectedSubTabId == 'current_cycle' || _selectedSubTabId == 'predictions')
                  const SizedBox(height: 10.0),

                // 4. "Cycle phases ✦" Connected Timeline Card (4 Numbered Circles)
                if (_selectedSubTabId == 'current_cycle' || _selectedSubTabId == 'predictions')
                  CyclePhasesTimelineCard(
                    dynamicPhases: cycleState.cyclePhasesTimeline,
                    onLearnMore: () => _openPhaseDetail('Ovulation'),
                    onPhaseTap: (idx) => _openPhaseDetail(phaseNames[idx]),
                  ),

                if (_selectedSubTabId == 'current_cycle' || _selectedSubTabId == 'predictions')
                  const SizedBox(height: 10.0),

                // 5. "Cycle history" Table Card
                if (_selectedSubTabId == 'current_cycle' || _selectedSubTabId == 'history')
                  CycleHistoryTableCard(
                    history: pastCycles,
                    onSeeAll: () => _openCycleEntryDetail(
                      pastCycles.isNotEmpty
                          ? pastCycles.first
                          : const PastCycleEntry(
                              cycleNumber: 6,
                              dateRange: 'Apr 6 – May 3',
                              lengthDays: 28,
                              ovulationDate: 'Apr 20',
                            ),
                    ),
                    onRowTap: _openCycleEntryDetail,
                  ),

                if (_selectedSubTabId == 'current_cycle' || _selectedSubTabId == 'history')
                  const SizedBox(height: 10.0),

                // 6. Consistency Feedback Banner
                GestureDetector(
                  onTap: () => _openPhaseDetail('Follicular'),
                  child: const CyclesConsistencyBanner(
                    title: 'Your cycles are looking consistent!',
                    subtitle: 'Keep logging to get more accurate insights.',
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
