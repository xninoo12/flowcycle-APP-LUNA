import 'package:flutter/material.dart';

enum AppGoalMode { cycleAwareness, tryingToConceive }

/// Card displaying "Your current mode" with exact side-by-side selectable tiles.
class CurrentModeSelectionCard extends StatelessWidget {
  final AppGoalMode currentMode;
  final ValueChanged<AppGoalMode>? onModeChanged;

  const CurrentModeSelectionCard({
    super.key,
    this.currentMode = AppGoalMode.cycleAwareness,
    this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.0),
        border: Border.all(color: const Color(0xFFF0EBF5), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1A3C).withValues(alpha: 0.04),
            blurRadius: 12.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Title and description
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Your current mode',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1A3C),
                  ),
                ),
                SizedBox(height: 3.0),
                Text(
                  'This helps us personalize your insights.',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7A708A),
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12.0),

          // Right: 2 Selectable Tiles
          Expanded(
            flex: 6,
            child: Row(
              children: [
                // 1. Cycle Awareness Tile
                Expanded(
                  child: _buildTile(
                    mode: AppGoalMode.cycleAwareness,
                    icon: Icons.filter_vintage_rounded,
                    titleTop: 'Cycle',
                    titleBottom: 'Awareness',
                    isActive: currentMode == AppGoalMode.cycleAwareness,
                  ),
                ),

                const SizedBox(width: 8.0),

                // 2. Trying to Conceive Tile
                Expanded(
                  child: _buildTile(
                    mode: AppGoalMode.tryingToConceive,
                    icon: Icons.track_changes_rounded,
                    titleTop: 'Trying to',
                    titleBottom: 'Conceive',
                    isActive: currentMode == AppGoalMode.tryingToConceive,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile({
    required AppGoalMode mode,
    required IconData icon,
    required String titleTop,
    required String titleBottom,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => onModeChanged?.call(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 4.0),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFFF0F5) : Colors.white,
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(
            color: isActive ? const Color(0xFFFFCCD8) : const Color(0xFFEFE9F3),
            width: isActive ? 1.2 : 1.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18.0,
              color: isActive
                  ? const Color(0xFFE84D75)
                  : const Color(0xFF7A708A),
            ),
            const SizedBox(height: 3.5),
            Text(
              titleTop,
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                color: isActive
                    ? const Color(0xFFE84D75)
                    : const Color(0xFF4A4358),
                height: 1.1,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              titleBottom,
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                color: isActive
                    ? const Color(0xFFE84D75)
                    : const Color(0xFF4A4358),
                height: 1.1,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
