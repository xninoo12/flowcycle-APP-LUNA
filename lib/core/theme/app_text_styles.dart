import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Standard typography tokens for FlowCycle.
///
/// Designed with balanced line heights, letter spacing, and weights for wellness UI.
abstract final class AppTextStyles {
  static const TextStyle display = TextStyle(
    fontSize: 34.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading1 = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  static const TextStyle title = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.0,
    height: 1.45,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.2,
    color: AppColors.textInverse,
  );
}
