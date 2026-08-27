import 'package:flutter/material.dart';

enum EnergyLevel { low, medium, high }

/// Sleep Quality & Energy Level input controls matching exact UI specifications.
class SleepAndEnergySection extends StatelessWidget {
  final int sleepRating;
  final String sleepDurationText;
  final EnergyLevel energyLevel;
  final ValueChanged<int>? onSleepRatingChanged;
  final ValueChanged<EnergyLevel>? onEnergyLevelChanged;

  const SleepAndEnergySection({
    super.key,
    this.sleepRating = 4,
    this.sleepDurationText = '7h 30m',
    this.energyLevel = EnergyLevel.medium,
    this.onSleepRatingChanged,
    this.onEnergyLevelChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Sleep Subsection
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.nightlight_round,
                      size: 14.0,
                      color: Color(0xFF7C5CE7),
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      'Sleep',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1A3C),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.0),
                Text(
                  'How did you sleep?',
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7A708A),
                  ),
                ),
              ],
            ),

            Text(
              sleepDurationText,
              style: const TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5A5068),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6.0),

        // 5-Star Rating
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            final isFilled = starIndex <= sleepRating;
            return GestureDetector(
              onTap: () => onSleepRatingChanged?.call(starIndex),
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Icon(
                  isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 24.0,
                  color: isFilled
                      ? const Color(0xFF7C5CE7)
                      : const Color(0xFFDCD6E5),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 14.0),

        // 2. Energy Level Subsection
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.bolt_rounded, size: 15.0, color: Color(0xFFF59E0B)),
                SizedBox(width: 3.0),
                Text(
                  'Energy Level',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1A3C),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2.0),
            const Text(
              'How is your energy today?',
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w500,
                color: Color(0xFF7A708A),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8.0),

        // Segmented Control
        Container(
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF8FC),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: const Color(0xFFEFE9F3), width: 1.0),
          ),
          child: Row(
            children: [
              _buildSegment(
                level: EnergyLevel.low,
                label: 'Low',
                isSelected: energyLevel == EnergyLevel.low,
              ),
              _buildSegment(
                level: EnergyLevel.medium,
                label: 'Medium',
                isSelected: energyLevel == EnergyLevel.medium,
              ),
              _buildSegment(
                level: EnergyLevel.high,
                label: 'High',
                isSelected: energyLevel == EnergyLevel.high,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSegment({
    required EnergyLevel level,
    required String label,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onEnergyLevelChanged?.call(level),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF7C5CE7) : Colors.transparent,
            borderRadius: BorderRadius.circular(9.0),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF7C5CE7).withValues(alpha: 0.25),
                      blurRadius: 4.0,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.0,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF5A5068),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
