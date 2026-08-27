import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Today's Chance & Conception Factors Card for TTC Dashboard.
class TtcTodaysChanceCard extends StatelessWidget {
  final int percentage;
  final String level;
  final VoidCallback? onLearnMore;
  final VoidCallback? onTap;

  const TtcTodaysChanceCard({
    super.key,
    this.percentage = 78,
    this.level = 'High',
    this.onLearnMore,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? onLearnMore,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.large,
          border: Border.all(color: const Color(0xFFEFE9F3), width: 1.0),
          boxShadow: AppShadows.card,
        ),
        padding: const EdgeInsets.all(AppSpacing.sm + 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header: Title + Upward Trend Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "Today's chance",
                    style: AppTextStyles.subtitle.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                      color: const Color(0xFF1E1A3C),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4.0),
                const Icon(
                  Icons.trending_up_rounded,
                  color: Color(0xFFE84D75),
                  size: 18.0,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm + 2.0),

            // 2. Gauge + Main Factors Row
            Row(
              children: [
                // Circular Gauge (78% High)
                SizedBox(
                  width: 68.0,
                  height: 68.0,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(68.0, 68.0),
                        painter: _GaugeArcPainter(progress: percentage / 100.0),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$percentage%',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E1A3C),
                              height: 1.1,
                            ),
                          ),
                          Text(
                            level,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2E9E68),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: AppSpacing.sm + 2.0),

                // Main Factors List
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Main factors',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 9.0,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF7A708A),
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      _buildFactorItem('High fertility', isArrow: true),
                      _buildFactorItem('Cervical mucus', isArrow: true),
                      _buildFactorItem('Ovulation soon', isArrow: true),
                      _buildFactorItem('Intercourse logged', isCheck: true),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm + 4.0),

            // 3. Learn more link
            InkWell(
              onTap: onLearnMore,
              borderRadius: BorderRadius.circular(4.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        'Learn more about your fertility',
                        style: AppTextStyles.caption.copyWith(
                          color: const Color(0xFF7A708A),
                          fontWeight: FontWeight.w500,
                          fontSize: 10.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 3.0),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Color(0xFFE84D75),
                      size: 13.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFactorItem(
    String label, {
    bool isArrow = false,
    bool isCheck = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                fontSize: 10.0,
                color: const Color(0xFF1E1A3C),
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isArrow)
            const Icon(
              Icons.arrow_upward_rounded,
              size: 11.0,
              color: Color(0xFF2E9E68),
            )
          else if (isCheck)
            const Icon(
              Icons.check_rounded,
              size: 12.0,
              color: Color(0xFF2E9E68),
            ),
        ],
      ),
    );
  }
}

class _GaugeArcPainter extends CustomPainter {
  final double progress;

  _GaugeArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4.0;

    // Background track
    final trackPaint = Paint()
      ..color = const Color(0xFFEFE9F3)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.75,
      math.pi * 1.5,
      false,
      trackPaint,
    );

    // Active progress arc (mint green)
    final activePaint = Paint()
      ..color = const Color(0xFF43C59E)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.75,
      math.pi * 1.5 * progress,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugeArcPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
