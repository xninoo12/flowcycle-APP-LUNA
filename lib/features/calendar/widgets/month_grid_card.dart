import 'package:flutter/material.dart';

/// Interactive Calendar Month Grid Card for FlowCycle matching the exact design mockup
/// with full dynamic date calculations, layer filtering, and touch/long-press interactivity.
class MonthGridCard extends StatefulWidget {
  final int selectedDay;
  final int selectedMonth;
  final int selectedYear;
  final String selectedTimeframe;
  final Map<String, bool>? activeFilters;
  final ValueChanged<int>? onDaySelected;
  final ValueChanged<int>? onDayLongPress;
  final ValueChanged<String>? onTimeframeChanged;
  final VoidCallback? onPrevMonth;
  final VoidCallback? onNextMonth;
  final VoidCallback? onMonthDropdown;
  final VoidCallback? onTodayTap;

  const MonthGridCard({
    super.key,
    this.selectedDay = 14,
    this.selectedMonth = 5,
    this.selectedYear = 2025,
    this.selectedTimeframe = 'Month',
    this.activeFilters,
    this.onDaySelected,
    this.onDayLongPress,
    this.onTimeframeChanged,
    this.onPrevMonth,
    this.onNextMonth,
    this.onMonthDropdown,
    this.onTodayTap,
  });

  @override
  State<MonthGridCard> createState() => _MonthGridCardState();
}

