import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/pattern_models.dart';

class BbtThermalCurveCard extends StatefulWidget {
  final List<BbtDataPoint> bbtPoints;
  final double coverline;
  final int ovulationDay;

  const BbtThermalCurveCard({
    super.key,
    required this.bbtPoints,
    this.coverline = 97.55,
    this.ovulationDay = 14,
  });

  @override
  State<BbtThermalCurveCard> createState() => _BbtThermalCurveCardState();
}

class _BbtThermalCurveCardState extends State<BbtThermalCurveCard> {
  int? _selectedPointIndex;

  void _handleTouch(Offset localPosition, double width) {
    if (widget.bbtPoints.isEmpty) return;
    final xStep = width / (widget.bbtPoints.length - 1).clamp(1, 999);
    final index = (localPosition.dx / xStep).round().clamp(0, widget.bbtPoints.length - 1);
    if (_selectedPointIndex != index) {
      setState(() {
        _selectedPointIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedPoint = _selectedPointIndex != null &&
            _selectedPointIndex! < widget.bbtPoints.length
        ? widget.bbtPoints[_selectedPointIndex!]
        : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.large,
        border: Border.all(color: const Color(0xFFF0EBF5), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C5CE7).withValues(alpha: 0.05),
            blurRadius: 14.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F5),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Icon(
                        Icons.show_chart_rounded,
                        color: Color(0xFFFF5252),
                        size: 20.0,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Flexible(
                      child: Text(
                        'Biphasic BBT Thermal Shift',
                        style: AppTextStyles.subtitle.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 15.0,
                          color: const Color(0xFF1E1A3C),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF2E7D32),
                      size: 12.0,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      'Ovulation Confirmed',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Text(
            'Basal Body Temperature shows a clear biphasic pattern confirming progesterone surge post-ovulation (Day ${widget.ovulationDay}):',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12.0),

          // Interactive dynamic scrubber tooltip badge
          if (selectedPoint != null)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: selectedPoint.isPostOvulation
                    ? const Color(0xFFFFECEF)
                    : const Color(0xFFEAF2FD),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: selectedPoint.isPostOvulation
                      ? const Color(0xFFFFB4C2)
                      : const Color(0xFFB5D4FA),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.touch_app_rounded,
                    size: 14.0,
                    color: selectedPoint.isPostOvulation
                        ? const Color(0xFFFF5252)
                        : const Color(0xFF4A90E2),
                  ),
                  const SizedBox(width: 6.0),
                  Text(
                    'Day ${selectedPoint.cycleDay}: ${selectedPoint.temperature.toStringAsFixed(2)}°F (${selectedPoint.isPostOvulation ? 'Luteal Shift' : 'Follicular Baseline'})',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: selectedPoint.isPostOvulation
                          ? const Color(0xFFD32F2F)
                          : const Color(0xFF1976D2),
                    ),
                  ),
                ],
              ),
            )
          else
            const SizedBox(height: 4.0),

          const SizedBox(height: 10.0),

          // Custom BBT Chart Canvas with interactive GestureDetector
          LayoutBuilder(
            builder: (context, constraints) {
              return GestureDetector(
                onPanDown: (details) =>
                    _handleTouch(details.localPosition, constraints.maxWidth),
                onPanUpdate: (details) =>
                    _handleTouch(details.localPosition, constraints.maxWidth),
                onTapUp: (details) =>
                    _handleTouch(details.localPosition, constraints.maxWidth),
                child: Container(
                  height: 160.0,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF9FC),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: const Color(0xFFEDE8F5)),
                  ),
                  child: CustomPaint(
                    painter: _BbtChartPainter(
                      bbtPoints: widget.bbtPoints,
                      coverline: widget.coverline,
                      ovulationDay: widget.ovulationDay,
                      selectedIndex: _selectedPointIndex,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 14.0),

          // Legend
          Center(
            child: Wrap(
              spacing: 12.0,
              runSpacing: 6.0,
              alignment: WrapAlignment.center,
              children: [
                _buildLegendItem(const Color(0xFF4A90E2), 'Follicular (<97.6°)'),
                _buildLegendItem(
                  const Color(0xFF9E96A8),
                  'Coverline (97.55°)',
                  isDashed: true,
                ),
                _buildLegendItem(const Color(0xFFFF5252), 'Luteal (>97.8°)'),
              ],
            ),
          ),

          const SizedBox(height: 14.0),

          // Clinical takeaway box
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF6FBF6),
              borderRadius: AppRadius.medium,
              border: Border.all(color: const Color(0xFFD4EED8)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🌡️', style: TextStyle(fontSize: 16.0)),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    'Thermal Shift: Temperatures sustained an average +0.55°F rise across 12 consecutive luteal days, indicating robust corpus luteum function and fertile ovulation.',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1B5E20),
                      height: 1.35,
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

  Widget _buildLegendItem(Color color, String label, {bool isDashed = false}) {
    return Row(
      children: [
        Container(
          width: 12.0,
          height: isDashed ? 2.0 : 8.0,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
        const SizedBox(width: 5.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A4458),
          ),
        ),
      ],
    );
  }
}

class _BbtChartPainter extends CustomPainter {
  final List<BbtDataPoint> bbtPoints;
  final double coverline;
  final int ovulationDay;
  final int? selectedIndex;

