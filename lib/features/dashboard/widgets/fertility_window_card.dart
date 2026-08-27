import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Fertility Window & Chance card for Cycle Awareness Dashboard.
class FertilityWindowCard extends StatelessWidget {
  final String chanceLevel;
  final String statusText;
  final VoidCallback? onViewDetails;

  const FertilityWindowCard({
    super.key,
    this.chanceLevel = 'Low',
    this.statusText = 'Not fertile',
    this.onViewDetails,
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
      padding: const EdgeInsets.all(AppSpacing.sm + 4.0),
      child: Stack(
        children: [
          // Wave Graphic in Background
          Positioned(
            right: -8.0,
            bottom: 0.0,
            child: CustomPaint(
              size: const Size(100.0, 60.0),
              painter: _FertilityWavePainter(),
            ),
          ),

          // Content Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        size: 12.0,
                        color: Color(0xFF6C449B),
                      ),
                      const SizedBox(width: 4.0),
                      Flexible(
                        child: Text(
                          'FERTILITY WINDOW',
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF6C449B),
                            letterSpacing: 0.8,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs + 2.0),
                  Text(
                    'Chance: $chanceLevel',
                    style: AppTextStyles.subtitle.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 16.0,
                      color: const Color(0xFF1E1A3C),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    statusText,
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFF7A708A),
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              InkWell(
                onTap: onViewDetails,
                borderRadius: BorderRadius.circular(4.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    'View details →',
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFF6C449B),
                      fontWeight: FontWeight.w700,
                      fontSize: 11.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FertilityWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF8E63C7)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF8E63C7).withValues(alpha: 0.0),
          const Color(0xFF8E63C7).withValues(alpha: 0.18),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.9)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.8,
        size.width * 0.6,
        size.height * 0.45,
      )
      ..quadraticBezierTo(size.width * 0.82, size.height * 0.12, size.width, 0);

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    final dotCenter = Offset(size.width * 0.6, size.height * 0.45);
    final dotPaint = Paint()
      ..color = const Color(0xFF6C449B)
      ..style = PaintingStyle.fill;

    final dotBorderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(dotCenter, 5.0, dotPaint);
    canvas.drawCircle(dotCenter, 5.0, dotBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
