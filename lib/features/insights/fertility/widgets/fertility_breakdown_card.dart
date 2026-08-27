import 'dart:math' as math;
import 'package:flutter/material.dart';

/// "Fertility breakdown" 5-Day Strip Card for Fertility Subscreen matching the exact mockup.
class FertilityBreakdownCard extends StatelessWidget {
  final int selectedDayIndex;
  final ValueChanged<int>? onDaySelected;
  final VoidCallback? onLearnMore;
  final List<Map<String, dynamic>>? dynamicDays;

  const FertilityBreakdownCard({
    super.key,
    this.selectedDayIndex = 2,
    this.onDaySelected,
    this.onLearnMore,
    this.dynamicDays,
  });

  static const List<Map<String, dynamic>> _days = [
    {
      'weekday': 'Mon',
      'date': 'May 11',
      'chance': 20,
      'isPeak': false,
      'label': 'Low',
      'color': Color(0xFF6366F1),
    },
    {
      'weekday': 'Tue',
      'date': 'May 12',
      'chance': 60,
      'isPeak': false,
      'label': 'High',
      'color': Color(0xFF10B981),
    },
    {
      'weekday': 'Wed',
      'date': 'May 13',
      'chance': 85,
      'isPeak': false,
      'label': 'Very high',
      'color': Color(0xFFE84855),
    },
    {
      'weekday': 'Thu',
      'date': 'May 14',
      'chance': 100,
      'isPeak': true,
      'label': 'Ovulation',
      'color': Color(0xFF8B5CF6),
    },
    {
      'weekday': 'Fri',
      'date': 'May 15',
      'chance': 60,
      'isPeak': false,
      'label': 'High',
      'color': Color(0xFF10B981),
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
            const Text(
              'Fertility breakdown',
              style: TextStyle(
                fontFamily: 'serif',
                fontWeight: FontWeight.w900,
                fontSize: 15.5,
                color: Color(0xFF1E1A3C),
                letterSpacing: -0.2,
              ),
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

        const SizedBox(height: 8.0),

        // 2. 5 Days Row
        Row(
          children: List.generate(5, (index) {
            final d = (dynamicDays != null && index < dynamicDays!.length)
                ? {
                    'weekday': dynamicDays![index]['dayName'] ?? _days[index]['weekday'],
                    'date': dynamicDays![index]['date'] ?? _days[index]['date'],
                    'chance': dynamicDays![index]['chancePercent'] ?? _days[index]['chance'],
                    'isPeak': dynamicDays![index]['isPeak'] ?? _days[index]['isPeak'],
                    'label': dynamicDays![index]['chance'] ?? _days[index]['label'],
                    'color': _days[index]['color'],
                  }
                : _days[index];
            final isSelected = index == selectedDayIndex;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index < 4 ? 6.0 : 0.0,
                ),
                child: _DayCard(
                  weekday: d['weekday'] as String,
                  date: d['date'] as String,
                  chance: d['chance'] as int,
                  isPeak: d['isPeak'] as bool,
                  label: d['label'] as String,
                  color: d['color'] as Color,
                  isSelected: isSelected,
                  onTap: () => onDaySelected?.call(index),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 8.0),

        // 3. Legend Row
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: const [
            _LegendItem(color: Color(0xFF6366F1), text: 'Low (0–29%)'),
            _LegendItem(color: Color(0xFF10B981), text: 'High (30–69%)'),
            _LegendItem(color: Color(0xFFE84855), text: 'Very high (70–89%)'),
            _LegendItem(color: Color(0xFF8B5CF6), text: 'Peak (90–100%)'),
          ],
        ),
      ],
    );
  }
}

class _DayCard extends StatelessWidget {
  final String weekday;
  final String date;
  final int chance;
  final bool isPeak;
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback? onTap;

  const _DayCard({
    required this.weekday,
    required this.date,
    required this.chance,
    required this.isPeak,
    required this.label,
    required this.color,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFF0F5) : Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: isSelected ? const Color(0xFFFF85A1) : const Color(0xFFF1ECF5),
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? const Color(0xFFFF6B8B).withValues(alpha: 0.1)
                    : const Color(0xFF1E1A3C).withValues(alpha: 0.02),
                blurRadius: 8.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                weekday,
                style: const TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1A3C),
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7A708A),
                ),
              ),
              const SizedBox(height: 5.0),

              // Progress Mini Ring
              SizedBox(
                width: 36.0,
                height: 36.0,
                child: CustomPaint(
                  painter: _DayProgressPainter(
                    progress: chance / 100.0,
                    color: color,
                  ),
                  child: Center(
                    child: Text(
                      isPeak ? 'Peak' : '$chance%',
                      style: TextStyle(
                        fontSize: isPeak ? 8.0 : 9.5,
                        fontWeight: FontWeight.w900,
                        color: color,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5.0),

              // Label (Low, High, Very high, Ovulation)
              Text(
                label,
                style: TextStyle(
                  fontSize: 9.0,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  const _DayProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2.0;

    final bgPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawCircle(center, radius, bgPaint);

    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DayProgressPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6.0,
          height: 6.0,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 3.0),
        Text(
          text,
          style: const TextStyle(
            fontSize: 9.0,
            color: Color(0xFF7A708A),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
