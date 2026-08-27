import 'package:flutter/material.dart';

/// Small Rectangular Key-Metrics Cards for FlowCycle Calendar Screen.
/// Displays Sexual Intercourse Logged and Days Logged side-by-side.
class CalendarMetricsCards extends StatelessWidget {
  final int intercourseCount;
  final int daysLoggedCount;
  final VoidCallback? onIntercourseTap;
  final VoidCallback? onDaysLoggedTap;

  const CalendarMetricsCards({
    super.key,
    this.intercourseCount = 2,
    this.daysLoggedCount = 14,
    this.onIntercourseTap,
    this.onDaysLoggedTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 1. Sexual Intercourse Logged Card
        Expanded(
          child: _buildMetricCard(
            icon: Icons.favorite_rounded,
            iconColor: const Color(0xFFE81B54),
            iconBgColor: const Color(0xFFFFE8EE),
            title: 'Sexual Intercourse Logged',
            value: '$intercourseCount',
            valueColor: const Color(0xFFE81B54),
            unit: 'times',
            onTap: onIntercourseTap,
          ),
        ),

        const SizedBox(width: 12.0),

        // 2. Days Logged Card
        Expanded(
          child: _buildMetricCard(
            icon: Icons.calendar_month_rounded,
            iconColor: const Color(0xFF7C3AED),
            iconBgColor: const Color(0xFFEDE9FE),
            title: 'Days Logged',
            value: '$daysLoggedCount',
            valueColor: const Color(0xFF7C3AED),
            unit: 'days',
            onTap: onDaysLoggedTap,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String value,
    required Color valueColor,
    required String unit,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.0),
            border: Border.all(
              color: const Color(0xFFF1ECF5),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E1A3C).withValues(alpha: 0.02),
                blurRadius: 10.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon Badge Box
              Container(
                width: 38.0,
                height: 38.0,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20.0,
                  ),
                ),
              ),

              const SizedBox(width: 10.0),

              // Title and Value
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E1A3C),
                        height: 1.15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          value,
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 19.0,
                            fontWeight: FontWeight.w900,
                            color: valueColor,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(width: 3.0),
                        Flexible(
                          child: Text(
                            unit,
                            style: const TextStyle(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF7A708A),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
