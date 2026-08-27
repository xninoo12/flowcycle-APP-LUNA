import 'package:flutter/material.dart';
import '../models/article_item.dart';

/// Modal bottom sheet reader for AI Learning Articles.
class ArticleReaderModal extends StatelessWidget {
  final ArticleItem article;
  final VoidCallback? onAskAiPressed;

  const ArticleReaderModal({
    super.key,
    required this.article,
    this.onAskAiPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 24.0),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 36.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCD6E5),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // Category Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: article.themeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  article.category,
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w700,
                    color: article.themeColor,
                  ),
                ),
              ),

              const SizedBox(height: 12.0),

              // Title
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E1A3C),
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 12.0),

              // Summary
              Text(
                article.summary,
                style: const TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF4A4358),
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 18.0),

              // Key Takeaways Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF8FC),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: const Color(0xFFEFE9F3),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.auto_awesome,
                          size: 15.0,
                          color: Color(0xFF7C5CE7),
                        ),
                        SizedBox(width: 6.0),
                        Text(
                          'AI Key Takeaways',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E1A3C),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    ...article.keyTakeaways.map((point) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '• ',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF7C5CE7),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                point,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF4A4358),
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

              const SizedBox(height: 20.0),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                height: 44.0,
                child: ElevatedButton.icon(
                  onPressed:
                      onAskAiPressed ?? () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C5CE7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    elevation: 2.0,
                  ),
                  icon: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 16.0,
                  ),
                  label: const Text(
                    'Ask AI About This Topic',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
