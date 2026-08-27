import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animated subtle pulse of petals and radiant glow for the lotus flower held by the woman.
/// Zero asset overhead — 100% vector canvas & AnimationController.
class LotusPetalPulse extends StatefulWidget {
  final double flowerSize;
  final bool animate;

  const LotusPetalPulse({
    super.key,
    this.flowerSize = 64.0,
    this.animate = true,
  });

  @override
  State<LotusPetalPulse> createState() => _LotusPetalPulseState();
}

class _LotusPetalPulseState extends State<LotusPetalPulse>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );

    if (widget.animate) {
      _pulseController.repeat(reverse: true);
      _shimmerController.repeat();
    } else {
      _pulseController.value = 0.5;
      _shimmerController.value = 0.5;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.flowerSize;

    return SizedBox(
      width: size * 2.0,
      height: size * 2.0,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseController, _shimmerController]),
        builder: (context, child) {
          final pulseVal = _pulseController.value;
          final shimmerVal = _shimmerController.value;

          return CustomPaint(
            size: Size(size * 2.0, size * 2.0),
            painter: _LotusGlowPainter(
              pulse: pulseVal,
              shimmer: shimmerVal,
            ),
          );
        },
      ),
    );
  }
}

class _LotusGlowPainter extends CustomPainter {
  final double pulse;
  final double shimmer;

  _LotusGlowPainter({
    required this.pulse,
    required this.shimmer,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * 0.28;

    // 1. Soft Core Bloom Aura
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFB4C8).withValues(alpha: (0.45 + 0.3 * pulse).clamp(0.0, 1.0)),
          const Color(0xFFFF8DA1).withValues(alpha: (0.25 + 0.2 * pulse).clamp(0.0, 1.0)),
          const Color(0xFFFFD6E0).withValues(alpha: (0.10 + 0.1 * pulse).clamp(0.0, 1.0)),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 0.75, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: baseRadius * (1.1 + 0.25 * pulse)));

    canvas.drawCircle(center, baseRadius * (1.1 + 0.25 * pulse), corePaint);

    // 2. Harmonic Radial Petal Aura Rings (Breathing outwards)
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..isAntiAlias = true;

    for (int r = 0; r < 3; r++) {
      final ringProgress = (pulse + (r * 0.33)) % 1.0;
      final ringRadius = baseRadius * (0.8 + ringProgress * 0.9);
      final ringAlpha = ((1.0 - ringProgress) * 0.25).clamp(0.0, 0.3);

      ringPaint.color = const Color(0xFFFF8EA3).withValues(alpha: ringAlpha);
      canvas.drawCircle(center, ringRadius, ringPaint);
    }

    // 3. Delicate Floating Petal Sparks around the flower
    final sparkPaint = Paint()..style = PaintingStyle.fill;
    const int sparkCount = 5;

    for (int i = 0; i < sparkCount; i++) {
      final seedAngle = (i * (math.pi * 2 / sparkCount)) + (shimmer * math.pi * 2);
      final floatDist = baseRadius * (0.75 + 0.45 * math.sin(shimmer * math.pi * 2 + i));
      final sx = center.dx + math.cos(seedAngle) * floatDist;
      final sy = center.dy + math.sin(seedAngle) * floatDist * 0.7 - (shimmer * 8.0);

      final sparkAlpha = (0.25 + 0.35 * math.sin(shimmer * math.pi * 2 + i)).clamp(0.0, 0.6);
      sparkPaint.color = const Color(0xFFFFC0D0).withValues(alpha: sparkAlpha);

      // Micro-petal spark
      final path = Path();
      const double pSize = 3.5;
      path.moveTo(sx, sy - pSize);
      path.quadraticBezierTo(sx + pSize * 0.8, sy, sx, sy + pSize);
      path.quadraticBezierTo(-pSize * 0.8, sy, sx, sy - pSize);
      path.close();

      canvas.drawPath(path, sparkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LotusGlowPainter oldDelegate) =>
      oldDelegate.pulse != pulse || oldDelegate.shimmer != shimmer;
}
