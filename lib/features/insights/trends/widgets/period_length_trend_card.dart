import 'package:flutter/material.dart';

/// "Period length trend" Bar Chart Card for Trends subscreen matching the exact mockup.
class PeriodLengthTrendCard extends StatelessWidget {
  final int averagePeriodLength;
  final String deltaText;
  final VoidCallback? onViewDetails;

  const PeriodLengthTrendCard({
    super.key,
    this.averagePeriodLength = 5,
    this.deltaText = '0.3 day vs last 3 months',
    this.onViewDetails,
  });

  static const List<String> months = ['Feb', 'Mar', 'Apr', 'May', 'Jun'];
  static const List<int> periodLengths = [5, 4, 5, 5, 4];

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
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Header: Title + View details >
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24.0,
                    height: 24.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFEEF0),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.water_drop_rounded,
                        color: Color(0xFFE84855),
                        size: 14.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6.0),
                  const Text(
                    'Period length trend',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontWeight: FontWeight.w900,
                      fontSize: 15.0,
                      color: Color(0xFF1E1A3C),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: onViewDetails,
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7.0,
                    vertical: 3.0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F5),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: const Color(0xFFFFCCD5),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'View details',
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFE84855),
                        ),
                      ),
                      SizedBox(width: 2.0),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 12.0,
                        color: Color(0xFFE84855),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8.0),

          // 2. Bar Chart (Left) & Metrics (Right) Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Bar Chart Area
              Expanded(
                flex: 6,
                child: SizedBox(
                  height: 110.0,
                  child: Stack(
                    children: [
                      // "Days" Unit Top Label
                      const Positioned(
                        left: 0.0,
                        top: 0.0,
                        child: Text(
                          'Days',
                          style: TextStyle(
                            fontSize: 7.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF7A708A),
                          ),
                        ),
                      ),

                      // Y-Axis labels & Grid lines
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, bottom: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            _BarGridLine(label: '7'),
                            _BarGridLine(label: '5'),
                            _BarGridLine(label: '3'),
                            _BarGridLine(label: '1'),
                            _BarGridLine(label: '0'),
                          ],
                        ),
                      ),

                      // Average line at 5
                      Positioned(
                        left: 18.0,
                        right: 8.0,
                        top: 36.0,
                        child: Container(
                          height: 1.0,
                          color: const Color(0xFFFF6B8B).withValues(alpha: 0.5),
                        ),
                      ),

                      // 5 Vertical Pink Gradient Bars
                      Positioned(
                        left: 18.0,
                        right: 8.0,
                        top: 12.0,
                        bottom: 16.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(5, (index) {
                            final length = periodLengths[index];
                            final barHeight = (length / 7.0) * 72.0;

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '$length',
                                  style: const TextStyle(
                                    fontSize: 8.0,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1E1A3C),
                                  ),
                                ),
                                const SizedBox(height: 2.0),
                                Container(
                                  width: 12.0,
                                  height: barHeight.clamp(14.0, 72.0),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFFF85A1), Color(0xFFFF4D6D)],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),

                      // X-Axis Month Labels
                      Positioned(
                        left: 18.0,
                        right: 8.0,
                        bottom: 0.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: months.map((m) {
                            return Text(
                              m,
                              style: const TextStyle(
                                fontSize: 8.5,
                                color: Color(0xFF7A708A),
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 10.0),

              // Right: Stats Column + Floral Illustration
              Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Average period length',
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Color(0xFF7A708A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 1.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '$averagePeriodLength',
                              style: const TextStyle(
                                fontFamily: 'serif',
                                fontSize: 24.0,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFE84855),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(width: 3.0),
                            const Text(
                              'days',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFE84855),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3.0),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Text(
                            '▼ $deltaText',
                            style: const TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF059669),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Positioned(
                      bottom: 0,
                      right: 0,
                      child: Text(
                        '🌸',
                        style: TextStyle(fontSize: 22.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarGridLine extends StatelessWidget {
  final String label;

  const _BarGridLine({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 12.0,
          child: Text(
            label,
            style: const TextStyle(fontSize: 7.5, color: Color(0xFFB0A4B8)),
          ),
        ),
        const SizedBox(width: 3.0),
        Expanded(
          child: Container(
            height: 0.7,
            color: const Color(0xFFF1ECF5),
          ),
        ),
      ],
    );
  }
}
