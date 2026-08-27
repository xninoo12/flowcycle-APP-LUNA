import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Three horizontally arranged feature cards highlighting FlowCycle's core value:
/// - Track: Your cycle
/// - Predict: Your patterns
/// - Feel in Control: Every day
class SplashFeatureCards extends StatelessWidget {
  const SplashFeatureCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _FeatureCard(
            icon: Icons.calendar_month_outlined,
            title: 'Track',
            subtitle: 'Your cycle',
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _FeatureCard(
            icon: Icons.show_chart_rounded,
            title: 'Predict',
            subtitle: 'Your patterns',
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _FeatureCard(
            icon: Icons.spa_outlined,
            title: 'Feel in Control',
            subtitle: 'Every day',
            isSmallTitle: true,
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSmallTitle;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isSmallTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.border, width: 0.8),
        boxShadow: AppShadows.subtle,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular Soft Rose Icon Container
          Container(
            width: 44.0,
            height: 44.0,
            decoration: const BoxDecoration(
              color: AppColors.primaryRoseLight,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(icon, color: AppColors.primaryRose, size: 22.0),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Title
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              fontSize: isSmallTitle ? 12.0 : 13.5,
              letterSpacing: -0.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 2.0),

          // Subtitle
          Text(
            subtitle,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11.0,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
