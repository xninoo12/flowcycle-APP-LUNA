import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/route_names.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/app_mode.dart';
import '../../../shared/models/daily_log_entry.dart';

/// Modal detailing instant AI analysis and clinical interpretations of logged data.
class LogInsightsAnalysisSheet extends StatelessWidget {
  final DailyLogEntry entry;
  final AppMode mode;

  const LogInsightsAnalysisSheet({
    super.key,
    required this.entry,
    this.mode = AppMode.tryingToConceive,
  });

  void _askAi(BuildContext context) {
    Navigator.pop(context);
    try {
      context.push(
        AppRoutes.aiChatPath,
        extra: {
          'prompt':
              'Can you analyze my log for ${entry.date.month}/${entry.date.day}? (Mood: ${entry.mood}, Flow: ${entry.flow}, Mucus: ${entry.cervicalMucus}, BBT: ${entry.bbtTemperature ?? 'N/A'}, LH: ${entry.lhTestResult}, Symptoms: ${entry.symptoms.join(', ')})',
        },
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isTtc = mode == AppMode.tryingToConceive;
    final hasFertileMucus =
        entry.cervicalMucus == 'Egg-white' || entry.cervicalMucus == 'Watery';
    final isLhSurge = entry.lhTestResult.contains('Peak');

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      '✦',
                      style: TextStyle(fontSize: 18, color: Color(0xFF7C5CE7)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isTtc
                          ? 'AI Conception & Biomarker Analysis'
                          : 'AI Cycle Harmony & Wellness Analysis',
                      style: AppTextStyles.subtitle.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E1A3C),
                        fontSize: 14,
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Assessment Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isTtc
                            ? (hasFertileMucus || isLhSurge
                                  ? [
                                      const Color(0xFFFFF0F5),
                                      const Color(0xFFFDE8EF),
                                    ]
                                  : [
                                      const Color(0xFFF5F3FF),
                                      const Color(0xFFECEBFE),
                                    ])
                            : [
                                const Color(0xFFE8F8F0),
                                const Color(0xFFDCFCE7),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: AppRadius.medium,
                      border: Border.all(
                        color: isTtc
                            ? (hasFertileMucus || isLhSurge
                                  ? const Color(0xFFFBCFE8)
                                  : const Color(0xFFDDD6FE))
                            : const Color(0xFFBBF7D0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              isTtc
                                  ? (hasFertileMucus || isLhSurge
                                        ? '🎯 Peak Conception Window Active'
                                        : '🌱 Follicular Building Phase')
                                  : '✨ Optimal Hormonal Balance',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 13.5,
                                color: isTtc
                                    ? (hasFertileMucus || isLhSurge
                                          ? const Color(0xFF9D174D)
                                          : const Color(0xFF5B21B6))
                                    : const Color(0xFF166534),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isTtc
                              ? (hasFertileMucus || isLhSurge
                                    ? 'Your logged egg-white cervical fluid and ovulation indicators suggest prime conditions for fertilization. Having intercourse today maximizes conception probability.'
                                    : 'Cervical mucus and temperature readings match baseline follicular follicle maturation.')
                              : 'Your energy level of ${entry.energyLevel} and ${entry.mood} mood align well with your active cycle phase. Keep logging symptoms to maintain accurate predictions.',
                          style: AppTextStyles.caption.copyWith(
                            color: const Color(0xFF1E1A3C),
                            fontSize: 12,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'LOGGED BIOMARKER SUMMARY',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF7A708A),
                      letterSpacing: 0.8,
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Summary Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricPill(
                          'Mood',
                          entry.mood,
                          Icons.sentiment_satisfied_alt_rounded,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMetricPill(
                          'Flow',
                          entry.flow,
                          Icons.water_drop_outlined,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricPill(
                          'Mucus',
                          entry.cervicalMucus,
                          Icons.opacity_rounded,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMetricPill(
                          'BBT Temp',
                          entry.bbtTemperature != null
                              ? '${entry.bbtTemperature}°F'
                              : 'Not logged',
                          Icons.thermostat_outlined,
                        ),
                      ),
                    ],
                  ),

                  if (entry.symptoms.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'ACTIVE SYMPTOMS',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF7A708A),
                        letterSpacing: 0.8,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: entry.symptoms.map((sym) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE5DBFF)),
                          ),
                          child: Text(
                            sym,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF7C5CE7),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Doctor Advice Box
                  Container(
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
                          children: const [
                            Icon(
                              Icons.medical_services_outlined,
                              color: Color(0xFF7C5CE7),
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Clinical Recommendations',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 12.5,
                                color: Color(0xFF1E1A3C),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isTtc
                              ? 'Continue tracking morning basal body temperature before getting out of bed. A biphasic thermal shift confirms successful ovulation.'
                              : 'Stay hydrated with 8+ glasses of water and balance physical workouts with restorative stretching.',
                          style: AppTextStyles.caption.copyWith(
                            color: const Color(0xFF4A4259),
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
                onPressed: () => _askAi(context),
                icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                label: const Text(
                  "Ask AI About Today's Log ✦",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C5CE7),
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

  Widget _buildMetricPill(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.medium,
        border: Border.all(color: const Color(0xFFEFE9F3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF7C5CE7), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 9.5,
                    color: Color(0xFF7A708A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1A3C),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
