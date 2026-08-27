import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/providers/app_scope.dart';

/// Interactive Month Calendar Grid Card for Trying to Conceive (TTC) Mode.
class TtcMonthGridCard extends StatefulWidget {
  final int selectedDay;
  final ValueChanged<int>? onDaySelected;
  final VoidCallback? onPrevMonth;
  final VoidCallback? onNextMonth;

  const TtcMonthGridCard({
    super.key,
    this.selectedDay = 14,
    this.onDaySelected,
    this.onPrevMonth,
    this.onNextMonth,
  });

  @override
  State<TtcMonthGridCard> createState() => _TtcMonthGridCardState();
}

class _TtcMonthGridCardState extends State<TtcMonthGridCard> {
  late int _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDay;
  }

  @override
  void didUpdateWidget(covariant TtcMonthGridCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDay != widget.selectedDay) {
      _selectedDay = widget.selectedDay;
    }
  }

  static const List<String> _singleLetterWeekdays = [
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
    'S',
  ];

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
        children: [
          // 1. Month Header Navigator: < May 2025 >
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 34.0,
                height: 34.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF7F2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFEFE9F3),
                    width: 0.8,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFFE84D75),
                    size: 14.0,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: widget.onPrevMonth ?? () {},
                ),
              ),
              Text(
                'May 2025',
                style: AppTextStyles.subtitle.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 17.5,
                  color: const Color(0xFF1E1A3C),
                ),
              ),
              Container(
                width: 34.0,
                height: 34.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF7F2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFEFE9F3),
                    width: 0.8,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFFE84D75),
                    size: 14.0,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: widget.onNextMonth ?? () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // 2. Single Letter Weekdays Header Row: M T W T F S S
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _singleLetterWeekdays
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: AppTextStyles.caption.copyWith(
                          color: const Color(0xFF8C829A),
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: AppSpacing.sm),

          // 3. 7x5 Days Grid
          _buildMonthGrid(),

          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1.0, color: Color(0xFFEFE9F3)),
          const SizedBox(height: AppSpacing.sm + 2.0),

          // 4. Legend Row at Bottom
          Wrap(
            alignment: WrapAlignment.spaceAround,
            spacing: 8.0,
            runSpacing: 6.0,
            children: [
              _buildLegendDot(const Color(0xFFE84D75), 'Period'),
              _buildLegendDot(const Color(0xFF43C59E), 'Fertile Window'),
              _buildLegendDot(const Color(0xFFF59E0B), 'Ovulation'),
              _buildLegendDot(const Color(0xFF8C9ECC), 'Luteal Phase'),
              _buildLegendCircle(const Color(0xFF10B981), 'Today'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthGrid() {
    final List<Widget> dayCells = [];

    // Prev month days: 28, 29, 30
    dayCells.add(_buildInactiveDay(28));
    dayCells.add(_buildInactiveDay(29));
    dayCells.add(_buildInactiveDay(30));

    // Current month days (1..31)
    for (int day = 1; day <= 31; day++) {
      dayCells.add(_buildCurrentMonthDay(day));
    }

    // Next month day: 1
    dayCells.add(_buildInactiveDay(1));

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 2.0,
      childAspectRatio: 0.85,
      children: dayCells,
    );
  }

  Widget _buildInactiveDay(int day) {
    return Center(
      child: Text(
        '$day',
        style: const TextStyle(
          color: Color(0xFFB4ACB9),
          fontSize: 13.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCurrentMonthDay(int day) {
    final isSelected = day == _selectedDay;
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, day);

    final controller = AppScope.of(context);
    final log = controller.getLogForDate(date);
    final profile = controller.userProfile;
    final lastPeriod = profile.lastPeriodStartDate;
    final cycleLen = profile.averageCycleLength;
    final periodDuration = profile.typicalPeriodDuration;

    final daysDiff = date.difference(DateTime(lastPeriod.year, lastPeriod.month, lastPeriod.day)).inDays;
    final cycleDay = (daysDiff % cycleLen) + 1;
    final ovulationDay = cycleLen - 14;

    final hasPeriodLog = log?.flow != null && log!.flow != 'None';
    final isPeriod = hasPeriodLog || (cycleDay > 0 && cycleDay <= periodDuration);
    final isPreOvulation = cycleDay == ovulationDay - 2;
    final isFertileHeart =
        (cycleDay >= ovulationDay - 5 && cycleDay <= ovulationDay + 1 && cycleDay != ovulationDay);
    final isTodayOvulation = cycleDay == ovulationDay;
    final isLuteal = cycleDay > ovulationDay + 1 && cycleDay <= cycleLen;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDay = day;
        });
        widget.onDaySelected?.call(day);
      },
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: _buildDayVisual(
            day: day,
            isSelected: isSelected,
            isPeriod: isPeriod,
            isPreOvulation: isPreOvulation,
            isFertileHeart: isFertileHeart,
            isTodayOvulation: isTodayOvulation,
            isLuteal: isLuteal,
          ),
        ),
      ),
    );
  }

  Widget _buildDayVisual({
    required int day,
    required bool isSelected,
    required bool isPeriod,
    required bool isPreOvulation,
    required bool isFertileHeart,
    required bool isTodayOvulation,
    required bool isLuteal,
  }) {
    // 1. Today / Ovulation Peak (Day 14): Solid Green Circle with White Text + Green Ring + Pointer Arrow ▲
    if (isTodayOvulation) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32.0,
            height: 32.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF10B981).withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Container(
                width: 24.0,
                height: 24.0,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 1.0),
          const Icon(
            Icons.arrow_drop_up_rounded,
            color: Color(0xFF10B981),
            size: 14.0,
          ),
        ],
      );
    }

    // 2. Fertile Window Days with Green Heart (13, 15, 16, 17)
    if (isFertileHeart) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30.0,
            height: 30.0,
            decoration: const BoxDecoration(
              color: Color(0xFFE6F8F0),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$day',
                style: const TextStyle(
                  color: Color(0xFF059669),
                  fontSize: 13.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 2.0),
          const Icon(
            Icons.favorite_rounded,
            color: Color(0xFF059669),
            size: 8.5,
          ),
        ],
      );
    }

    // 3. Period Days (2..7)
    if (isPeriod) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30.0,
            height: 30.0,
            decoration: const BoxDecoration(
              color: Color(0xFFFDE8EF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$day',
                style: const TextStyle(
                  color: Color(0xFFE84D75),
                  fontSize: 13.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 2.0),
          Container(
            width: 4.0,
            height: 4.0,
            decoration: const BoxDecoration(
              color: Color(0xFFE84D75),
              shape: BoxShape.circle,
            ),
          ),
        ],
      );
    }

    // 4. Pre-Ovulation Day (12) Peach/Orange
    if (isPreOvulation) {
      return Container(
        width: 30.0,
        height: 30.0,
        decoration: const BoxDecoration(
          color: Color(0xFFFEF3C7),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '$day',
            style: const TextStyle(
              color: Color(0xFFD97706),
              fontSize: 13.0,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    }

    // 5. Luteal Phase Days (1, 20..24, 26..31) Soft Purple with Dot
    if (isLuteal) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30.0,
            height: 30.0,
            decoration: const BoxDecoration(
              color: Color(0xFFEEF2FF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$day',
                style: const TextStyle(
                  color: Color(0xFF1E1A3C),
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 2.0),
          Container(
            width: 4.0,
            height: 4.0,
            decoration: const BoxDecoration(
              color: Color(0xFF8C9ECC),
              shape: BoxShape.circle,
            ),
          ),
        ],
      );
    }

    // 6. Normal Day
    return Text(
      '$day',
      style: TextStyle(
        color: isSelected ? const Color(0xFFE84D75) : const Color(0xFF1E1A3C),
        fontSize: 13.0,
        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7.5,
          height: 7.5,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4.0),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontSize: 10.0,
            color: const Color(0xFF7A708A),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendCircle(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.5,
          height: 8.5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 1.5),
          ),
        ),
        const SizedBox(width: 4.0),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontSize: 10.0,
            color: const Color(0xFF7A708A),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
