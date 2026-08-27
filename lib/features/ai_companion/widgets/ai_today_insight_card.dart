import 'package:flutter/material.dart';

/// "Today's Insight" Card with crystal ball icon and 3D glowing heart graphic.
class AiTodayInsightCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onTap;

  const AiTodayInsightCard({
    super.key,
    this.title = "Today's Insight",
    this.description =
        "You're in your fertile window and your body is showing positive signs. Great time to prioritize rest, hydration and connection.",
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: const Color(0xFFF1ECF5), width: 1.0),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E1A3C).withValues(alpha: 0.025),
                blurRadius: 10.0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 11.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Crystal Ball Icon
              Container(
                width: 40.0,
                height: 40.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3EDFA),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.lens_blur_rounded,
                    color: Color(0xFF8B5CF6),
                    size: 20.0,
                  ),
                ),
              ),

              const SizedBox(width: 10.0),

              // 2. Text Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 13.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF8B5CF6),
                          ),
                        ),
                        const SizedBox(width: 3.0),
                        const Text('✦', style: TextStyle(color: Color(0xFFF59E0B), fontSize: 10.0)),
                      ],
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6E6875),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8.0),

              // 3. Glowing Pink Heart
              Container(
                width: 44.0,
                height: 44.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F5),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFFD4E2),
                    width: 0.8,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: const [
                    Icon(
                      Icons.favorite_rounded,
                      color: Color(0xFFFF85A1),
                      size: 24.0,
                    ),
                    Positioned(
                      top: 4.0,
                      right: 4.0,
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        color: Color(0xFFFFBACD),
                        size: 11.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
