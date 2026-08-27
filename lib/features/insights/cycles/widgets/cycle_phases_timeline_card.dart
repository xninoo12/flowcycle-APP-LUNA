import 'package:flutter/material.dart';

/// "Cycle phases ✦" Connected Milestone Timeline for Cycles Subscreen matching the exact mockup.
class CyclePhasesTimelineCard extends StatelessWidget {
  final ValueChanged<int>? onPhaseTap;
  final VoidCallback? onLearnMore;
  final List<Map<String, dynamic>>? dynamicPhases;

  const CyclePhasesTimelineCard({
    super.key,
    this.onPhaseTap,
    this.onLearnMore,
    this.dynamicPhases,
  });

  static const List<Map<String, dynamic>> _phases = [
    {
      'number': '1',
      'icon': Icons.water_drop_outlined,
      'iconColor': Color(0xFFE84855),
      'iconBg': Color(0xFFFFEEF0),
      'name': 'Period',
      'dates': 'May 1 – May 5',
      'badgeColor': Color(0xFFFF6B8B),
    },
    {
      'number': '2',
      'icon': Icons.eco_outlined,
      'iconColor': Color(0xFF10B981),
      'iconBg': Color(0xFFE8F5E9),
      'name': 'Follicular',
      'dates': 'May 6 – May 13',
      'badgeColor': Color(0xFF10B981),
    },
    {
      'number': '3',
      'icon': Icons.track_changes_rounded,
      'iconColor': Color(0xFF8B5CF6),
      'iconBg': Color(0xFFEDE9FE),
      'name': 'Ovulation',
      'dates': 'May 14',
      'badgeColor': Color(0xFF8B5CF6),
    },
    {
      'number': '4',
      'icon': Icons.local_florist_outlined,
      'iconColor': Color(0xFFF59E0B),
      'iconBg': Color(0xFFFEF3C7),
      'name': 'Luteal',
      'dates': 'May 15 – May 28',
      'badgeColor': Color(0xFFF59E0B),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Header: Title + Learn more ⓘ
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Cycle phases',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w900,
                    fontSize: 15.5,
                    color: Color(0xFF1E1A3C),
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(width: 4.0),
                Text(
                  '✦',
                  style: TextStyle(
                    color: Color(0xFFF59E0B),
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: onLearnMore,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Learn more',
                    style: TextStyle(
                      color: Color(0xFF7A708A),
                      fontSize: 11.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 3.0),
                  Icon(
                    Icons.info_outline_rounded,
                    size: 13.0,
                    color: Color(0xFF7A708A),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 10.0),

        // 2. 4 Phase Circles with Dotted Connectors
        Row(
          children: List.generate(4, (index) {
            final p = _phases[index];
            final datesText = (dynamicPhases != null && index < dynamicPhases!.length)
                ? (dynamicPhases![index]['dates'] as String? ?? p['dates'] as String)
                : (p['dates'] as String);

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => onPhaseTap?.call(index),
                      borderRadius: BorderRadius.circular(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Stacked Circle with Number Badge
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 44.0,
                                height: 44.0,
                                decoration: BoxDecoration(
                                  color: p['iconBg'] as Color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: (p['badgeColor'] as Color).withValues(alpha: 0.3),
                                    width: 1.0,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    p['icon'] as IconData,
                                    color: p['iconColor'] as Color,
                                    size: 19.0,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -2,
                                left: -2,
                                child: Container(
                                  width: 15.0,
                                  height: 15.0,
                                  decoration: BoxDecoration(
                                    color: p['badgeColor'] as Color,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      p['number'] as String,
                                      style: const TextStyle(
                                        fontSize: 9.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6.0),

                          // Phase Name
                          Text(
                            p['name'] as String,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: p['iconColor'] as Color,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1.0),

                          // Phase Dates
                          Text(
                            datesText,
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
                  // Dotted connector line between phase circles
                  if (index < 3)
                    Container(
                      width: 16.0,
                      height: 1.5,
                      margin: const EdgeInsets.symmetric(horizontal: 2.0),
                      color: const Color(0xFFE2D9E8),
                    ),
                ],
              ),
            );
          }),
        ),

        const SizedBox(height: 12.0),

        // 3. Tip Box: Ovulation release tip with botanical artwork
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 9.0),
          decoration: BoxDecoration(
            color: const Color(0xFFFBF8FF),
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(color: const Color(0xFFEDE9FE), width: 1.0),
          ),
          child: Row(
            children: [
              Container(
                width: 28.0,
                height: 28.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFEDE9FE),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.lightbulb_outline_rounded,
                    color: Color(0xFF7C3AED),
                    size: 16.0,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              const Expanded(
                child: Text(
                  'Ovulation is the day your body is most likely to release an egg.',
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E1A3C),
                  ),
                ),
              ),
              const SizedBox(width: 4.0),
              const Text('🌿', style: TextStyle(fontSize: 16.0)),
            ],
          ),
        ),
      ],
    );
  }
}
