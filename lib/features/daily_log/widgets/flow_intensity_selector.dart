import 'package:flutter/material.dart';

enum FlowLevel { none, spotting, light, medium, heavy }

class FlowTileConfig {
  final FlowLevel level;
  final String label;
  final IconData icon;
  final Color iconColor;

  const FlowTileConfig({
    required this.level,
    required this.label,
    required this.icon,
    required this.iconColor,
  });
}

/// 5-Level Flow Intensity selector tiles matching exact UI layout and active styling.
class FlowIntensitySelector extends StatelessWidget {
  final FlowLevel selectedFlow;
  final ValueChanged<FlowLevel>? onFlowChanged;

  static const List<FlowTileConfig> options = [
    FlowTileConfig(
      level: FlowLevel.none,
      label: 'None',
      icon: Icons.water_drop_outlined,
      iconColor: Color(0xFF8C7C92),
    ),
    FlowTileConfig(
      level: FlowLevel.spotting,
      label: 'Spotting',
      icon: Icons.water_drop_rounded,
      iconColor: Color(0xFFE11D48),
    ),
    FlowTileConfig(
      level: FlowLevel.light,
      label: 'Light',
      icon: Icons.water_drop_rounded,
      iconColor: Color(0xFF7C5CE7),
    ),
    FlowTileConfig(
      level: FlowLevel.medium,
      label: 'Medium',
      icon: Icons.water_drop_rounded,
      iconColor: Color(0xFFE11D48),
    ),
    FlowTileConfig(
      level: FlowLevel.heavy,
      label: 'Heavy',
      icon: Icons.opacity_rounded,
      iconColor: Color(0xFFBE123C),
    ),
  ];

  const FlowIntensitySelector({
    super.key,
    this.selectedFlow = FlowLevel.light,
    this.onFlowChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title Row
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.water_drop_rounded,
              size: 14.0,
              color: Color(0xFFE11D48),
            ),
            SizedBox(width: 4.0),
            Text(
              'Flow',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1A3C),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8.0),

        // Row of 5 Options
        Row(
          children: options.map((option) {
            final bool isSelected = option.level == selectedFlow;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.5),
                child: GestureDetector(
                  onTap: () => onFlowChanged?.call(option.level),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF7C5CE7)
                          : const Color(0xFFFAF8FC),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF7C5CE7)
                            : const Color(0xFFEFE9F3),
                        width: 1.0,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(
                                  0xFF7C5CE7,
                                ).withValues(alpha: 0.3),
                                blurRadius: 6.0,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          option.icon,
                          size: 18.0,
                          color: isSelected ? Colors.white : option.iconColor,
                        ),
                        const SizedBox(height: 3.5),
                        Text(
                          option.label,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: isSelected
                                ? FontWeight.w800
                                : FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF4A4358),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
