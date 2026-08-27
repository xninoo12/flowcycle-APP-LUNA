import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Your Insights & Fertile Days Trend Chart Card for TTC Dashboard.
class TtcInsightsTrendCard extends StatelessWidget {
  final String fertileDaysSummary;
  final String supportiveMessage;

  const TtcInsightsTrendCard({
    super.key,
    this.fertileDaysSummary = "You've had 2 fertile days this week.",
    this.supportiveMessage = 'Keep going! Consistency matters.',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.large,
        border: Border.all(color: const Color(0xFFEFE9F3), width: 1.0),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 4.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header with Sparkle
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: Color(0xFFE84D75),
                size: 13.0,
              ),
              const SizedBox(width: 4.0),
              Text(
                'Your insights',
                style: AppTextStyles.subtitle.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 13.5,
                  color: const Color(0xFF1E1A3C),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xs + 2.0),

          // 2. Content: Summary Text on Left + Mini Trend Chart on Right
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fertileDaysSummary,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E1A3C),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      supportiveMessage,
                      style: AppTextStyles.caption.copyWith(
                        color: const Color(0xFF7A708A),
                        fontSize: 11.0,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              // Mini Trend Chart
              CustomPaint(
                size: const Size(110.0, 52.0),
                painter: _TtcTrendChartPainter(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TtcTrendChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final barPaintMint = Paint()
      ..color = const Color(0xFF43C59E).withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    final barPaintPink = Paint()
      ..color = const Color(0xFFFF5E82).withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    final barWidth = 6.5;
    final heights = [0.4, 0.6, 0.5, 0.75, 0.9, 0.7, 0.95];
    final isMint = [true, true, false, false, false, false, false];

    for (int i = 0; i < heights.length; i++) {
      final x = 8.0 + (i * 14.0);
      final barH = size.height * heights[i];
      final y = size.height - barH;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barH),
        const Radius.circular(3.0),
      );

      canvas.drawRRect(rect, isMint[i] ? barPaintMint : barPaintPink);
    }

    // Trajectory Line
    final linePaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(8.0, size.height * 0.7)
      ..lineTo(22.0, size.height * 0.48)
      ..lineTo(36.0, size.height * 0.6)
      ..lineTo(50.0, size.height * 0.35)
      ..lineTo(64.0, size.height * 0.22)
      ..lineTo(78.0, size.height * 0.38)
      ..lineTo(94.0, size.height * 0.12);

    canvas.drawPath(path, linePaint);

    // Arrow indicator at end
    final arrowPaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.fill;

    final arrowOffset = Offset(94.0, size.height * 0.12);
    canvas.drawCircle(arrowOffset, 3.5, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
