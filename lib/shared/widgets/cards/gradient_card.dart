import 'package:flutter/material.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';

/// A card with a vibrant or calming gradient background for highlight cards.
class GradientCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? shadows;

  const GradientCard({
    super.key,
    required this.child,
    this.gradient,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius effectiveRadius = borderRadius ?? AppRadius.large;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient ?? AppGradients.dawnBloom,
        borderRadius: effectiveRadius,
        boxShadow: shadows ?? AppShadows.floating,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveRadius,
          child: Padding(
            padding: padding ?? AppSpacing.paddingLg,
            child: child,
          ),
        ),
      ),
    );
  }
}
