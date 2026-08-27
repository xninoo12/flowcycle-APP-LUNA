import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/route_names.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';

/// In-depth clinical breakdown modal for Cycle Highlights & Phase Durations.
class CycleHighlightsDetailSheet extends StatelessWidget {
  final int avgCycleLength;
  final int avgPeriodLength;
  final String avgOvulationDay;
  final int longestCycle;

  const CycleHighlightsDetailSheet({
    super.key,
    this.avgCycleLength = 28,
    this.avgPeriodLength = 5,
    this.avgOvulationDay = 'Day 14',
    this.longestCycle = 31,
  });

  void _askAi(BuildContext context) {
    Navigator.pop(context);
    try {
      context.push(
        AppRoutes.aiChatPath,
        extra: {
          'prompt':
              'Can you analyze my cycle highlights? (Average length: $avgCycleLength days, Period: $avgPeriodLength days, Ovulation: $avgOvulationDay)',
        },
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final follicularLength = 14;
    final lutealLength = avgCycleLength - follicularLength;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFFFAF8FC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Header Grab Bar & Close
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 14, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('📊', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(
                      'Cycle Highlights Breakdown',
                      style: AppTextStyles.subtitle.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E1A3C),
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

          // Scrollable Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Regularity Badge Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F8F0),
                      borderRadius: AppRadius.medium,
                      border: Border.all(color: const Color(0xFFC3EED7)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Highly Consistent Cycle Pattern',
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF065F46),
                                  fontSize: 13.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Cycle length variance is ±1.2 days, well within the healthy clinical range of < 3 days.',
                                style: AppTextStyles.caption.copyWith(
                                  color: const Color(0xFF047857),
                                  fontSize: 11.5,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'PHASE DURATION METRICS',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF7A708A),
                      letterSpacing: 0.8,
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Phase Cards Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricTile(
                          title: 'Follicular Phase',
                          value: '$follicularLength days',
                          subtitle: 'Follicle maturation & estrogen rise',
                          icon: Icons.bubble_chart_outlined,
                          color: const Color(0xFF8B5CF6),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricTile(
                          title: 'Luteal Phase',
                          value: '$lutealLength days',
                          subtitle: 'Progesterone sustain & implantation',
                          icon: Icons.shield_moon_outlined,
                          color: const Color(0xFFEC4899),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricTile(
                          title: 'Period Flow',
                          value: '$avgPeriodLength days',
                          subtitle: 'Healthy endometrial shedding',
                          icon: Icons.water_drop_outlined,
                          color: const Color(0xFFE84D75),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricTile(
                          title: 'Ovulation Day',
                          value: avgOvulationDay,
                          subtitle: 'Peak egg release probability',
                          icon: Icons.wb_sunny_outlined,
                          color: const Color(0xFFF59E0B),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Clinical Guidance Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.medium,
                      border: Border.all(color: const Color(0xFFEFE9F3)),
                      boxShadow: AppShadows.card,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.medical_services_outlined,
                              color: Color(0xFF7C64E8),
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Clinical Insights & Luteal Sufficiency',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: Color(0xFF1E1A3C),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your luteal phase of $lutealLength days indicates optimal progesterone production for uterine lining support and fertility conception. A luteal phase between 11–16 days is considered ideal by reproductive endocrinologists.',
                          style: AppTextStyles.caption.copyWith(
                            color: const Color(0xFF4A4259),
                            fontSize: 12,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Bar
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
                onPressed: () => _askAi(context),
                icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                label: const Text(
                  'Ask AI About My Cycle Highlights ✦',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C64E8),
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

  Widget _buildMetricTile({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.medium,
        border: Border.all(color: const Color(0xFFEFE9F3)),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF7A708A),
                  fontSize: 11,
                ),
              ),
              Icon(icon, size: 16, color: color),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.subtitle.copyWith(
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1E1A3C),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.caption.copyWith(
              color: const Color(0xFFAAA3B8),
              fontSize: 10,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}
