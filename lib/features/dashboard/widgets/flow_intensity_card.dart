import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Flow Intensity tracking card for Cycle Awareness Dashboard.
class FlowIntensityCard extends StatefulWidget {
  final String selectedIntensity;
  final ValueChanged<String>? onIntensitySelected;
  final VoidCallback? onViewHistory;

  const FlowIntensityCard({
    super.key,
    this.selectedIntensity = 'Medium',
    this.onIntensitySelected,
    this.onViewHistory,
  });

  @override
  State<FlowIntensityCard> createState() => _FlowIntensityCardState();
}

class _FlowIntensityCardState extends State<FlowIntensityCard> {
  late String _currentSelection;

  @override
  void initState() {
    super.initState();
    _currentSelection = widget.selectedIntensity;
  }

  @override
  void didUpdateWidget(covariant FlowIntensityCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIntensity != widget.selectedIntensity) {
      _currentSelection = widget.selectedIntensity;
    }
  }

  static const List<_FlowLevel> _levels = [
    _FlowLevel(label: 'Light', symbol: '–'),
    _FlowLevel(label: 'Medium', symbol: '='),
    _FlowLevel(label: 'Heavy', symbol: '≡'),
    _FlowLevel(label: 'Very heavy', symbol: '≣'),
    _FlowLevel(label: 'Spot', symbol: '–'),
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
      padding: const EdgeInsets.all(AppSpacing.sm + 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Flow intensity',
                  style: AppTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    color: const Color(0xFF1E1A3C),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'Today',
                style: AppTextStyles.caption.copyWith(
                  color: const Color(0xFF6C449B),
                  fontWeight: FontWeight.w700,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: _levels.map((level) {
              final isSelected = _currentSelection == level.label;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentSelection = level.label;
                    });
                    widget.onIntensitySelected?.call(level.label);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 28.0,
                        height: 28.0,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFFDE8EF)
                              : const Color(0xFFFAF7F2),
                          borderRadius: BorderRadius.circular(7.0),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFE84D75)
                                : const Color(0xFFEDE8E0),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            level.symbol,
                            style: const TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFE84D75),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      Text(
                        level.label,
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 8.5,
                          color: isSelected
                              ? const Color(0xFF1E1A3C)
                              : const Color(0xFF7A708A),
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.sm + 2.0),
          InkWell(
            onTap: widget.onViewHistory,
            borderRadius: BorderRadius.circular(4.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text(
                'View history →',
                style: AppTextStyles.caption.copyWith(
                  color: const Color(0xFFE84D75),
                  fontWeight: FontWeight.w700,
                  fontSize: 11.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FlowLevel {
  final String label;
  final String symbol;

  const _FlowLevel({required this.label, required this.symbol});
}
