import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Prominent, floating open-space Cycle Dial for Cycle Awareness Dashboard.
///
/// Features numbered 28-day segmented phase track, active day glowing bead,
/// central floating hub with blooming purple flower and fertility status,
/// and phase color legend.
class CycleRingCard extends StatefulWidget {
  final int currentDay;
  final int totalDays;
  final String phaseName;
  final String phaseDescription;
  final String nextPeriodText;
  final String dateString;
  final String fertilityStatus;
  final VoidCallback? onCalendarTap;
  final VoidCallback? onTap;
  final bool animate;

  const CycleRingCard({
    super.key,
    this.currentDay = 8,
    this.totalDays = 28,
    this.phaseName = 'Follicular Phase',
    this.phaseDescription = 'Your energy is rising and follicles are maturing.',
    this.nextPeriodText = 'expected in 20 days',
    this.dateString = 'Today • May 24',
    this.fertilityStatus = 'Low Fertility',
    this.onCalendarTap,
    this.onTap,
    this.animate = false,
  });

  @override
  State<CycleRingCard> createState() => _CycleRingCardState();
}

class _CycleRingCardState extends State<CycleRingCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );

    if (widget.animate) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Date & Phase Title Header
        Text(
          widget.dateString,
          style: const TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w600,
            color: Color(0xFF7A708A),
          ),
        ),
        const SizedBox(height: 4.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.spa_rounded,
              color: Color(0xFF8B5CF6),
              size: 20.0,
            ),
            const SizedBox(width: 6.0),
            Flexible(
              child: Text(
                widget.phaseName,
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 24.0,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E1A3C),
                  letterSpacing: -0.3,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2.0),
        Text(
          'Cycle Day ${widget.currentDay} of ${widget.totalDays}',
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF7A708A),
          ),
        ),

        const SizedBox(height: 16.0),

        // 2. Open-Space Prominent Hero Cycle Dial (280dp)
        Semantics(
          button: true,
          label:
              'Cycle Ring: Day ${widget.currentDay} of ${widget.totalDays}, ${widget.phaseName}',
          child: GestureDetector(
            onTap: widget.onTap,
            behavior: HitTestBehavior.opaque,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: 280.0,
                height: 280.0,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Outer Ambient Breathing Aura Glow
                  if (widget.animate)
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: child,
                        );
                      },
                      child: Container(
                        width: 250.0,
                        height: 250.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6)
                                  .withValues(alpha: 0.12),
                              blurRadius: 36.0,
                              spreadRadius: 8.0,
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Custom Painter: Segmented Numbered Track
                  CustomPaint(
                    size: const Size(280.0, 280.0),
                    painter: _CycleDialPainter(
                      currentDay: widget.currentDay,
                      totalDays: widget.totalDays,
                    ),
                  ),

                  // Central Floating Frosted Hub
                  Container(
                    width: 176.0,
                    height: 176.0,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.94),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFFFEEF3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E1A3C)
                              .withValues(alpha: 0.05),
                          blurRadius: 18.0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "You're doing great ✨",
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7A708A),
                          ),
                        ),
                        const SizedBox(height: 3.0),
                        Text(
                          widget.fertilityStatus,
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 19.5,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1A3C),
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 1.0),
                        const Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7A708A),
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        // Blooming Purple Dahlia Flower
                        SizedBox(
                          height: 44.0,
                          child: Image.asset(
                            'assets/images/cycle_wellness_flower.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.local_florist_rounded,
                              color: Color(0xFF8B5CF6),
                              size: 34.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Active Day Floating Badge
                  _buildActiveDayBadge(
                    currentDay: widget.currentDay,
                    totalDays: widget.totalDays,
                    radius: 120.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

        const SizedBox(height: 16.0),

        // 3. Phase Color Legend Row
        _buildPhaseLegend(),
      ],
    );
  }

  Widget _buildActiveDayBadge({
    required int currentDay,
    required int totalDays,
    required double radius,
  }) {
    // Calculate angle: Day 1 starts at top (-pi/2)
    final double angle = -math.pi / 2 + ((currentDay - 0.5) / totalDays) * 2 * math.pi;
    final double x = radius * math.cos(angle);
    final double y = radius * math.sin(angle);

    return Transform.translate(
      offset: Offset(x, y),
      child: Container(
        width: 32.0,
        height: 32.0,
        decoration: BoxDecoration(
          color: const Color(0xFF7C5CE7),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C5CE7).withValues(alpha: 0.45),
              blurRadius: 10.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            '$currentDay',
            style: const TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhaseLegend() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12.0,
      runSpacing: 6.0,
      children: const [
        _LegendDot(color: Color(0xFFFF6B8B), label: 'Period'),
        _LegendDot(color: Color(0xFF9D7BE8), label: 'Follicular'),
        _LegendDot(color: Color(0xFF34D399), label: 'Fertile Window'),
        _LegendDot(color: Color(0xFFF59E0B), label: 'Ovulation'),
        _LegendDot(color: Color(0xFFC4B5FD), label: 'Luteal'),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7.5,
          height: 7.5,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.0,
            fontWeight: FontWeight.w600,
            color: Color(0xFF7A708A),
          ),
        ),
      ],
    );
  }
}

/// Custom painter for the 28-day segmented phase track with numbers.
class _CycleDialPainter extends CustomPainter {
  final int currentDay;
  final int totalDays;

  _CycleDialPainter({required this.currentDay, required this.totalDays});

  Color _getPhaseColor(int day, int total) {
    if (day <= 5) return const Color(0xFFFF6B8B); // Period
    if (day <= 11) return const Color(0xFF9D7BE8); // Follicular
    if (day <= 15) {
      if (day == 14) return const Color(0xFFF59E0B); // Ovulation
      return const Color(0xFF34D399); // Fertile Window
    }
    return const Color(0xFFC4B5FD); // Luteal
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double trackRadius = 120.0;
    final double innerTrackRadius = 94.0;
    final double trackWidth = trackRadius - innerTrackRadius;

    // Draw background track ring
    final bgPaint = Paint()
      ..color = const Color(0xFFF6F0FA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = trackWidth;
    canvas.drawCircle(center, (trackRadius + innerTrackRadius) / 2, bgPaint);

    final double stepAngle = (2 * math.pi) / totalDays;

    for (int day = 1; day <= totalDays; day++) {
      final double startAngle = -math.pi / 2 + (day - 1) * stepAngle;
      final double sweepAngle = stepAngle * 0.88;

      final color = _getPhaseColor(day, totalDays);

      final segmentPaint = Paint()
        ..color = color.withValues(alpha: day == currentDay ? 1.0 : 0.85)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = trackWidth * 0.78;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: (trackRadius + innerTrackRadius) / 2),
        startAngle + stepAngle * 0.06,
        sweepAngle,
        false,
        segmentPaint,
      );

      // Draw Day Number around perimeter
      final double numRadius = trackRadius + 14.0;
      final double numAngle = -math.pi / 2 + (day - 0.5) * stepAngle;
      final double numX = center.dx + numRadius * math.cos(numAngle);
      final double numY = center.dy + numRadius * math.sin(numAngle);

      final textSpan = TextSpan(
        text: '$day',
        style: TextStyle(
          fontSize: 9.0,
          fontWeight: day == currentDay ? FontWeight.w900 : FontWeight.w600,
          color: day == currentDay
              ? const Color(0xFF7C5CE7)
              : const Color(0xFF8C829A),
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(numX - textPainter.width / 2, numY - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CycleDialPainter oldDelegate) {
    return oldDelegate.currentDay != currentDay || oldDelegate.totalDays != totalDays;
  }
}
