import 'package:flutter/material.dart';

/// Soft, premium, wellness-inspired elevation shadows.
abstract final class AppShadows {
  /// Subtle shadow for resting cards and soft containers.
  static const List<BoxShadow> subtle = [
    BoxShadow(
      color: Color(0x0A1E1A22), // ~4% opacity
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  /// Standard card shadow for interactive tiles and list items.
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0E1E1A22), // ~5.5% opacity
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  /// Floating element shadow for bottom bars, FABs, and active cards.
  static const List<BoxShadow> floating = [
    BoxShadow(
      color: Color(0x141E1A22), // ~8% opacity
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: -2,
    ),
  ];

  /// Prominent shadow for bottom sheets and modals.
  static const List<BoxShadow> elevated = [
    BoxShadow(
      color: Color(0x1C1E1A22), // ~11% opacity
      offset: Offset(0, 12),
      blurRadius: 36,
      spreadRadius: -4,
    ),
  ];

  /// Glowing brand accent shadow for primary action buttons.
  static const List<BoxShadow> primaryButton = [
    BoxShadow(
      color: Color(0x38E86A8D), // ~22% opacity rose
      offset: Offset(0, 6),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];
}
