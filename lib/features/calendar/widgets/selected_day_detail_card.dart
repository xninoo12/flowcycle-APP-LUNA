import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Selected Day Detail & Logged Events Card for Calendar.
class SelectedDayDetailCard extends StatelessWidget {
  final String dateTitle;
  final String phaseBadgeText;
  final String chanceBadgeText;
  final String bbtBadgeText;
  final String loggedEventText;
  final VoidCallback? onEventTap;

  const SelectedDayDetailCard({
    super.key,
    this.dateTitle = 'Wednesday, May 14',
    this.phaseBadgeText = 'Ovulation',
    this.chanceBadgeText = 'High chance',
    this.bbtBadgeText = 'BBT: 36.72°C',
    this.loggedEventText = 'You logged intercourse',
    this.onEventTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // 1. Date Heading
          Text(
            dateTitle,
            style: AppTextStyles.subtitle.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 16.0,
              color: const Color(0xFF1E1A3C),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // 2. 3 Metric Badges Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildBadge(
                  icon: Icons.radio_button_checked_rounded,
                  label: phaseBadgeText,
                ),
                const SizedBox(width: 8.0),
                _buildBadge(
                  icon: Icons.favorite_rounded,
                  label: chanceBadgeText,
                ),
                const SizedBox(width: 8.0),
                _buildBadge(
                  icon: Icons.show_chart_rounded,
                  label: bbtBadgeText,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // 3. Logged Event Tile
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onEventTap,
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm + 4.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF7F2),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: const Color(0xFFEDE8E0),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.mode_edit_outline_rounded,
                      color: Color(0xFFE84D75),
                      size: 18.0,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        loggedEventText,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E1A3C),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFFE84D75),
                      size: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F8F0),
        borderRadius: AppRadius.pill,
        border: Border.all(
          color: const Color(0xFF43C59E).withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.0, color: const Color(0xFF059669)),
          const SizedBox(width: 4.0),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF059669),
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
