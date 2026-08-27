import 'package:flutter/material.dart';

/// Prompt card model
class AiSuggestedPrompt {
  final String text;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const AiSuggestedPrompt({
    required this.text,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });
}

/// "Try asking me ✨" Horizontal Scrolling Prompt Capsule Cards matching the exact mockup.
class AiPromptCarousel extends StatelessWidget {
  final ValueChanged<String>? onPromptSelected;
  final VoidCallback? onViewAll;

  static const List<AiSuggestedPrompt> prompts = [
    AiSuggestedPrompt(
      text: 'What are my best days to try this cycle?',
      icon: Icons.calendar_month_outlined,
      iconColor: Color(0xFFE84855),
      bgColor: Color(0xFFFFEEF0),
    ),
    AiSuggestedPrompt(
      text: 'How does stress affect fertility?',
      icon: Icons.show_chart_rounded,
      iconColor: Color(0xFF8B5CF6),
      bgColor: Color(0xFFEDE9FE),
    ),
    AiSuggestedPrompt(
      text: 'What foods are good for fertility?',
      icon: Icons.ramen_dining_outlined,
      iconColor: Color(0xFF10B981),
      bgColor: Color(0xFFE8F5E9),
    ),
    AiSuggestedPrompt(
      text: 'Is spotting normal in fertile window?',
      icon: Icons.water_drop_outlined,
      iconColor: Color(0xFFE84855),
      bgColor: Color(0xFFFFEEF0),
    ),
  ];

  const AiPromptCarousel({super.key, this.onPromptSelected, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Header: "Try asking me ✨" + "View all →"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Try asking me',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w900,
                    fontSize: 15.0,
                    color: Color(0xFF1E1A3C),
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(width: 4.0),
                Text('✨', style: TextStyle(fontSize: 13.0)),
              ],
            ),
            InkWell(
              onTap: onViewAll,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFF4D6D),
                    ),
                  ),
                  SizedBox(width: 3.0),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 13.0,
                    color: Color(0xFFFF4D6D),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 8.0),

        // 2. Horizontal Capsule Cards
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: prompts.map((prompt) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onPromptSelected?.call(prompt.text),
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      width: 175.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 9.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: const Color(0xFFF1ECF5),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E1A3C).withValues(alpha: 0.02),
                            blurRadius: 6.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Colored Icon Box
                          Container(
                            width: 32.0,
                            height: 32.0,
                            decoration: BoxDecoration(
                              color: prompt.bgColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Icon(
                                prompt.icon,
                                color: prompt.iconColor,
                                size: 16.0,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8.0),

                          // Prompt Text
                          Expanded(
                            child: Text(
                              prompt.text,
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E1A3C),
                                height: 1.25,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const SizedBox(width: 4.0),

                          // Chevron >
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 14.0,
                            color: Color(0xFF7A708A),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
