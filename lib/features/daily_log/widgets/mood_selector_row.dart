import 'package:flutter/material.dart';

enum MoodState { great, good, okay, low, awful }

class MoodConfig {
  final MoodState state;
  final String label;
  final String emoji;
  final Color inactiveBgColor;
  final Color inactiveBorderColor;
  final Color activeColor;

  const MoodConfig({
    required this.state,
    required this.label,
    required this.emoji,
    required this.inactiveBgColor,
    required this.inactiveBorderColor,
    required this.activeColor,
  });
}

/// 5-State Mood Selector row for Log Modal matching exact UI specs.
class MoodSelectorRow extends StatelessWidget {
  final MoodState selectedMood;
  final ValueChanged<MoodState>? onMoodChanged;

  static const List<MoodConfig> moods = [
    MoodConfig(
      state: MoodState.great,
      label: 'Great',
      emoji: '😃',
      inactiveBgColor: Color(0xFFD1FAE5),
      inactiveBorderColor: Color(0xFFA7F3D0),
      activeColor: Color(0xFF10B981),
    ),
    MoodConfig(
      state: MoodState.good,
      label: 'Good',
      emoji: '😊',
      inactiveBgColor: Color(0xFFF3EDFA),
      inactiveBorderColor: Color(0xFFE5DBFF),
      activeColor: Color(0xFF7C5CE7),
    ),
    MoodConfig(
      state: MoodState.okay,
      label: 'Okay',
      emoji: '😐',
      inactiveBgColor: Color(0xFFFEF3C7),
      inactiveBorderColor: Color(0xFFFDE68A),
      activeColor: Color(0xFFF59E0B),
    ),
    MoodConfig(
      state: MoodState.low,
      label: 'Low',
      emoji: '🙁',
      inactiveBgColor: Color(0xFFFFEDD5),
      inactiveBorderColor: Color(0xFFFED7AA),
      activeColor: Color(0xFFF97316),
    ),
    MoodConfig(
      state: MoodState.awful,
      label: 'Awful',
      emoji: '😫',
      inactiveBgColor: Color(0xFFFCE7F3),
      inactiveBorderColor: Color(0xFFFBCFE8),
      activeColor: Color(0xFFE11D48),
    ),
  ];

  const MoodSelectorRow({
    super.key,
    this.selectedMood = MoodState.good,
    this.onMoodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'How are you feeling?',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E1A3C),
          ),
        ),

        const SizedBox(height: 8.0),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: moods.map((item) {
            final bool isSelected = item.state == selectedMood;
            return GestureDetector(
              onTap: () => onMoodChanged?.call(item.state),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44.0,
                    height: 44.0,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF7C5CE7)
                          : item.inactiveBgColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF7C5CE7)
                            : item.inactiveBorderColor,
                        width: 1.0,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(
                                  0xFF7C5CE7,
                                ).withValues(alpha: 0.3),
                                blurRadius: 8.0,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        item.emoji,
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),

                  const SizedBox(height: 4.0),

                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFF7C5CE7)
                          : const Color(0xFF7A708A),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
