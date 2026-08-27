import 'package:flutter/material.dart';
import '../../../shared/models/app_mode.dart';

/// Selectable goal/mode card for FlowCycle Adaptive Onboarding.
///
/// Clearly communicates mode intent (Cycle Wellness vs Trying to Conceive)
/// with floral illustrations, feature chips, and multi-attribute selection indicators.
class ModeSelectionCard extends StatelessWidget {
  final AppMode mode;
  final bool isSelected;
  final VoidCallback onSelect;

  const ModeSelectionCard({
    super.key,
    required this.mode,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCycle = mode == AppMode.cycleAwareness;
    final String title = isCycle ? 'Cycle Wellness' : 'Trying to Conceive';
    final String description = isCycle
        ? 'Track your cycle, moods\n& overall wellness.'
        : 'Optimize your fertility\nand track ovulation.';

    final String flowerAsset = isCycle
        ? 'assets/images/cycle_wellness_flower.png'
        : 'assets/images/ttc_flower.png';

    final Color accentColor = isCycle
        ? const Color(0xFFFF4D79)
        : const Color(0xFFFF8C66);

    final Color iconBg = isCycle
        ? const Color(0xFFFFEEF3)
        : const Color(0xFFFFF2EB);

    final IconData mainIcon = isCycle
        ? Icons.spa_rounded
        : Icons.favorite_border_rounded;

    return Semantics(
      selected: isSelected,
      button: true,
      label: '$title: $description',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF8DA1)
                : const Color(0xFFEFE8ED),
            width: isSelected ? 1.6 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0x1FFF4D79)
                  : const Color(0x0A1E1A3C),
              blurRadius: isSelected ? 16.0 : 8.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.0),
          child: Stack(
            children: [
              // 1. Right-side Blooming Floral Accent Art
              Positioned(
                right: -10,
                top: -10,
                bottom: -10,
                width: 140,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: isSelected ? 0.95 : 0.65,
                    child: Image.asset(
                      flowerAsset,
                      fit: BoxFit.contain,
                      alignment: Alignment.centerRight,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),

              // 2. Card Interactive Content
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onSelect,
                  borderRadius: BorderRadius.circular(24.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 14.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Row: Most Popular Badge + Selector Radio
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Left Main Icon
                            Container(
                              width: 44.0,
                              height: 44.0,
                              decoration: BoxDecoration(
                                color: iconBg,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  mainIcon,
                                  color: accentColor,
                                  size: 22.0,
                                ),
                              ),
                            ),

                            const SizedBox(width: 12.0),

                            // Center: Most Popular Badge (if cycle) or Title area
                            if (isCycle)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 4.0,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFEEF2),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: const Text(
                                  'MOST POPULAR',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFFF4D79),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),

                            const Spacer(),

                            // Right Selection Indicator Circle
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 24.0,
                              height: 24.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? const Color(0xFFFF4D79)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFFF4D79)
                                      : const Color(0xFFD6CCD8),
                                  width: isSelected ? 1.5 : 1.4,
                                ),
                              ),
                              child: isSelected
                                  ? const Center(
                                      child: Icon(
                                        Icons.check_rounded,
                                        size: 15.0,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                          ],
                        ),

                        const SizedBox(height: 8.0),

                        // Title
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1A3C),
                            letterSpacing: -0.3,
                          ),
                        ),

                        const SizedBox(height: 4.0),

                        // Description
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 220),
                          child: Text(
                            description,
                            style: const TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF7A708A),
                              height: 1.35,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12.0),

                        // Bottom Feature Chips Row
                        Row(
                          children: isCycle
                              ? [
                                  _buildFeatureChip(
                                    icon: Icons.calendar_month_rounded,
                                    label: 'Cycle',
                                    iconColor: const Color(0xFFFF4D79),
                                  ),
                                  const SizedBox(width: 8.0),
                                  _buildFeatureChip(
                                    icon: Icons.sentiment_satisfied_alt_rounded,
                                    label: 'Mood',
                                    iconColor: const Color(0xFFFF4D79),
                                  ),
                                ]
                              : [
                                  _buildFeatureChip(
                                    icon: Icons.track_changes_rounded,
                                    label: 'Ovulation',
                                    iconColor: const Color(0xFFFF8C66),
                                  ),
                                  const SizedBox(width: 8.0),
                                  _buildFeatureChip(
                                    icon: Icons.bar_chart_rounded,
                                    label: 'Insights',
                                    iconColor: const Color(0xFF7A708A),
                                  ),
                                ],
                        ),
                      ],
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

  Widget _buildFeatureChip({
    required IconData icon,
    required String label,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7F9),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: const Color(0xFFEFE8ED),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.0,
            color: iconColor,
          ),
          const SizedBox(width: 5.0),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2C243B),
            ),
          ),
        ],
      ),
    );
  }
}
