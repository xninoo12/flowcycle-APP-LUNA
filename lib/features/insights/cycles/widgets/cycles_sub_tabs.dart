import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';

/// Sub-Tab Item definition for Cycles screen.
class CycleSubTabItem {
  final String id;
  final String label;
  final IconData icon;

  const CycleSubTabItem({
    required this.id,
    required this.label,
    required this.icon,
  });
}

/// Horizontal scrolling pill tabs for Cycles subscreen.
class CyclesSubTabs extends StatelessWidget {
  final String selectedTabId;
  final ValueChanged<String>? onTabSelected;

  static const List<CycleSubTabItem> defaultTabs = [
    CycleSubTabItem(
      id: 'current_cycle',
      label: 'Current cycle',
      icon: Icons.track_changes_rounded,
    ),
    CycleSubTabItem(
      id: 'history',
      label: 'History',
      icon: Icons.history_rounded,
    ),
    CycleSubTabItem(
      id: 'predictions',
      label: 'Predictions',
      icon: Icons.av_timer_rounded,
    ),
    CycleSubTabItem(
      id: 'calendar',
      label: 'Calendar',
      icon: Icons.calendar_month_outlined,
    ),
  ];

  const CyclesSubTabs({
    super.key,
    this.selectedTabId = 'current_cycle',
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: defaultTabs.map((tab) {
          final isSelected = tab.id == selectedTabId;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: GestureDetector(
              onTap: () => onTabSelected?.call(tab.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : const Color(0xFFF7F4FB),
                  borderRadius: AppRadius.pill,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFFFD4E2)
                        : const Color(0xFFEFE9F3),
                    width: 1.0,
                  ),
                  boxShadow: isSelected ? AppShadows.card : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tab.icon,
                      size: 15.0,
                      color: isSelected
                          ? const Color(0xFFE84D75)
                          : const Color(0xFF8C7C92),
                    ),
                    const SizedBox(width: 5.0),
                    Text(
                      tab.label,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFFE84D75)
                            : const Color(0xFF8C7C92),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
