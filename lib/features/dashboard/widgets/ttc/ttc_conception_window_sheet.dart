import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Modal detailing the 6-day fertile window breakdown and optimal conception timing.
class TtcConceptionWindowSheet extends StatelessWidget {
  final int currentDay;
  final int totalDays;
  final String statusHeading;
  final String bestDaysText;
  final String ovulationCountdownText;

  const TtcConceptionWindowSheet({
    super.key,
    required this.currentDay,
    required this.totalDays,
    required this.statusHeading,
    required this.bestDaysText,
    required this.ovulationCountdownText,
  });

  static const List<Map<String, dynamic>> windowDays = [
    {'day': 'Day 11', 'date': 'May 11', 'chance': 'Low (12%)', 'isPeak': false},
    {
      'day': 'Day 12',
      'date': 'May 12',
      'chance': 'High (26%)',
      'isPeak': false,
    },
    {
      'day': 'Day 13',
      'date': 'May 13',
      'chance': 'High (34%)',
      'isPeak': false,
    },
    {
      'day': 'Day 14',
      'date': 'May 14',
      'chance': 'Peak (38%) 🎯',
      'isPeak': true,
    },
    {
      'day': 'Day 15',
      'date': 'May 15',
      'chance': 'High (22%)',
      'isPeak': false,
    },
    {'day': 'Day 16', 'date': 'May 16', 'chance': 'Low (8%)', 'isPeak': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
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
              children: [
                const Text('💗', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Fertile Window & Conception Timing',
                    style: AppTextStyles.subtitle.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1E1A3C),
                      fontSize: 14.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFF0F5), Color(0xFFFDE8EF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: AppRadius.medium,
                      border: Border.all(color: const Color(0xFFFBCFE8)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                statusHeading,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF9D174D),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE84D75),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Ovulation in $ovulationCountdownText',
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Optimal Conception Timing: $bestDaysText. Sperm can survive up to 5 days in fertile cervical fluid.',
                          style: AppTextStyles.caption.copyWith(
                            color: const Color(0xFF4A4259),
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    '6-DAY FERTILE WINDOW BREAKDOWN',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF7A708A),
                      letterSpacing: 0.8,
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Day-by-day table
                  ...windowDays.map((item) {
                    final day = item['day'] as String;
                    final date = item['date'] as String;
                    final chance = item['chance'] as String;
                    final isPeak = item['isPeak'] as bool;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isPeak ? const Color(0xFFFFF0F5) : Colors.white,
                        borderRadius: AppRadius.medium,
                        border: Border.all(
                          color: isPeak
                              ? const Color(0xFFE84D75)
                              : const Color(0xFFEFE9F3),
                          width: isPeak ? 1.5 : 1.0,
                        ),
                        boxShadow: AppShadows.card,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                isPeak ? '🎯' : '🌱',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$day • $date',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: isPeak
                                          ? FontWeight.w900
                                          : FontWeight.w700,
                                      color: const Color(0xFF1E1A3C),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: isPeak
                                  ? const Color(0xFFFDE8EF)
                                  : const Color(0xFFFAF8FC),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              chance,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: isPeak
                                    ? const Color(0xFFE84D75)
                                    : const Color(0xFF7C5CE7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Bottom Action
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: AppShadows.card,
              border: const Border(top: BorderSide(color: Color(0xFFEFE9F3))),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  try {
                    context.push(AppRoutes.dailyLogPath);
                  } catch (_) {}
                },
                icon: const Icon(Icons.favorite_rounded, size: 18),
                label: const Text(
                  'Log Intercourse & Timing 💕',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE84D75),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
