import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Next Period Countdown & Logging card for Cycle Awareness Dashboard.
class NextPeriodCard extends StatelessWidget {
  final int daysRemaining;
  final String statusText;
  final VoidCallback? onLogPeriod;
  final VoidCallback? onTap;

  const NextPeriodCard({
    super.key,
    this.daysRemaining = 0,
    this.statusText = 'Expected today',
    this.onLogPeriod,
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
        padding: const EdgeInsets.all(AppSpacing.sm + 4.0),
        child: Stack(
          children: [
            // 3D Calendar Graphic Illustration on Right
            Positioned(
              right: -4.0,
              bottom: 4.0,
              child: _buildCalendarGraphic(),
            ),

            // Content Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.water_drop_rounded,
                          size: 12.0,
                          color: Color(0xFFE84D75),
                        ),
                        const SizedBox(width: 4.0),
                        Flexible(
                          child: Text(
                            'NEXT PERIOD',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFE84D75),
                              letterSpacing: 0.8,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      daysRemaining == 0
                          ? 'Today'
                          : '$daysRemaining ${daysRemaining == 1 ? 'day' : 'days'}',
                      style: AppTextStyles.title.copyWith(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF1E1A3C),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      statusText,
                      style: AppTextStyles.caption.copyWith(
                        color: const Color(0xFF7A708A),
                        fontWeight: FontWeight.w500,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                InkWell(
                  onTap: onLogPeriod,
                  borderRadius: BorderRadius.circular(4.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      'Log period →',
                      style: AppTextStyles.caption.copyWith(
                        color: const Color(0xFFE84D75),
                        fontWeight: FontWeight.w700,
                        fontSize: 11.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGraphic() {
    return Container(
      width: 58.0,
      height: 58.0,
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEF3),
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: const Color(0xFFFFD4E2), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE84D75).withValues(alpha: 0.16),
            blurRadius: 8.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Top binder rings
          Positioned(
            top: 4.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 4.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE84D75),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
                const SizedBox(width: 10.0),
                Container(
                  width: 4.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE84D75),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ],
            ),
          ),
          // Center Droplet
          const Icon(
            Icons.water_drop_rounded,
            color: Color(0xFFE84D75),
            size: 26.0,
          ),
        ],
      ),
    );
  }
}
