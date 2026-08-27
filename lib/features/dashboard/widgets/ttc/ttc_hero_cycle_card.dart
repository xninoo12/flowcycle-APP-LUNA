import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Prominent, floating open-space Cycle Dial for Trying to Conceive (TTC) Dashboard.
///
/// Features numbered segmented TTC phase track, active day glowing badge,
/// central floating hub with 3D heart, sunburst rays, and ovulation countdown,
/// and phase color legend matching the TTC design mockup.
class TtcHeroCycleCard extends StatefulWidget {
  final int currentDay;
  final int totalDays;
  final String statusHeading;
  final String bestDaysText;
  final String ovulationCountdownText;
  final String dateString;
  final VoidCallback? onLogIntercourse;
  final VoidCallback? onTap;
  final bool animate;

  const TtcHeroCycleCard({
    super.key,
    this.currentDay = 13,
    this.totalDays = 30,
    this.statusHeading = 'High Fertility',
    this.bestDaysText = 'May 24 – May 28',
    this.ovulationCountdownText = '3 Days',
    this.dateString = 'Today • May 24',
    this.onLogIntercourse,
    this.onTap,
    this.animate = false,
  });

  @override
  State<TtcHeroCycleCard> createState() => _TtcHeroCycleCardState();
}

class _TtcHeroCycleCardState extends State<TtcHeroCycleCard>
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
        // 1. Date & Status Heading
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
              Icons.favorite_rounded,
              color: Color(0xFFE81B54),
              size: 22.0,
            ),
            const SizedBox(width: 6.0),
            Flexible(
              child: Text(
                widget.statusHeading,
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 25.0,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFE81B54),
                  letterSpacing: -0.3,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2.0),
        Text(
          'Cycle Day ${widget.currentDay} • 3 days to ovulation',
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF7A708A),
          ),
        ),

        const SizedBox(height: 16.0),

        // 2. Open-Space Prominent Hero Conception Dial (280dp)
        Semantics(
          button: true,
          label:
              'TTC Conception Dial: Day ${widget.currentDay} of ${widget.totalDays}, ${widget.statusHeading}',
          child: GestureDetector(
            onTap: widget.onTap,
            behavior: HitTestBehavior.opaque,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: 290.0,
                height: 290.0,
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
                        width: 260.0,
                        height: 260.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE81B54)
                                  .withValues(alpha: 0.12),
                              blurRadius: 38.0,
                              spreadRadius: 8.0,
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Floating Sparkle Micro-Accents around dial
                  Positioned(
                    top: 15.0,
                    left: 20.0,
                    child: _buildSparkle(const Color(0xFFFBBF24), 14.0),
                  ),
                  Positioned(
                    top: 30.0,
                    right: 15.0,
                    child: _buildSparkle(const Color(0xFFFBBF24), 12.0),
                  ),
                  Positioned(
                    bottom: 30.0,
                    left: 15.0,
                    child: _buildSparkle(const Color(0xFFFBBF24), 11.0),
                  ),

                  // Custom Painter: Segmented Numbered Track
                  CustomPaint(
                    size: const Size(290.0, 290.0),
                    painter: _TtcDialPainter(
                      currentDay: widget.currentDay,
                      totalDays: widget.totalDays,
                    ),
                  ),

                  // Central Floating Frosted Hub
                  Container(
                    width: 176.0,
                    height: 176.0,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFFFD1DC),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E1A3C)
                              .withValues(alpha: 0.04),
                          blurRadius: 16.0,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Subtle Corner Sparkles inside hub
                        Positioned(
                          top: 24.0,
                          left: 24.0,
                          child: _buildSparkle(const Color(0xFFFBBF24), 9.0),
                        ),
                        Positioned(
                          top: 24.0,
                          right: 24.0,
                          child: _buildSparkle(const Color(0xFFFBBF24), 9.0),
                        ),
                        Positioned(
                          bottom: 50.0,
                          left: 20.0,
                          child: _buildSparkle(const Color(0xFFFBBF24), 8.0),
                        ),
                        Positioned(
                          bottom: 50.0,
                          right: 20.0,
                          child: _buildSparkle(const Color(0xFFFBBF24), 8.0),
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Ovulation in',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF7A708A),
                              ),
                            ),
                            const SizedBox(height: 1.0),
                            Text(
                              widget.ovulationCountdownText,
                              style: const TextStyle(
                                fontFamily: 'serif',
                                fontSize: 26.0,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFE81B54),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 2.0),

                            // 3D Heart with Sunburst Rays
                            SizedBox(
                              width: 58.0,
                              height: 58.0,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Sunburst Radial Rays Painter
                                  CustomPaint(
                                    size: const Size(58.0, 58.0),
                                    painter: _SunburstRaysPainter(),
                                  ),
                                  // 3D Heart Icon
                                  Container(
                                    width: 38.0,
                                    height: 38.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const RadialGradient(
                                        colors: [
                                          Color(0xFFFF7597),
                                          Color(0xFFE81B54),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFE81B54)
                                              .withValues(alpha: 0.35),
                                          blurRadius: 10.0,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.favorite_rounded,
                                        color: Colors.white,
                                        size: 22.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Active Day 13 Floating Badge
                  _buildActiveDayBadge(
                    currentDay: widget.currentDay,
                    totalDays: widget.totalDays,
                    radius: 122.0,
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

  Widget _buildSparkle(Color color, double size) {
    return Icon(
      Icons.auto_awesome_rounded,
      color: color,
      size: size,
    );
  }

  Widget _buildActiveDayBadge({
    required int currentDay,
    required int totalDays,
    required double radius,
  }) {
    final double angle = -math.pi / 2 + ((currentDay - 0.5) / totalDays) * 2 * math.pi;
    final double x = radius * math.cos(angle);
    final double y = radius * math.sin(angle);

    return Transform.translate(
      offset: Offset(x, y),
      child: Container(
        width: 32.0,
        height: 32.0,
        decoration: BoxDecoration(
          color: const Color(0xFFE81B54),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE81B54).withValues(alpha: 0.5),
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
        _LegendDot(color: Color(0xFFE84855), label: 'Period'),
        _LegendDot(color: Color(0xFFF687B3), label: 'Fertile Window'),
        _LegendDot(color: Color(0xFFE81B54), label: 'Ovulation'),
        _LegendDot(color: Color(0xFFD4C5B9), label: 'Luteal Phase'),
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

/// Custom painter for the TTC segmented phase track with numbers.
class _TtcDialPainter extends CustomPainter {
  final int currentDay;
  final int totalDays;

  _TtcDialPainter({required this.currentDay, required this.totalDays});

  Color _getPhaseColor(int day, int total) {
    if (day <= 5) return const Color(0xFFE84855); // Period (Coral-Red)
    if (day <= 12) return const Color(0xFFD8B4E2); // Follicular/Early Fertile (Soft Lilac)
    if (day <= 16) {
      if (day == 14) return const Color(0xFFE81B54); // Ovulation
      return const Color(0xFFF687B3); // Fertile Window (Pink)
    }
    return const Color(0xFFEDE0D4); // Luteal Phase (Warm Nude/Sand)
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double trackRadius = 122.0;
    final double innerTrackRadius = 96.0;
    final double trackWidth = trackRadius - innerTrackRadius;

    // Draw background track ring
    final bgPaint = Paint()
      ..color = const Color(0xFFFFF0F5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = trackWidth;
    canvas.drawCircle(center, (trackRadius + innerTrackRadius) / 2, bgPaint);

    final double stepAngle = (2 * math.pi) / totalDays;

    for (int day = 1; day <= totalDays; day++) {
      final double startAngle = -math.pi / 2 + (day - 1) * stepAngle;
      final double sweepAngle = stepAngle * 0.88;

      final color = _getPhaseColor(day, totalDays);

      final segmentPaint = Paint()
        ..color = color.withValues(alpha: day == currentDay ? 1.0 : 0.90)
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
          fontSize: 8.8,
          fontWeight: day == currentDay ? FontWeight.w900 : FontWeight.w600,
          color: day == currentDay
              ? const Color(0xFFE81B54)
              : const Color(0xFF7A708A),
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
  bool shouldRepaint(covariant _TtcDialPainter oldDelegate) {
    return oldDelegate.currentDay != currentDay || oldDelegate.totalDays != totalDays;
  }
}

/// Custom painter for golden sunburst flare rays behind the heart.
class _SunburstRaysPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rayPaint = Paint()
      ..color = const Color(0xFFFDE68A).withValues(alpha: 0.6)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const rayCount = 12;
    for (int i = 0; i < rayCount; i++) {
      final angle = (i * 2 * math.pi) / rayCount;
      final innerX = center.dx + 20.0 * math.cos(angle);
      final innerY = center.dy + 20.0 * math.sin(angle);
      final outerX = center.dx + 28.0 * math.cos(angle);
      final outerY = center.dy + 28.0 * math.sin(angle);
      canvas.drawLine(Offset(innerX, innerY), Offset(outerX, outerY), rayPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
