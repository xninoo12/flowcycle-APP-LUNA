import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_names.dart';
import '../../core/theme/app_spacing.dart';
import 'widgets/splash_action_area.dart';
import 'widgets/splash_branding.dart';
import 'widgets/splash_feature_cards.dart';
import 'widgets/splash_hero_visual.dart';

/// Combined Splash + Welcome Screen for FlowCycle.
///
/// Features a serene hero visual of the meditating woman holding a glowing lotus with
/// animated petal pulse, clear branding, three horizontal feature cards,
/// and immediate "Get Started" and "Sign In" actions with zero artificial loading.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.03), end: Offset.zero).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleGetStarted() {
    context.push(AppRoutes.registerPath);
  }

  void _handleSignIn() {
    context.push(AppRoutes.loginPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double screenHeight = constraints.maxHeight;
              // Proportional hero visual height matching reference
              final double heroHeight = (screenHeight * 0.36).clamp(190.0, 310.0);

              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: screenHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Top & Middle Content Group
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // 1. Seamless Meditating Hero with Lotus Petal Pulse & Floating Petals
                                SplashHeroVisual(maxHeight: heroHeight),

                                const SizedBox(height: AppSpacing.xs),

                                // 2. FlowCycle Branding & Tagline
                                const SplashBranding(),

                                const SizedBox(height: AppSpacing.md),

                                // 3. Three Horizontal Feature Cards (Track, Predict, Feel in Control)
                                const SplashFeatureCards(),
                              ],
                            ),

                            const SizedBox(height: AppSpacing.md),

                            // 4. Primary CTA & Secondary Action Area
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.xs,
                              ),
                              child: SplashActionArea(
                                onGetStarted: _handleGetStarted,
                                onSignIn: _handleSignIn,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
