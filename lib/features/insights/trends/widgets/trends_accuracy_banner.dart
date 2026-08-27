import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';

/// Bottom AI tracking accuracy callout banner for Trends subscreen.
class TrendsAccuracyBanner extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const TrendsAccuracyBanner({
    super.key,
    this.text =
        'Tracking consistently helps improve the accuracy of your predictions.',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.large,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 12.0,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F5),
            borderRadius: AppRadius.large,
            border: Border.all(color: const Color(0xFFFFD4E2), width: 1.0),
            boxShadow: AppShadows.card,
          ),
          child: Row(
            children: [
              // Shield Icon Container
              Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE1EA),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Center(
                  child: Icon(
                    Icons.security_rounded,
                    color: Color(0xFFE84D75),
                    size: 19.0,
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.sm + 4.0),

              // Text
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E1A3C),
                    height: 1.3,
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.xs),

              // Right Chevron
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF8A64B8),
                size: 22.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
