import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

/// Intimacy status and fertility supplements tracker for TTC mode.
class IntimacySection extends StatelessWidget {
  final String intimacyStatus;
  final Set<String> selectedSupplements;
  final ValueChanged<String> onIntimacyChanged;
  final ValueChanged<String> onToggleSupplement;

  const IntimacySection({
    super.key,
    required this.intimacyStatus,
    required this.selectedSupplements,
    required this.onIntimacyChanged,
    required this.onToggleSupplement,
  });

  static const List<String> intimacyOptions = [
    'None',
    'Unprotected (Trying) 💕',
    'Protected',
    'High Libido 🔥',
  ];

  static const List<String> supplementOptions = [
    'Prenatal Vitamin',
    'Folic Acid',
    'CoQ10',
    'Omega-3',
    'Inositol',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Intimacy
        Row(
          children: [
            const Text('❤️', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              'Intimacy & Timing',
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
          children: intimacyOptions.map((opt) {
            final isSelected = intimacyStatus == opt;
            final isTrying = opt.contains('Trying');
            return ChoiceChip(
              label: Text(opt),
              selected: isSelected,
              onSelected: (_) => onIntimacyChanged(opt),
              labelStyle: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? (isTrying
                          ? const Color(0xFFE84D75)
                          : const Color(0xFF7C5CE7))
                    : const Color(0xFF4A4259),
              ),
              selectedColor: isTrying
                  ? const Color(0xFFFDE8EF)
                  : const Color(0xFFF3EDFA),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isSelected
                      ? (isTrying
                            ? const Color(0xFFE84D75)
                            : const Color(0xFF7C5CE7))
                      : const Color(0xFFEFE9F3),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 12),

        // Supplements
        Row(
          children: [
            const Text('💊', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              'Fertility Supplements',
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
          children: supplementOptions.map((sup) {
            final isSelected = selectedSupplements.contains(sup);
            return FilterChip(
              label: Text(sup),
              selected: isSelected,
              onSelected: (_) => onToggleSupplement(sup),
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
