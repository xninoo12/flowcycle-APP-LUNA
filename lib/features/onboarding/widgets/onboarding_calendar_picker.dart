import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Refined, accessible calendar picker component for selecting the last period start date.
///
/// Features weekday headers, circular month navigation controls, past-date selection constraints,
/// glowing selected day with sparkle aura, and quick-date shortcut pills.
class OnboardingCalendarPicker extends StatefulWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime? maxDate;
  final DateTime? minDate;
  final VoidCallback? onNotSureTap;

  const OnboardingCalendarPicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.maxDate,
    this.minDate,
    this.onNotSureTap,
  });

  @override
  State<OnboardingCalendarPicker> createState() =>
      _OnboardingCalendarPickerState();
}

class _OnboardingCalendarPickerState extends State<OnboardingCalendarPicker> {
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    final initial = widget.selectedDate ?? DateTime.now();
    _displayedMonth = DateTime(initial.year, initial.month, 1);
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
        1,
      );
    });
  }

  void _nextMonth() {
    final now = widget.maxDate ?? DateTime.now();
    final next = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
    if (next.year < now.year ||
        (next.year == now.year && next.month <= now.month)) {
      setState(() {
        _displayedMonth = next;
      });
    }
  }

  static const List<String> _weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  static const List<String> _months = [
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

  @override
  Widget build(BuildContext context) {
    final now = widget.maxDate ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final canGoNext =
        _displayedMonth.year < now.year ||
        (_displayedMonth.year == now.year && _displayedMonth.month < now.month);

    final daysInMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      0,
    ).day;
    final firstWeekday =
        DateTime(_displayedMonth.year, _displayedMonth.month, 1).weekday % 7;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: const Color(0xFFF3E8EE), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1A3C).withValues(alpha: 0.03),
            blurRadius: 16.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Weekday Labels (S, M, T, W, T, F, S) at the top of the card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _weekdays
                  .map(
                    (day) => SizedBox(
                      width: 38.0,
                      child: Center(
                        child: Text(
                          day,
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7A708A),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          const SizedBox(height: 12.0),

          // 2. Month Navigator Header (<  May 2025  >)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavButton(
                  icon: Icons.chevron_left_rounded,
                  onPressed: _previousMonth,
                  semanticLabel: 'Previous Month',
                  isEnabled: true,
                ),
                Text(
                  '${_months[_displayedMonth.month - 1]} ${_displayedMonth.year}',
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1A3C),
                    letterSpacing: -0.3,
                  ),
                ),
                _buildNavButton(
                  icon: Icons.chevron_right_rounded,
                  onPressed: canGoNext ? _nextMonth : null,
                  semanticLabel: 'Next Month',
                  isEnabled: canGoNext,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12.0),

          // 3. Calendar Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: firstWeekday + daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 6.0,
            ),
            itemBuilder: (context, index) {
              if (index < firstWeekday) {
                return const SizedBox.shrink();
              }

              final day = index - firstWeekday + 1;
              final date = DateTime(
                _displayedMonth.year,
                _displayedMonth.month,
                day,
              );

              final bool isFuture = date.isAfter(today);
              final bool isSelected =
                  widget.selectedDate != null &&
                  widget.selectedDate!.year == date.year &&
                  widget.selectedDate!.month == date.month &&
                  widget.selectedDate!.day == date.day;

              return Semantics(
                button: true,
                selected: isSelected,
                enabled: !isFuture,
                label:
                    '${_months[date.month - 1]} $day, ${date.year}${isSelected ? ', selected' : ''}',
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isFuture
                        ? null
                        : () {
                            widget.onDateSelected(date);
                          },
                    customBorder: const CircleBorder(),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Radiant Sparkle Aura Ring around the selected day
                          if (isSelected) ...[
                            Container(
                              width: 44.0,
                              height: 44.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFFF8DA1).withValues(alpha: 0.18),
                                border: Border.all(
                                  color: const Color(0xFFFFD1DC),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            // Tiny sparkle dot
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Icon(
                                Icons.auto_awesome_rounded,
                                size: 8.0,
                                color: AppColors.primaryRose.withValues(alpha: 0.8),
                              ),
                            ),
                          ],

                          // Main Day Circle
                          Container(
                            width: 36.0,
                            height: 36.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? const Color(0xFFFF4D79)
                                  : Colors.transparent,
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFFFF4D79).withValues(alpha: 0.35),
                                        blurRadius: 10.0,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '$day',
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: isSelected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : (isFuture
                                          ? const Color(0xFFC4BDCC)
                                          : const Color(0xFF1E1A3C)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16.0),
          const Divider(height: 1.0, color: Color(0xFFF3E8EE)),
          const SizedBox(height: 14.0),

          // 4. Quick-Date Shortcuts
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.start,
            children: [
              _buildShortcutChip(
                icon: Icons.local_florist_rounded,
                label: 'Today',
                onTap: () => widget.onDateSelected(today),
              ),
              _buildShortcutChip(
                icon: Icons.calendar_today_rounded,
                label: '1 Week Ago',
                onTap: () => widget.onDateSelected(
                  today.subtract(const Duration(days: 7)),
                ),
              ),
              _buildShortcutChip(
                icon: Icons.calendar_today_rounded,
                label: '2 Weeks Ago',
                onTap: () => widget.onDateSelected(
                  today.subtract(const Duration(days: 14)),
                ),
              ),
              if (widget.onNotSureTap != null)
                _buildShortcutChip(
                  icon: Icons.help_outline_rounded,
                  label: 'Not Sure',
                  onTap: widget.onNotSureTap!,
                  isSecondary: true,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required String semanticLabel,
    required bool isEnabled,
  }) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 32.0,
          height: 32.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFAF7F9),
            border: Border.all(
              color: const Color(0xFFEFE8ED),
              width: 1.0,
            ),
          ),
          child: Center(
            child: Icon(
              icon,
              size: 20.0,
              color: isEnabled
                  ? const Color(0xFF1E1A3C)
                  : const Color(0xFFC4BDCC),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShortcutChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isSecondary = false,
  }) {
    final Color bgColor = isSecondary
        ? const Color(0xFFF7F0FA)
        : const Color(0xFFFFF0F4);

    final Color borderColor = isSecondary
        ? const Color(0xFFE6D6FA)
        : const Color(0xFFFFD6E2);

    final Color iconColor = isSecondary
        ? const Color(0xFF9B51E0)
        : const Color(0xFFFF4D79);

    final Color textColor = isSecondary
        ? const Color(0xFF5C3A82)
        : const Color(0xFF1E1A3C);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: borderColor,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13.0,
              color: iconColor,
            ),
            const SizedBox(width: 5.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
