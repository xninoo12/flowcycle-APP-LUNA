import 'package:flutter/material.dart';

/// 4-Item Metric Grid Row for Profile Screen matching the exact mockup.
///
/// Features:
/// 1. Cycle Day (13 of 28)
/// 2. Sex Logged (4 this cycle)
/// 3. Days Logged (21 this cycle)
/// 4. Current Mode (Cycle Awareness / Trying to Conceive) with chevron >
class ProfileMetricsRow extends StatelessWidget {
  final int currentCycleDay;
  final int totalCycleDays;
  final int sexLoggedCount;
  final int daysLoggedCount;
  final String currentModeName;
  final VoidCallback? onCycleDayTap;
  final VoidCallback? onSexLoggedTap;
  final VoidCallback? onDaysLoggedTap;
  final VoidCallback? onCurrentModeTap;

  const ProfileMetricsRow({
    super.key,
    this.currentCycleDay = 13,
    this.totalCycleDays = 28,
    this.sexLoggedCount = 4,
    this.daysLoggedCount = 21,
    this.currentModeName = 'Cycle\nAwareness',
    this.onCycleDayTap,
    this.onSexLoggedTap,
    this.onDaysLoggedTap,
    this.onCurrentModeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: const Color(0xFFF1ECF5),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1A3C).withValues(alpha: 0.025),
            blurRadius: 10.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
      child: Row(
        children: [
          // 1. Cycle Day
          Expanded(
            child: _buildMetricItem(
              onTap: onCycleDayTap,
              icon: Icons.calendar_month_outlined,
              iconColor: const Color(0xFFFF4D6D),
              iconBgColor: const Color(0xFFFFEEF0),
              label: 'Cycle Day',
              value: '$currentCycleDay',
              caption: 'of $totalCycleDays',
            ),
          ),

          _buildDivider(),

          // 2. Sex Logged
          Expanded(
            child: _buildMetricItem(
              onTap: onSexLoggedTap,
              customIcon: Container(
                width: 32.0,
                height: 32.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFEDE9FE),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: const [
                    Icon(
                      Icons.favorite_rounded,
                      color: Color(0xFF8B5CF6),
                      size: 18.0,
                    ),
                    Icon(
                      Icons.lock_rounded,
                      color: Colors.white,
                      size: 9.0,
                    ),
                  ],
                ),
              ),
              label: 'Sex Logged',
              value: '$sexLoggedCount',
              caption: 'this cycle',
            ),
          ),

          _buildDivider(),

          // 3. Days Logged
          Expanded(
            child: _buildMetricItem(
              onTap: onDaysLoggedTap,
              icon: Icons.event_available_rounded,
              iconColor: const Color(0xFF10B981),
              iconBgColor: const Color(0xFFE8F5E9),
              label: 'Days Logged',
              value: '$daysLoggedCount',
              caption: 'this cycle',
            ),
          ),

          _buildDivider(),

          // 4. Current Mode
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onCurrentModeTap,
                borderRadius: BorderRadius.circular(12.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Golden Water Drop Icon
                            Container(
                              width: 32.0,
                              height: 32.0,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFEF3C7),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.water_drop_rounded,
                                  color: Color(0xFFF59E0B),
                                  size: 18.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 3.0),
                            const Text(
                              'Current Mode',
                              style: TextStyle(
                                fontSize: 8.5,
                                color: Color(0xFF7A708A),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 1.0),
                            Text(
                              currentModeName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1E1A3C),
                                height: 1.15,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 14.0,
                        color: Color(0xFFFF4D6D),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1.0,
      height: 48.0,
      color: const Color(0xFFF1ECF5),
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
    );
  }

  Widget _buildMetricItem({
    required VoidCallback? onTap,
    IconData? icon,
    Color? iconColor,
    Color? iconBgColor,
    Widget? customIcon,
    required String label,
    required String value,
    required String caption,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Container
              customIcon ??
                  Container(
                    width: 32.0,
                    height: 32.0,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 18.0,
                      ),
                    ),
                  ),

              const SizedBox(height: 3.0),

              // Label
              Text(
                label,
                style: const TextStyle(
                  fontSize: 8.5,
                  color: Color(0xFF7A708A),
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 1.0),

              // Value
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E1A3C),
                  height: 1.15,
                ),
              ),

              // Caption
              Text(
                caption,
                style: const TextStyle(
                  fontSize: 8.5,
                  color: Color(0xFF7A708A),
                  fontWeight: FontWeight.w500,
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
