import 'package:flutter/material.dart';
import '../../../core/theme/flow_cycle_theme_extension.dart';

/// Hero visual section for the Choose Mode / Goal Selection step (Step 1)
/// featuring dual-tone serif typography, goal description, and the serene woman
/// holding a radiant glowing heart with subtle breathing aura and theme adaptability.
class ChooseModeHero extends StatefulWidget {
  final bool animate;

  const ChooseModeHero({
    super.key,
    this.animate = false,
  });

  @override
  State<ChooseModeHero> createState() => _ChooseModeHeroState();
}

class _ChooseModeHeroState extends State<ChooseModeHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    if (widget.animate) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.value = 0.5;
    }

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
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
    final theme = context.flowTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 6.0, bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Left Column: Dual-tone Serif Headline & Subtitle
          Expanded(
            flex: 13,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🌸', style: TextStyle(fontSize: 14.0)),
                    const SizedBox(width: 4.0),
                    Text(
                      'Welcome to FlowCycle',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: theme.primary,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 3.0),
                    const Text('✨', style: TextStyle(fontSize: 11.0)),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 25.0,
                      fontWeight: FontWeight.w900,
                      color: theme.textPrimary,
                      letterSpacing: -0.5,
                      height: 1.22,
                    ),
                    children: [
                      const TextSpan(text: "Let's personalize\n"),
                      TextSpan(
                        text: 'FlowCycle',
                        style: TextStyle(
                          color: theme.primary,
                        ),
                      ),
                      const TextSpan(text: ' for you'),
                    ],
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  "We'll tailor your experience\nto match your goals.",
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: theme.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8.0),

          // 2. Right Column: Serene Woman Hero with Glowing Heart-Light & Flora
          Expanded(
            flex: 11,
            child: SizedBox(
              height: 130.0,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Subtle Heart Breathing Glow Effect behind her hands
                  AnimatedBuilder(
                    animation: _glowAnimation,
                    builder: (context, child) {
                      return Positioned(
                        right: 48,
                        top: 54,
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: theme.primary.withValues(
                                  alpha: 0.45 * _glowAnimation.value,
                                ),
                                blurRadius: 24.0 * _glowAnimation.value,
                                spreadRadius: 6.0 * _glowAnimation.value,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Woman Illustration Asset
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/choose_mode_woman_hero.png',
                      fit: BoxFit.contain,
                      alignment: Alignment.centerRight,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
