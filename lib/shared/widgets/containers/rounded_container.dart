import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

/// A general-purpose container with design-system rounded corners, borders, and shadows.
class RoundedContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Border? border;
  final List<BoxShadow>? shadows;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final Clip clipBehavior;

  const RoundedContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.gradient,
    this.borderRadius,
    this.padding,
    this.margin,
    this.border,
    this.shadows,
    this.width,
    this.height,
    this.alignment,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      alignment: alignment,
      decoration: BoxDecoration(
        color: gradient == null ? (backgroundColor ?? AppColors.surface) : null,
        gradient: gradient,
        borderRadius: borderRadius ?? AppRadius.medium,
        border: border,
        boxShadow: shadows,
      ),
      clipBehavior: clipBehavior,
      child: Padding(padding: padding ?? AppSpacing.paddingMd, child: child),
    );
  }
}
