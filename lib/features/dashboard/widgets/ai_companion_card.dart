import 'package:flutter/material.dart';
import '../../../shared/models/app_mode.dart';

/// Dynamic AI Insight / Fertility Guidance Card with Friendly Bot Avatar.
class AiCompanionCard extends StatelessWidget {
  final AppMode mode;
  final String? insightText;
  final VoidCallback onTap;

  const AiCompanionCard({
    super.key,
    required this.mode,
    this.insightText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCycle = mode == AppMode.cycleAwareness;

    final defaultText = isCycle
        ? 'Your energy may rise in the next few days. Great time to focus on goals and build healthy habits. 🌸'
        : "You're in your fertile window! Having intercourse today or tomorrow gives you the highest chance. 💕";

    final text = insightText ?? defaultText;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 18.0,
            vertical: 16.0,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isCycle
                  ? [
                      const Color(0xFFF9F6FF),
                      Colors.white,
                    ]
                  : [
                      const Color(0xFFFFF5F8),
                      Colors.white,
                    ],
            ),
            borderRadius: BorderRadius.circular(22.0),
            border: Border.all(
              color: isCycle
                  ? const Color(0xFFE9D5FF)
                  : const Color(0xFFFFD6E2),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: (isCycle
                        ? const Color(0xFF7C5CE7)
                        : const Color(0xFFFF4D79))
                    .withValues(alpha: 0.04),
                blurRadius: 14.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          size: 13.0,
                          color: isCycle
                              ? const Color(0xFF7C5CE7)
                              : const Color(0xFFFF4D79),
                        ),
                        const SizedBox(width: 5.0),
                        Flexible(
                          child: Text(
                            isCycle ? 'AI Insight' : 'AI Fertility Guidance',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: isCycle
                                  ? const Color(0xFF7C5CE7)
                                  : const Color(0xFFFF4D79),
                              letterSpacing: -0.2,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B627A),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            'Chat with AI Companion',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: isCycle
                                  ? const Color(0xFF7C5CE7)
                                  : const Color(0xFFFF4D79),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 12.0,
                          color: isCycle
                              ? const Color(0xFF7C5CE7)
                              : const Color(0xFFFF4D79),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 14.0),

              // Right AI Bot Avatar Illustration
              Container(
                width: 64.0,
                height: 64.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: isCycle
                        ? [
                            const Color(0xFF8B5CF6),
                            const Color(0xFF6D28D9),
                          ]
                        : [
                            const Color(0xFFFF6B8B),
                            const Color(0xFFFF4D79),
                          ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isCycle
                              ? const Color(0xFF8B5CF6)
                              : const Color(0xFFFF4D79))
                          .withValues(alpha: 0.3),
                      blurRadius: 12.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 48.0,
                    height: 38.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 7.0,
                            height: 7.0,
                            decoration: BoxDecoration(
                              color: isCycle
                                  ? const Color(0xFF6D28D9)
                                  : const Color(0xFFFF4D79),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Container(
                            width: 7.0,
                            height: 7.0,
                            decoration: BoxDecoration(
                              color: isCycle
                                  ? const Color(0xFF6D28D9)
                                  : const Color(0xFFFF4D79),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
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
