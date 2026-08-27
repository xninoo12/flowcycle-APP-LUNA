import 'package:flutter/material.dart';
import 'models/article_item.dart';
import 'widgets/article_reader_modal.dart';

/// Interactive "AI Learning & Daily Wisdom" Carousel for AI Companion Hub matching the exact mockup.
class AiLearningSection extends StatefulWidget {
  final ValueChanged<String>? onTopicAskAi;

  const AiLearningSection({super.key, this.onTopicAskAi});

  @override
  State<AiLearningSection> createState() => _AiLearningSectionState();
}

class _AiLearningSectionState extends State<AiLearningSection> {
  int _activePageIndex = 0;

  static const List<Map<String, dynamic>> _wisdomCards = [
    {
      'id': 'art_cycle',
      'title': 'Understanding\nYour Cycle',
      'subtitle': 'Learn how your cycle works and what your body is telling you.',
      'badge': 'New',
      'badgeBg': Color(0xFF8B5CF6),
      'gradient': [Color(0xFFF7F2FE), Color(0xFFEDE4FD)],
      'arrowColor': Color(0xFF8B5CF6),
      'iconType': 'book',
      'article': ArticleItem(
        id: 'art_cycle',
        title: 'Understanding Your Cycle',
        category: 'Cycle Phases',
        summary:
            'Your menstrual cycle consists of four distinct phases: menstrual, follicular, ovulatory, and luteal. Understanding the hormonal shifts behind each phase empowers you to optimize energy, mood, and conception timing.',
        keyTakeaways: [
          'Estrogen rises during follicular phase, boosting energy and optimism.',
          'LH surge triggers ovulation within 24–36 hours.',
          'Progesterone dominates the luteal phase, supporting implantation and restorative rest.',
        ],
        themeColor: Color(0xFF8B5CF6),
        icon: Icons.auto_stories_rounded,
      ),
    },
    {
      'id': 'art_fertility_boost',
      'title': 'Boost Fertility\nNaturally',
      'subtitle': 'Simple habits that support your fertility and overall wellness.',
      'badge': null,
      'gradient': [Color(0xFFFFF4F2), Color(0xFFFFECE8)],
      'arrowColor': Color(0xFFFF6B8B),
      'iconType': 'plant',
      'article': ArticleItem(
        id: 'art_fertility_boost',
        title: 'Boost Fertility Naturally',
        category: 'Fertility',
        summary:
            'Evidence-based lifestyle habits significantly improve ovarian function, sperm viability, and endometrial receptivity.',
        keyTakeaways: [
          'Aim for 7–9 hours of restful sleep to stabilize melatonin and cortisol.',
          'Incorporate antioxidant-rich foods like berries, leafy greens, and walnuts.',
          'Maintain regular moderate exercise while avoiding chronic overexertion.',
        ],
        themeColor: Color(0xFFFF6B8B),
        icon: Icons.local_florist_rounded,
      ),
    },
    {
      'id': 'art_mind_body',
      'title': 'Mind & Body\nBalance',
      'subtitle': 'Balance your stress hormones and optimize daily flow.',
      'badge': null,
      'gradient': [Color(0xFFF5F3FF), Color(0xFFECE7FF)],
      'arrowColor': Color(0xFF7C3AED),
      'iconType': 'mind',
      'article': ArticleItem(
        id: 'art_mind_body',
        title: 'Mind & Body Balance',
        category: 'Wellness',
        summary:
            'Mind-body interventions such as meditation, gentle yoga, and journaling lower autonomic stress responses and promote hormonal harmony.',
        keyTakeaways: [
          '10 minutes of box breathing reduces acute cortisol spikes.',
          'Acupressure and warm foot soaks encourage pelvic blood circulation.',
          'Open emotional expression with your partner strengthens intimacy.',
        ],
        themeColor: Color(0xFF7C3AED),
        icon: Icons.self_improvement_rounded,
      ),
    },
  ];

