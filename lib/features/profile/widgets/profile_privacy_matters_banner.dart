import 'package:flutter/material.dart';

/// "Your privacy matters" Bottom Banner for Profile Screen matching the exact mockup.
class ProfilePrivacyMattersBanner extends StatelessWidget {
  final VoidCallback? onLearnMore;

  const ProfilePrivacyMattersBanner({super.key, this.onLearnMore});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 11.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F8),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: const Color(0xFFFFE4EC), width: 1.0),
      ),
      child: Row(
        children: [
          // Pink Lock Icon Container
          Container(
            width: 32.0,
            height: 32.0,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4EC),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Center(
              child: Icon(
                Icons.lock_rounded,
                color: Color(0xFFFF4D6D),
                size: 17.0,
              ),
            ),
          ),

          const SizedBox(width: 10.0),

          // Text Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Your privacy matters',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontStyle: FontStyle.italic,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFFF4D6D),
                  ),
                ),
                SizedBox(height: 1.0),
                Text(
                  'Your data is private, encrypted and never shared.',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7A708A),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 8.0),

          // "Learn more →" Pill Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onLearnMore,
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: const Color(0xFFFFD4E2),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF4D6D).withValues(alpha: 0.08),
                      blurRadius: 4.0,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Learn more',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFFF4D6D),
                      ),
                    ),
                    SizedBox(width: 3.0),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 11.0,
                      color: Color(0xFFFF4D6D),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
