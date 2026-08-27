import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Consistency tracking & insight accuracy banner card.
class AccuracyProgressBanner extends StatelessWidget {
  final int progressPercent;
  final VoidCallback? onTrackNow;

  const AccuracyProgressBanner({
    super.key,
    this.progressPercent = 80,
    this.onTrackNow,
  });

  @override
  Widget build(BuildContext context) {
    final progressRatio = (progressPercent / 100.0).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.large,
        border: Border.all(color: const Color(0xFFEFE9F3), width: 1.0),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // 1. Glowing 3D Purple Shield Icon
          Container(
            width: 46.0,
            height: 46.0,
            decoration: BoxDecoration(
              color: const Color(0xFFF3EDFA),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: const Color(0xFFE2D6F3), width: 1.0),
            ),
            child: const Center(
              child: Icon(
                Icons.shield_rounded,
                color: Color(0xFF8A64B8),
                size: 26.0,
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // 2. Middle Content & Progress Bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Know your body better',
                  style: AppTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.0,
                    color: const Color(0xFF1E1A3C),
                  ),
                ),
                const SizedBox(height: 1.0),
                Text(
                  'Track consistently to get more accurate insights',
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF7A708A),
                    fontSize: 10.5,
                  ),
                ),
                const SizedBox(height: 6.0),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: Container(
                          height: 5.0,
                          color: const Color(0xFFF3EDFA),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: progressRatio,
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFE84D75),
                                    Color(0xFFFF8FA2),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      '$progressPercent%',
                      style: const TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFE84D75),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.sm),

          // 3. "Track now" Outlined Pill Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTrackNow,
              borderRadius: AppRadius.pill,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.pill,
                  border: Border.all(
                    color: const Color(0xFFFFD4E2),
                    width: 1.2,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Track now',
                    style: TextStyle(
                      color: Color(0xFFE84D75),
                      fontWeight: FontWeight.w800,
                      fontSize: 12.0,
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