  _BbtChartPainter({
    required this.bbtPoints,
    required this.coverline,
    required this.ovulationDay,
    this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (bbtPoints.isEmpty) return;

    const minTemp = 97.0;
    const maxTemp = 98.6;
    final tempRange = maxTemp - minTemp;

    final gridPaint = Paint()
      ..color = const Color(0xFFE8E2F0)
      ..strokeWidth = 0.8;

    // Draw horizontal grid lines
    for (double t = 97.2; t <= 98.4; t += 0.4) {
      final y = size.height - ((t - minTemp) / tempRange) * size.height;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw Coverline (dashed)
    final coverlineY =
        size.height - ((coverline - minTemp) / tempRange) * size.height;
    final coverlinePaint = Paint()
      ..color = const Color(0xFFB0A8B9)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    double dashX = 0;
    while (dashX < size.width) {
      canvas.drawLine(
        Offset(dashX, coverlineY),
        Offset(dashX + 5, coverlineY),
        coverlinePaint,
      );
      dashX += 9;
    }

    // Draw data points & connecting line
    final linePaintFollicular = Paint()
      ..color = const Color(0xFF4A90E2)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final linePaintLuteal = Paint()
      ..color = const Color(0xFFFF5252)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaintFollicular = Paint()
      ..color = const Color(0xFF4A90E2)
      ..style = PaintingStyle.fill;

    final dotPaintLuteal = Paint()
      ..color = const Color(0xFFFF5252)
      ..style = PaintingStyle.fill;

    final xStep = size.width / (bbtPoints.length - 1).clamp(1, 999);

    for (int i = 0; i < bbtPoints.length - 1; i++) {
      final p1 = bbtPoints[i];
      final p2 = bbtPoints[i + 1];

      final x1 = i * xStep;
      final y1 =
          size.height - ((p1.temperature - minTemp) / tempRange) * size.height;
      final x2 = (i + 1) * xStep;
      final y2 =
          size.height - ((p2.temperature - minTemp) / tempRange) * size.height;

      final isLuteal = p1.isPostOvulation || p2.isPostOvulation;
      canvas.drawLine(
        Offset(x1, y1),
        Offset(x2, y2),
        isLuteal ? linePaintLuteal : linePaintFollicular,
      );
    }

    for (int i = 0; i < bbtPoints.length; i++) {
      final p = bbtPoints[i];
      final x = i * xStep;
      final y =
          size.height - ((p.temperature - minTemp) / tempRange) * size.height;

      final isSelected = selectedIndex == i;

      if (isSelected) {
        // Glowing halo around selected point
        final haloPaint = Paint()
          ..color = (p.isPostOvulation
                  ? const Color(0xFFFF5252)
                  : const Color(0xFF4A90E2))
              .withValues(alpha: 0.25)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(x, y), 10.0, haloPaint);

        // Vertical guide dashed line
        final guidePaint = Paint()
          ..color = const Color(0xFF7C5CE7).withValues(alpha: 0.4)
          ..strokeWidth = 1.0;
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), guidePaint);
      }

      canvas.drawCircle(
        Offset(x, y),
        isSelected ? 5.0 : 3.5,
        p.isPostOvulation ? dotPaintLuteal : dotPaintFollicular,
      );
      canvas.drawCircle(
        Offset(x, y),
        isSelected ? 2.2 : 1.5,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BbtChartPainter oldDelegate) => true;
}
