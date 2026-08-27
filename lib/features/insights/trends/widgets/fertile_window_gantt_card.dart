import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// "Fertile window vs ovulation" Gantt Range Chart Card for Trends subscreen.
class FertileWindowGanttCard extends StatelessWidget {
  const FertileWindowGanttCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.large,
        border: Border.all(color: const Color(0xFFEFE9F3), width: 1.0),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header: Title + Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Fertile window vs ovulation',
                  style: AppTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                    color: const Color(0xFF1E1A3C),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLegendDot(const Color(0xFF43C59E), 'Fertile window'),
                  const SizedBox(width: 6.0),
                  _buildLegendDot(const Color(0xFF6C5CE7), 'Ovulation'),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // 2. Gantt Bars & AI Callout Tile
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Gantt Chart Area
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    _buildGanttRow(
                      month: 'Feb',
                      startFraction: 0.22,
                      widthFraction: 0.38,
                      ovulationFraction: 0.63,
                    ),
                    _buildGanttRow(
                      month: 'Mar',
                      startFraction: 0.36,
                      widthFraction: 0.48,
                      ovulationFraction: 0.86,
                    ),
                    _buildGanttRow(
                      month: 'Apr',
                      startFraction: 0.35,
                      widthFraction: 0.28,
                      ovulationFraction: 0.65,
                    ),
                    _buildGanttRow(
                      month: 'May',
                      startFraction: 0.50,
                      widthFraction: 0.36,
                      ovulationFraction: 0.88,
                    ),
                    _buildGanttRow(
                      month: 'Jun',
                      startFraction: 0.25,
                      widthFraction: 0.28,
                      ovulationFraction: 0.55,
                    ),

                    const SizedBox(height: 6.0),

                    // X-Axis Day Numbers (5, 10, 15, 20, 25, 30)
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            '5',
                            style: TextStyle(
                              fontSize: 8.5,
                              color: Color(0xFF8C7C92),
                            ),
                          ),
                          Text(
                            '10',
                            style: TextStyle(
                              fontSize: 8.5,
                              color: Color(0xFF8C7C92),
                            ),
                          ),
                          Text(
                            '15',
                            style: TextStyle(
                              fontSize: 8.5,
                              color: Color(0xFF8C7C92),
                            ),
                          ),
                          Text(
                            '20',
                            style: TextStyle(
                              fontSize: 8.5,
                              color: Color(0xFF8C7C92),
                            ),
                          ),
                          Text(
                            '25',
                            style: TextStyle(
                              fontSize: 8.5,
                              color: Color(0xFF8C7C92),
                            ),
                          ),
                          Text(
                            '30',
                            style: TextStyle(
                              fontSize: 8.5,
                              color: Color(0xFF8C7C92),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              // Right: AI Consistency Callout Tile
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F5),
                    borderRadius: BorderRadius.circular(14.0),
                    border: Border.all(
                      color: const Color(0xFFFFD4E2),
                      width: 0.8,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sparkle Icon Container
                      Container(
                        width: 28.0,
                        height: 28.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE1EA),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            color: Color(0xFFE84D75),
                            size: 15.0,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8.0),

                      // Text: "Your cycles are very consistent!"
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E1A3C),
                            height: 1.25,
                          ),
                          children: [
                            TextSpan(text: 'Your cycles are\n'),
                            TextSpan(
                              text: 'very consistent!',
                              style: TextStyle(
                                color: Color(0xFFE84D75),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 4.0),

                      const Text(
                        'Keep tracking to unlock deeper insights.',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF7A708A),
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGanttRow({
    required String month,
    required double startFraction,
    required double widthFraction,
    required double ovulationFraction,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 22.0,
            child: Text(
              month,
              style: const TextStyle(
                fontSize: 9.0,
                color: Color(0xFF8C7C92),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 2.0),
          Expanded(
            child: SizedBox(
              height: 12.0,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Light background track
                  Container(height: 1.0, color: const Color(0xFFEFE9F3)),

                  // Fertile Window Capsule
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final left = constraints.maxWidth * startFraction;
                      final width = constraints.maxWidth * widthFraction;
                      final ovuLeft = constraints.maxWidth * ovulationFraction;

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: left,
                            width: width,
                            top: 1.0,
                            bottom: 1.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFB4EBD8),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                          ),
                          Positioned(
                            left: ovuLeft,
                            top: 2.0,
                            child: Container(
                              width: 8.0,
                              height: 8.0,
                              decoration: const BoxDecoration(
                                color: Color(0xFF6C5CE7),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5.5,
          height: 5.5,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 3.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF7A708A),
          ),
        ),
      ],
    );
  }
}
