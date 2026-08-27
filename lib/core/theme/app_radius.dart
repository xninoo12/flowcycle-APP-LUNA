import 'package:flutter/material.dart';

/// Border radius tokens for FlowCycle.
abstract final class AppRadius {
  // Raw numeric values
  static const double smallValue = 8.0;
  static const double mediumValue = 16.0;
  static const double largeValue = 24.0;
  static const double extraLargeValue = 32.0;
  static const double pillValue = 999.0;
  static const double circularValue = 9999.0;

  // Radius geometries
  static const Radius smallRadius = Radius.circular(smallValue);
  static const Radius mediumRadius = Radius.circular(mediumValue);
  static const Radius largeRadius = Radius.circular(largeValue);
  static const Radius extraLargeRadius = Radius.circular(extraLargeValue);
  static const Radius pillRadius = Radius.circular(pillValue);
  static const Radius circularRadius = Radius.circular(circularValue);

  // Ready-to-use BorderRadius constants
  static const BorderRadius small = BorderRadius.all(smallRadius);
  static const BorderRadius medium = BorderRadius.all(mediumRadius);
  static const BorderRadius large = BorderRadius.all(largeRadius);
  static const BorderRadius extraLarge = BorderRadius.all(extraLargeRadius);
  static const BorderRadius pill = BorderRadius.all(pillRadius);
  static const BorderRadius circular = BorderRadius.all(circularRadius);
}
