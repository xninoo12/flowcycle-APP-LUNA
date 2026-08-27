import 'dart:math' as math;
import 'package:flutter/material.dart';

/// "Current cycle" Open-Space Hero Card for Cycles Subscreen matching the exact mockup.
///
/// Features:
/// - Left column: Fertile window, Ovulation, Next period expected with colored circle icons
/// - Right column: Cycle Ring on the RIGHT with Day/Total text and Day 1 pill badge
/// - Bottom banner: "You're in your fertile window" with forward arrow
class CyclesCurrentHeroCard extends StatelessWidget {
  final int currentDay;
  final int totalDays;
  final String fertileWindowDates;
  final String ovulationDate;
  final String periodExpectedDates;
  final String bannerTitle;
  final String bannerSubtitle;
  final VoidCallback? onBannerTap;
  final VoidCallback? onFertileWindowTap;
  final VoidCallback? onOvulationTap;
  final VoidCallback? onNextPeriodTap;
  final VoidCallback? onRingTap;

  const CyclesCurrentHeroCard({
    super.key,
    this.currentDay = 1,
    this.totalDays = 28,
    this.fertileWindowDates = 'May 12 – May 17',
    this.ovulationDate = 'May 14',
    this.periodExpectedDates = 'May 26 – May 30',
    this.bannerTitle = "You're in your fertile window",
    this.bannerSubtitle = "Great time to try if you're trying to conceive.",
    this.onBannerTap,
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
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Metrics (Left) & Cycle Ring (Right)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: 3 Milestones
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Milestone 1: Fertile window
                    _CycleBiomarkerItem(
                      icon: Icons.eco_rounded,
                      iconColor: const Color(0xFF10B981),
                      iconBg: const Color(0xFFE8F5E9),
                      title: 'Fertile window',
                      value: fertileWindowDates,
                      valueColor: const Color(0xFF059669),
                      onTap: onFertileWindowTap,
                    ),
                    const SizedBox(height: 7.0),

                    // Milestone 2: Ovulation
                    _CycleBiomarkerItem(
                      icon: Icons.egg_rounded,
                      iconColor: const Color(0xFF8B5CF6),
                      iconBg: const Color(0xFFEDE9FE),
                      title: 'Ovulation',
                      value: ovulationDate,
                      valueColor: const Color(0xFF7C3AED),
                      onTap: onOvulationTap,
                    ),
                    const SizedBox(height: 7.0),

                    // Milestone 3: Next period expected
                    _CycleBiomarkerItem(
                      icon: Icons.water_drop_outlined,
                      iconColor: const Color(0xFFE84855),
                      iconBg: const Color(0xFFFFEEF0),
                      title: 'Next period expected',
                      value: periodExpectedDates,
                      valueColor: const Color(0xFFE84855),
                      onTap: onNextPeriodTap,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10.0),

              // Right: Cycle Ring Dial on the RIGHT
              _CyclesRingDial(
                currentDay: currentDay,
                totalDays: totalDays,
                progress: progress,
                onTap: onRingTap,
              ),
            ],
          ),

          const SizedBox(height: 10.0),

          // 2. Bottom Banner with Arrow
          InkWell(
            onTap: onBannerTap ?? () {},
            borderRadius: BorderRadius.circular(14.0),
            child: Container(
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
                  Container(
                    width: 28.0,
                    height: 28.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFE4EC),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '✦',
                        style: TextStyle(
                          color: Color(0xFFE84855),
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          bannerTitle,
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFE84855),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 1.0),
                        Text(
                          bannerSubtitle,
                          style: const TextStyle(
                            fontSize: 10.0,
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
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFFE84855),
                    size: 18.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CycleBiomarkerItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String value;
  final Color valueColor;
  final VoidCallback? onTap;

  const _CycleBiomarkerItem({
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
              child: Center(child: Icon(icon, color: iconColor, size: 15.0)),
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

class _CyclesRingDial extends StatelessWidget {
  final int currentDay;
  final int totalDays;
  final double progress;
  final VoidCallback? onTap;

  const _CyclesRingDial({
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
            painter: _CyclesRingPainter(progress: progress),
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
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 1.0),
                  const Text(
                    'Cycle day',
                    style: TextStyle(
                      fontSize: 9.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7A708A),
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEF0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Day $currentDay',
                      style: const TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFE84855),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Soft Botanical Illustration Accent on Right
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

class _CyclesRingPainter extends CustomPainter {
  final double progress;

  const _CyclesRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 16.0) / 2;

    // Background Track
    final bgPaint = Paint()
      ..color = const Color(0xFFF1ECF5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.5;
    canvas.drawCircle(center, radius, bgPaint);

    // Gradient Sweep
    final sweepAngle = (2 * math.pi * progress).clamp(0.2, 2 * math.pi);
    final arcRect = Rect.fromCircle(center: center, radius: radius);

    final sweepGradient = const SweepGradient(
      colors: [
        Color(0xFFFF6B8B),
        Color(0xFFE84855),
        Color(0xFF8B5CF6),
        Color(0xFF6366F1),
        Color(0xFFFF6B8B),
      ],
      stops: [0.0, 0.35, 0.7, 0.9, 1.0],
      transform: GradientRotation(-math.pi / 2),
    );

    final arcPaint = Paint()
      ..shader = sweepGradient.createShader(arcRect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 7.5;

    canvas.drawArc(arcRect, -math.pi / 2, sweepAngle, false, arcPaint);
  }

  @override
  bool shouldRepaint(covariant _CyclesRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
