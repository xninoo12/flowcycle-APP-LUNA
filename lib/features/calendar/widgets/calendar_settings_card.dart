import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Calendar settings entry card.
class CalendarSettingsCard extends StatelessWidget {
  final VoidCallback? onTap;

  const CalendarSettingsCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.large,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.large,
            border: Border.all(color: const Color(0xFFEFE9F3), width: 1.0),
            boxShadow: AppShadows.card,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              // 1. Settings Icon in Soft Pink Container
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE8EF),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Center(
                  child: Icon(
                    Icons.settings_outlined,
                    color: Color(0xFFE84D75),
                    size: 22.0,
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              // 2. Title & Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calendar settings',
                      style: AppTextStyles.subtitle.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                        color: const Color(0xFF1E1A3C),
                      ),
                    ),
                    const SizedBox(height: 1.0),
                    Text(
                      'Customize what you see on your calendar',
                      style: AppTextStyles.caption.copyWith(
                        color: const Color(0xFF7A708A),
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              // 3. Pink Chevron Arrow
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFE84D75),
                size: 22.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
