import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Modal detailing biological, hormonal, and wellness insights for a cycle phase.
class PhaseDetailSheet extends StatelessWidget {
  final String phaseName;
  final String dayRange;
  final String emoji;
  final Color themeColor;
  final String hormoneOverview;
  final String bodySignals;
  final List<String> wellnessTips;

  const PhaseDetailSheet({
    super.key,
    required this.phaseName,
    required this.dayRange,
    required this.emoji,
    required this.themeColor,
    required this.hormoneOverview,
    required this.bodySignals,
    required this.wellnessTips,
  });

  void _askAi(BuildContext context) {
    Navigator.pop(context);
    try {
      context.push(
        AppRoutes.aiChatPath,
        extra: {
          'prompt':
              'Tell me more about the $phaseName ($dayRange) and how I can optimize my energy and health.',
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
          // Header Grab Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 14, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      '$phaseName ($dayRange)',
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
                  // Hormone Profile Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.1),
                      borderRadius: AppRadius.medium,
                      border: Border.all(
                        color: themeColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.bubble_chart_rounded,
                              color: themeColor,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Hormone Profile',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: themeColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          hormoneOverview,
                          style: AppTextStyles.body.copyWith(
                            color: const Color(0xFF1E1A3C),
                            fontSize: 13,
                            height: 1.45,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'BODY SIGNALS & BIOMARKERS',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF7A708A),
                      letterSpacing: 0.8,
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.medium,
                      border: Border.all(color: const Color(0xFFEFE9F3)),
                      boxShadow: AppShadows.card,
                    ),
                    child: Text(
                      bodySignals,
                      style: AppTextStyles.caption.copyWith(
                        color: const Color(0xFF4A4259),
                        fontSize: 12.5,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'OPTIMAL LIFESTYLE & NUTRITION',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF7A708A),
                      letterSpacing: 0.8,
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ...wellnessTips.map((tip) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: AppRadius.medium,
                          border: Border.all(color: const Color(0xFFEFE9F3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '✦ ',
                              style: TextStyle(
                                color: themeColor,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                tip,
                                style: AppTextStyles.caption.copyWith(
                                  color: const Color(0xFF1E1A3C),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                onPressed: () => _askAi(context),
                icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                label: Text(
                  'Ask AI About $phaseName ✦',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
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
