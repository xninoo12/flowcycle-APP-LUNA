import 'package:flutter/material.dart';

/// "Cycle highlights ✦" 4-Card Metric Grid for Insights screen matching the exact mockup.
class CycleHighlightsRow extends StatelessWidget {
  final int avgCycleLength;
  final int avgPeriodLength;
  final String avgOvulationDay;
  final int longestCycle;
  final VoidCallback? onTap;

  const CycleHighlightsRow({
    super.key,
    this.avgCycleLength = 28,
    this.avgPeriodLength = 5,
    this.avgOvulationDay = 'May 14',
    this.longestCycle = 31,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Header: Title + vs. last 6 cycles ⓘ
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Cycle highlights',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w900,
                    fontSize: 15.5,
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
                    'vs. last 6 cycles',
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

        // 2. 4 Metric Cards Row
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.calendar_today_rounded,
                iconColor: const Color(0xFF10B981),
                iconBg: const Color(0xFFE8F5E9),
                value: '$avgCycleLength',
                title: 'Avg cycle length\ndays',
                badgeText: '↑ 2 days',
                badgeColor: const Color(0xFF10B981),
                onTap: onTap,
              ),
            ),
            const SizedBox(width: 6.0),
            Expanded(
              child: _MetricCard(
                icon: Icons.water_drop_outlined,
                iconColor: const Color(0xFFE84855),
                iconBg: const Color(0xFFFFEEF0),
                value: '$avgPeriodLength',
                title: 'Avg period length\ndays',
                badgeText: '↓ 1 day',
                badgeColor: const Color(0xFFE84855),
                onTap: onTap,
              ),
            ),
            const SizedBox(width: 6.0),
            Expanded(
              child: _MetricCard(
                icon: Icons.track_changes_rounded,
                iconColor: const Color(0xFF8B5CF6),
                iconBg: const Color(0xFFEDE9FE),
                value: avgOvulationDay,
                title: 'Avg ovulation\nday',
                badgeText: '—',
                badgeColor: const Color(0xFF7A708A),
                isSmallValue: true,
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
                title: 'Longest cycle\ndays',
                badgeText: '↑ 3 days',
                badgeColor: const Color(0xFF10B981),
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
  final String title;
  final String badgeText;
  final Color badgeColor;
  final bool isSmallValue;
  final VoidCallback? onTap;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.title,
    required this.badgeText,
    required this.badgeColor,
    this.isSmallValue = false,
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
                blurRadius: 10.0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
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
              const SizedBox(height: 4.0),

              // Value
              Text(
                value,
                style: TextStyle(
                  fontFamily: isSmallValue ? null : 'serif',
                  fontSize: isSmallValue ? 12.0 : 18.0,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E1A3C),
                  letterSpacing: -0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2.0),

              // Title
              Text(
                title,
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
              const SizedBox(height: 3.0),

              // Trend Badge
              Text(
                badgeText,
                style: TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  color: badgeColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
