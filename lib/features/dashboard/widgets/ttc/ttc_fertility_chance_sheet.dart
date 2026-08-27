import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Modal detailing today's conception chance percentage, cervical mucus status, and BBT shift.
class TtcFertilityChanceSheet extends StatelessWidget {
  final int percentage;
  final String level;

  const TtcFertilityChanceSheet({
    super.key,
    required this.percentage,
    required this.level,
  });

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
              children: [
                const Text('🎯', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Today\'s Fertility Probability',
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
                  // Hero Probability Gauge Card
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
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE84D75),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '$percentage%',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$level Conception Probability',
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF9D174D),
                                ),
                              ),
                              const SizedBox(height: 3),
                              const Text(
                                'Prime biological conditions for fertilization today.',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF4A4259),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    'BIOLOGICAL INDICATOR ANALYSIS',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF7A708A),
                      letterSpacing: 0.8,
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 10),

                  _buildBiomarkerCard(
                    '💧 Cervical Fluid (Spinnbarkeit)',
                    'Egg-white consistency provides alkaline nourishment and easy transit for sperm to reach the fallopian tubes.',
                    const Color(0xFF3B82F6),
                  ),
                  const SizedBox(height: 8),
                  _buildBiomarkerCard(
                    '🧪 LH Ovulation Surge',
                    'Luteinizing hormone surge detected 24 hours prior to follicle rupture.',
                    const Color(0xFF7C5CE7),
                  ),
                  const SizedBox(height: 8),
                  _buildBiomarkerCard(
                    '🌡️ Basal Body Temperature (BBT)',
                    'Baseline thermal reading confirms ovulation is imminent.',
                    const Color(0xFFD97706),
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
                onPressed: () {
                  Navigator.pop(context);
                  try {
                    context.push(AppRoutes.dailyLogPath);
                  } catch (_) {}
                },
                icon: const Icon(Icons.edit_calendar_rounded, size: 18),
                label: const Text(
                  'Record Today\'s BBT & Mucus',
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

  Widget _buildBiomarkerCard(
    String title,
    String description,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.medium,
        border: Border.all(color: const Color(0xFFEFE9F3)),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: AppTextStyles.caption.copyWith(
              color: const Color(0xFF6B627A),
              fontSize: 11,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
