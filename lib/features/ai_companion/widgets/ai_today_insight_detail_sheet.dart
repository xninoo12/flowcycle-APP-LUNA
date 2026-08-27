import 'package:flutter/material.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../shared/widgets/buttons/primary_button.dart';

/// Modal bottom sheet popup for Today's AI Insight details and physiological breakdown.
class AiTodayInsightDetailSheet extends StatelessWidget {
  final ValueChanged<String>? onAskAiPrompt;

  const AiTodayInsightDetailSheet({super.key, this.onAskAiPrompt});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFAF7F2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          const SizedBox(height: 12.0),
          Container(
            width: 44.0,
            height: 4.5,
            decoration: BoxDecoration(
              color: const Color(0xFFE2DCE8),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          const SizedBox(height: 14.0),

          // Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Text('🔮', style: TextStyle(fontSize: 18.0)),
                          SizedBox(width: 6.0),
                          Text(
                            "Today's AI Insight",
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 22.0,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E1A3C),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        'Hormone-synced clinical intelligence & rhythm',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF7A708A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFF7A708A),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14.0),
          const Divider(height: 1.0, color: Color(0xFFEFE9F4)),

          // Scrollable Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Insight Card
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFF0F5), Color(0xFFFAF2FE)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: const Color(0xFFFFD6E2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 42.0,
                          height: 42.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14.0),
                            border: Border.all(color: const Color(0xFFFFD1DC)),
                          ),
                          child: const Center(
                            child: Text('✨', style: TextStyle(fontSize: 20.0)),
                          ),
                        ),
                        const SizedBox(width: 14.0),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Estrogen Surge & Peak Vitality',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1E1A3C),
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                'Your follicular estrogen is peaking today, driving enhanced neuro-cognitive clarity, verbal fluency, and metabolic efficiency.',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Color(0xFF5E546E),
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // Biomarker & Strategy Cards
                  const Text(
                    'Cycle Synced Recommendations',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E1A3C),
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  _buildPillarTile(
                    emoji: '🥗',
                    title: 'Nutritional Focus',
                    body:
                        'Cruciferous vegetables (broccoli, arugula) help support liver estrogen metabolism and glutathione production.',
                  ),
                  const SizedBox(height: 10.0),

                  _buildPillarTile(
                    emoji: '🏃‍♀️',
                    title: 'Movement & Workouts',
                    body:
                        'High energy threshold makes today ideal for strength resistance workouts and cardiovascular conditioning.',
                  ),
                  const SizedBox(height: 10.0),

                  _buildPillarTile(
                    emoji: '🧠',
                    title: 'Cognitive & Mood Rhythm',
                    body:
                        'Elevated estradiol enhances social connection, creative brainstorming, and strategic decision making.',
                  ),

                  const SizedBox(height: 24.0),

                  // Ask AI Button
                  PrimaryButton(
                    label: 'Ask AI About Today’s Rhythm ✦',
                    gradient: AppGradients.dawnBloom,
                    height: 50.0,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onAskAiPrompt?.call(
                        "Explain my hormone profile and how to optimize my day today",
                      );
                    },
                  ),
                  const SizedBox(height: 12.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillarTile({
    required String emoji,
    required String title,
    required String body,
  }) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(color: const Color(0xFFE8E2EE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22.0)),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1A3C),
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFF7A708A),
                    height: 1.35,
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
