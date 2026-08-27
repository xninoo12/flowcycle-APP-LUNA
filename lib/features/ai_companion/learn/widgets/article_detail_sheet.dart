import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Full interactive modal displaying complete health wisdom articles.
class ArticleDetailSheet extends StatelessWidget {
  final String title;
  final String category;
  final String author;
  final String summary;
  final List<String> takeaways;
  final List<Map<String, String>> sections;

  const ArticleDetailSheet({
    super.key,
    required this.title,
    required this.category,
    this.author = 'Dr. Maya Lin, OB/GYN & Endocrinologist',
    required this.summary,
    required this.takeaways,
    required this.sections,
  });

  void _askAiAboutArticle(BuildContext context) {
    Navigator.pop(context);
    try {
      context.push(
        AppRoutes.aiChatPath,
        extra: {'prompt': 'Can you explain more about "$title"?'},
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: const BoxDecoration(
        color: Color(0xFFFAF8FC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Header Grab Handle & Close Button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 14, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0EAF8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    category,
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFF7C64E8),
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
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

          // Scrollable Article Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: AppTextStyles.title.copyWith(
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1E1A3C),
                      fontSize: 22,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Author Byline
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFF0F5),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('👩‍⚕️', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              author,
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1E1A3C),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Medical Reviewer & Cycle Specialist',
                              style: AppTextStyles.caption.copyWith(
                                color: const Color(0xFF7A708A),
                                fontSize: 10.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Summary Box
                  Text(
                    summary,
                    style: AppTextStyles.body.copyWith(
                      color: const Color(0xFF4A4259),
                      fontSize: 13.5,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Key Takeaways Box
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
                          children: [
                            const Icon(
                              Icons.stars_rounded,
                              color: Color(0xFF7C64E8),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'KEY CLINICAL TAKEAWAYS',
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF7C64E8),
                                letterSpacing: 0.8,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...takeaways.map((point) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '✦ ',
                                  style: TextStyle(
                                    color: Color(0xFF7C64E8),
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    point,
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
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Detailed Article Sections
                  ...sections.map((sec) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sec['heading'] ?? '',
                            style: AppTextStyles.subtitle.copyWith(
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1E1A3C),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            sec['body'] ?? '',
                            style: AppTextStyles.body.copyWith(
                              color: const Color(0xFF4A4259),
                              fontSize: 13,
                              height: 1.55,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Bottom Action Bar ("Ask AI About This Article")
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
                onPressed: () => _askAiAboutArticle(context),
                icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                label: const Text(
                  'Ask AI About This Article ✦',
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
}
