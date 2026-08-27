import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Intercourse Logging & Timings Card for TTC Dashboard.
class TtcIntercourseCard extends StatelessWidget {
  final bool isLogged;
  final String bestTimeText;
  final VoidCallback? onEdit;
  final VoidCallback? onViewHistory;

  const TtcIntercourseCard({
    super.key,
    this.isLogged = true,
    this.bestTimeText = '2:30 PM',
    this.onEdit,
    this.onViewHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.large,
        border: Border.all(color: const Color(0xFFEFE9F3), width: 1.0),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(AppSpacing.sm + 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header: Title + Edit Link
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Intercourse',
                  style: AppTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    color: const Color(0xFF1E1A3C),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: onEdit,
                borderRadius: BorderRadius.circular(4.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 2.0,
                  ),
                  child: Text(
                    'Edit',
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFFE84D75),
                      fontWeight: FontWeight.w700,
                      fontSize: 11.5,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm + 2.0),

          // 2. Donut Graphic + Details Row
          Row(
            children: [
              // Donut Ring Indicator
              Container(
                width: 66.0,
                height: 66.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFF4E7E),
                    width: 4.5,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.favorite_rounded,
                        color: Color(0xFFE84D75),
                        size: 20.0,
                      ),
                      const SizedBox(height: 1.0),
                      Text(
                        'Logged',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFE84D75),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.sm + 4.0),

              // Details Column: Today (Yes) + Best time (2:30 PM)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 9.5,
                        color: const Color(0xFF7A708A),
                      ),
                    ),
                    Text(
                      isLogged ? 'Yes' : 'No',
                      style: AppTextStyles.body.copyWith(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFE84D75),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Best time',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 9.5,
                        color: const Color(0xFF7A708A),
                      ),
                    ),
                    Text(
                      bestTimeText,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E1A3C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm + 4.0),

          // 3. View history Link
          InkWell(
            onTap: onViewHistory,
            borderRadius: BorderRadius.circular(4.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      'View history',
                      style: AppTextStyles.caption.copyWith(
                        color: const Color(0xFFE84D75),
                        fontWeight: FontWeight.w700,
                        fontSize: 11.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 3.0),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Color(0xFFE84D75),
                    size: 13.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
