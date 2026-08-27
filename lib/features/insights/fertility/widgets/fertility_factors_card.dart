import 'package:flutter/material.dart';

/// "What increases your chances" 4-Factor Card for Fertility Subscreen matching the exact mockup.
class FertilityFactorsCard extends StatelessWidget {
  final VoidCallback? onSeeAll;
  final ValueChanged<int>? onFactorTap;

  const FertilityFactorsCard({
    super.key,
    this.onSeeAll,
    this.onFactorTap,
  });

  static const List<Map<String, dynamic>> _factors = [
    {
      'icon': Icons.favorite_border_rounded,
      'iconColor': Color(0xFFE84855),
      'iconBg': Color(0xFFFFEEF0),
      'title': 'Have sex',
      'subtitle': 'Every 1–2 days',
    },
    {
      'icon': Icons.nights_stay_outlined,
      'iconColor': Color(0xFF8B5CF6),
      'iconBg': Color(0xFFEDE9FE),
      'title': 'Get good sleep',
      'subtitle': '7–9 hours',
    },
    {
      'icon': Icons.eco_outlined,
      'iconColor': Color(0xFF10B981),
      'iconBg': Color(0xFFE8F5E9),
      'title': 'Manage stress',
      'subtitle': 'Daily relaxation',
    },
    {
      'icon': Icons.water_drop_outlined,
      'iconColor': Color(0xFF3B82F6),
      'iconBg': Color(0xFFEFF6FF),
      'title': 'Stay hydrated',
      'subtitle': '8 cups a day',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Header: Title + See all >
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'What increases your chances',
              style: TextStyle(
                fontFamily: 'serif',
                fontWeight: FontWeight.w900,
                fontSize: 15.0,
                color: Color(0xFF1E1A3C),
                letterSpacing: -0.2,
              ),
            ),
            InkWell(
              onTap: onSeeAll,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'See all',
                    style: TextStyle(
                      color: Color(0xFFE84855),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 2.0),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 13.0,
                    color: Color(0xFFE84855),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 8.0),

        // 2. 4 Factor Cards Row
        Row(
          children: List.generate(4, (index) {
            final f = _factors[index];

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index < 3 ? 6.0 : 0.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16.0),
                    onTap: () => onFactorTap?.call(index),
                    child: Container(
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
                            blurRadius: 8.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 10.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Circular Icon Container
                          Container(
                            width: 36.0,
                            height: 36.0,
                            decoration: BoxDecoration(
                              color: f['iconBg'] as Color,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                f['icon'] as IconData,
                                color: f['iconColor'] as Color,
                                size: 18.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6.0),

                          // Title
                          Text(
                            f['title'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E1A3C),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2.0),

                          // Subtitle
                          Text(
                            f['subtitle'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF7A708A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
