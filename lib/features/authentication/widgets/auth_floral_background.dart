import 'package:flutter/material.dart';
import '../../splash/widgets/splash_breathing_aura.dart';

/// Serene silk floral background with top-right glowing lotus bloom and floating petals
/// for authentication screens (Register, Sign In, Forgot Password).
class AuthFloralBackground extends StatelessWidget {
  final Widget child;
  final bool animate;

  const AuthFloralBackground({
    super.key,
    required this.child,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFAF6F2),
            Color(0xFFFFF4F7),
            Color(0xFFFAF5F1),
          ],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // 1. Top-Right Radiant Lotus Bloom Background Art
          Positioned(
            top: -20,
            right: -30,
            width: 260,
            height: 260,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.85,
                child: Image.asset(
                  'assets/images/auth_lotus_header.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),

          // 2. Ambient Floating Petals Canvas
          Positioned.fill(
            child: IgnorePointer(
              child: SplashBreathingAura(
                size: 300,
                animate: animate,
              ),
            ),
          ),

          // 3. Screen Content
          Positioned.fill(
            child: child,
          ),
        ],
      ),
    );
  }
}
