import 'package:flutter/material.dart';

/// Medical Disclaimer Banner for AI Companion screen.
class AiDisclaimerBanner extends StatelessWidget {
  final VoidCallback? onLearnMore;

  const AiDisclaimerBanner({super.key, this.onLearnMore});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 9.5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF8FF),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFEDE9FE), width: 1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Shield Icon Container
          Container(
            width: 30.0,
            height: 30.0,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FE),
              borderRadius: BorderRadius.circular(9.0),
            ),
            child: const Center(
              child: Icon(
                Icons.shield_outlined,
                color: Color(0xFF7C3AED),
                size: 17.0,
              ),
            ),
          ),

          const SizedBox(width: 8.0),

          // Message Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'AI Companion can make mistakes.',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E1A3C),
                  ),
                ),
                SizedBox(height: 1.0),
                Text(
                  'Always consult a healthcare professional for medical advice.',
                  style: TextStyle(
                    fontSize: 9.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7A708A),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 4.0),

          // "Learn more >"
          GestureDetector(
            onTap: onLearnMore,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Learn more',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF7C3AED),
                  ),
                ),
                SizedBox(width: 1.0),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 14.0,
                  color: Color(0xFF7C3AED),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
