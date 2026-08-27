import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// A lightweight, clickable text button for inline actions and links.
class AppTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final Color? color;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final EdgeInsetsGeometry? padding;

  const AppTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.textStyle,
    this.color,
    this.leadingIcon,
    this.trailingIcon,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveColor = color ?? AppColors.primaryRose;
    final TextStyle effectiveStyle = (textStyle ?? AppTextStyles.subtitle)
        .copyWith(color: effectiveColor, fontWeight: FontWeight.w600);

    return InkWell(
      onTap: onPressed,
      borderRadius: AppRadius.small,
      child: Padding(
        padding:
            padding ??
            const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, color: effectiveColor, size: AppSpacing.md),
              const SizedBox(width: AppSpacing.xs),
            ],
            Flexible(
              child: Text(
                label,
                style: effectiveStyle,
                textAlign: TextAlign.center,
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: AppSpacing.xs),
              Icon(trailingIcon, color: effectiveColor, size: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }
}
