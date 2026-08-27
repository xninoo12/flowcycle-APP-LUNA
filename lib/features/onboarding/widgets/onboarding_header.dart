import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/flow_cycle_theme_extension.dart';
import '../../../shared/widgets/brand/flow_cycle_brand_header.dart';
import '../../../shared/widgets/buttons/app_icon_button.dart';

/// Reusable top header for the Adaptive Onboarding flow featuring
/// navigation back action, FlowCycle branding, sleek gradient progress indicator,
/// optional icon badge, and inline "Why we ask this" rationale trigger.
class OnboardingHeader extends StatelessWidget {
  final VoidCallback onBack;
  final double progress;
  final String title;
  final String subtitle;
  final String? questionText;
  final String? helperText;
  final IconData? iconBadge;
  final VoidCallback? onWhyWeAsk;
  final bool showTitleAndSubtitle;

  const OnboardingHeader({
    super.key,
    required this.onBack,
    required this.progress,
    required this.title,
    required this.subtitle,
    this.questionText,
    this.helperText,
    this.iconBadge,
    this.onWhyWeAsk,
    this.showTitleAndSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.flowTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Top Navigation Bar with Centered FlowCycle Branding & Tagline
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              iconSize: 18.0,
              onPressed: onBack,
            ),
            const FlowCycleBrandHeader(
              crossAxisAlignment: CrossAxisAlignment.center,
              size: BrandHeaderSize.standard,
              showTagline: true,
            ),
            // Symmetrical spacing / helper badge
            Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: theme.containerLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.auto_awesome,
                  color: theme.primary,
                  size: 18.0,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12.0),

        // 2. Reusable Sleek Progress Indicator with Theme Gradient Fill
        Container(
          width: double.infinity,
          height: 4.5,
          decoration: BoxDecoration(
            color: theme.chipBackground,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: progress),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: value.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: theme.primaryGradient,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        if (showTitleAndSubtitle) ...[
          const SizedBox(height: AppSpacing.md),

          // 3. Step Title with Optional Icon Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (iconBadge != null) ...[
                Container(
                  width: 38.0,
                  height: 38.0,
                  decoration: BoxDecoration(
                    color: theme.containerLight,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: theme.chipBorder,
                      width: 1.0,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      iconBadge,
                      color: theme.primary,
                      size: 20.0,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w900,
                    color: theme.textPrimary,
                    letterSpacing: -0.4,
                    fontFamily: 'serif',
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4.0),

          // 4. Reassuring Subtitle
          Text(
            subtitle,
            style: TextStyle(
              color: theme.textSecondary,
              fontSize: 13.5,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),

          if (questionText != null) ...[
            const SizedBox(height: 16.0),
            Text(
              questionText!,
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 19.0,
                fontWeight: FontWeight.w900,
                color: theme.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            if (helperText != null || onWhyWeAsk != null) ...[
              const SizedBox(height: 6.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (helperText != null)
                    Expanded(
                      child: Text(
                        helperText!,
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          color: theme.textSecondary,
                        ),
                      ),
                    ),
                  if (onWhyWeAsk != null)
                    GestureDetector(
                      onTap: onWhyWeAsk,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: theme.containerLight,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: theme.chipBorder,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 13.0,
                              color: theme.primary,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              'Why we ask this',
                              style: TextStyle(
                                fontSize: 11.0,
                                fontWeight: FontWeight.w700,
                                color: theme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ],
      ],
    );
  }
}
