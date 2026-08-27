import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Timeframe Switcher (Month / Year) and "Today" quick action for Calendar.
class CalendarTimeframeSwitcher extends StatelessWidget {
  final String selectedTimeframe;
  final ValueChanged<String>? onTimeframeChanged;
  final VoidCallback? onTodayTap;

  const CalendarTimeframeSwitcher({
    super.key,
    this.selectedTimeframe = 'Month',
    this.onTimeframeChanged,
    this.onTodayTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMonth = selectedTimeframe == 'Month';

    return Row(
      children: [
        // 1. Month / Year Segmented Switcher
        Expanded(
          flex: 6,
          child: Container(
            height: 40.0,
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F4FB),
              borderRadius: AppRadius.pill,
              border: Border.all(color: const Color(0xFFEFE9F3), width: 0.8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildSegment(
                    label: 'Month',
                    isSelected: isMonth,
                    onTap: () => onTimeframeChanged?.call('Month'),
                  ),
                ),
                Expanded(
                  child: _buildSegment(
                    label: 'Year',
                    isSelected: !isMonth,
                    onTap: () => onTimeframeChanged?.call('Year'),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: AppSpacing.md),

        // 2. "Today" Action Pill Button
        Expanded(
          flex: 3,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTodayTap,
              borderRadius: AppRadius.pill,
              child: Container(
                height: 40.0,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.pill,
                  border: Border.all(
                    color: const Color(0xFFFFD4E2),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Today',
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFFE84D75),
                      fontWeight: FontWeight.w800,
                      fontSize: 13.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSegment({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: AppRadius.pill,
          boxShadow: isSelected ? AppShadows.card : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.0,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              color: isSelected
                  ? const Color(0xFFE84D75)
                  : const Color(0xFF8C7C92),
            ),
          ),
        ),
      ),
    );
  }
}
