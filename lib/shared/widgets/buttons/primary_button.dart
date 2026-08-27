import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/flow_cycle_theme_extension.dart';

/// A premium, customizable primary button with optional gradient, loading state, icon, and dynamic theme reactivity.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final double? height;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
    this.gradient,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.height = 54.0,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;
    final theme = context.flowTheme;

    final Gradient? effectiveGradient = gradient ??
        (backgroundColor == null ? theme.primaryGradient : null);
    final Color effectiveBgColor = backgroundColor ?? theme.primary;
    final Color effectiveTextColor = textColor ?? AppColors.textInverse;

    Widget buttonContent = FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
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
      ),
    );

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.55,
      child: Container(
        height: height,
        width: isFullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          color: effectiveGradient == null ? effectiveBgColor : null,
          gradient: effectiveGradient,
          borderRadius: AppRadius.pill,
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: theme.primary.withValues(alpha: 0.28),
                    blurRadius: 10.0,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
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
