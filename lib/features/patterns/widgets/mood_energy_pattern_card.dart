import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';

class MoodEnergyPatternCard extends StatelessWidget {
  const MoodEnergyPatternCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.large,
        border: Border.all(color: const Color(0xFFF0EBF5), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C5CE7).withValues(alpha: 0.05),
            blurRadius: 14.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9E6),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Icon(
                        Icons.bolt_rounded,
                        color: Color(0xFFF59E0B),
                        size: 20.0,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Flexible(
                      child: Text(
                        'Mood & Energy Rhythm',
                        style: AppTextStyles.subtitle.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 15.0,
                          color: const Color(0xFF1E1A3C),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF5FF),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Text(
                  'Infradian Sync',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8B5CF6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Text(
            'Your monthly infradian rhythm dictates predictable mental and physical energy peaks:',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16.0),

          // 4 Phase Grid Cards
          Row(
            children: [
              Expanded(
                child: _buildPhaseRhythmTile(
                  phase: 'Menstrual',
                  days: 'Days 1–5',
                  mood: 'Reflective 🧘‍♀️',
                  energy: 'Low / Inward',
                  color: const Color(0xFFFF5252),
                  bgColor: const Color(0xFFFFF1F1),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: _buildPhaseRhythmTile(
                  phase: 'Follicular',
                  days: 'Days 6–12',
                  mood: 'Creative 🚀',
                  energy: 'Rising / High',
                  color: const Color(0xFF3B82F6),
                  bgColor: const Color(0xFFEFF6FF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              Expanded(
                child: _buildPhaseRhythmTile(
                  phase: 'Ovulatory',
                  days: 'Days 13–16',
                  mood: 'Confident 👑',
                  energy: 'Peak Vibrant',
                  color: const Color(0xFF10B981),
                  bgColor: const Color(0xFFECFDF5),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: _buildPhaseRhythmTile(
                  phase: 'Luteal',
                  days: 'Days 17–28',
                  mood: 'Nesting 🌿',
                  energy: 'Gentle / Wind Down',
                  color: const Color(0xFF8B5CF6),
                  bgColor: const Color(0xFFF5F3FF),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14.0),

          // Cycle Synching Tip
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: AppRadius.medium,
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('✨', style: TextStyle(fontSize: 16.0)),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    'Cycle Syncing Tip: Schedule major creative work and high-intensity workouts during your Follicular & Ovulatory window when estrogen and dopamine are at their highest.',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF92400E),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseRhythmTile({
    required String phase,
    required String days,
    required String mood,
    required String energy,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.medium,
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  phase,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4.0),
              Text(
                days,
                style: TextStyle(
                  fontSize: 9.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Text(
            mood,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E1A3C),
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            'Energy: $energy',
            style: TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
