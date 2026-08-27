import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Serene Breathing Aura and Floating Petal Particle system for Splash & Welcome screen.
/// Zero asset overhead — 100% computed with lightweight Flutter vector math.
class SplashBreathingAura extends StatefulWidget {
  final double size;
  final Widget? child;
  final bool animate;

  const SplashBreathingAura({
    super.key,
    required this.size,
    this.child,
    this.animate = true,
  });

  @override
  State<SplashBreathingAura> createState() => _SplashBreathingAuraState();
}

class _SplashBreathingAuraState extends State<SplashBreathingAura>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    if (widget.animate) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.value = 0.5;
    }

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );

    _opacityAnimation = Tween<double>(begin: 0.35, end: 0.75).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // 1. Floating Petal Canvas (Subtle background motion)
            CustomPaint(
              size: Size(widget.size * 1.5, widget.size * 1.5),
              painter: _FloatingPetalsPainter(progress: _pulseController.value),
            ),

            // 2. Outer Ambient Breathing Halo
            Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: widget.size * 1.25,
                height: widget.size * 1.25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primaryRoseLight.withValues(
                        alpha: _opacityAnimation.value * 0.7,
                      ),
                      AppColors.softLavenderLight.withValues(
                        alpha: _opacityAnimation.value * 0.4,
                      ),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),
            ),

            // 3. Inner Focused Glow
            Container(
              width: widget.size * 0.95,
              height: widget.size * 0.95,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryRose.withValues(
                      alpha: 0.12 * _opacityAnimation.value,
                    ),
                    blurRadius: 36.0,
                    spreadRadius: 10.0,
                  ),
                ],
              ),
            ),

            // 4. Center Child (Hero / Logo)
            if (widget.child != null) widget.child!,
          ],
        );
      },
    );
  }
}

/// Lightweight floating petal particles rendered on pure canvas
class _FloatingPetalsPainter extends CustomPainter {
  final double progress;

  _FloatingPetalsPainter({required this.progress});

  // Seeded positions of 6 subtle wellness petals
  static const List<_PetalSeed> _seeds = [
    _PetalSeed(angle: 0.35, radiusRatio: 0.58, size: 10.0, rotation: 0.4),
    _PetalSeed(angle: 1.45, radiusRatio: 0.62, size: 8.0, rotation: 1.2),
    _PetalSeed(angle: 2.70, radiusRatio: 0.55, size: 11.0, rotation: -0.6),
    _PetalSeed(angle: 3.80, radiusRatio: 0.64, size: 9.0, rotation: 0.8),
    _PetalSeed(angle: 4.90, radiusRatio: 0.52, size: 12.0, rotation: -1.1),
    _PetalSeed(angle: 5.85, radiusRatio: 0.60, size: 7.5, rotation: 0.3),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    for (int i = 0; i < _seeds.length; i++) {
      final seed = _seeds[i];
      // Subtle float movement using harmonic sine waves
      final driftAngle = seed.angle + (math.sin(progress * math.pi * 2 + i) * 0.08);
      final dynamicRadius = (maxRadius * seed.radiusRatio) +
          (math.cos(progress * math.pi * 2 + (i * 0.8)) * 6.0);

      final px = center.dx + math.cos(driftAngle) * dynamicRadius;
      final py = center.dy + math.sin(driftAngle) * dynamicRadius;

      // Soft rose & blush translucent colors
      final alpha = (0.25 + 0.2 * math.sin(progress * math.pi + i)).clamp(0.1, 0.5);
      paint.color = i % 2 == 0
          ? AppColors.primaryRose.withValues(alpha: alpha)
          : AppColors.softLavender.withValues(alpha: alpha);

      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(seed.rotation + (progress * 0.2));

      // Draw soft organic petal shape
      final path = Path();
      final pSize = seed.size;
      path.moveTo(0, -pSize);
      path.quadraticBezierTo(pSize * 0.6, -pSize * 0.2, 0, pSize);
      path.quadraticBezierTo(-pSize * 0.6, -pSize * 0.2, 0, -pSize);
      path.close();

      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _FloatingPetalsPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _PetalSeed {
  final double angle;
  final double radiusRatio;
  final double size;
  final double rotation;

  const _PetalSeed({
    required this.angle,
    required this.radiusRatio,
    required this.size,
    required this.rotation,
  });
}
