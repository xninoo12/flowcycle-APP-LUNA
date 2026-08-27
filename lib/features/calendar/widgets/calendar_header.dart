import 'package:flutter/material.dart';

/// Top App Header for FlowCycle Calendar Screen matching the exact design mockup.
class CalendarHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onBackTap;
  final VoidCallback? onCalendarTap;
  final VoidCallback? onMoreTap;

  const CalendarHeader({
    super.key,
    this.title = 'Calendar',
    this.subtitle = 'Track your cycle & fertile window',
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
          onTap: onBackTap,
          child: Container(
            width: 42.0,
            height: 42.0,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFF1ECF5),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E1A3C).withValues(alpha: 0.04),
                  blurRadius: 10.0,
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

        // 2. Title & Subtitle with Leaf Icon
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 22.0,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1A3C),
                        letterSpacing: -0.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  // Pink/Coral Leaf Accent
                  Transform.rotate(
                    angle: 0.3,
                    child: const Icon(
                      Icons.eco_rounded,
                      color: Color(0xFFE84855),
                      size: 18.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2.0),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7A708A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // 3. Right Action Buttons: Calendar Picker + 3-Dots Options
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onCalendarTap,
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
                      color: const Color(0xFF1E1A3C).withValues(alpha: 0.04),
                      blurRadius: 10.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.calendar_today_rounded,
                    color: Color(0xFFE84855),
                    size: 18.0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            GestureDetector(
              onTap: onMoreTap,
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
                      color: const Color(0xFF1E1A3C).withValues(alpha: 0.04),
                      blurRadius: 10.0,
                      offset: const Offset(0, 2),
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
