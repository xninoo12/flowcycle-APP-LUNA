import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 3-Card Split Row (Intercourse, Consistency, Body Balance) for Insights screen matching the exact mockup.
class IntercourseAndSymptomsRow extends StatelessWidget {
  final int intercourseTimes;
  final int intercourseDiff;
  final int consistencyPercent;
  final String symptomsStatus;
  final VoidCallback? onIntercourseTap;
  final VoidCallback? onConsistencyTap;
  final VoidCallback? onSymptomsTap;

  const IntercourseAndSymptomsRow({
    super.key,
    this.intercourseTimes = 0,
    this.intercourseDiff = 0,
    this.consistencyPercent = 0,
    this.symptomsStatus = 'No logs yet',
    this.onIntercourseTap,
    this.onConsistencyTap,
    this.onSymptomsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Intercourse Card
        Expanded(
          child: _buildCard(
            onTap: onIntercourseTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Intercourse',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontWeight: FontWeight.w800,
                          fontSize: 11.5,
                          color: Color(0xFF1E1A3C),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 2.0),
                    Container(
                      width: 18.0,
                      height: 18.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFEEF0),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.favorite_rounded,
                          color: Color(0xFFE84855),
                          size: 11.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3.0),
                const Text(
                  'This cycle',
                  style: TextStyle(
                    fontSize: 9.0,
                    color: Color(0xFF7A708A),
                  ),
                ),
                const SizedBox(height: 1.0),
                Text(
                  '$intercourseTimes times',
                  style: const TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFE84855),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text.rich(
                  TextSpan(
                    text: 'Vs. last cycle: ',
                    style: const TextStyle(
                      fontSize: 8.0,
                      color: Color(0xFF7A708A),
                    ),
                    children: [
                      TextSpan(
                        text: '+ $intercourseDiff time',
                        style: const TextStyle(
                          fontSize: 8.0,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFE84855),
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 6.0),

        // 2. Consistency Card
        Expanded(
          child: _buildCard(
            onTap: onConsistencyTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Consistency',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontWeight: FontWeight.w800,
                          fontSize: 11.5,
                          color: Color(0xFF1E1A3C),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 2.0),
                    SizedBox(
                      width: 22.0,
                      height: 22.0,
                      child: CustomPaint(
                        painter: _MiniGaugePainter(
                          percent: consistencyPercent / 100,
                          color: const Color(0xFF8B5CF6),
                        ),
                        child: Center(
                          child: Text(
                            '$consistencyPercent%',
                            style: const TextStyle(
                              fontSize: 6.5,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E1A3C),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3.0),
                const Text(
                  'Keep it up!',
                  style: TextStyle(
                    fontSize: 9.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E1A3C),
                  ),
                ),
                const Text(
                  "You're doing great",
                  style: TextStyle(
                    fontSize: 8.5,
                    color: Color(0xFF7A708A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(
                      child: Text(
                        'Track consistently',
                        style: TextStyle(
                          fontSize: 8.0,
                          color: Color(0xFF7A708A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 11.0,
                      color: Color(0xFF7A708A),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 6.0),

        // 3. Body Balance Card
        Expanded(
          child: _buildCard(
            onTap: onSymptomsTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Body balance',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontWeight: FontWeight.w800,
                          fontSize: 11.5,
                          color: Color(0xFF1E1A3C),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 2.0),
                    SizedBox(
                      width: 22.0,
                      height: 14.0,
                      child: CustomPaint(
                        painter: _SemiArcGaugePainter(color: const Color(0xFF8B5CF6)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3.0),
                const Text(
                  'This cycle',
                  style: TextStyle(
                    fontSize: 9.0,
                    color: Color(0xFF7A708A),
                  ),
                ),
                Text(
                  symptomsStatus,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF6366F1),
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(
                      child: Text(
                        'In good balance',
                        style: TextStyle(
                          fontSize: 8.0,
                          color: Color(0xFF7A708A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 11.0,
                      color: Color(0xFF7A708A),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required Widget child, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: const Color(0xFFF1ECF5), width: 1.0),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E1A3C).withValues(alpha: 0.025),
                blurRadius: 8.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 8.0),
          child: child,
        ),
      ),
    );
  }
}

class _MiniGaugePainter extends CustomPainter {
  final double percent;
  final Color color;

  const _MiniGaugePainter({required this.percent, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2.0;

    final bgPaint = Paint()
      ..color = const Color(0xFFEDE9FE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(center, radius, bgPaint);

    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.5;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * percent,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _MiniGaugePainter oldDelegate) =>
      oldDelegate.percent != percent || oldDelegate.color != color;
}

class _SemiArcGaugePainter extends CustomPainter {
  final Color color;

  const _SemiArcGaugePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 1.0;

    final bgPaint = Paint()
      ..color = const Color(0xFFEDE9FE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      bgPaint,
    );

    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.5;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi * 0.75,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
