import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/providers/app_scope.dart';
import '../widgets/cycle_highlights_detail_sheet.dart';
import 'widgets/cycle_length_trend_card.dart';
import 'widgets/period_length_trend_card.dart';
import 'widgets/trends_header.dart';
import 'widgets/trends_horizon_selector.dart';
import 'widgets/trends_insights_metric_grid.dart';

/// Trends Subscreen under Insights feature matching the exact mockup.
class TrendsSubscreen extends StatefulWidget {
  final VoidCallback? onBack;

  const TrendsSubscreen({super.key, this.onBack});

  @override
  State<TrendsSubscreen> createState() => _TrendsSubscreenState();
}

class _TrendsSubscreenState extends State<TrendsSubscreen> {
  String _selectedHorizon = '3 months';

  void _handleHorizonChanged(String horizon) {
    setState(() {
      _selectedHorizon = horizon;
    });
  }

  void _openHighlightsDetail({
    required int avgCycleLength,
    required int avgPeriodLength,
    required String avgOvulationDay,
    int longestCycle = 31,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CycleHighlightsDetailSheet(
        avgCycleLength: avgCycleLength,
        avgPeriodLength: avgPeriodLength,
        avgOvulationDay: avgOvulationDay,
        longestCycle: longestCycle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = AppScope.of(context).userProfile;
    final avgCycle = userProfile.averageCycleLength;
    final avgPeriod = userProfile.typicalPeriodDuration;

    String deltaCycle = '1 day vs last 3 months';
    String rangeCycle = '26 – 31 days';
    String deltaPeriod = '0.3 day vs last 3 months';
    int longestCycle = 31;

    if (_selectedHorizon == '6 months') {
      deltaCycle = '0.8 day vs last 6 months';
      rangeCycle = '25 – 32 days';
      deltaPeriod = '0.4 day vs last 6 months';
      longestCycle = 32;
    } else if (_selectedHorizon == '12 months') {
      deltaCycle = '1.4 days vs last 12 months';
      rangeCycle = '25 – 33 days';
      deltaPeriod = '0.5 day vs last 12 months';
      longestCycle = 33;
    }

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
                // 1. Trends Header (Back ←, "Trends ✦ 🌸", Calendar, More ⋮)
                TrendsHeader(
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

                // 2. 3-Month / 6-Month / 12-Month Horizon Selector
                TrendsHorizonSelector(
                  selectedHorizon: _selectedHorizon,
                  onHorizonChanged: _handleHorizonChanged,
                ),

                const SizedBox(height: 10.0),

                // 3. "Cycle length trend" Line Chart Card (Open-Space)
                CycleLengthTrendCard(
                  averageLength: avgCycle,
                  deltaText: deltaCycle,
                  rangeText: rangeCycle,
                  onViewDetails: () => _openHighlightsDetail(
                    avgCycleLength: avgCycle,
                    avgPeriodLength: avgPeriod,
                    avgOvulationDay: 'Day 14',
                    longestCycle: longestCycle,
                  ),
                ),

                const SizedBox(height: 10.0),

                // 4. "Cycle insights ✦" 4-Card Metric Grid Row
                TrendsInsightsMetricGrid(
                  avgPeriodLength: avgPeriod,
                  avgCycleLength: avgCycle,
                  avgOvulationDay: 14,
                  longestCycle: longestCycle,
                  onTap: () => _openHighlightsDetail(
                    avgCycleLength: avgCycle,
                    avgPeriodLength: avgPeriod,
                    avgOvulationDay: 'Day 14',
                    longestCycle: longestCycle,
                  ),
                ),

                const SizedBox(height: 10.0),

                // 5. "Period length trend" Bar Chart Card
                PeriodLengthTrendCard(
                  averagePeriodLength: avgPeriod,
                  deltaText: deltaPeriod,
                  onViewDetails: () => _openHighlightsDetail(
                    avgCycleLength: avgCycle,
                    avgPeriodLength: avgPeriod,
                    avgOvulationDay: 'Day 14',
                    longestCycle: longestCycle,
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
