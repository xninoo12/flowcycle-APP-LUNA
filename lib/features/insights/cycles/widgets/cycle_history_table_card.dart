import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Data model representing a past recorded cycle entry.
class PastCycleEntry {
  final int cycleNumber;
  final String dateRange;
  final int lengthDays;
  final String ovulationDate;

  const PastCycleEntry({
    required this.cycleNumber,
    required this.dateRange,
    required this.lengthDays,
    required this.ovulationDate,
  });
}

/// "Cycle history" Table Card with past cycle rows for Cycles subscreen.
class CycleHistoryTableCard extends StatelessWidget {
  final List<PastCycleEntry>? history;
  final VoidCallback? onSeeAll;
  final ValueChanged<PastCycleEntry>? onRowTap;

  static List<PastCycleEntry> generatePastCycles({
    required DateTime lastPeriodStartDate,
    required int averageCycleLength,
    int count = 4,
  }) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final List<PastCycleEntry> list = [];
    DateTime cycleStart = lastPeriodStartDate;

    for (int i = 0; i < count; i++) {
      final cycleEnd = cycleStart.subtract(const Duration(days: 1));
      final prevStart = cycleEnd.subtract(Duration(days: averageCycleLength - 1));
      final ovulationDate = prevStart.add(Duration(days: averageCycleLength - 14));

      final startMonth = months[prevStart.month - 1];
      final endMonth = months[cycleEnd.month - 1];
      final ovMonth = months[ovulationDate.month - 1];

      final String rangeText = startMonth == endMonth
          ? '$startMonth ${prevStart.day} – ${cycleEnd.day}'
          : '$startMonth ${prevStart.day} – $endMonth ${cycleEnd.day}';

      list.add(
        PastCycleEntry(
          cycleNumber: count + 2 - i,
          dateRange: rangeText,
          lengthDays: averageCycleLength + (i % 2 == 0 ? 0 : (i == 1 ? 1 : -1)),
          ovulationDate: '$ovMonth ${ovulationDate.day}',
        ),
      );

      cycleStart = prevStart;
    }

    return list;
  }

  static const List<PastCycleEntry> defaultHistory = [
    PastCycleEntry(
      cycleNumber: 6,
      dateRange: 'Apr 6 – May 3',
      lengthDays: 28,
      ovulationDate: 'Apr 20',
    ),
    PastCycleEntry(
      cycleNumber: 5,
      dateRange: 'Mar 9 – Apr 5',
      lengthDays: 28,
      ovulationDate: 'Mar 23',
    ),
    PastCycleEntry(
      cycleNumber: 4,
      dateRange: 'Feb 8 – Mar 8',
      lengthDays: 29,
      ovulationDate: 'Feb 22',
    ),
    PastCycleEntry(
      cycleNumber: 3,
      dateRange: 'Jan 12 – Feb 7',
      lengthDays: 27,
      ovulationDate: 'Jan 25',
    ),
  ];

  const CycleHistoryTableCard({
    super.key,
    this.history,
    this.onSeeAll,
    this.onRowTap,
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
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header: Title + "See all"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cycle history',
                style: AppTextStyles.subtitle.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: const Color(0xFF1E1A3C),
                ),
              ),
              InkWell(
                onTap: onSeeAll,
                borderRadius: BorderRadius.circular(4.0),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                  child: Text(
                    'See all',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6C5CE7),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm + 2.0),

          // 2. Table Column Headers: Cycle, Dates, Length, Ovulation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
            child: Row(
              children: const [
                SizedBox(
                  width: 38.0,
                  child: Text(
                    'Cycle',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8C7C92),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    'Dates',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8C7C92),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    'Length',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8C7C92),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    'Ovulation',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8C7C92),
                    ),
                  ),
                ),
                SizedBox(width: 14.0),
              ],
            ),
          ),

          const Divider(height: 1.0, color: Color(0xFFEFE9F3)),

          // 3. Past Cycle Rows
          ...(history ?? defaultHistory).map((entry) => _buildHistoryRow(entry)),
        ],
      ),
    );
  }

  Widget _buildHistoryRow(PastCycleEntry entry) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onRowTap?.call(entry),
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Cycle Number Circle
              Container(
                width: 26.0,
                height: 26.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3EDFA),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${entry.cycleNumber}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF6C5CE7),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12.0),

              // Dates Range
              Expanded(
                flex: 5,
                child: Text(
                  entry.dateRange,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E1A3C),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Length in Days
              Expanded(
                flex: 4,
                child: Text(
                  '${entry.lengthDays} days',
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E1A3C),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Ovulation Date (Purple)
              Expanded(
                flex: 4,
                child: Text(
                  entry.ovulationDate,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6C5CE7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Right Chevron
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF8C7C92),
                size: 18.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
