import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

/// Cycle-synced workout and movement selector for Cycle Awareness mode.
class WorkoutChipsSelector extends StatelessWidget {
  final String selectedWorkout;
  final ValueChanged<String> onWorkoutChanged;

  const WorkoutChipsSelector({
    super.key,
    required this.selectedWorkout,
    required this.onWorkoutChanged,
  });

  static const List<Map<String, dynamic>> workoutOptions = [
    {'name': 'HIIT / Strength', 'emoji': '🏋️‍♀️'},
    {'name': 'Cardio / Run', 'emoji': '🏃‍♀️'},
    {'name': 'Pilates', 'emoji': '🧘‍♀️'},
    {'name': 'Yoga / Stretch', 'emoji': '🌸'},
    {'name': 'Walking', 'emoji': '🚶‍♀️'},
    {'name': 'Rest Day', 'emoji': '🛋️'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('🏃‍♀️', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              'Cycle-Synced Workout & Movement',
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
          children: workoutOptions.map((opt) {
            final name = opt['name'] as String;
            final emoji = opt['emoji'] as String;
            final isSelected = selectedWorkout == name;

            return ChoiceChip(
              avatar: Text(emoji, style: const TextStyle(fontSize: 12)),
              label: Text(name),
              selected: isSelected,
              onSelected: (_) => onWorkoutChanged(name),
              labelStyle: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF7C5CE7)
                    : const Color(0xFF4A4259),
              ),
              selectedColor: const Color(0xFFF3EDFA),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF7C5CE7)
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
