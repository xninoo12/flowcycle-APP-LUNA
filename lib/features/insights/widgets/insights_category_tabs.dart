import 'package:flutter/material.dart';

/// Category Tab Item
class InsightCategoryItem {
  final String id;
  final String label;
  final IconData icon;

  const InsightCategoryItem({
    required this.id,
    required this.label,
    required this.icon,
  });
}

/// Segmented capsule navigation bar for Insights matching the exact mockup.
class InsightsCategoryTabs extends StatelessWidget {
  final String selectedTabId;
  final ValueChanged<String>? onTabSelected;

  static const List<InsightCategoryItem> defaultTabs = [
    InsightCategoryItem(
      id: 'overview',
      label: 'Overview',
      icon: Icons.track_changes_rounded,
    ),
    InsightCategoryItem(
      id: 'cycles',
      label: 'Cycles',
      icon: Icons.calendar_today_rounded,
    ),
    InsightCategoryItem(
      id: 'fertility',
      label: 'Fertility',
      icon: Icons.water_drop_outlined,
    ),
    InsightCategoryItem(
      id: 'trends',
      label: 'Trends',
      icon: Icons.bar_chart_rounded,
    ),
  ];

  const InsightsCategoryTabs({
    super.key,
    this.selectedTabId = 'overview',
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: defaultTabs.map((tab) {
        final isSelected = tab.id == selectedTabId;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.0),
                onTap: () => onTabSelected?.call(tab.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 7.5,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Color(0xFFFF6B8B), Color(0xFFFF4D6D)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFFF6B8B)
                          : const Color(0xFFF1ECF5),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? const Color(0xFFFF4D6D).withValues(alpha: 0.25)
                            : const Color(0xFF1E1A3C).withValues(alpha: 0.02),
                        blurRadius: isSelected ? 8.0 : 4.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        tab.icon,
                        size: 13.0,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF7A708A),
                      ),
                      const SizedBox(width: 3.5),
                      Flexible(
                        child: Text(
                          tab.label,
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: isSelected
                                ? FontWeight.w800
                                : FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF1E1A3C),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
