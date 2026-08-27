import 'package:flutter/material.dart';
import '../../../shared/models/app_mode.dart';

/// 5-Button Horizontal Quick-Log Action Strip for FlowCycle Dashboards.
class QuickLogActionStrip extends StatelessWidget {
  final AppMode mode;
  final VoidCallback onEditTap;
  final ValueChanged<String>? onActionTap;

  const QuickLogActionStrip({
    super.key,
    required this.mode,
    required this.onEditTap,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCycle = mode == AppMode.cycleAwareness;

    final items = isCycle
        ? const [
            _QuickActionItem(
              id: 'flow',
              label: 'Flow',
              icon: Icons.water_drop_rounded,
              bgColor: Color(0xFFFFEEF3),
              iconColor: Color(0xFFFF4D79),
            ),
            _QuickActionItem(
              id: 'mood',
              label: 'Mood',
              icon: Icons.sentiment_satisfied_alt_rounded,
              bgColor: Color(0xFFFEF3C7),
              iconColor: Color(0xFFD97706),
            ),
            _QuickActionItem(
              id: 'symptoms',
              label: 'Symptoms',
              icon: Icons.sick_rounded,
              bgColor: Color(0xFFF3E8FF),
              iconColor: Color(0xFF8B5CF6),
            ),
            _QuickActionItem(
              id: 'sleep',
              label: 'Sleep',
              icon: Icons.nightlight_round,
              bgColor: Color(0xFFEEF2FF),
              iconColor: Color(0xFF6366F1),
            ),
            _QuickActionItem(
              id: 'notes',
              label: 'Notes',
              icon: Icons.edit_note_rounded,
              bgColor: Color(0xFFECFDF5),
              iconColor: Color(0xFF059669),
            ),
          ]
        : const [
            _QuickActionItem(
              id: 'intercourse',
              label: 'Intercourse',
              icon: Icons.favorite_rounded,
              bgColor: Color(0xFFF3E8FF),
              iconColor: Color(0xFF8B5CF6),
            ),
            _QuickActionItem(
              id: 'lh_test',
              label: 'LH Test',
              icon: Icons.science_rounded,
              bgColor: Color(0xFFEDE9FE),
              iconColor: Color(0xFF7C3AED),
            ),
            _QuickActionItem(
              id: 'bbt',
              label: 'BBT',
              icon: Icons.thermostat_rounded,
              bgColor: Color(0xFFFFE4E6),
              iconColor: Color(0xFFFF4D79),
            ),
            _QuickActionItem(
              id: 'cervical_mucus',
              label: 'Cervical Mucus',
              icon: Icons.opacity_rounded,
              bgColor: Color(0xFFFEF3C7),
              iconColor: Color(0xFFD97706),
            ),
            _QuickActionItem(
              id: 'notes',
              label: 'Notes',
              icon: Icons.edit_note_rounded,
              bgColor: Color(0xFFECFDF5),
              iconColor: Color(0xFF059669),
            ),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isCycle ? 'Quick Log' : 'TTC Quick Log',
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1A3C),
                letterSpacing: -0.2,
              ),
            ),
            GestureDetector(
              onTap: onEditTap,
              child: Text(
                'Edit',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: isCycle
                      ? const Color(0xFF7C5CE7)
                      : const Color(0xFFFF4D79),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12.0),

        // Action Buttons Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.map((item) {
            return Expanded(
              child: GestureDetector(
                onTap: () => onActionTap?.call(item.id),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 46.0,
                      height: 46.0,
                      decoration: BoxDecoration(
                        color: item.bgColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E1A3C).withValues(alpha: 0.03),
                            blurRadius: 8.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          item.icon,
                          color: item.iconColor,
                          size: 21.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Text(
                        item.label,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7A708A),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _QuickActionItem {
  final String id;
  final String label;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  const _QuickActionItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });
}
