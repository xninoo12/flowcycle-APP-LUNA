import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// A compact pill chip for displaying statuses, tags, and category labels.
class StatusChip extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final bool showDot;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const StatusChip({
    super.key,
    required this.label,
    this.color,
    this.textColor,
    this.icon,
    this.showDot = false,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveColor = color ?? AppColors.primaryRose;
    final Color effectiveTextColor = textColor ?? effectiveColor;

    Widget chipContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showDot) ...[
          Container(
            width: 6.0,
            height: 6.0,
            decoration: BoxDecoration(
              color: effectiveColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.xs + 2.0),
        ] else if (icon != null) ...[
          Icon(icon, size: 14.0, color: effectiveTextColor),
          const SizedBox(width: AppSpacing.xs),
        ],
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: effectiveTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.pill,
        child: Container(
          padding:
              padding ??
              const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm + 2.0,
                vertical: AppSpacing.xs,
              ),
          decoration: BoxDecoration(
            color: effectiveColor.withValues(alpha: 0.12),
            borderRadius: AppRadius.pill,
            border: Border.all(
              color: effectiveColor.withValues(alpha: 0.25),
              width: 0.8,
            ),
          ),
          child: chipContent,
        ),
      ),
    );
  }
}
