import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';

/// A standard surface card with subtle border and wellness elevation shadow.
class PrimaryCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? shadows;
  final Border? border;

  const PrimaryCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.borderRadius,
    this.shadows,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius effectiveRadius = borderRadius ?? AppRadius.medium;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: effectiveRadius,
        border: border ?? Border.all(color: AppColors.border, width: 0.8),
        boxShadow: shadows ?? AppShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveRadius,
          child: Padding(
            padding: padding ?? AppSpacing.paddingMd,
            child: child,
          ),
        ),
      ),
    );
  }
}
