import 'package:flutter/material.dart';

/// "Cycle length trend" Open-Space Line Chart Card for Trends subscreen matching the exact mockup.
class CycleLengthTrendCard extends StatelessWidget {
  final int averageLength;
  final String deltaText;
  final String rangeText;
  final VoidCallback? onViewDetails;

  const CycleLengthTrendCard({
    super.key,
    this.averageLength = 28,
    this.deltaText = '1 day vs last 3 months',
    this.rangeText = '26 – 31 days',
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Header: Title + View details >
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24.0,
                    height: 24.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFEEF0),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.show_chart_rounded,
                        color: Color(0xFFE84855),
                        size: 14.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6.0),
                  const Text(
                    'Cycle length trend',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontWeight: FontWeight.w900,
                      fontSize: 15.0,
                      color: Color(0xFF1E1A3C),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: onViewDetails,
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7.0,
                    vertical: 3.0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F5),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: const Color(0xFFFFCCD5),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'View details',
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFE84855),
                        ),
                      ),
                      SizedBox(width: 2.0),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 12.0,
                        color: Color(0xFFE84855),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8.0),

          // 2. Chart (Left) & Metrics (Right) Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Spline Chart Area
              Expanded(
                flex: 6,
                child: SizedBox(
                  height: 110.0,
                  child: Stack(
                    children: [
                      // Y-Axis labels & Grid lines
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          _GridLineRow(label: '35'),
                          _GridLineRow(label: '30'),
                          _GridLineRow(label: '25'),
                          _GridLineRow(label: '20'),
                          _GridLineRow(label: '15'),
                        ],
                      ),

                      // Custom Painted Curved Spline
                      Positioned.fill(
                        left: 18.0,
                        right: 8.0,
                        top: 4.0,
                        bottom: 16.0,
                        child: CustomPaint(painter: _SplineTrendLinePainter()),
                      ),

                      // Floating "28 days" Peak Badge
                      Positioned(
                        top: 10.0,
                        right: 12.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6.0),
                            border: Border.all(
                              color: const Color(0xFFC084FC),
                              width: 0.8,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                                blurRadius: 4.0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Text(
                            '28 days',
                            style: TextStyle(
                              fontSize: 9.0,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF7C3AED),
                            ),
                          ),
                        ),
                      ),

                      // X-Axis Month Labels
                      Positioned(
                        left: 18.0,
                        right: 8.0,
                        bottom: 0.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Feb', style: TextStyle(fontSize: 8.5, color: Color(0xFF7A708A))),
                            Text('Mar', style: TextStyle(fontSize: 8.5, color: Color(0xFF7A708A))),
                            Text('Apr', style: TextStyle(fontSize: 8.5, color: Color(0xFF7A708A))),
                            Text('May', style: TextStyle(fontSize: 8.5, color: Color(0xFF7A708A))),
                            Text('Jun', style: TextStyle(fontSize: 8.5, color: Color(0xFF7A708A))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 10.0),

              // Right: Stats Column
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Average cycle length',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Color(0xFF7A708A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 1.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$averageLength',
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 24.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF6366F1),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 3.0),
                        const Text(
                          'days',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Text(
                        '▲ $deltaText',
                        style: const TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF059669),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    const Text(
                      'Cycle range',
                      style: TextStyle(
                        fontSize: 9.5,
                        color: Color(0xFF7A708A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      rangeText,
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1A3C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GridLineRow extends StatelessWidget {
  final String label;

  const _GridLineRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 14.0,
          child: Text(
            label,
            style: const TextStyle(fontSize: 7.5, color: Color(0xFFB0A4B8)),
          ),
        ),
        const SizedBox(width: 3.0),
        Expanded(
          child: Container(
            height: 0.7,
            color: const Color(0xFFF1ECF5),
          ),
        ),
      ],
    );
  }
}

class _SplineTrendLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 5 Data points representing Feb, Mar, Apr, May, Jun
    final points = [
      Offset(0.05 * w, 0.72 * h),
      Offset(0.28 * w, 0.48 * h),
      Offset(0.50 * w, 0.65 * h),
      Offset(0.72 * w, 0.35 * h),
      Offset(0.95 * w, 0.22 * h),
    ];

    // 1. Shaded area below spline
    final fillPath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final cx = (p0.dx + p1.dx) / 2;
      fillPath.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }
    fillPath.lineTo(points.last.dx, h);
    fillPath.lineTo(points.first.dx, h);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF8B5CF6).withValues(alpha: 0.18),
          const Color(0xFF8B5CF6).withValues(alpha: 0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    // 2. Stroke spline curve
    final strokePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final cx = (p0.dx + p1.dx) / 2;
      strokePath.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }

    final strokePaint = Paint()
      ..color = const Color(0xFF8B5CF6)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.4;
    canvas.drawPath(strokePath, strokePaint);

    // 3. Circles on each point
    final dotBg = Paint()..color = Colors.white;
    final dotBorder = Paint()
      ..color = const Color(0xFF8B5CF6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (final p in points) {
      canvas.drawCircle(p, 3.5, dotBg);
      canvas.drawCircle(p, 3.5, dotBorder);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
