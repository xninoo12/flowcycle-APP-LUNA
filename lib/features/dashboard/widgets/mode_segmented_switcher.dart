import 'package:flutter/material.dart';
import '../../../shared/models/app_mode.dart';

/// Compact, sleek mode segmented switcher for toggling between Cycle Awareness and Trying to Conceive.
class ModeSegmentedSwitcher extends StatelessWidget {
  final AppMode currentMode;
  final ValueChanged<AppMode> onModeChanged;

  const ModeSegmentedSwitcher({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isCycle = currentMode == AppMode.cycleAwareness;

    return Container(
      height: 38.0,
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF4EEF7),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: const Color(0xFFE8DEEC),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSegmentButton(
              title: 'Cycle Awareness',
              emoji: '🌸',
              iconColor: const Color(0xFF7C5CE7),
              activeTextColor: const Color(0xFF6B46C1),
              isSelected: isCycle,
              onTap: () => onModeChanged(AppMode.cycleAwareness),
            ),
          ),
          Expanded(
            child: _buildSegmentButton(
              title: 'Trying to Conceive',
              emoji: '💗',
              iconColor: const Color(0xFFFF4D79),
              activeTextColor: const Color(0xFFFF4D79),
              isSelected: !isCycle,
              onTap: () => onModeChanged(AppMode.tryingToConceive),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton({
    required String title,
    required String emoji,
    required Color iconColor,
    required Color activeTextColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(18.0),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF1E1A3C).withValues(alpha: 0.06),
                        blurRadius: 8.0,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 13.0)),
                  const SizedBox(width: 5.0),
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        fontSize: 12.0,
                        color: isSelected
                            ? activeTextColor
                            : const Color(0xFF8C7C92),
                        letterSpacing: -0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
