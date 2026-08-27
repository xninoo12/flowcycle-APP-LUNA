import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/providers/app_scope.dart';
import '../../dashboard/models/cycle_dashboard_state.dart';
import 'widgets/daily_fertility_detail_sheet.dart';
import 'widgets/fertility_breakdown_card.dart';
import 'widgets/fertility_factor_detail_sheet.dart';
import 'widgets/fertility_factors_card.dart';
import 'widgets/fertility_header.dart';
import 'widgets/fertility_today_hero_card.dart';

/// Fertility Subscreen under Insights feature matching the exact mockup.
class FertilitySubscreen extends StatelessWidget {
  final VoidCallback? onBack;

  const FertilitySubscreen({super.key, this.onBack});

  void _openDailyFertilityDetail({
    required BuildContext context,
    required String dayLabel,
    required String dateText,
    required int chancePercent,
    required String chanceRating,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DailyFertilityDetailSheet(
        dayLabel: dayLabel,
        dateText: dateText,
        chancePercent: chancePercent,
        chanceRating: chanceRating,
      ),
    );
  }

  void _openFactorDetail(BuildContext context, String factorTitle) {
    String impact = 'High Impact • +35% Success Rate';
    String description =
        'Timing intercourse during the 5 days leading up to and including ovulation maximizes the presence of viable sperm when egg is released.';
    IconData icon = Icons.favorite_rounded;
    Color color = const Color(0xFFE84855);
    List<String> tips = [
      'Focus on intercourse every 1–2 days during your fertile window.',
      'Morning intimacy often coincides with peak male testosterone and motility.',
      'Avoid artificial lubricants that can impair sperm motility.',
    ];

    if (factorTitle == 'Get good sleep') {
      impact = 'Moderate Impact • Hormonal Regularity';
      description =
          'Chronic sleep deprivation increases cortisol, which can suppress GnRH pulsation and delay or impair ovulation.';
      icon = Icons.nightlight_round;
      color = const Color(0xFF8B5CF6);
      tips = [
        'Maintain a consistent bedtime and wake time (7–9 hours).',
        'Avoid blue light 1 hour prior to sleep to preserve melatonin.',
        'Keep bedroom temperature cool and dark.',
      ];
    } else if (factorTitle == 'Manage stress') {
      impact = 'Moderate Impact • Cortisol Modulation';
      description =
          'High sympathetic nervous system arousal can interfere with the hypothalamic-pituitary-ovarian axis.';
      icon = Icons.eco_rounded;
      color = const Color(0xFF10B981);
      tips = [
        'Engage in 10 minutes of daily mindfulness or deep breathing.',
        'Low-impact movement (nature walks, restorative yoga).',
        'Prioritize self-care and open communication with your partner.',
      ];
    } else if (factorTitle == 'Stay hydrated') {
      impact = 'High Impact • Cervical Fluid Volume';
      description =
          'Adequate hydration is critical for producing fertile egg-white cervical fluid needed for sperm survival.';
      icon = Icons.water_drop_outlined;
      color = const Color(0xFF3B82F6);
      tips = [
        'Drink at least 8–10 cups (2.5L) of fresh water daily.',
        'Incorporate electrolytes and coconut water.',
        'Limit dehydrating diuretics like excessive caffeine.',
      ];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FertilityFactorDetailSheet(
        title: factorTitle,
        impact: impact,
        description: description,
        icon: icon,
        color: color,
        actionableTips: tips,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final cycleState = controller.calculateCurrentCycleState();
    final fertileDays = cycleState.fertileBreakdownDays;
    final int todayChancePercent = cycleState.phase == CyclePhase.ovulation
        ? 100
        : (cycleState.fertilityChance == 'High' ? 85 : 30);

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
                // 1. Fertility Header (Back ←, "Fertility ✦ 🌸", Calendar, More ⋮)
                FertilityHeader(
                  onBackTap: () {
                    if (onBack != null) {
                      onBack!();
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

                // 2. "Fertility chance Today" Hero Card (Right-Aligned Ring + Open Space)
                FertilityTodayHeroCard(
                  chancePercent: todayChancePercent,
                  fertileWindowDates: cycleState.fertileWindowDatesText,
                  ovulationDate: cycleState.ovulationDateText,
                  nextPeriodDates: cycleState.nextPeriodDatesRangeText,
                  bannerTitle: cycleState.phase == CyclePhase.ovulation
                      ? "You're in peak fertile window"
                      : "Fertility chance: ${cycleState.fertilityStatus}",
                  bannerSubtitle: cycleState.phaseDescription,
                  onBannerTap: () {
                    try {
                      context.push(
                        AppRoutes.aiChatPath,
                        extra: {
                          'prompt':
                              "I'm on Day ${cycleState.currentDay} (${cycleState.phaseName}). What should I know about optimizing timing and tracking my symptoms?",
                        },
                      );
                    } catch (_) {
                      context.push(AppRoutes.aiCompanionPath);
                    }
                  },
                  onFertileWindowTap: () => _openDailyFertilityDetail(
                    context: context,
                    dayLabel: fertileDays.length > 2 ? fertileDays[2]['dayName'] as String : 'Wed',
                    dateText: fertileDays.length > 2 ? fertileDays[2]['date'] as String : cycleState.ovulationDateText,
                    chancePercent: 85,
                    chanceRating: 'High Fertility 💗',
                  ),
                  onOvulationTap: () => _openDailyFertilityDetail(
                    context: context,
                    dayLabel: fertileDays.length > 3 ? fertileDays[3]['dayName'] as String : 'Thu',
                    dateText: cycleState.ovulationDateText,
                    chancePercent: 100,
                    chanceRating: 'Peak Fertility 💗',
                  ),
                  onNextPeriodTap: () {
                    try {
                      context.push(
                        AppRoutes.aiChatPath,
                        extra: {
                          'prompt':
                              'When is my next period expected (${cycleState.nextPeriodDatesRangeText}) and what luteal symptoms should I watch for?',
                        },
                      );
                    } catch (_) {
                      context.push(AppRoutes.aiCompanionPath);
                    }
                  },
                  onRingTap: () => _openDailyFertilityDetail(
                    context: context,
                    dayLabel: fertileDays.length > 2 ? fertileDays[2]['dayName'] as String : 'Today',
                    dateText: cycleState.ovulationDateText,
                    chancePercent: todayChancePercent,
                    chanceRating: '${cycleState.fertilityChance} Fertility 💗',
                  ),
                ),

                const SizedBox(height: 10.0),

                // 3. "Fertility breakdown" 5-Day Strip Card
                FertilityBreakdownCard(
                  selectedDayIndex: 2,
                  dynamicDays: fertileDays,
                  onDaySelected: (idx) {
                    if (idx < fertileDays.length) {
                      final item = fertileDays[idx];
                      _openDailyFertilityDetail(
                        context: context,
                        dayLabel: item['dayName'] as String,
                        dateText: item['date'] as String,
                        chancePercent: item['chancePercent'] as int,
                        chanceRating: item['chance'] as String,
                      );
                    }
                  },
                  onLearnMore: () {
                    try {
                      context.push(
                        AppRoutes.aiChatPath,
                        extra: {
                          'prompt':
                              'Can you explain my 5-day fertility breakdown (${cycleState.fertileWindowDatesText}) and the best intercourse schedule?',
                        },
                      );
                    } catch (_) {
                      context.push(AppRoutes.aiCompanionPath);
                    }
                  },
                ),

                const SizedBox(height: 10.0),

                // 4. "What increases your chances" 4-Factor Card
                FertilityFactorsCard(
                  onSeeAll: () {
                    try {
                      context.push(
                        AppRoutes.aiChatPath,
                        extra: {
                          'prompt':
                              'What lifestyle habits and nutrition factors have the highest clinical impact on increasing fertility chances?',
                        },
                      );
                    } catch (_) {
                      context.push(AppRoutes.aiCompanionPath);
                    }
                  },
                  onFactorTap: (idx) {
                    final titles = [
                      'Have sex',
                      'Get good sleep',
                      'Manage stress',
                      'Stay hydrated',
                    ];
                    _openFactorDetail(context, titles[idx]);
                  },
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
