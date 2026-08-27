import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';

/// A circular or rounded icon button with optional shadow and subtle background.
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final Color? backgroundColor;
  final double size;
  final double iconSize;
  final bool hasShadow;
  final Border? border;
  final String? tooltip;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconColor,
    this.backgroundColor,
    this.size = 44.0,
    this.iconSize = 22.0,
    this.hasShadow = false,
    this.border,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final Widget button = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        shape: BoxShape.circle,
        border: border ?? Border.all(color: AppColors.border, width: 0.8),
        boxShadow: hasShadow ? AppShadows.subtle : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Center(
            child: Icon(
              icon,
              size: iconSize,
              color: iconColor ?? AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}
