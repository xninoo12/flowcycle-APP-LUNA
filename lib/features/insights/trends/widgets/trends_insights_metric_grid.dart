import 'package:flutter/material.dart';

/// "Cycle insights ✦" 4-Card Vertical Grid for Trends subscreen matching the exact mockup.
class TrendsInsightsMetricGrid extends StatelessWidget {
  final int avgPeriodLength;
  final int avgCycleLength;
  final int avgOvulationDay;
  final int longestCycle;
  final VoidCallback? onTap;

  const TrendsInsightsMetricGrid({
    super.key,
    this.avgPeriodLength = 5,
    this.avgCycleLength = 28,
    this.avgOvulationDay = 14,
    this.longestCycle = 31,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Header: Title + Learn more ⓘ
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Cycle insights',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w900,
                    fontSize: 15.0,
                    color: Color(0xFF1E1A3C),
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(width: 4.0),
                Text(
                  '✦',
                  style: TextStyle(
                    color: Color(0xFFF59E0B),
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: onTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Learn more',
                    style: TextStyle(
                      color: Color(0xFF7A708A),
                      fontSize: 11.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 3.0),
                  Icon(
                    Icons.info_outline_rounded,
                    size: 13.0,
                    color: Color(0xFF7A708A),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 8.0),

        // 2. 4 Vertical Cards Row
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.water_drop_outlined,
                iconColor: const Color(0xFFE84855),
                iconBg: const Color(0xFFFFEEF0),
                value: '$avgPeriodLength',
                unit: 'days',
                valueColor: const Color(0xFF1E1A3C),
                label: 'Avg period\nlength',
                onTap: onTap,
              ),
            ),
            const SizedBox(width: 6.0),
            Expanded(
              child: _MetricCard(
                icon: Icons.calendar_today_rounded,
                iconColor: const Color(0xFF10B981),
                iconBg: const Color(0xFFE8F5E9),
                value: '$avgCycleLength',
                unit: 'days',
                valueColor: const Color(0xFF059669),
                label: 'Avg cycle\nlength',
                onTap: onTap,
              ),
            ),
            const SizedBox(width: 6.0),
            Expanded(
              child: _MetricCard(
                icon: Icons.track_changes_rounded,
                iconColor: const Color(0xFF8B5CF6),
                iconBg: const Color(0xFFEDE9FE),
                value: '$avgOvulationDay',
                unit: 'days',
                valueColor: const Color(0xFF7C3AED),
                label: 'Avg ovulation\nday',
                onTap: onTap,
              ),
            ),
            const SizedBox(width: 6.0),
            Expanded(
              child: _MetricCard(
                icon: Icons.access_time_rounded,
                iconColor: const Color(0xFF3B82F6),
                iconBg: const Color(0xFFEFF6FF),
                value: '$longestCycle',
                unit: 'days',
                valueColor: const Color(0xFF2563EB),
                label: 'Longest\ncycle',
                onTap: onTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String value;
  final String unit;
  final Color valueColor;
  final String label;
  final VoidCallback? onTap;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.unit,
    required this.valueColor,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: const Color(0xFFF1ECF5), width: 1.0),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E1A3C).withValues(alpha: 0.025),
                blurRadius: 8.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Circle
              Container(
                width: 26.0,
                height: 26.0,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Center(child: Icon(icon, color: iconColor, size: 14.0)),
              ),
              const SizedBox(height: 5.0),

              // Value & unit row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w900,
                      color: valueColor,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(width: 2.0),
                  Text(
                    unit,
                    style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w700,
                      color: valueColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2.0),

              // Label
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7A708A),
                  height: 1.15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
