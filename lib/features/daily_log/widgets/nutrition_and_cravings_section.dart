import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

/// Nutrition, hydration, and food cravings logger for Cycle Awareness mode.
class NutritionAndCravingsSection extends StatelessWidget {
  final int waterGlasses;
  final Set<String> selectedCravings;
  final ValueChanged<int> onWaterChanged;
  final ValueChanged<String> onToggleCraving;

  const NutritionAndCravingsSection({
    super.key,
    required this.waterGlasses,
    required this.selectedCravings,
    required this.onWaterChanged,
    required this.onToggleCraving,
  });

  static const List<String> cravingOptions = [
    'Chocolate / Sweets 🍫',
    'Salty / Savory 🍟',
    'Carbs & Bread 🥐',
    'High Appetite 🍽️',
    'Low Appetite 🥗',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Water Hydration
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Text('💧', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Hydration (Water Intake)',
                      style: AppTextStyles.subtitle.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 12.5,
                        color: const Color(0xFF1E1A3C),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline_rounded,
                    color: Color(0xFF3B82F6),
                    size: 20,
                  ),
                  onPressed: () {
                    if (waterGlasses > 0) onWaterChanged(waterGlasses - 1);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                Text(
                  '$waterGlasses glasses',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1A3C),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline_rounded,
                    color: Color(0xFF3B82F6),
                    size: 20,
                  ),
                  onPressed: () => onWaterChanged(waterGlasses + 1),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Cravings & Appetite
        Row(
          children: [
            const Text('🥑', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              'Food Cravings & Appetite',
              style: AppTextStyles.subtitle.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: const Color(0xFF1E1A3C),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: cravingOptions.map((crav) {
            final isSelected = selectedCravings.contains(crav);
            return FilterChip(
              label: Text(crav),
              selected: isSelected,
              onSelected: (_) => onToggleCraving(crav),
              labelStyle: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? const Color(0xFFD97706)
                    : const Color(0xFF4A4259),
              ),
              selectedColor: const Color(0xFFFEF3C7),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFFEFE9F3),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
