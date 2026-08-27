import 'package:flutter/material.dart';
import '../../../core/theme/flow_cycle_theme_extension.dart';

/// Appearance Theme Card with responsive theme swatches and dynamic styling.
class AppearanceThemeCard extends StatelessWidget {
  final String selectedThemeId;
  final ValueChanged<String>? onThemeSelected;
  final VoidCallback? onMoreTap;

  const AppearanceThemeCard({
    super.key,
    this.selectedThemeId = 'pink',
    this.onThemeSelected,
    this.onMoreTap,
  });

  static const List<Map<String, dynamic>> _themes = [
    {
      'id': 'pink',
      'color': Color(0xFFFF6B8B),
      'label': 'Rosé',
    },
    {
      'id': 'purple',
      'color': Color(0xFFA78BFA),
      'label': 'Lavender',
    },
    {
      'id': 'mint',
      'color': Color(0xFF34D399),
      'label': 'Mint',
    },
    {
      'id': 'amber',
      'color': Color(0xFFFBBF24),
      'label': 'Amber',
    },
    {
      'id': 'navy',
      'color': Color(0xFF1E293B),
      'label': 'Indigo',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.flowTheme;
    final normalizedSelected = selectedThemeId == 'lavender'
        ? 'purple'
        : (selectedThemeId == 'green' ? 'mint' : selectedThemeId);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: theme.cardBorder,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFF1E1A3C).withValues(alpha: 0.025),
            blurRadius: 10.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      child: Row(
        children: [
          // 1. Palette Icon Badge
          Container(
            width: 38.0,
            height: 38.0,
            decoration: BoxDecoration(
              color: theme.containerLight,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.palette_outlined,
                color: theme.primary,
                size: 20.0,
              ),
            ),
          ),

          const SizedBox(width: 10.0),

          // 2. Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Appearance',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontSize: 16.0,
                    color: theme.primary,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  'Customize how the app looks.',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: theme.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 8.0),

          // 3. Color Swatches
          Row(
            mainAxisSize: MainAxisSize.min,
            children: _themes.map((t) {
              final id = t['id'] as String;
              final color = t['color'] as Color;
              final isSelected = id == normalizedSelected;

              return Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: GestureDetector(
                  onTap: () => onThemeSelected?.call(id),
                  child: Container(
                    width: 26.0,
                    height: 26.0,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8.0),
                      border: isSelected
                          ? Border.all(
                              color: theme.isDark ? Colors.white : Colors.black87,
                              width: 1.5,
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 4.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isSelected
                        ? const Center(
                            child: Icon(
                              Icons.check_rounded,
                              size: 14.0,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),

          // 4. Trailing Chevron >
          InkWell(
            onTap: onMoreTap,
            child: Icon(
              Icons.chevron_right_rounded,
              size: 18.0,
              color: theme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
