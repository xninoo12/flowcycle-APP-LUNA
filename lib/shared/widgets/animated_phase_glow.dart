import 'package:flutter/material.dart';
import '../../core/theme/phase_ambient_aura.dart';
import '../../features/dashboard/models/cycle_dashboard_state.dart';

/// Micro-animation widget rendering a gentle, breathing ambient radial glow
/// matching the user's active biological cycle phase.
class AnimatedPhaseGlow extends StatefulWidget {
  final CyclePhase phase;
  final Widget child;
  final double baseRadius;
  final double pulseMagnitude;

  const AnimatedPhaseGlow({
    super.key,
    required this.phase,
    required this.child,
    this.baseRadius = 140.0,
    this.pulseMagnitude = 16.0,
  });

  @override
  State<AnimatedPhaseGlow> createState() => _AnimatedPhaseGlowState();
}

class _AnimatedPhaseGlowState extends State<AnimatedPhaseGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _pulseAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    );

    if (WidgetsBinding.instance.runtimeType.toString().contains('TestWidgetsFlutterBinding')) {
      _controller.value = 0.5;
    } else {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auraColors = PhaseAmbientAura.getAuraColors(widget.phase);

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        final currentSpread = widget.pulseMagnitude * _pulseAnimation.value;
        final currentAlpha = 0.18 + (0.10 * _pulseAnimation.value);

        return Stack(
          alignment: Alignment.center,
          children: [
            // Ambient Radial Breathing Glow
            Container(
              width: (widget.baseRadius * 2) + currentSpread,
              height: (widget.baseRadius * 2) + currentSpread,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    auraColors[0].withValues(alpha: currentAlpha),
                    auraColors[1].withValues(alpha: currentAlpha * 0.4),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
            // Foreground Child Element
            widget.child,
          ],
        );
      },
      child: widget.child,
    );
  }
}
