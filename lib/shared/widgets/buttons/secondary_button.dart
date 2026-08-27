import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// An outlined, secondary action button with customizable border, icon, and loading states.
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Color? borderColor;
  final Color? textColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double? height;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
    this.borderColor,
    this.textColor,
    this.backgroundColor,
    this.padding,
    this.height = 54.0,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;
    final Color effectiveTextColor = textColor ?? AppColors.textPrimary;
    final Color effectiveBorderColor = borderColor ?? AppColors.border;

    Widget buttonContent = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: AppSpacing.lg,
            height: AppSpacing.lg,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
            ),
          )
        else ...[
          if (leadingIcon != null) ...[
            Icon(leadingIcon, color: effectiveTextColor, size: AppSpacing.lg),
            const SizedBox(width: AppSpacing.sm),
          ],
          Text(
            label,
            style: AppTextStyles.button.copyWith(color: effectiveTextColor),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: AppSpacing.sm),
            Icon(trailingIcon, color: effectiveTextColor, size: AppSpacing.lg),
          ],
        ],
      ],
    );

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.55,
      child: Container(
        height: height,
        width: isFullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: AppRadius.pill,
          border: Border.all(color: effectiveBorderColor, width: 1.2),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: AppRadius.pill,
            child: Padding(
              padding: padding ?? AppSpacing.horizontalLg,
              child: Center(child: buttonContent),
            ),
          ),
        ),
      ),
    );
  }
}
