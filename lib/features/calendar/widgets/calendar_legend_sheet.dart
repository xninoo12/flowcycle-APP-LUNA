import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';

/// Clinical legend guide explaining all symbols, colors, and markers on the calendar.
class CalendarLegendSheet extends StatelessWidget {
  const CalendarLegendSheet({super.key});

  static const List<Map<String, dynamic>> legendItems = [
    {
      'title': 'Logged Menstrual Flow',
      'desc': 'Days when period bleeding or spotting was actively recorded.',
      'symbolWidget': Icon(
        Icons.water_drop,
        color: Color(0xFFE84D75),
        size: 20,
      ),
      'badgeColor': Color(0xFFFDE8EF),
    },
    {
      'title': 'Predicted Period',
      'desc':
          'Forecasted bleeding days calculated from your historical cycle length.',
      'symbolWidget': Icon(
        Icons.circle_outlined,
        color: Color(0xFFF472B6),
        size: 20,
      ),
      'badgeColor': Color(0xFFFDF2F8),
    },
    {
      'title': 'Peak Ovulation Day',
      'desc':
          'Day of estimated egg release. Highest probability of conception.',
      'symbolWidget': Icon(
        Icons.star_rounded,
        color: Color(0xFF7C5CE7),
        size: 22,
      ),
      'badgeColor': Color(0xFFF3EDFA),
    },
    {
      'title': 'Fertile Window (5 Days)',
      'desc': 'The 5 days leading up to ovulation when sperm can survive.',
      'symbolWidget': Icon(
        Icons.wb_sunny_outlined,
        color: Color(0xFF3B82F6),
        size: 20,
      ),
      'badgeColor': Color(0xFFEFF6FF),
    },
    {
      'title': 'Logged Intercourse',
      'desc': 'Intimacy recorded for conception timing or activity tracking.',
      'symbolWidget': Icon(
        Icons.favorite_rounded,
        color: Color(0xFFEC4899),
        size: 20,
      ),
      'badgeColor': Color(0xFFFDF2F8),
    },
    {
      'title': 'Basal Body Temperature (BBT)',
      'desc': 'Recorded morning waking temperature and biphasic shift.',
      'symbolWidget': Icon(
        Icons.thermostat_outlined,
        color: Color(0xFFD97706),
        size: 20,
      ),
      'badgeColor': Color(0xFFFEF3C7),
    },
    {
      'title': 'Symptoms & Notes Logged',
      'desc':
          'Indicates physical cues, cramps, cravings, or mood entries recorded for that day.',
      'symbolWidget': Icon(
        Icons.auto_awesome_rounded,
        color: Color(0xFF10B981),
        size: 20,
      ),
      'badgeColor': Color(0xFFE8F8F0),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: const BoxDecoration(
        color: Color(0xFFFAF8FC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 14, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('🎨', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(
                      'Calendar Symbols & Legend',
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
          ),

          const Divider(height: 1, color: Color(0xFFEFE9F3)),

          // Body
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              itemCount: legendItems.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = legendItems[index];
                final title = item['title'] as String;
                final desc = item['desc'] as String;
                final symbol = item['symbolWidget'] as Widget;
                final badgeColor = item['badgeColor'] as Color;

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppRadius.medium,
                    border: Border.all(color: const Color(0xFFEFE9F3)),
                    boxShadow: AppShadows.card,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(child: symbol),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E1A3C),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              desc,
                              style: AppTextStyles.caption.copyWith(
                                color: const Color(0xFF6B627A),
                                fontSize: 11.5,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
