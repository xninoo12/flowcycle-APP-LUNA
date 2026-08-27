import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';

/// 12-Month Annual Overview Grid with period and ovulation mini-highlights.
class YearOverviewGrid extends StatelessWidget {
  final int selectedYear;
  final ValueChanged<int> onMonthSelected;

  const YearOverviewGrid({
    super.key,
    this.selectedYear = 2025,
    required this.onMonthSelected,
  });

  static const List<String> monthNames = [
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Year Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.medium,
            border: Border.all(color: const Color(0xFFEFE9F3)),
            boxShadow: AppShadows.card,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '$selectedYear Annual Forecast',
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1A3C),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EDFA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '13 Cycles Predicted',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7C5CE7),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // 12-Month Mini Cards Grid (2 columns)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.15,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            final monthNumber = index + 1;
            final monthName = monthNames[index];
            final isMay = monthNumber == 5;

            return GestureDetector(
              onTap: () => onMonthSelected(monthNumber),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isMay ? const Color(0xFFFAF7FF) : Colors.white,
                  borderRadius: AppRadius.medium,
                  border: Border.all(
                    color: isMay
                        ? const Color(0xFF7C5CE7)
                        : const Color(0xFFEFE9F3),
                    width: isMay ? 1.5 : 1.0,
                  ),
                  boxShadow: AppShadows.card,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          monthName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: isMay
                                ? const Color(0xFF7C5CE7)
                                : const Color(0xFF1E1A3C),
                          ),
                        ),
                        if (isMay)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7C5CE7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Current',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    // Mini 4-week dots preview
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(4, (week) {
                        return Column(
                          children: List.generate(7, (day) {
                            final dayNum = week * 7 + day + 1;
                            final isPeriod = dayNum >= 2 && dayNum <= 6;
                            final isOvulation = dayNum == 14;
                            final isFertile = dayNum >= 12 && dayNum <= 16;

                            Color dotColor = const Color(0xFFE8E5EE);
                            if (isPeriod) {
                              dotColor = const Color(0xFFE84D75);
                            } else if (isOvulation) {
                              dotColor = const Color(0xFF7C5CE7);
                            } else if (isFertile) {
                              dotColor = const Color(0xFFA78BFA);
                            }

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 1),
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: dotColor,
                                shape: BoxShape.circle,
                              ),
                            );
                          }),
                        );
                      }),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
