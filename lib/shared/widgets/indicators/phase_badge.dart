import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Enum representing the standard physiological cycle phases.
enum CyclePhase { menstrual, follicular, fertileWindow, ovulation, luteal }

/// A badge for presenting cycle phases with dedicated thematic colors and labels.
class PhaseBadge extends StatelessWidget {
  final CyclePhase phase;
  final String? customLabel;
  final int? cycleDay;
  final bool isCompact;

  const PhaseBadge({
    super.key,
    required this.phase,
    this.customLabel,
    this.cycleDay,
    this.isCompact = false,
  });

  Color get _phaseColor {
    switch (phase) {
      case CyclePhase.menstrual:
        return AppColors.menstrualPhase;
      case CyclePhase.follicular:
        return AppColors.follicularPhase;
      case CyclePhase.fertileWindow:
        return AppColors.fertileWindow;
      case CyclePhase.ovulation:
        return AppColors.ovulation;
      case CyclePhase.luteal:
        return AppColors.lutealPhase;
    }
  }

  String get _defaultLabel {
    switch (phase) {
      case CyclePhase.menstrual:
        return 'Menstrual Phase';
      case CyclePhase.follicular:
        return 'Follicular Phase';
      case CyclePhase.fertileWindow:
        return 'Fertile Window';
      case CyclePhase.ovulation:
        return 'Ovulation';
      case CyclePhase.luteal:
        return 'Luteal Phase';
    }
  }

  IconData get _phaseIcon {
    switch (phase) {
      case CyclePhase.menstrual:
        return Icons.water_drop;
      case CyclePhase.follicular:
        return Icons.spa;
      case CyclePhase.fertileWindow:
        return Icons.favorite;
      case CyclePhase.ovulation:
        return Icons.wb_sunny;
      case CyclePhase.luteal:
        return Icons.bedtime;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color color = _phaseColor;
    final String label = customLabel ?? _defaultLabel;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? AppSpacing.sm : AppSpacing.md,
        vertical: isCompact ? AppSpacing.xs : AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: AppRadius.pill,
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_phaseIcon, color: color, size: isCompact ? 14.0 : 16.0),
          const SizedBox(width: AppSpacing.xs + 2.0),
          Text(
            label,
            style: (isCompact ? AppTextStyles.caption : AppTextStyles.subtitle)
                .copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: isCompact ? 12.0 : 13.0,
                ),
          ),
          if (cycleDay != null) ...[
            const SizedBox(width: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs + 2.0,
                vertical: 1.0,
              ),
              decoration: BoxDecoration(
                color: color,
                borderRadius: AppRadius.pill,
              ),
              child: Text(
                'Day $cycleDay',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textInverse,
                  fontWeight: FontWeight.w700,
                  fontSize: 10.0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
