import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

/// Ovulation LH test and Pregnancy HCG test strip logger for TTC mode.
class LhAndPregnancyTestSection extends StatelessWidget {
  final String lhResult;
  final String hcgResult;
  final ValueChanged<String> onLhChanged;
  final ValueChanged<String> onHcgChanged;

  const LhAndPregnancyTestSection({
    super.key,
    required this.lhResult,
    required this.hcgResult,
    required this.onLhChanged,
    required this.onHcgChanged,
  });

  static const List<String> lhOptions = [
    'Not Tested',
    'Negative',
    'Low',
    'Peak Surge ➕',
  ];

  static const List<String> hcgOptions = [
    'Not Tested',
    'Negative',
    'Faint Line',
    'Positive 🤰',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LH Ovulation Test
        Row(
          children: [
            const Text('🧪', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              'Ovulation Test (LH Strip)',
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
          children: lhOptions.map((opt) {
            final isSelected = lhResult == opt;
            final isPeak = opt.contains('Peak');
            return ChoiceChip(
              label: Text(opt),
              selected: isSelected,
              onSelected: (_) => onLhChanged(opt),
              labelStyle: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? (isPeak
                          ? const Color(0xFFE84D75)
                          : const Color(0xFF7C5CE7))
                    : const Color(0xFF4A4259),
              ),
              selectedColor: isPeak
                  ? const Color(0xFFFDE8EF)
                  : const Color(0xFFF3EDFA),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isSelected
                      ? (isPeak
                            ? const Color(0xFFE84D75)
                            : const Color(0xFF7C5CE7))
                      : const Color(0xFFEFE9F3),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 12),

        // Pregnancy HCG Test
        Row(
          children: [
            const Text('✨', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              'Pregnancy Test (HCG)',
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
          children: hcgOptions.map((opt) {
            final isSelected = hcgResult == opt;
            final isPositive = opt.contains('Positive');
            return ChoiceChip(
              label: Text(opt),
              selected: isSelected,
              onSelected: (_) => onHcgChanged(opt),
              labelStyle: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? (isPositive
                          ? const Color(0xFF10B981)
                          : const Color(0xFF7C5CE7))
                    : const Color(0xFF4A4259),
              ),
              selectedColor: isPositive
                  ? const Color(0xFFE8F8F0)
                  : const Color(0xFFF3EDFA),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isSelected
                      ? (isPositive
                            ? const Color(0xFF10B981)
                            : const Color(0xFF7C5CE7))
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
