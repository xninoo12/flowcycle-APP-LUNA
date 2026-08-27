import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Branding header for FlowCycle displaying the app title, leaf glyph,
/// sub-brand platform line, tagline, and supporting description.
class SplashBranding extends StatelessWidget {
  const SplashBranding({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. FlowCycle Brand Title with Leaf Accent
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: AppTextStyles.display.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 34.0,
                  letterSpacing: -0.6,
                  fontFamily: 'serif',
                ),
                children: const [
                  TextSpan(
                    text: 'Flow',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  TextSpan(
                    text: 'Cycle',
                    style: TextStyle(color: AppColors.primaryRose),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            const Icon(
              Icons.eco_rounded,
              size: 20.0,
              color: AppColors.primaryRose,
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.xs + 2.0),

        // 2. Sub-brand Platform Divider Line: — • AI HEALTH PLATFORM • —
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 24.0, height: 1.0, color: AppColors.border),
            const SizedBox(width: AppSpacing.xs),
            Container(
              width: 3.5,
              height: 3.5,
              decoration: const BoxDecoration(
                color: AppColors.primaryRose,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.xs + 2.0),
            Text(
              'AI HEALTH PLATFORM',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.6,
              ),
            ),
            const SizedBox(width: AppSpacing.xs + 2.0),
            Container(
              width: 3.5,
              height: 3.5,
              decoration: const BoxDecoration(
                color: AppColors.primaryRose,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Container(width: 24.0, height: 1.0, color: AppColors.border),
          ],
        ),

        const SizedBox(height: AppSpacing.sm + 2.0),

        // 3. Tagline: Understand. Track. Thrive.
        Text(
          'Understand. Track. Thrive.',
          style: AppTextStyles.title.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
            letterSpacing: 0.2,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppSpacing.xs),

        // 4. Subtitle
        Text(
          'A personalized wellness companion\nfor your cycle & fertility',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            fontSize: 13.0,
            height: 1.35,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
