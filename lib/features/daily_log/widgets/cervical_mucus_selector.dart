import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

/// Cervical fluid / mucus clinical biomarker selector for TTC mode.
class CervicalMucusSelector extends StatelessWidget {
  final String selectedMucus;
  final ValueChanged<String> onMucusChanged;
  final VoidCallback? onInfoTap;

  const CervicalMucusSelector({
    super.key,
    required this.selectedMucus,
    required this.onMucusChanged,
    this.onInfoTap,
  });

  static const List<Map<String, dynamic>> options = [
    {
      'id': 'None',
      'label': 'Dry / None',
      'emoji': '🍂',
      'desc': 'Low fertility',
      'isFertile': false,
    },
    {
      'id': 'Sticky',
      'label': 'Sticky',
      'emoji': '🌾',
      'desc': 'Thick / pasty',
      'isFertile': false,
    },
    {
      'id': 'Creamy',
      'label': 'Creamy',
      'emoji': '🥛',
      'desc': 'Lotion-like',
      'isFertile': false,
    },
    {
      'id': 'Egg-white',
      'label': 'Egg-white',
      'emoji': '💧',
      'desc': 'Peak fertile',
      'isFertile': true,
    },
    {
      'id': 'Watery',
      'label': 'Watery',
      'emoji': '🌊',
      'desc': 'High fertility',
      'isFertile': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text('💧', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Text(
                  'Cervical Fluid / Mucus',
                  style: AppTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.0,
                    color: const Color(0xFF1E1A3C),
                  ),
                ),
              ],
            ),
            if (onInfoTap != null)
              GestureDetector(
                onTap: onInfoTap,
                child: const Row(
                  children: [
                    Text(
                      'Guide',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7C5CE7),
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.info_outline_rounded,
                      size: 13,
                      color: Color(0xFF7C5CE7),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: options.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final opt = options[index];
              final id = opt['id'] as String;
              final label = opt['label'] as String;
              final emoji = opt['emoji'] as String;
              final desc = opt['desc'] as String;
              final isFertile = opt['isFertile'] as bool;
              final isSelected = selectedMucus == id;

              return GestureDetector(
                onTap: () => onMucusChanged(id),
                child: Container(
                  width: 84,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isFertile
                              ? const Color(0xFFFDE8EF)
                              : const Color(0xFFF3EDFA))
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? (isFertile
                                ? const Color(0xFFE84D75)
                                : const Color(0xFF7C5CE7))
                          : const Color(0xFFEFE9F3),
                      width: isSelected ? 1.6 : 1.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 15)),
                      const SizedBox(height: 1),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: isSelected
                              ? (isFertile
                                    ? const Color(0xFFE84D75)
                                    : const Color(0xFF7C5CE7))
                              : const Color(0xFF1E1A3C),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        desc,
                        style: TextStyle(
                          fontSize: 8.0,
                          color: isSelected
                              ? (isFertile
                                    ? const Color(0xFFE84D75)
                                    : const Color(0xFF7C5CE7))
                              : const Color(0xFF8C7C92),
                          fontWeight: isFertile
                              ? FontWeight.w700
                              : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