  void _openArticle(ArticleItem article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ArticleReaderModal(
        article: article,
        onAskAiPressed: () {
          Navigator.of(ctx).pop();
          widget.onTopicAskAi?.call('Tell me more about ${article.title}');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Section Title: "AI Learning & Daily Wisdom"
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'AI Learning & Daily Wisdom',
              style: TextStyle(
                fontFamily: 'serif',
                fontWeight: FontWeight.w900,
                fontSize: 15.0,
                color: Color(0xFF1E1A3C),
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8.0),

        // 2. Horizontal Cards Carousel
        SizedBox(
          height: 140.0,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.76),
            padEnds: false,
            itemCount: _wisdomCards.length,
            onPageChanged: (idx) {
              setState(() {
                _activePageIndex = idx;
              });
            },
            itemBuilder: (context, index) {
              final card = _wisdomCards[index];
              final article = card['article'] as ArticleItem;

              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _openArticle(article),
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: card['gradient'] as List<Color>,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.8),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (card['arrowColor'] as Color).withValues(alpha: 0.08),
                            blurRadius: 10.0,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Optional Badge (e.g. "New")
                              if (card['badge'] != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 2.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: card['badgeBg'] as Color,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    card['badge'] as String,
                                    style: const TextStyle(
                                      fontSize: 9.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                              if (card['badge'] != null)
                                const SizedBox(height: 6.0),

                              // Title
                              Text(
                                card['title'] as String,
                                style: const TextStyle(
                                  fontFamily: 'serif',
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1E1A3C),
                                  height: 1.15,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 4.0),

                              // Subtitle
                              SizedBox(
                                width: 120.0,
                                child: Text(
                                  card['subtitle'] as String,
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF6E6875),
                                    height: 1.25,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          // Right Illustration Artwork
                          Positioned(
                            right: 0,
                            top: 10.0,
                            child: _buildCardIllustration(card['iconType'] as String),
                          ),

                          // Bottom Right Circular Arrow Button
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 26.0,
                              height: 26.0,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x15000000),
                                    blurRadius: 4.0,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 14.0,
                                  color: card['arrowColor'] as Color,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8.0),

        // 3. Dot Pagination Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_wisdomCards.length, (i) {
            final isActive = i == _activePageIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              width: isActive ? 16.0 : 5.0,
              height: 5.0,
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF8B5CF6)
                    : const Color(0xFFE2D9E8),
                borderRadius: BorderRadius.circular(3.0),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCardIllustration(String type) {
    if (type == 'book') {
      return SizedBox(
        width: 60.0,
        height: 60.0,
        child: Stack(
          alignment: Alignment.center,
          children: const [
            Icon(
              Icons.menu_book_rounded,
              color: Color(0xFFC4B5FD),
              size: 42.0,
            ),
            Positioned(
              top: 0,
              right: 4,
              child: Text('✦', style: TextStyle(color: Color(0xFFA78BFA), fontSize: 11.0)),
            ),
            Positioned(
              bottom: 4,
              right: 0,
              child: Text('🌸', style: TextStyle(fontSize: 10.0)),
            ),
          ],
        ),
      );
    } else if (type == 'plant') {
      return SizedBox(
        width: 60.0,
        height: 60.0,
        child: Stack(
          alignment: Alignment.center,
          children: const [
            Icon(
              Icons.spa_rounded,
              color: Color(0xFFFCA5A5),
              size: 40.0,
            ),
            Positioned(
              top: 2,
              right: 4,
              child: Text('✦', style: TextStyle(color: Color(0xFFF87171), fontSize: 11.0)),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: 60.0,
      height: 60.0,
      child: Stack(
        alignment: Alignment.center,
        children: const [
          Icon(
            Icons.self_improvement_rounded,
            color: Color(0xFFA78BFA),
            size: 42.0,
          ),
          Positioned(
            top: 2,
            right: 4,
            child: Text('✦', style: TextStyle(color: Color(0xFF8B5CF6), fontSize: 11.0)),
          ),
        ],
      ),
    );
  }
}
