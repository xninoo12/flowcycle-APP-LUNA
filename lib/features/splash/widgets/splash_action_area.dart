import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/buttons/primary_button.dart';

/// Action area for the FlowCycle Welcome screen displaying
/// the primary "Get Started" button, secondary "Sign In" link, and privacy assurance note.
class SplashActionArea extends StatelessWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onSignIn;

  const SplashActionArea({
    super.key,
    required this.onGetStarted,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Primary CTA: Get Started →
        PrimaryButton(
          label: 'Get Started',
          height: 52.0,
          gradient: AppGradients.dawnBloom,
          trailingIcon: Icons.arrow_forward_rounded,
          onPressed: onGetStarted,
        ),

        const SizedBox(height: AppSpacing.sm),

        // 2. Secondary Action: Already have an account? Sign In
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13.5,
                ),
              ),
              const SizedBox(width: 4.0),
              GestureDetector(
                onTap: onSignIn,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: 4.0,
                  ),
                  child: Text(
                    'Sign In',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primaryRose,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6.0),

        // 3. Privacy & Security Assurance: 🔒 Your data is private and secure.
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_rounded,
                size: 13.0,
                color: Color(0xFFFFA5BA),
              ),
              const SizedBox(width: 5.0),
              Text(
                'Your data is private and secure.',
                style: AppTextStyles.caption.copyWith(
                  color: const Color(0xFF9E95A8),
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
