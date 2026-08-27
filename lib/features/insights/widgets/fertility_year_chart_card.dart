import 'package:flutter/material.dart';
import 'fertility_month_detail_sheet.dart';

/// 12-Month Fertility Bar Chart & Insight Card for Insights screen matching the exact mockup.
class FertilityYearChartCard extends StatelessWidget {
  final VoidCallback? onAiCalloutTap;
  final ValueChanged<int>? onMonthTap;

  const FertilityYearChartCard({
    super.key,
    this.onAiCalloutTap,
    this.onMonthTap,
  });

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const List<double> _monthHeights = [
    0.28,
    0.62,
    0.68,
    0.55,
    0.95,
    0.62,
    0.35,
    0.62,
    0.68,
    0.40,
    0.60,
    0.60,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: const Color(0xFFF1ECF5), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1A3C).withValues(alpha: 0.025),
            blurRadius: 10.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Header: Title + Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Flexible(
                      child: Text(
                        'Fertility this year',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontWeight: FontWeight.w900,
                          fontSize: 14.5,
                          color: Color(0xFF1E1A3C),
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 3.0),
                    Text(
                      '✦',
                      style: TextStyle(
                        color: Color(0xFFF59E0B),
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLegendDot(const Color(0xFF10B981), 'Fertile days'),
                  const SizedBox(width: 6.0),
                  _buildLegendDot(const Color(0xFF8B5CF6), 'Ovulation'),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8.0),

          // 2. Main Content: Chart (Left) + Insight Callout (Right)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 12-Month Bar Chart with Y-Axis Labels
              Expanded(
                flex: 7,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Y-Axis Labels
                    SizedBox(
                      height: 88.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'High',
                            style: TextStyle(
                              fontSize: 7.5,
                              color: Color(0xFF7A708A),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Medium',
                            style: TextStyle(
                              fontSize: 7.5,
                              color: Color(0xFF7A708A),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Low',
                            style: TextStyle(
                              fontSize: 7.5,
                              color: Color(0xFF7A708A),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 2.0),

                    // 12 Monthly Bars
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(12, (index) {
                          final isMay = index == 4;
                          return Expanded(
                            child: _buildMonthlyBar(
                              context: context,
                              index: index,
                              month: _months[index],
                              heightRatio: _monthHeights[index],
                              isHighlight: isMay,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6.0),

              // Right: Insight Card
              Expanded(
                flex: 4,
                child: InkWell(
                  onTap: onAiCalloutTap ?? () {},
                  borderRadius: BorderRadius.circular(14.0),
                  child: Container(
                    padding: const EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(14.0),
                      border: Border.all(color: const Color(0xFFDCFCE7), width: 1.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 20.0,
                              height: 20.0,
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.eco_rounded,
                                  color: Colors.white,
                                  size: 12.0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4.0),
                            const Expanded(
                              child: Text(
                                'May is your most fertile month this year.',
                                style: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF065F46),
                                  height: 1.15,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Expanded(
                              child: Text(
                                'You had high chances of conception for 6 days.',
                                style: TextStyle(
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF047857),
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 13.0,
                              color: Color(0xFF10B981),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5.5,
          height: 5.5,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 2.5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 9.0,
            color: Color(0xFF7A708A),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  static const List<String> _fullMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  void _openMonthDetail(BuildContext context, int index) {
    if (onMonthTap != null) {
      onMonthTap!(index);
      return;
    }

    final monthName = _fullMonths[index];
    final isPeak = index == 4;
    final fertileRanges = [
      'Jan 14 – Jan 19',
      'Feb 11 – Feb 16',
      'Mar 13 – Mar 18',
      'Apr 10 – Apr 15',
      'May 12 – May 17',
      'Jun 9 – Jun 14',
      'Jul 14 – Jul 19',
      'Aug 11 – Aug 16',
      'Sep 12 – Sep 17',
      'Oct 10 – Oct 15',
      'Nov 11 – Nov 16',
      'Dec 9 – Dec 14',
    ];
    final ovulations = [
      'Jan 16',
      'Feb 13',
      'Mar 15',
      'Apr 12',
      'May 14',
      'Jun 11',
      'Jul 16',
      'Aug 13',
      'Sep 14',
      'Oct 12',
      'Nov 13',
      'Dec 11',
    ];
    final percents = [30, 65, 70, 58, 95, 65, 38, 65, 70, 42, 62, 62];
    final ratings = [
      'Moderate Window',
      'High Conception Potential',
      'High Conception Potential',
      'Moderate Window',
      'Peak Conception Potential 💗',
      'High Conception Potential',
      'Moderate Window',
      'High Conception Potential',
      'High Conception Potential',
      'Moderate Window',
      'High Conception Potential',
      'High Conception Potential',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FertilityMonthDetailSheet(
        monthName: monthName,
        fertileRange: fertileRanges[index],
        peakOvulationDay: ovulations[index],
        conceptionProbabilityPercent: percents[index],
        conceptionRating: ratings[index],
        isPeakMonth: isPeak,
      ),
    );
  }

  Widget _buildMonthlyBar({
    required BuildContext context,
    required int index,
    required String month,
    required double heightRatio,
    required bool isHighlight,
  }) {
    const maxBarHeight = 58.0;
    final barHeight = maxBarHeight * heightRatio;

    return GestureDetector(
      onTap: () => _openMonthDetail(context, index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Crown for Highlight Month (May)
          if (isHighlight)
            const Text('👑', style: TextStyle(fontSize: 8.0))
          else
            const SizedBox(height: 10.0),

          // Ovulation Top Dot
          Container(
            width: 4.5,
            height: 4.5,
            decoration: BoxDecoration(
              color: isHighlight
                  ? const Color(0xFF10B981)
                  : const Color(0xFF8B5CF6),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 2.0),

          // Bar
          Container(
            width: isHighlight ? 7.0 : 5.0,
            height: barHeight,
            decoration: BoxDecoration(
              color: isHighlight
                  ? const Color(0xFF10B981)
                  : const Color(0xFFA7F3D0),
              borderRadius: BorderRadius.circular(3.0),
            ),
          ),
          const SizedBox(height: 3.0),

          // Month Label
          if (isHighlight)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 0.5),
              decoration: BoxDecoration(
                color: const Color(0xFF059669),
                borderRadius: BorderRadius.circular(3.0),
              ),
              child: Text(
                month,
                style: const TextStyle(
                  fontSize: 6.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
            )
          else
            Text(
              month,
              style: const TextStyle(
                fontSize: 7.0,
                color: Color(0xFF7A708A),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.clip,
            ),
        ],
      ),
    );
  }
}
