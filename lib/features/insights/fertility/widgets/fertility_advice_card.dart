import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

/// Educational AI Ovulation Advice Card for Fertility subscreen.
class FertilityAdviceCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const FertilityAdviceCard({
    super.key,
    this.title =
        'Ovulation is the day your body is most likely to release an egg.',
    this.subtitle =
        'Your best days to conceive are the 5 days before ovulation and the day of ovulation.',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F4FB),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFEFE9F3), width: 1.0),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lightbulb Icon in Circular Container
          Container(
            width: 36.0,
            height: 36.0,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE5F7),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.lightbulb_outline_rounded,
                color: Color(0xFF8A64B8),
                size: 19.0,
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.sm + 4.0),

          // Message Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1A3C),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 3.0),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7A708A),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
