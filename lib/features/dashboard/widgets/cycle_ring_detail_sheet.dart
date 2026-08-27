import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/route_names.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';

/// Modal detailing the 4-phase cycle ring breakdown and daily hormone curves.
class CycleRingDetailSheet extends StatelessWidget {
  final int currentDay;
  final int totalDays;
  final String phaseName;
  final String phaseDescription;

  const CycleRingDetailSheet({
    super.key,
    required this.currentDay,
    required this.totalDays,
    required this.phaseName,
    required this.phaseDescription,
  });

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
                const Text('🌸', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Cycle Phase & Hormone Curve',
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
                  // Hero Status Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF5F3FF), Color(0xFFECEBFE)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: AppRadius.medium,
                      border: Border.all(color: const Color(0xFFDDD6FE)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                phaseName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF5B21B6),
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
                                color: const Color(0xFF7C5CE7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Day $currentDay of $totalDays',
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
                          phaseDescription,
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
                    'DAILY HORMONE CONCENTRATIONS',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF7A708A),
                      letterSpacing: 0.8,
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Hormone Gauges
                  _buildHormoneGauge(
                    'Progesterone',
                    'Dominant (Corpus Luteum)',
                    0.85,
                    const Color(0xFF7C5CE7),
                  ),
                  const SizedBox(height: 8),
                  _buildHormoneGauge(
                    'Estrogen',
                    'Secondary Luteal Rise',
                    0.60,
                    const Color(0xFFEC4899),
                  ),
                  const SizedBox(height: 8),
                  _buildHormoneGauge(
                    'Luteinizing Hormone (LH)',
                    'Low Baseline',
                    0.15,
                    const Color(0xFF3B82F6),
                  ),
                  const SizedBox(height: 8),
                  _buildHormoneGauge(
                    'Follicle-Stimulating (FSH)',
                    'Suppressed',
                    0.10,
                    const Color(0xFF10B981),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    '4-PHASE CYCLE ARCHITECTURE',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF7A708A),
                      letterSpacing: 0.8,
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 10),

                  _buildPhaseTimelineCard(
                    'Menstrual Phase',
                    'Days 1–5 • Endometrial Shedding',
                    'Uterine lining clears; resting hormone baselines.',
                    const Color(0xFFE84D75),
                    const Color(0xFFFDE8EF),
                  ),
                  const SizedBox(height: 8),
                  _buildPhaseTimelineCard(
                    'Follicular Phase',
                    'Days 6–13 • Estrogen Surge',
                    'Follicles mature; energy and mental clarity peak.',
                    const Color(0xFF3B82F6),
                    const Color(0xFFEFF6FF),
                  ),
                  const SizedBox(height: 8),
                  _buildPhaseTimelineCard(
                    'Ovulation Phase',
                    'Day 14 • LH Peak & Egg Release',
                    'Optimal conception window; heightened libido.',
                    const Color(0xFF7C5CE7),
                    const Color(0xFFF3EDFA),
                  ),
                  const SizedBox(height: 8),
                  _buildPhaseTimelineCard(
                    'Luteal Phase',
                    'Days 15–28 • Progesterone Build',
                    'Uterine lining thickens; metabolic shift towards restorative care.',
                    const Color(0xFF8B5CF6),
                    const Color(0xFFFAF5FF),
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
                  'Log Today\'s Symptoms & Mood',
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

  Widget _buildHormoneGauge(
    String name,
    String levelText,
    double progress,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                name,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1A3C),
                ),
              ),
              Text(
                levelText,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFFF2EDF7),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseTimelineCard(
    String title,
    String timing,
    String description,
    Color accentColor,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
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
            width: 8,
            height: 38,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E1A3C),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timing,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF6B627A),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
