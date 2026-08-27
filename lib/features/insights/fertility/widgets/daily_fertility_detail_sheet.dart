import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Modal detailing day-by-day conception probability, mucus cues, and intimacy timing.
class DailyFertilityDetailSheet extends StatelessWidget {
  final String dayLabel;
  final String dateText;
  final int chancePercent;
  final String chanceRating;
  final String cervicalMucus;
  final String bbtStatus;
  final String timingRecommendation;

  const DailyFertilityDetailSheet({
    super.key,
    required this.dayLabel,
    required this.dateText,
    this.chancePercent = 85,
    this.chanceRating = 'Peak Fertility 💗',
    this.cervicalMucus =
        'Clear, stretchy "egg-white" texture with high Spinnbarkeit elasticity. Provides optimal alkaline pH for sperm survival.',
    this.bbtStatus =
        'Pre-ovulatory baseline dip. A 0.5–1.0°F biphasic thermal rise is expected post-ovulation.',
    this.timingRecommendation =
        'Prime conception window! Intercourse today and tomorrow morning maximizes fertilization probability.',
  });

  void _askAi(BuildContext context) {
    Navigator.pop(context);
    try {
      context.push(
        AppRoutes.aiChatPath,
        extra: {
          'prompt':
              'Tell me more about my fertility on $dateText ($chancePercent% - $chanceRating). How should I time intercourse and track symptoms?',
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
                    const Text('💧', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      '$dayLabel • $dateText',
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

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Chance Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFF0F5), Color(0xFFFDE8EF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: AppRadius.medium,
                      border: Border.all(color: const Color(0xFFFBCFE8)),
                      boxShadow: AppShadows.card,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE84D75),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '$chancePercent%',
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
                              Text(
                                chanceRating,
                                style: AppTextStyles.subtitle.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF9D174D),
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                timingRecommendation,
                                style: AppTextStyles.caption.copyWith(
                                  color: const Color(0xFF831843),
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
                    'BIOLOGICAL FERTILITY MARKERS',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF7A708A),
                      letterSpacing: 0.8,
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Cervical Mucus Box
                  _buildBiomarkerCard(
                    title: 'Cervical Fluid State',
                    description: cervicalMucus,
                    icon: Icons.water_drop_outlined,
                    color: const Color(0xFF3B82F6),
                  ),

                  const SizedBox(height: 12),

                  // BBT Box
                  _buildBiomarkerCard(
                    title: 'Basal Body Temperature (BBT)',
                    description: bbtStatus,
                    icon: Icons.thermostat_outlined,
                    color: const Color(0xFFF59E0B),
                  ),

                  const SizedBox(height: 20),

                  // Clinical Advice Box
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
                              'Conception Timing Strategy',
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
                          'Sperm can survive in fertile cervical mucus for up to 5 days, whereas an egg remains viable for 12–24 hours post-ovulation. Having sperm present in the fallopian tubes prior to egg release provides the highest probability of conception.',
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
                label: const Text(
                  "Ask AI About Today's Fertility ✦",
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
