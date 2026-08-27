import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_theme.dart';

/// Reusable gradient styles for FlowCycle with dynamic theme reactivity.
abstract final class AppGradients {
  /// Reactive Primary Gradient based on the active theme
  static LinearGradient primary(BuildContext context) {
    return context.flowTheme.primaryGradient;
  }

  /// Reactive Secondary Gradient based on the active theme
  static LinearGradient secondary(BuildContext context) {
    return context.flowTheme.secondaryGradient;
  }

  /// Reactive Hero Gradient based on the active theme
  static LinearGradient hero(BuildContext context) {
    return context.flowTheme.heroGradient;
  }

  /// Explicit Gradient for a given Theme ID
  static LinearGradient forTheme(String themeId) {
    return AppTheme.getThemeExtensionById(themeId).primaryGradient;
  }

  /// Dawn Bloom (Pink → Peach) - Preserved for static compatibility
  static const LinearGradient dawnBloom = LinearGradient(
    colors: [Color(0xFFFF6B8B), Color(0xFFFFA07A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Lavender Sky (Lavender → Pink)
  static const LinearGradient lavenderSky = LinearGradient(
    colors: [AppColors.softLavender, AppColors.primaryRoseLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Mint Breeze (Mint → Sky Blue)
  static const LinearGradient mintBreeze = LinearGradient(
    colors: [AppColors.mintGreen, AppColors.skyBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Sunset Glow (Peach → Rose)
  static const LinearGradient sunsetGlow = LinearGradient(
    colors: [AppColors.peach, AppColors.primaryRose],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Fertility Glow (Mint → Soft Teal)
  static const LinearGradient fertilityGlow = LinearGradient(
    colors: [AppColors.mintGreen, AppColors.fertileWindow],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Premium Gold (Subtle Champagne)
  static const LinearGradient premiumGold = LinearGradient(
    colors: [Color(0xFFFBE4C8), Color(0xFFE8C88B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
