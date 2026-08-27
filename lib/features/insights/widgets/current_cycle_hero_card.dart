import 'dart:math' as math;
import 'package:flutter/material.dart';

/// "Your current cycle ✦" Hero Card for Insights screen matching the exact mockup.
///
/// Features:
/// - Left column: Fertile window, Predicted ovulation, Next period with colored icon pills
/// - Right column: Cycle Ring placed on the RIGHT with pink-purple gradient track,
///   center Day/Total text, and pink flower accent.
/// - Bottom banner: "Follicular Energy Peak ✦" with "Learn more →" button.
/// - Open-space floating container styling with reduced spacing.
class CurrentCycleHeroCard extends StatelessWidget {
  final int currentDay;
  final int totalDays;
  final String fertileWindowDates;
  final String predictedOvulationDate;
  final String nextPeriodDates;
  final String energyPhaseTitle;
  final String energyPhaseSubtitle;
  final VoidCallback? onLearnMore;
  final VoidCallback? onFertileWindowTap;
  final VoidCallback? onOvulationTap;
  final VoidCallback? onNextPeriodTap;
  final VoidCallback? onRingTap;

  const CurrentCycleHeroCard({
    super.key,
    this.currentDay = 15,
    this.totalDays = 28,
    this.fertileWindowDates = 'May 12 – May 17',
    this.predictedOvulationDate = 'May 14',
    this.nextPeriodDates = 'May 26 – May 30',
    this.energyPhaseTitle = 'Follicular Energy Peak ✦',
    this.energyPhaseSubtitle = 'Estrogen rising! Peak creativity & vitality.',
    this.onLearnMore,
    this.onFertileWindowTap,
    this.onOvulationTap,
    this.onNextPeriodTap,
    this.onRingTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentDay / totalDays).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.0),
        border: Border.all(color: const Color(0xFFF3EDF7), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1A3C).withValues(alpha: 0.035),
            blurRadius: 14.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Header Title
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Your current cycle',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontWeight: FontWeight.w900,
                  fontSize: 16.0,
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

          const SizedBox(height: 10.0),

          // 2. Metrics (Left) & Cycle Ring (Right)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: 3 Biomarker Rows
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // A. Fertile window
                    _BiomarkerItem(
                      icon: Icons.eco_rounded,
                      iconColor: const Color(0xFF10B981),
                      iconBg: const Color(0xFFE8F5E9),
                      title: 'Fertile window',
                      value: fertileWindowDates,
                      valueColor: const Color(0xFF059669),
                      onTap: onFertileWindowTap,
                    ),
                    const SizedBox(height: 7.0),

                    // B. Predicted ovulation
                    _BiomarkerItem(
                      icon: Icons.alarm_rounded,
                      iconColor: const Color(0xFF8B5CF6),
                      iconBg: const Color(0xFFEDE9FE),
                      title: 'Predicted ovulation',
                      value: predictedOvulationDate,
                      valueColor: const Color(0xFF7C3AED),
                      onTap: onOvulationTap,
                    ),
                    const SizedBox(height: 7.0),

                    // C. Next period
                    _BiomarkerItem(
                      icon: Icons.water_drop_rounded,
                      iconColor: const Color(0xFFE84855),
                      iconBg: const Color(0xFFFFEEF0),
                      title: 'Next period',
                      value: nextPeriodDates,
                      valueColor: const Color(0xFFE84855),
                      onTap: onNextPeriodTap,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10.0),

              // Right: Beautiful Cycle Ring Dial
              _OverviewCycleRing(
                currentDay: currentDay,
                totalDays: totalDays,
                progress: progress,
                onTap: onRingTap,
              ),
            ],
          ),

          const SizedBox(height: 10.0),

          // 3. Bottom Energy Peak Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF0F5), Color(0xFFFFEEF2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(color: const Color(0xFFFFDEE6), width: 1.0),
            ),
            child: Row(
              children: [
                // Energy Lightning Badge
                Container(
                  width: 32.0,
                  height: 32.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF6B8B), Color(0xFFFF4D6D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.bolt_rounded,
                      color: Colors.white,
                      size: 19.0,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        energyPhaseTitle,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFB91C1C),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1.0),
                      Text(
                        energyPhaseSubtitle,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF7A708A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 4.0),

                // Learn More Button
                InkWell(
                  onTap: onLearnMore ?? () {},
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: const Color(0xFFFFCCD5),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Learn more',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFE84855),
                          ),
                        ),
                        SizedBox(width: 2.0),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 11.0,
                          color: Color(0xFFE84855),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Biomarker row item with circle icon, title, and bold date value.
class _BiomarkerItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String value;
  final Color valueColor;
  final VoidCallback? onTap;

  const _BiomarkerItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.value,
    required this.valueColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Row(
          children: [
            Container(
              width: 28.0,
              height: 28.0,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(icon, color: iconColor, size: 15.0),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7A708A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: valueColor,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Right-aligned Circular Cycle Ring with beads and floral accent.
class _OverviewCycleRing extends StatelessWidget {
  final int currentDay;
  final int totalDays;
  final double progress;
  final VoidCallback? onTap;

  const _OverviewCycleRing({
    required this.currentDay,
    required this.totalDays,
    required this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: 108.0,
            height: 108.0,
            child: CustomPaint(
              painter: _CycleRingArcPainter(progress: progress),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$currentDay / $totalDays',
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 20.0,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1A3C),
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 1.0),
                    const Text(
                      'Cycle day',
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8C7C92),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Flower Petal Accent on Bottom-Right
          const Positioned(
            bottom: -4,
            right: -4,
            child: Text(
              '🌸',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}

class _CycleRingArcPainter extends CustomPainter {
  final double progress;

  const _CycleRingArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 16.0) / 2;

    // 1. Background Track
    final bgPaint = Paint()
      ..color = const Color(0xFFF3EDF7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.5;
    canvas.drawCircle(center, radius, bgPaint);

    // 2. Gradient Arc for progress
    final sweepAngle = 2 * math.pi * progress;
    final arcRect = Rect.fromCircle(center: center, radius: radius);

    final sweepGradient = const SweepGradient(
      colors: [
        Color(0xFFFF6B8B),
        Color(0xFFE84855),
        Color(0xFF9333EA),
        Color(0xFF6366F1),
        Color(0xFFFF6B8B),
      ],
      stops: [0.0, 0.3, 0.6, 0.85, 1.0],
      transform: GradientRotation(-math.pi / 2),
    );

    final arcPaint = Paint()
      ..shader = sweepGradient.createShader(arcRect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 7.5;

    canvas.drawArc(
      arcRect,
      -math.pi / 2,
      sweepAngle,
      false,
      arcPaint,
    );

    // 3. Beads along the track at key positions
    final beadAngles = [0.0, 0.25, 0.5, 0.75];
    final beadPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final beadBorder = Paint()
      ..color = const Color(0xFFFF85A1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (final b in beadAngles) {
      final angle = -math.pi / 2 + (2 * math.pi * b);
      final bx = center.dx + radius * math.cos(angle);
      final by = center.dy + radius * math.sin(angle);
      canvas.drawCircle(Offset(bx, by), 3.5, beadPaint);
      canvas.drawCircle(Offset(bx, by), 3.5, beadBorder);
    }
  }

  @override
  bool shouldRepaint(covariant _CycleRingArcPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
