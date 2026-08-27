import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// "Your fertility" detail summary card for TTC Calendar mode.
class TtcFertilityDetailCard extends StatelessWidget {
  final String fertilityChance;
  final String fertileWindowDates;
  final String supportiveText;
  final String intercourseLoggedText;
  final String cycleDayText;
  final VoidCallback? onTap;

  const TtcFertilityDetailCard({
    super.key,
    this.fertilityChance = 'High chance',
    this.fertileWindowDates = 'May 12 – May 17',
    this.supportiveText = 'Great time to try! 💜',
    this.intercourseLoggedText = 'May 13',
    this.cycleDayText = '14 of 28',
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. 3D Glowing Target Illustration Container
              Container(
                width: 58.0,
                height: 58.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFF85A1).withValues(alpha: 0.25),
                      const Color(0xFFFFEEF3),
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 44.0,
                    height: 44.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFFFF85A1).withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFFE84D75,
                          ).withValues(alpha: 0.15),
                          blurRadius: 6.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.track_changes_rounded,
                        color: Color(0xFFE84D75),
                        size: 26.0,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.sm + 4.0),

              // 2. Center Column: "Your fertility", "High chance", "May 12 – May 17"
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          color: Color(0xFFE84D75),
                          size: 11.0,
                        ),
                        const SizedBox(width: 3.0),
                        Flexible(
                          child: Text(
                            'Your fertility',
                            style: AppTextStyles.caption.copyWith(
                              color: const Color(0xFFE84D75),
                              fontWeight: FontWeight.w800,
                              fontSize: 11.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1.0),
                    Text(
                      fertilityChance,
                      style: AppTextStyles.subtitle.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 15.0,
                        color: const Color(0xFF1E1A3C),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1.0),
                    Text(
                      fertileWindowDates,
                      style: AppTextStyles.caption.copyWith(
                        color: const Color(0xFF059669),
                        fontWeight: FontWeight.w800,
                        fontSize: 11.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1.0),
                    Text(
                      supportiveText,
                      style: AppTextStyles.caption.copyWith(
                        color: const Color(0xFF7A708A),
                        fontSize: 10.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Vertical divider line
              Container(
                width: 1.0,
                height: 48.0,
                color: const Color(0xFFEFE9F3),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
              ),

              // 3. Right Column: Intercourse logged + Cycle day
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top item: Intercourse logged
                    Row(
                      children: [
                        Container(
                          width: 22.0,
                          height: 22.0,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFDE8EF),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.favorite_rounded,
                              color: Color(0xFFE84D75),
                              size: 11.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Intercourse',
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10.5,
                                  color: const Color(0xFF1E1A3C),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                intercourseLoggedText,
                                style: AppTextStyles.caption.copyWith(
                                  color: const Color(0xFF7A708A),
                                  fontSize: 9.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6.0),

                    // Bottom item: Cycle day
                    Row(
                      children: [
                        Container(
                          width: 22.0,
                          height: 22.0,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEEF2FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.show_chart_rounded,
                              color: Color(0xFF6C5CE7),
                              size: 12.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cycle day',
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10.5,
                                  color: const Color(0xFF1E1A3C),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                cycleDayText,
                                style: AppTextStyles.caption.copyWith(
                                  color: const Color(0xFF7A708A),
                                  fontSize: 9.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 2.0),

              // Pink Chevron
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFE84D75),
                size: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
