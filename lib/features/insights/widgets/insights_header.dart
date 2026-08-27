import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Top header for the Insights main screen.
///
/// Features title "Insights ✦ 🌸" with lotus flower logo accent,
/// subtitle "Understand your body. Plan your future.",
/// calendar date picker button, and profile avatar.
class InsightsHeader extends StatelessWidget {
  final VoidCallback? onCalendarTap;
  final VoidCallback? onProfileTap;

  const InsightsHeader({super.key, this.onCalendarTap, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Title & Subtitle Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Insights',
                    style: AppTextStyles.title.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 26.0,
                      color: const Color(0xFF1E1A3C),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  const Text(
                    '✦',
                    style: TextStyle(
                      color: Color(0xFFF59E0B),
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  // Pink Lotus Flower Logo Accent
                  const _LotusHeaderLogo(size: 22.0),
                ],
              ),
              const SizedBox(height: 2.0),
              Text(
                'Understand your body. Plan your future.',
                style: AppTextStyles.caption.copyWith(
                  color: const Color(0xFF7A708A),
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        const SizedBox(width: AppSpacing.sm),

        // 2. Action Buttons (Calendar Picker + Profile Avatar)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38.0,
              height: 38.0,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFEFE9F3), width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E1A3C).withValues(alpha: 0.03),
                    blurRadius: 8.0,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.calendar_month_outlined,
                  color: Color(0xFF7A708A),
                  size: 19.0,
                ),
                padding: EdgeInsets.zero,
                tooltip: 'Calendar',
                onPressed: onCalendarTap ?? () {},
              ),
            ),

            const SizedBox(width: AppSpacing.sm),

            // Profile Avatar
            GestureDetector(
              onTap: onProfileTap ?? () {},
              child: Container(
                width: 38.0,
                height: 38.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFFD4E2),
                    width: 1.5,
                  ),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD4E2), Color(0xFFFFEEF3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const ClipOval(
                  child: Center(
                    child: Icon(
                      Icons.person_rounded,
                      color: Color(0xFFE84D75),
                      size: 24.0,
                    ),
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

/// Miniature Pink Lotus Flower Logo for Section Headers
class _LotusHeaderLogo extends StatelessWidget {
  final double size;

  const _LotusHeaderLogo({this.size = 20.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LotusFlowerPainter(),
      ),
    );
  }
}

class _LotusFlowerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.6);
    final scale = size.width / 24.0;

    final paint1 = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFF85A1), Color(0xFFFF4D6D)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFB3C1), Color(0xFFFF758F)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Central Petal
    final centerPetal = Path();
    centerPetal.moveTo(center.dx, center.dy + 4 * scale);
    centerPetal.cubicTo(
      center.dx - 6 * scale,
      center.dy - 4 * scale,
      center.dx - 4 * scale,
      center.dy - 14 * scale,
      center.dx,
      center.dy - 16 * scale,
    );
    centerPetal.cubicTo(
      center.dx + 4 * scale,
      center.dy - 14 * scale,
      center.dx + 6 * scale,
      center.dy - 4 * scale,
      center.dx,
      center.dy + 4 * scale,
    );
    canvas.drawPath(centerPetal, paint1);

    // Left Petal
    final leftPetal = Path();
    leftPetal.moveTo(center.dx, center.dy + 3 * scale);
    leftPetal.cubicTo(
      center.dx - 12 * scale,
      center.dy - 2 * scale,
      center.dx - 14 * scale,
      center.dy - 10 * scale,
      center.dx - 8 * scale,
      center.dy - 13 * scale,
    );
    leftPetal.cubicTo(
      center.dx - 2 * scale,
      center.dy - 8 * scale,
      center.dx,
      center.dy,
      center.dx,
      center.dy + 3 * scale,
    );
    canvas.drawPath(leftPetal, paint2);

    // Right Petal
    final rightPetal = Path();
    rightPetal.moveTo(center.dx, center.dy + 3 * scale);
    rightPetal.cubicTo(
      center.dx + 12 * scale,
      center.dy - 2 * scale,
      center.dx + 14 * scale,
      center.dy - 10 * scale,
      center.dx + 8 * scale,
      center.dy - 13 * scale,
    );
    rightPetal.cubicTo(
      center.dx + 2 * scale,
      center.dy - 8 * scale,
      center.dx,
      center.dy,
      center.dx,
      center.dy + 3 * scale,
    );
    canvas.drawPath(rightPetal, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
