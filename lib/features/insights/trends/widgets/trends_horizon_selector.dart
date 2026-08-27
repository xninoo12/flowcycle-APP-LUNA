import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';

/// 3-option time horizon segmented pill selector (3m, 6m, 12m) for Trends screen.
class TrendsHorizonSelector extends StatelessWidget {
  final String selectedHorizon;
  final ValueChanged<String>? onHorizonChanged;

  static const List<String> horizons = ['3 months', '6 months', '12 months'];

  const TrendsHorizonSelector({
    super.key,
    this.selectedHorizon = '3 months',
    this.onHorizonChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.pill,
        border: Border.all(color: const Color(0xFFEFE9F3), width: 1.0),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(3.0),
      child: Row(
        children: horizons.map((horizon) {
          final isSelected = horizon == selectedHorizon;
          return Expanded(
            child: GestureDetector(
              onTap: () => onHorizonChanged?.call(horizon),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFFFF0F5)
                      : Colors.transparent,
                  borderRadius: AppRadius.pill,
                ),
                child: Center(
                  child: Text(
                    horizon,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFFE84D75)
                          : const Color(0xFF6E6875),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
