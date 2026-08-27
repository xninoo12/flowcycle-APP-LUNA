import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

/// Self-care and mindfulness tracker for Cycle Awareness mode.
class SelfCareSection extends StatelessWidget {
  final Set<String> selectedSelfCare;
  final ValueChanged<String> onToggleSelfCare;

  const SelfCareSection({
    super.key,
    required this.selectedSelfCare,
    required this.onToggleSelfCare,
  });

  static const List<String> selfCareOptions = [
    'Meditation / Breathwork 🧘',
    'Warm Bath / Rest 🛁',
    'Social & Outgoing 👯‍♀️',
    'Solo Recharge 📖',
    'Journaling ✍️',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('🌿', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              'Self-Care & Mindfulness',
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
          children: selfCareOptions.map((item) {
            final isSelected = selectedSelfCare.contains(item);
            return FilterChip(
              label: Text(item),
              selected: isSelected,
              onSelected: (_) => onToggleSelfCare(item),
              labelStyle: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF059669)
                    : const Color(0xFF4A4259),
              ),
              selectedColor: const Color(0xFFE8F8F0),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF10B981)
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
