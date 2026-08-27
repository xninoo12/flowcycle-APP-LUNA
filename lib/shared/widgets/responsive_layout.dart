import 'package:flutter/material.dart';

/// Responsive layout container ensuring mobile-first UI components are gracefully
/// constrained and centered on tablets, foldable inner displays, and wide monitors.
class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const ResponsiveLayout({
    super.key,
    required this.child,
    this.maxWidth = 600.0,
    this.backgroundColor,
    this.padding,
  });

  /// Check if the current display width qualifies as a compact screen (< 360dp)
  static bool isCompact(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 360.0;
  }

  /// Check if the current display width qualifies as a tablet or foldable (> 600dp)
  static bool isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= 600.0;
  }

  /// Check if the current display qualifies as a large tablet/desktop (> 900dp)
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= 900.0;
  }

  /// Responsive horizontal page padding based on screen class
  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 360.0) return 12.0;
    if (width >= 600.0) return 24.0;
    return 16.0;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          color: backgroundColor,
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
