import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';

/// Modal allowing users to customize visible biomarker overlays on the calendar.
class CalendarFilterSheet extends StatefulWidget {
  final Map<String, bool> currentFilters;
  final ValueChanged<Map<String, bool>> onApplyFilters;

  const CalendarFilterSheet({
    super.key,
    required this.currentFilters,
    required this.onApplyFilters,
  });

  @override
  State<CalendarFilterSheet> createState() => _CalendarFilterSheetState();
}

class _CalendarFilterSheetState extends State<CalendarFilterSheet> {
  late Map<String, bool> _filters;

  static const List<Map<String, dynamic>> filterOptions = [
    {
      'key': 'period',
      'label': 'Period & Flow Intensity',
      'desc': 'Show recorded flow and predicted periods',
      'emoji': '🩸',
      'color': Color(0xFFE84D75),
    },
    {
      'key': 'fertileWindow',
      'label': 'Fertile Window & Ovulation',
      'desc': 'Highlight high-conception days and ovulation peak',
      'emoji': '🌸',
      'color': Color(0xFF7C5CE7),
    },
    {
      'key': 'cervicalFluid',
      'label': 'Cervical Fluid & BBT',
      'desc': 'Egg-white mucus drops and thermal shifts',
      'emoji': '💧',
      'color': Color(0xFF3B82F6),
    },
    {
      'key': 'intimacy',
      'label': 'Intimacy & Intercourse',
      'desc': 'Display intimacy logs and timing hearts',
      'emoji': '❤️',
      'color': Color(0xFFEC4899),
    },
    {
      'key': 'symptoms',
      'label': 'Symptoms & Biomarkers',
      'desc': 'Show recorded symptoms and physical cues',
      'emoji': '✨',
      'color': Color(0xFF10B981),
    },
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, bool>.from(widget.currentFilters);
  }

  void _selectAll(bool value) {
    setState(() {
      for (final opt in filterOptions) {
        _filters[opt['key'] as String] = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFAF8FC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('🔍', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        'Calendar Overlays & Filters',
                        style: AppTextStyles.subtitle.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1E1A3C),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF7A708A),
                      size: 22,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              // Quick Actions
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => _selectAll(true),
                    icon: const Icon(
                      Icons.select_all_rounded,
                      size: 16,
                      color: Color(0xFF7C5CE7),
                    ),
                    label: const Text(
                      'Select All',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7C5CE7),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => _selectAll(false),
                    icon: const Icon(
                      Icons.deselect_rounded,
                      size: 16,
                      color: Color(0xFF7A708A),
                    ),
                    label: const Text(
                      'Clear All',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7A708A),
                      ),
                    ),
                  ),
                ],
              ),

              const Divider(height: 1, color: Color(0xFFEFE9F3)),
              const SizedBox(height: 12),

              // Filter Options List
              ...filterOptions.map((opt) {
                final key = opt['key'] as String;
                final label = opt['label'] as String;
                final desc = opt['desc'] as String;
                final emoji = opt['emoji'] as String;
                final isSelected = _filters[key] ?? true;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppRadius.medium,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF7C5CE7).withValues(alpha: 0.35)
                          : const Color(0xFFEFE9F3),
                    ),
                    boxShadow: AppShadows.card,
                  ),
                  child: Row(
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              label,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E1A3C),
                              ),
                            ),
                            Text(
                              desc,
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: Color(0xFF8C7C92),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: isSelected,
                        activeTrackColor: const Color(0xFF7C5CE7),
                        onChanged: (val) {
                          setState(() {
                            _filters[key] = val;
                          });
                        },
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 16),

              // Apply CTA
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApplyFilters(_filters);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C5CE7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
