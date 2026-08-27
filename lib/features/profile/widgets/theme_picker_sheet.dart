import 'package:flutter/material.dart';
import '../../../core/theme/flow_cycle_theme_extension.dart';
import '../../../shared/providers/app_scope.dart';

/// Modal bottom sheet popup for choosing appearance themes.
class ThemePickerSheet extends StatefulWidget {
  final String currentThemeId;
  final ValueChanged<String>? onThemeSelected;

  const ThemePickerSheet({
    super.key,
    required this.currentThemeId,
    this.onThemeSelected,
  });

  @override
  State<ThemePickerSheet> createState() => _ThemePickerSheetState();
}

class _ThemePickerSheetState extends State<ThemePickerSheet> {
  late String _selected;

  static const List<Map<String, dynamic>> _themes = [
    {
      'id': 'pink',
      'name': 'Rosé Bloom (Default)',
      'subtitle': 'Warm coral rose & soft peony',
      'color': Color(0xFFF06292),
      'gradient': [Color(0xFFFF6B8B), Color(0xFFFFA07A)],
      'emoji': '🌸',
    },
    {
      'id': 'purple',
      'name': 'Lavender Dream',
      'subtitle': 'Calming violet & amethyst',
      'color': Color(0xFFA78BFA),
      'gradient': [Color(0xFF8B5CF6), Color(0xFFC084FC)],
      'emoji': '💜',
    },
    {
      'id': 'mint',
      'name': 'Emerald Mint',
      'subtitle': 'Refreshing sage & botanical green',
      'color': Color(0xFF34D399),
      'gradient': [Color(0xFF10B981), Color(0xFF6EE7B7)],
      'emoji': '🍃',
    },
    {
      'id': 'amber',
      'name': 'Sunset Amber',
      'subtitle': 'Radiant honey & golden glow',
      'color': Color(0xFFFBBF24),
      'gradient': [Color(0xFFF59E0B), Color(0xFFFCD34D)],
      'emoji': '✨',
    },
    {
      'id': 'navy',
      'name': 'Midnight Indigo',
      'subtitle': 'Deep cosmic blue & lunar starlight',
      'color': Color(0xFF6366F1),
      'gradient': [Color(0xFF4F46E5), Color(0xFF818CF8)],
      'emoji': '🌙',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.currentThemeId == 'lavender'
        ? 'purple'
        : (widget.currentThemeId == 'green' ? 'mint' : widget.currentThemeId);
  }

  void _applyTheme(String id) {
    setState(() => _selected = id);
    widget.onThemeSelected?.call(id);
    final controller = AppScope.of(context);
    controller.setTheme(id);
    final theme = context.flowTheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Theme updated to ${_getThemeName(id)} ✨'),
        backgroundColor: theme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
    Navigator.of(context).pop();
  }

  String _getThemeName(String id) {
    final t = _themes.firstWhere(
      (e) => e['id'] == id,
      orElse: () => _themes.first,
    );
    return t['name'];
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.flowTheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12.0),
          Container(
            width: 44.0,
            height: 4.5,
            decoration: BoxDecoration(
              color: theme.cardBorder,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          const SizedBox(height: 14.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Text('🎨', style: TextStyle(fontSize: 18.0)),
                      const SizedBox(width: 6.0),
                      Expanded(
                        child: Text(
                          'Appearance Themes',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 20.0,
                            fontWeight: FontWeight.w900,
                            color: theme.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: theme.textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Divider(height: 1.0, color: theme.cardBorder),
          Flexible(
            child: ListView.separated(
              padding: const EdgeInsets.all(20.0),
              itemCount: _themes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10.0),
              itemBuilder: (context, index) {
                final item = _themes[index];
                final isSelected = _selected == item['id'];
                final List<Color> gradient = item['gradient'];

                return InkWell(
                  onTap: () => _applyTheme(item['id']),
                  borderRadius: BorderRadius.circular(18.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.containerLight
                          : theme.cardBackground,
                      borderRadius: BorderRadius.circular(18.0),
                      border: Border.all(
                        color: isSelected
                            ? theme.primary
                            : theme.cardBorder,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38.0,
                          height: 38.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: gradient),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: gradient.first.withValues(alpha: 0.3),
                                blurRadius: 6.0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              item['emoji'],
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: isSelected
                                      ? FontWeight.w900
                                      : FontWeight.w700,
                                  color: theme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                item['subtitle'],
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: theme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle_rounded,
                            color: theme.primary,
                            size: 22.0,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
