import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Reassuring "Why it matters" card for Step 3 (Cycle Insights) of onboarding.
///
/// Features a lightbulb icon badge, clinical explanation, and soft blooming floral accent.
class Step3WhyItMattersCard extends StatelessWidget {
  final String title;
  final String description;

  const Step3WhyItMattersCard({
    super.key,
    this.title = 'Why it matters',
    this.description =
        'Your average cycle length helps us identify patterns, predict your next period and fertile window more accurately.',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.0),
        border: Border.all(
          color: const Color(0xFFF3E8EE),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1A3C).withValues(alpha: 0.025),
            blurRadius: 12.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.0),
        child: Stack(
          children: [
            // 1. Right-side Blooming Flower Artwork
            Positioned(
              right: -12,
              top: -10,
              bottom: -10,
              width: 120,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.55,
                  child: Image.asset(
                    'assets/images/cycle_wellness_flower.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.centerRight,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
                ),
              ),
            ),

            // 2. Card Content
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Lightbulb Icon Badge
                  Container(
                    width: 36.0,
                    height: 36.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEF3),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFFFD1DC),
                        width: 1.0,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.lightbulb_outline_rounded,
                        color: AppColors.primaryRose,
                        size: 19.0,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12.0),

                  // Center Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E1A3C),
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Padding(
                          padding: const EdgeInsets.only(right: 48.0),
                          child: Text(
                            description,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF7A708A),
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
