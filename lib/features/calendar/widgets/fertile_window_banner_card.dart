import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// "Your fertile window" insight banner card for Calendar screen.
class FertileWindowBannerCard extends StatelessWidget {
  final VoidCallback? onLearnMore;

  const FertileWindowBannerCard({super.key, this.onLearnMore});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.large,
        border: Border.all(color: const Color(0xFFFDE8EF), width: 1.0),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Smiling Flower Character Illustration
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F5),
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: const Center(
              child: Icon(
                Icons.spa_rounded,
                color: Color(0xFFFF5E82),
                size: 28.0,
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // 2. Fertile Window Message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your fertile window',
                  style: AppTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                    color: const Color(0xFF059669),
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  'Great time to try! You have high chances of conception over the next 2 days.',
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF7A708A),
                    fontSize: 11.5,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.sm),

          // 3. "Learn more" Outlined Pill Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onLearnMore,
              borderRadius: AppRadius.pill,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 7.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.pill,
                  border: Border.all(
                    color: const Color(0xFFFFD4E2),
                    width: 1.2,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Learn more',
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFFE84D75),
                      fontWeight: FontWeight.w700,
                      fontSize: 11.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