class _MonthGridCardState extends State<MonthGridCard> {
  late int _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDay;
  }

  @override
  void didUpdateWidget(covariant MonthGridCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDay != widget.selectedDay) {
      _selectedDay = widget.selectedDay;
    }
  }

  static const List<String> _weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: const Color(0xFFF1ECF5), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1A3C).withValues(alpha: 0.03),
            blurRadius: 14.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 16.0),
      child: Column(
        children: [
          // 1. Timeframe & Today Controls Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Month / Year Toggle Pill
              Container(
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF7FC),
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: const Color(0xFFEFE9F3),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTimeframeTab('Month'),
                    _buildTimeframeTab('Year'),
                  ],
                ),
              ),

              // Today Action Pill Button
              GestureDetector(
                onTap: widget.onTodayTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: const Color(0xFFFFD1DC),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: Color(0xFFE81B54),
                        size: 12.0,
                      ),
                      SizedBox(width: 3.0),
                      Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFE81B54),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12.0),

          // 2. Month Navigator: < May 2025 ▼ >
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  color: Color(0xFF1E1A3C),
                  size: 24.0,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32.0, minHeight: 32.0),
                onPressed: widget.onPrevMonth ?? () {},
              ),

              Flexible(
                child: GestureDetector(
                  onTap: widget.onMonthDropdown ?? () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          _getMonthYearTitle(widget.selectedMonth, widget.selectedYear),
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 19.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1A3C),
                            letterSpacing: -0.3,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFFE81B54),
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
              ),

              IconButton(
                icon: const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF1E1A3C),
                  size: 24.0,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32.0, minHeight: 32.0),
                onPressed: widget.onNextMonth ?? () {},
              ),
            ],
          ),

          const SizedBox(height: 10.0),

          // 3. Weekdays Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _weekdays
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          color: Color(0xFF1E1A3C),
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 10.0),

          // 4. Days Grid (Dynamic 35/42 cells for any month/year)
          _buildMonthGrid(),

          const SizedBox(height: 14.0),
          const Divider(height: 1.0, color: Color(0xFFF1ECF5)),
          const SizedBox(height: 12.0),

          // 5. Calendar Legend Row
          _buildLegendRow(),
        ],
      ),
    );
  }

  Widget _buildTimeframeTab(String label) {
    final isSelected = widget.selectedTimeframe == label;

    return GestureDetector(
      onTap: () => widget.onTimeframeChanged?.call(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF1E1A3C).withValues(alpha: 0.05),
                    blurRadius: 4.0,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? const Color(0xFFE81B54) : const Color(0xFF7A708A),
          ),
        ),
      ),
    );
  }

  String _getMonthYearTitle(int month, int year) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[month - 1]} $year';
  }

  Widget _buildMonthGrid() {
    final List<Widget> dayCells = [];

    // Dynamically calculate leading previous month days
    final firstDayOfMonth = DateTime(widget.selectedYear, widget.selectedMonth, 1);
    final daysInCurrentMonth = DateUtils.getDaysInMonth(widget.selectedYear, widget.selectedMonth);

    final prevMonthYear = widget.selectedMonth == 1 ? widget.selectedYear - 1 : widget.selectedYear;
    final prevMonth = widget.selectedMonth == 1 ? 12 : widget.selectedMonth - 1;
    final daysInPrevMonth = DateUtils.getDaysInMonth(prevMonthYear, prevMonth);

    final leadingDaysCount = (firstDayOfMonth.weekday - 1) % 7;

    // Previous month trailing days
    for (int i = leadingDaysCount - 1; i >= 0; i--) {
      dayCells.add(_buildInactiveDay(daysInPrevMonth - i));
    }

    // Current month days (1..daysInCurrentMonth)
    for (int day = 1; day <= daysInCurrentMonth; day++) {
      dayCells.add(_buildCurrentMonthDay(day));
    }

    // Next month trailing days to complete a full 7x5 or 7x6 grid
    final totalCells = ((dayCells.length / 7).ceil()) * 7;
    final remainingDays = totalCells - dayCells.length;
    for (int day = 1; day <= (remainingDays < 7 ? (remainingDays == 0 ? 0 : remainingDays) : remainingDays); day++) {
      dayCells.add(_buildInactiveDay(day));
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 3.0,
      childAspectRatio: 0.82,
      children: dayCells,
    );
  }

  Widget _buildInactiveDay(int day) {
    return Center(
      child: Text(
        '$day',
        style: const TextStyle(
          color: Color(0xFFC4BCC9),
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCurrentMonthDay(int day) {
    final isSelected = day == _selectedDay;
    final filters = widget.activeFilters ?? {
      'period': true,
      'fertileWindow': true,
      'intimacy': true,
      'symptoms': true,
    };

    final showPeriod = filters['period'] ?? true;
    final showFertile = filters['fertileWindow'] ?? true;
    final showIntimacy = filters['intimacy'] ?? true;

    // Period days: 4 (hollow ring), 5, 6, 7, 8 (filled pink)
    final isPeriodHollow = showPeriod && day == 4;
    final isPeriodFilled = showPeriod && day >= 5 && day <= 8;

    // Logged Period badge: Day 11 (hollow pink + heart badge)
    final isLoggedPeriod = showPeriod && day == 11;

    // Luteal/Transition Phase: 12, 13, 14 (orange ring)
    final isLuteal = showPeriod && day >= 12 && day <= 14;

    // Fertile Window: 15, 16, 17, 19, 20 (green ring)
    final isFertile = showFertile && ((day >= 15 && day <= 17) || day == 19 || day == 20);

    // Sex Logged badge: Day 19 (purple lock-heart badge)
    final isSexLogged = showIntimacy && day == 19;

    // Ovulation Peak Day: Day 18 (purple droplet shape)
    final isOvulation = showFertile && day == 18;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDay = day;
        });
        widget.onDaySelected?.call(day);
      },
      onLongPress: () {
        setState(() {
          _selectedDay = day;
        });
        widget.onDayLongPress?.call(day);
      },
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: _buildDayCell(
            day: day,
            isSelected: isSelected,
            isPeriodHollow: isPeriodHollow,
            isPeriodFilled: isPeriodFilled,
            isLoggedPeriod: isLoggedPeriod,
            isLuteal: isLuteal,
            isFertile: isFertile,
            isSexLogged: isSexLogged,
            isOvulation: isOvulation,
            showPeriod: showPeriod,
          ),
        ),
      ),
    );
  }

  Widget _buildDayCell({
    required int day,
    required bool isSelected,
    required bool isPeriodHollow,
    required bool isPeriodFilled,
    required bool isLoggedPeriod,
    required bool isLuteal,
    required bool isFertile,
    required bool isSexLogged,
    required bool isOvulation,
    required bool showPeriod,
  }) {
    // 1. Ovulation Peak (Day 18) Droplet Shape
    if (isOvulation) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: 34.0,
                height: 38.0,
                decoration: const BoxDecoration(
                  color: Color(0xFF7C3AED),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(17.0),
                    bottom: Radius.circular(17.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Star Sparkle
              const Positioned(
                top: -3.0,
                right: -4.0,
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFF8B5CF6),
                  size: 13.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2.0),
          const Text(
            'OVULATION',
            style: TextStyle(
              fontSize: 7.5,
              fontWeight: FontWeight.w900,
              color: Color(0xFF7C3AED),
              letterSpacing: 0.2,
            ),
          ),
        ],
      );
    }

    // 2. Period Filled Badges (Days 5-8)
    if (isPeriodFilled) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32.0,
            height: 32.0,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE4E8),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$day',
                style: const TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFE81B54),
                ),
              ),
            ),
          ),
          const SizedBox(height: 2.0),
          _buildDot(const Color(0xFFE81B54)),
        ],
      );
    }

    // 3. Period Hollow Ring (Day 4)
    if (isPeriodHollow) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32.0,
            height: 32.0,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFE81B54),
                width: 1.2,
              ),
            ),
            child: Center(
              child: Text(
                '$day',
                style: const TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFE81B54),
                ),
              ),
            ),
          ),
          const SizedBox(height: 2.0),
          _buildDot(const Color(0xFFE81B54)),
        ],
      );
    }

    // 4. Logged Period (Day 11) with Heart Badge
    if (isLoggedPeriod) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFE81B54),
                    width: 1.2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFE81B54),
                    ),
                  ),
                ),
              ),
              const Positioned(
                bottom: -2.0,
                right: -2.0,
                child: Icon(
                  Icons.favorite_rounded,
                  color: Color(0xFFE81B54),
                  size: 11.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2.0),
          _buildDot(const Color(0xFFE81B54)),
        ],
      );
    }

    // 5. Luteal Phase (Days 12, 13, 14) Orange Outlined Badge
    if (isLuteal) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32.0,
            height: 32.0,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFF59E0B),
                width: 1.2,
              ),
            ),
            child: Center(
              child: Text(
                '$day',
                style: const TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFD97706),
                ),
              ),
            ),
          ),
          const SizedBox(height: 2.0),
          _buildDot(const Color(0xFFF59E0B)),
        ],
      );
    }

    // 6. Fertile Window (Days 15, 16, 17, 19, 20) Mint Green Outlined Badge
    if (isFertile) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF10B981),
                    width: 1.2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF059669),
                    ),
                  ),
                ),
              ),
              if (isSexLogged)
                const Positioned(
                  bottom: -3.0,
                  right: -3.0,
                  child: Icon(
                    Icons.lock_rounded,
                    color: Color(0xFF7C3AED),
                    size: 11.0,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2.0),
          _buildDot(const Color(0xFF10B981)),
        ],
      );
    }

    // 7. Regular Days (1, 2, 3, 9, 10, 21..31)
    final hasPeriodDot = showPeriod && day >= 1 && day <= 3;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 32.0,
          height: 32.0,
          child: Center(
            child: Text(
              '$day',
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E1A3C),
              ),
            ),
          ),
        ),
        const SizedBox(height: 2.0),
        if (hasPeriodDot)
          _buildDot(const Color(0xFFE81B54))
        else
          const SizedBox(height: 4.0),
      ],
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 4.0,
      height: 4.0,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildLegendRow() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10.0,
      runSpacing: 6.0,
      children: [
        _buildLegendItem(
          icon: const Icon(Icons.radio_button_checked_rounded, color: Color(0xFFE81B54), size: 12.0),
          label: 'Period',
        ),
        _buildLegendItem(
          icon: _buildDot(const Color(0xFF10B981)),
          label: 'Fertile window',
        ),
        _buildLegendItem(
          icon: _buildDot(const Color(0xFF7C3AED)),
          label: 'Ovulation',
        ),
        _buildLegendItem(
          icon: _buildDot(const Color(0xFFF59E0B)),
          label: 'Luteal phase',
        ),
        _buildLegendItem(
          icon: const Icon(Icons.favorite_rounded, color: Color(0xFFE81B54), size: 11.0),
          label: 'Logged period',
        ),
        _buildLegendItem(
          icon: const Icon(Icons.lock_rounded, color: Color(0xFF7C3AED), size: 11.0),
          label: 'Sex logged',
        ),
      ],
    );
  }

  Widget _buildLegendItem({required Widget icon, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 4.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF7A708A),
          ),
        ),
      ],
    );
  }
}
