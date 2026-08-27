import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Today's Wellness Insight & Micro-Metrics Summary Card.
class TodayInsightCard extends StatelessWidget {
  final String title;
  final String message;
  final String sleepValue;
  final String waterValue;
  final String stepsValue;
  final VoidCallback? onTap;

  const TodayInsightCard({
    super.key,
    this.title = "Today's Insight ✨",
    this.message =
        'Your sleep quality improved 15% in this cycle. Keep it up! 💜',
    this.sleepValue = '7h 20m',
    this.waterValue = '6 / 8 cups',
    this.stepsValue = '6,432',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.large,
          border: Border.all(color: const Color(0xFFEFE9F3), width: 1.0),
          boxShadow: AppShadows.card,
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Serene Sleeping Illustration Banner Container
                Container(
                  width: 76.0,
                  height: 76.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF38236B), Color(0xFF7149A6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: const [
                      Positioned(
                        top: 8.0,
                        left: 10.0,
                        child: Row(
                          children: [
                            Icon(
                              Icons.nightlight_round,
                              size: 13.0,
                              color: Color(0xFFFFD480),
                            ),
                            SizedBox(width: 2.0),
                            Icon(
                              Icons.auto_awesome,
                              size: 9.0,
                              color: Colors.white70,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 6.0,
                        child: Icon(
                          Icons.face_3_rounded,
                          color: Colors.white,
                          size: 40.0,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: AppSpacing.md),

                // 2. Insight Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.subtitle.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 14.5,
                          color: const Color(0xFF6C449B),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      Text(
                        message,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 12.5,
                          color: const Color(0xFF1E1A3C),
                          height: 1.3,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: AppSpacing.xs),

                // 3. Circular Chevron Action Button
                Container(
                  width: 32.0,
                  height: 32.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F5F9),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFEFE9F3),
                      width: 0.8,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.chevron_right_rounded,
                      size: 18.0,
                      color: Color(0xFF6C449B),
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: onTap ?? () {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1.0, color: Color(0xFFEFE9F3)),
            const SizedBox(height: AppSpacing.sm + 2.0),

            // 4. Micro Metrics: Sleep, Water, Steps
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetricItem(
                    icon: Icons.nightlight_round,
                    color: const Color(0xFF6C449B),
                    label: 'Sleep',
                    value: sleepValue,
                  ),
                  const SizedBox(width: 12.0),
                  Container(
                    width: 1.0,
                    height: 24.0,
                    color: const Color(0xFFEFE9F3),
                  ),
                  const SizedBox(width: 12.0),
                  _buildMetricItem(
                    icon: Icons.water_drop_rounded,
                    color: const Color(0xFF5D9CEC),
                    label: 'Water',
                    value: waterValue,
                  ),
                  const SizedBox(width: 12.0),
                  Container(
                    width: 1.0,
                    height: 24.0,
                    color: const Color(0xFFEFE9F3),
                  ),
                  const SizedBox(width: 12.0),
                  _buildMetricItem(
                    icon: Icons.directions_run_rounded,
                    color: const Color(0xFF8A64B8),
                    label: 'Steps',
                    value: stepsValue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16.0),
        const SizedBox(width: 6.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                fontSize: 9.5,
                color: const Color(0xFF7A708A),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.body.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E1A3C),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
