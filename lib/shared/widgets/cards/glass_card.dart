import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';

/// A frosted glassmorphism card with background blur and soft translucent sheen.
class GlassCard extends StatelessWidget {
  final Widget child;
  final double blurSigma;
  final Color? tintColor;
  final double opacity;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Border? border;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.blurSigma = 12.0,
    this.tintColor,
    this.opacity = 0.65,
    this.padding,
    this.margin,
    this.borderRadius,
    this.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius effectiveRadius = borderRadius ?? AppRadius.large;
    final Color effectiveTint = (tintColor ?? Colors.white).withValues(
      alpha: opacity,
    );

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: effectiveRadius,
        boxShadow: AppShadows.subtle,
      ),
      child: ClipRRect(
        borderRadius: effectiveRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            decoration: BoxDecoration(
              color: effectiveTint,
              borderRadius: effectiveRadius,
              border:
                  border ??
                  Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1.0,
                  ),
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
          ),
        ),
      ),
    );
  }
}
