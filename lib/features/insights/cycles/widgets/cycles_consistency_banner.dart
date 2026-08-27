import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Consistency feedback banner card for Cycles subscreen.
class CyclesConsistencyBanner extends StatelessWidget {
  final String title;
  final String subtitle;

  const CyclesConsistencyBanner({
    super.key,
    this.title = 'Your cycles are looking consistent!',
    this.subtitle = 'Keep logging to get more accurate insights.',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F5),
        borderRadius: AppRadius.large,
        border: Border.all(color: const Color(0xFFFFD4E2), width: 1.0),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          // 1. Sprout Icon in Circular Container
          Container(
            width: 44.0,
            height: 44.0,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE1EA),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFFBACD), width: 1.0),
            ),
            child: const Center(
              child: Icon(
                Icons.eco_rounded,
                color: Color(0xFFE84D75),
                size: 22.0,
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // 2. Message Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.0,
                    color: const Color(0xFF1E1A3C),
                  ),
                ),
                const SizedBox(height: 1.0),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF7A708A),
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
          ),

          // 3. Subtle Leaf Graphic Icon on Right
          const Icon(Icons.spa_outlined, color: Color(0xFFFFD4E2), size: 28.0),
        ],
      ),
    );
  }
}
