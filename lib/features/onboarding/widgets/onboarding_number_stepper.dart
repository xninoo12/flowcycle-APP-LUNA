import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Refined, tactile numeric stepper component matching the FlowCycle Onboarding UI.
///
/// Features circular glowing dial, prominent serif number typography,
/// benchmark range pill with calendar icon, tactile increment/decrement buttons,
/// and optional top dial icon (e.g. calendar/droplet).
class OnboardingNumberStepper extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final String unit;
  final String? helperText;
  final IconData? topIcon;
  final String decreaseSemanticLabel;
  final String increaseSemanticLabel;
  final ValueChanged<int> onChanged;

  const OnboardingNumberStepper({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    this.unit = 'days',
    this.helperText,
    this.topIcon,
    required this.decreaseSemanticLabel,
    required this.increaseSemanticLabel,
    required this.onChanged,
  });

  void _decrease() {
    if (value > min) {
      onChanged(value - 1);
    }
  }

  void _increase() {
    if (value < max) {
      onChanged(value + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canDecrease = value > min;
    final bool canIncrease = value < max;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Interactive Stepper Row with Glowing Central Dial
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Minus Button
            _buildStepperButton(
              icon: Icons.remove_rounded,
              isEnabled: canDecrease,
              semanticLabel: decreaseSemanticLabel,
              onTap: _decrease,
            ),

            const SizedBox(width: 16.0),

            // Central Glowing Dial with Serif Number & Unit
            SizedBox(
              width: 175.0,
              height: 175.0,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Outer Ambient Glow Ring
                  Container(
                    width: 170.0,
                    height: 170.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFFFFD1DC),
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF4D79).withValues(alpha: 0.12),
                          blurRadius: 24.0,
                          spreadRadius: 4.0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),

                  // Floating Sparkle Micro-accents around perimeter
                  Positioned(
                    top: 10,
                    left: 20,
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      size: 10.0,
                      color: AppColors.primaryRose.withValues(alpha: 0.5),
                    ),
                  ),
                  Positioned(
                    top: 14,
                    right: 22,
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      size: 11.0,
                      color: AppColors.primaryRose.withValues(alpha: 0.6),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 24,
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      size: 9.0,
                      color: AppColors.primaryRose.withValues(alpha: 0.5),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 20,
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      size: 10.0,
                      color: AppColors.primaryRose.withValues(alpha: 0.6),
                    ),
                  ),

                  // Center Icon, Value & Unit
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (topIcon != null) ...[
                        Icon(
                          topIcon,
                          size: 22.0,
                          color: const Color(0xFFFF4D79),
                        ),
                        const SizedBox(height: 2.0),
                      ],
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(scale: animation, child: child);
                        },
                        child: Text(
                          '$value',
                          key: ValueKey<int>(value),
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: topIcon != null ? 50.0 : 54.0,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFFFF4D79),
                            letterSpacing: -1.5,
                            height: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        unit,
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF7A708A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16.0),

            // Plus Button
            _buildStepperButton(
              icon: Icons.add_rounded,
              isEnabled: canIncrease,
              semanticLabel: increaseSemanticLabel,
              onTap: _increase,
            ),
          ],
        ),

        // 2. Normal Range / Benchmark Pill Below Dial
        if (helperText != null) ...[
          const SizedBox(height: 20.0),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 7.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: const Color(0xFFFFD6E2),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E1A3C).withValues(alpha: 0.02),
                  blurRadius: 8.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_month_rounded,
                  size: 14.0,
                  color: Color(0xFFFF4D79),
                ),
                const SizedBox(width: 6.0),
                Text(
                  helperText!,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E1A3C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStepperButton({
    required IconData icon,
    required bool isEnabled,
    required String semanticLabel,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      enabled: isEnabled,
      label: semanticLabel,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: Container(
          width: 52.0,
          height: 52.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: isEnabled
                  ? const Color(0xFFFFD6E2)
                  : const Color(0xFFEFE8ED),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isEnabled
                    ? const Color(0x14FF4D79)
                    : Colors.transparent,
                blurRadius: 10.0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              icon,
              size: 26.0,
              color: isEnabled
                  ? const Color(0xFFFF4D79)
                  : const Color(0xFFC4BDCC),
            ),
          ),
        ),
      ),
    );
  }
}
