import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Floating, open-space Hero Widget for Fertile Window / Cycle Day summary on Calendar Screen.
class FertileWindowHeroWidget extends StatelessWidget {
  final int day;
  final String weekdayName;
  final String monthName;
  final String badgeText;
  final String headingText;
  final String subtitleText;
  final VoidCallback? onTap;

  const FertileWindowHeroWidget({
    super.key,
    this.day = 14,
    this.weekdayName = 'WED',
    this.monthName = 'May',
    this.badgeText = 'FERTILE WINDOW',
    this.headingText = 'High fertility chance',
    this.subtitleText = 'Your body is getting close to ovulation.',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.0),
          border: Border.all(
            color: const Color(0xFFF1ECF5),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E1A3C).withValues(alpha: 0.03),
              blurRadius: 12.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Circular Date Badge with Purple Progress Ring
            SizedBox(
              width: 68.0,
              height: 68.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(68.0, 68.0),
                    painter: _DateProgressArcPainter(
                      progress: 0.72,
                      color: const Color(0xFF8B5CF6),
                      trackColor: const Color(0xFFF3E8FF),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        weekdayName.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E1A3C),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        '$day',
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E1A3C),
                          height: 1.0,
                        ),
                      ),
                      Text(
                        monthName,
                        style: const TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7A708A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 14.0),

            // 2. Fertile Window & High Fertility Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Green Fertile Window Pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 3.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_awesome_rounded,
                          size: 11.0,
                          color: Color(0xFF10B981),
                        ),
                        const SizedBox(width: 4.0),
                        Flexible(
                          child: Text(
                            badgeText.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF10B981),
                              letterSpacing: 0.3,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    headingText,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E1A3C),
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    subtitleText,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7A708A),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8.0),

            // 3. Botanical Pastel Leaves Artwork
            SizedBox(
              width: 54.0,
              height: 64.0,
              child: CustomPaint(
                painter: _PastelBotanicalLeavesPainter(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for the circular date progress arc.
class _DateProgressArcPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;

  _DateProgressArcPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 6.0) / 2;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress Arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      progress * 2 * math.pi,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DateProgressArcPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Custom painter for pastel pink/lilac botanical leaves illustration on right side.
class _PastelBotanicalLeavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final lilacPaint = Paint()
      ..color = const Color(0xFFDDD6FE).withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;

    final pinkPaint = Paint()
      ..color = const Color(0xFFFBCFE8).withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;

    final stemPaint = Paint()
      ..color = const Color(0xFFC4B5FD).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final path = Path();
    // Central stem
    path.moveTo(size.width * 0.7, size.height * 0.95);
    path.quadraticBezierTo(
      size.width * 0.45,
      size.height * 0.5,
      size.width * 0.2,
      size.height * 0.1,
    );
    canvas.drawPath(path, stemPaint);

    // Leaf pairs
    _drawLeaf(canvas, Offset(size.width * 0.2, size.height * 0.1), -0.7, lilacPaint, 9.0);
    _drawLeaf(canvas, Offset(size.width * 0.35, size.height * 0.3), -0.9, lilacPaint, 11.0);
    _drawLeaf(canvas, Offset(size.width * 0.5, size.height * 0.35), 0.4, pinkPaint, 11.0);
    _drawLeaf(canvas, Offset(size.width * 0.45, size.height * 0.55), -0.8, lilacPaint, 12.0);
    _drawLeaf(canvas, Offset(size.width * 0.62, size.height * 0.6), 0.5, pinkPaint, 12.0);
    _drawLeaf(canvas, Offset(size.width * 0.58, size.height * 0.78), -0.7, lilacPaint, 10.0);
    _drawLeaf(canvas, Offset(size.width * 0.75, size.height * 0.82), 0.4, pinkPaint, 10.0);
  }

  void _drawLeaf(Canvas canvas, Offset origin, double angle, Paint paint, double radius) {
    canvas.save();
    canvas.translate(origin.dx, origin.dy);
    canvas.rotate(angle);

    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(radius * 0.8, -radius * 0.5, radius * 1.5, 0);
    path.quadraticBezierTo(radius * 0.8, radius * 0.5, 0, 0);
    canvas.drawPath(path, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
