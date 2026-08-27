import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/route_names.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';

/// Modal detailing monthly fertility forecast, ovulation window, and conception potential.
class FertilityMonthDetailSheet extends StatelessWidget {
  final String monthName;
  final String fertileRange;
  final String peakOvulationDay;
  final int conceptionProbabilityPercent;
  final String conceptionRating;
  final bool isPeakMonth;

  const FertilityMonthDetailSheet({
    super.key,
    required this.monthName,
    this.fertileRange = 'May 12 – May 17',
    this.peakOvulationDay = 'May 14',
    this.conceptionProbabilityPercent = 95,
    this.conceptionRating = 'Peak Conception Potential 💗',
    this.isPeakMonth = true,
  });

  void _askAi(BuildContext context) {
    Navigator.pop(context);
    try {
      context.push(
        AppRoutes.aiChatPath,
        extra: {
          'prompt':
              'What is my fertility outlook for $monthName? How should I optimize my chances during the fertile window ($fertileRange)?',
        },
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
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
                    const Text('🌿', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      '$monthName Fertility Outlook',
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
                  // Hero Probability Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF0FDF4), Color(0xFFDCFCE7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: AppRadius.medium,
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                      boxShadow: AppShadows.card,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '$conceptionProbabilityPercent%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      conceptionRating,
                                      style: AppTextStyles.subtitle.copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: const Color(0xFF065F46),
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  if (isPeakMonth)
                                    const Text('👑', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Predicted 6 high-fertility days this month with strong ovulatory confidence.',
                                style: AppTextStyles.caption.copyWith(
                                  color: const Color(0xFF047857),
                                  fontSize: 12,
                                  height: 1.35,
                                  fontWeight: FontWeight.w500,
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
                    'KEY BIOMARKER TIMELINE',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF7A708A),
                      letterSpacing: 0.8,
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Fertile Window Card
                  _buildBiomarkerCard(
                    title: 'Predicted Fertile Window',
                    description:
                        'Dates: $fertileRange. Sperm can survive up to 5 days prior to ovulation.',
                    icon: Icons.eco_rounded,
                    color: const Color(0xFF10B981),
                  ),

                  const SizedBox(height: 12),

                  // Ovulation Day Card
                  _buildBiomarkerCard(
                    title: 'Estimated Peak Ovulation',
                    description:
                        'Date: $peakOvulationDay. LH surge triggers maximum egg release viability for 12–24 hours.',
                    icon: Icons.alarm_rounded,
                    color: const Color(0xFF8B5CF6),
                  ),

                  const SizedBox(height: 20),

                  // Clinical Conception Strategy Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EDFA),
                      borderRadius: AppRadius.medium,
                      border: Border.all(color: const Color(0xFFDFD4F2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.tips_and_updates_outlined,
                              color: Color(0xFF7C64E8),
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Optimized Conception Protocol',
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
                          'For $monthName, schedule intimacy every 1–2 days starting 4 days before $peakOvulationDay. Maintain optimal hydration to support elastic fertile cervical fluid.',
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
                label: Text(
                  'Ask AI About $monthName Fertility ✦',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
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

  Widget _buildBiomarkerCard({
    required String title,
    required String description,
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
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: AppTextStyles.caption.copyWith(
              color: const Color(0xFF4A4259),
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
