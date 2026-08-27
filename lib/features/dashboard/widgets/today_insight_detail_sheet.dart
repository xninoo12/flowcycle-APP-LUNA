import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/route_names.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';

/// Modal detailing AI cycle-synced nutrition, workout, and vitality insights for today.
class TodayInsightDetailSheet extends StatelessWidget {
  final String title;
  final String message;

  const TodayInsightDetailSheet({
    super.key,
    required this.title,
    required this.message,
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
                const Text('✨', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'AI Cycle Harmony & Lifestyle',
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
                  // Hero Insight Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF3EDFA), Color(0xFFEDE5F7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: AppRadius.medium,
                      border: Border.all(color: const Color(0xFFDDD6FE)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF5B21B6),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          message,
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
                    'CYCLE-SYNCED RECOMMENDATIONS',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF7A708A),
                      letterSpacing: 0.8,
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 10),

                  _buildPillarCard(
                    '🥑 Nutrition & Metabolism',
                    'Incorporate magnesium, complex carbohydrates (sweet potato, oats), and lean proteins to support steady blood sugar.',
                    const Color(0xFF10B981),
                  ),
                  const SizedBox(height: 8),
                  _buildPillarCard(
                    '🧘‍♀️ Movement & Workouts',
                    'Shift from heavy resistance to low-impact Pilates, brisk walking, or gentle stretching.',
                    const Color(0xFF7C5CE7),
                  ),
                  const SizedBox(height: 8),
                  _buildPillarCard(
                    '🌙 Sleep & Mental Focus',
                    'Take a warm bath with Epsom salts 1 hour before bed to facilitate restorative REM sleep.',
                    const Color(0xFF3B82F6),
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
                    context.push(AppRoutes.aiCompanionPath);
                  } catch (_) {}
                },
                icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                label: const Text(
                  'Ask AI Companion About Today ✦',
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

  Widget _buildPillarCard(String title, String description, Color accentColor) {
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
