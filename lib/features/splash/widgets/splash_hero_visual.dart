import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import 'lotus_petal_pulse.dart';
import 'splash_breathing_aura.dart';

/// Full-bleed, seamless hero visual displaying the meditating woman, glowing moon,
/// floating petals, and an animated subtle petal pulse over the lotus flower in her hands.
class SplashHeroVisual extends StatelessWidget {
  final double maxHeight;

  const SplashHeroVisual({super.key, this.maxHeight = 320.0});

  @override
  Widget build(BuildContext context) {
    // Calculated height that maintains the serene composition without squishing
    final double heroHeight = maxHeight.clamp(200.0, 360.0);
    // Original hero asset aspect ratio: 682 / 445 = 1.532
    final double heroWidth = (heroHeight * 1.532).clamp(280.0, 520.0);

    return Center(
      child: SizedBox(
        width: heroWidth,
        height: heroHeight,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // 1. Ambient Background Aura with drifting petals
            Positioned.fill(
              child: SplashBreathingAura(
                size: heroHeight * 0.85,
              ),
            ),

            // 2. Seamless Full-Bleed Illustration of Meditating Woman & Crescent Moon
            Positioned.fill(
              child: Image.asset(
                'assets/images/splash_hero.png',
                fit: BoxFit.contain,
                alignment: Alignment.topCenter,
                errorBuilder: (context, error, stackTrace) =>
                    _buildFallbackHero(heroHeight),
              ),
            ),

            // 3. Exact-Positioned Lotus Petal Pulse Animation over her hands (x=50.6%, y=60.2%)
            Positioned(
              left: (heroWidth * 0.506) - 36.0,
              top: (heroHeight * 0.602) - 36.0,
              child: const LotusPetalPulse(flowerSize: 36.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackHero(double size) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppGradients.lavenderSky,
      ),
      child: Center(
        child: Icon(
          Icons.spa_rounded,
          size: size * 0.4,
          color: AppColors.primaryRose,
        ),
      ),
    );
  }
}
