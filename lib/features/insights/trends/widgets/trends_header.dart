import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Top header for Trends subscreen with back button, pink lotus flower accent, and action buttons.
class TrendsHeader extends StatelessWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onCalendarTap;
  final VoidCallback? onMoreTap;

  const TrendsHeader({
    super.key,
    this.onBackTap,
    this.onCalendarTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Circular Back Button
        GestureDetector(
          onTap: () {
            if (onBackTap != null) {
              onBackTap!();
            } else {
              try {
                if (Navigator.of(context).canPop()) {
                  context.pop();
                } else {
                  context.go(AppRoutes.insightsPath);
                }
              } catch (_) {
                context.go(AppRoutes.insightsPath);
              }
            }
          },
          child: Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFF1ECF5),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E1A3C).withValues(alpha: 0.03),
                  blurRadius: 8.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.chevron_left_rounded,
                color: Color(0xFF1E1A3C),
                size: 26.0,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12.0),

        // 2. Title & Subtitle with Lotus Accent
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Trends',
                    style: AppTextStyles.title.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 24.0,
                      color: const Color(0xFF1E1A3C),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  const Text(
                    '✦',
                    style: TextStyle(
                      color: Color(0xFFF59E0B),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  const _LotusMiniIcon(),
                ],
              ),
              const SizedBox(height: 1.0),
              Text(
                'See patterns in your cycle over time',
                style: AppTextStyles.caption.copyWith(
                  color: const Color(0xFF7A708A),
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // 3. Right Action Buttons: Calendar + 3-Dots
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onCalendarTap ?? () {},
              child: Container(
                width: 38.0,
                height: 38.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF1ECF5), width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E1A3C).withValues(alpha: 0.03),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.calendar_today_rounded,
                    color: Color(0xFFE84855),
                    size: 17.0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            GestureDetector(
              onTap: onMoreTap ?? () {},
              child: Container(
                width: 38.0,
                height: 38.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF1ECF5), width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E1A3C).withValues(alpha: 0.03),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.more_vert_rounded,
                    color: Color(0xFF1E1A3C),
                    size: 20.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LotusMiniIcon extends StatelessWidget {
  const _LotusMiniIcon();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '🌸',
      style: TextStyle(fontSize: 16.0),
    );
  }
}
