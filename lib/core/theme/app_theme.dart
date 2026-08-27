import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';
import 'flow_cycle_theme_extension.dart';

export 'flow_cycle_theme_extension.dart';

/// Centralized ThemeData configuration with multi-theme support (Rosé Bloom, Lavender Dream, Emerald Mint, Sunset Amber, Midnight Indigo).
abstract final class AppTheme {
  // Preset Theme Extensions
  static const FlowCycleThemeExtension roseBloomExtension =
      FlowCycleThemeExtension(
    id: 'pink',
    name: 'Rosé Bloom',
    emoji: '🌸',
    primary: Color(0xFFFF4D79),
    secondary: Color(0xFFFFA07A),
    accent: Color(0xFFFF4D6D),
    scaffoldBackground: Color(0xFFFAF7F2),
    cardBackground: Colors.white,
    cardBorder: Color(0xFFF1ECF5),
    containerLight: Color(0xFFFFF0F5),
    textPrimary: Color(0xFF1E1A3C),
    textSecondary: Color(0xFF7A708A),
    chipBackground: Color(0xFFFFF0F5),
    chipBorder: Color(0xFFFFD6E2),
    primaryGradient: LinearGradient(
      colors: [Color(0xFFFF6B8B), Color(0xFFFFA07A)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    secondaryGradient: LinearGradient(
      colors: [Color(0xFFFF85A1), Color(0xFFFFB4A2)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    heroGradient: LinearGradient(
      colors: [Color(0xFFFFEEF3), Color(0xFFFFF7F2)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    auraGlow: Color(0xFFFF6B8B),
    isDark: false,
  );

  static const FlowCycleThemeExtension lavenderDreamExtension =
      FlowCycleThemeExtension(
    id: 'purple',
    name: 'Lavender Dream',
    emoji: '💜',
    primary: Color(0xFF8B5CF6),
    secondary: Color(0xFFC084FC),
    accent: Color(0xFFA855F7),
    scaffoldBackground: Color(0xFFFAF7FD),
    cardBackground: Colors.white,
    cardBorder: Color(0xFFEDE9FE),
    containerLight: Color(0xFFF3E8FF),
    textPrimary: Color(0xFF1E1A3C),
    textSecondary: Color(0xFF7A708A),
    chipBackground: Color(0xFFF3E8FF),
    chipBorder: Color(0xFFE9D5FF),
    primaryGradient: LinearGradient(
      colors: [Color(0xFF8B5CF6), Color(0xFFC084FC)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    secondaryGradient: LinearGradient(
      colors: [Color(0xFF9333EA), Color(0xFFA855F7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    heroGradient: LinearGradient(
      colors: [Color(0xFFF3E8FF), Color(0xFFFAF5FF)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    auraGlow: Color(0xFF8B5CF6),
    isDark: false,
  );

  static const FlowCycleThemeExtension emeraldMintExtension =
      FlowCycleThemeExtension(
    id: 'mint',
    name: 'Emerald Mint',
    emoji: '🍃',
    primary: Color(0xFF10B981),
    secondary: Color(0xFF6EE7B7),
    accent: Color(0xFF059669),
    scaffoldBackground: Color(0xFFF4FAF7),
    cardBackground: Colors.white,
    cardBorder: Color(0xFFD1FAE5),
    containerLight: Color(0xFFE6F8F0),
    textPrimary: Color(0xFF1E1A3C),
    textSecondary: Color(0xFF7A708A),
    chipBackground: Color(0xFFE6F8F0),
    chipBorder: Color(0xFFA7F3D0),
    primaryGradient: LinearGradient(
      colors: [Color(0xFF10B981), Color(0xFF6EE7B7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    secondaryGradient: LinearGradient(
      colors: [Color(0xFF059669), Color(0xFF34D399)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    heroGradient: LinearGradient(
      colors: [Color(0xFFE6F8F0), Color(0xFFF0FDF4)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    auraGlow: Color(0xFF10B981),
    isDark: false,
  );

  static const FlowCycleThemeExtension sunsetAmberExtension =
      FlowCycleThemeExtension(
    id: 'amber',
    name: 'Sunset Amber',
    emoji: '✨',
    primary: Color(0xFFF59E0B),
    secondary: Color(0xFFFCD34D),
    accent: Color(0xFFD97706),
    scaffoldBackground: Color(0xFFFDFBF7),
    cardBackground: Colors.white,
    cardBorder: Color(0xFFFEF3C7),
    containerLight: Color(0xFFFEF9EE),
    textPrimary: Color(0xFF1E1A3C),
    textSecondary: Color(0xFF7A708A),
    chipBackground: Color(0xFFFEF3C7),
    chipBorder: Color(0xFFFDE68A),
    primaryGradient: LinearGradient(
      colors: [Color(0xFFF59E0B), Color(0xFFFCD34D)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    secondaryGradient: LinearGradient(
      colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    heroGradient: LinearGradient(
      colors: [Color(0xFFFEF3C7), Color(0xFFFFFBEB)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    auraGlow: Color(0xFFF59E0B),
    isDark: false,
  );

  static const FlowCycleThemeExtension midnightIndigoExtension =
      FlowCycleThemeExtension(
    id: 'navy',
    name: 'Midnight Indigo',
    emoji: '🌙',
    primary: Color(0xFF818CF8),
    secondary: Color(0xFFC084FC),
    accent: Color(0xFF6366F1),
    scaffoldBackground: Color(0xFF0F172A),
    cardBackground: Color(0xFF1E293B),
    cardBorder: Color(0xFF334155),
    containerLight: Color(0xFF1E293B),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFF94A3B8),
    chipBackground: Color(0xFF1E293B),
    chipBorder: Color(0xFF334155),
    primaryGradient: LinearGradient(
      colors: [Color(0xFF4F46E5), Color(0xFF818CF8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    secondaryGradient: LinearGradient(
      colors: [Color(0xFF3730A3), Color(0xFF6366F1)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    heroGradient: LinearGradient(
      colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    auraGlow: Color(0xFF818CF8),
    isDark: true,
  );

  static FlowCycleThemeExtension getThemeExtensionById(String themeId) {
    switch (themeId.toLowerCase()) {
      case 'purple':
      case 'lavender':
        return lavenderDreamExtension;
      case 'mint':
      case 'green':
        return emeraldMintExtension;
      case 'amber':
      case 'sunset':
        return sunsetAmberExtension;
      case 'navy':
      case 'dark':
      case 'midnight':
        return midnightIndigoExtension;
      case 'pink':
      case 'rose':
      default:
        return roseBloomExtension;
    }
  }

  static ThemeData getThemeById(String themeId) {
    final extension = getThemeExtensionById(themeId);
    if (extension.isDark) {
      return _buildDarkTheme(extension);
    }
    return _buildLightTheme(extension);
  }

  static ThemeData get lightTheme => _buildLightTheme(roseBloomExtension);
  static ThemeData get darkTheme => _buildDarkTheme(midnightIndigoExtension);

  static ThemeData _buildLightTheme(FlowCycleThemeExtension ext) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: ext.scaffoldBackground,
      extensions: [ext],
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: ext.primary,
        onPrimary: Colors.white,
        primaryContainer: ext.containerLight,
        onPrimaryContainer: ext.primary,
        secondary: ext.secondary,
        onSecondary: Colors.white,
        secondaryContainer: ext.chipBackground,
        onSecondaryContainer: ext.textPrimary,
        tertiary: AppColors.peach,
        onTertiary: Colors.white,
        tertiaryContainer: AppColors.peachLight,
        onTertiaryContainer: ext.textPrimary,
        error: AppColors.error,
        onError: Colors.white,
        surface: ext.cardBackground,
        onSurface: ext.textPrimary,
        surfaceContainerHighest: ext.containerLight,
        outline: ext.cardBorder,
        outlineVariant: AppColors.divider,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.display,
        headlineLarge: AppTextStyles.heading1,
        headlineMedium: AppTextStyles.heading2,
        headlineSmall: AppTextStyles.heading3,
        titleLarge: AppTextStyles.title,
        titleMedium: AppTextStyles.subtitle,
        titleSmall: AppTextStyles.subtitle,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.body,
        bodySmall: AppTextStyles.caption,
        labelLarge: AppTextStyles.button,
        labelSmall: AppTextStyles.caption,
      ).apply(
        bodyColor: ext.textPrimary,
        displayColor: ext.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: ext.textPrimary),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      cardTheme: CardThemeData(
        color: ext.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ext.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          elevation: 0,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: ext.cardBorder,
        thickness: 1,
      ),
    );
  }

  static ThemeData _buildDarkTheme(FlowCycleThemeExtension ext) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: ext.scaffoldBackground,
      extensions: [ext],
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: ext.primary,
        onPrimary: Colors.black,
        primaryContainer: ext.containerLight,
        onPrimaryContainer: ext.primary,
        secondary: ext.secondary,
        onSecondary: Colors.black,
        secondaryContainer: const Color(0xFF1C3A32),
        onSecondaryContainer: Colors.white,
        tertiary: AppColors.peach,
        onTertiary: Colors.black,
        tertiaryContainer: const Color(0xFF3D2A22),
        onTertiaryContainer: Colors.white,
        error: const Color(0xFFFF6B6B),
        onError: Colors.black,
        surface: ext.cardBackground,
        onSurface: ext.textPrimary,
        surfaceContainerHighest: ext.containerLight,
        outline: ext.cardBorder,
        outlineVariant: const Color(0xFF252E49),
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.display,
        headlineLarge: AppTextStyles.heading1,
        headlineMedium: AppTextStyles.heading2,
        headlineSmall: AppTextStyles.heading3,
        titleLarge: AppTextStyles.title,
        titleMedium: AppTextStyles.subtitle,
        titleSmall: AppTextStyles.subtitle,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.body,
        bodySmall: AppTextStyles.caption,
        labelLarge: AppTextStyles.button,
        labelSmall: AppTextStyles.caption,
      ).apply(
        bodyColor: ext.textPrimary,
        displayColor: ext.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: ext.textPrimary),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: Color(0xFF0F172A),
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
      cardTheme: CardThemeData(
        color: ext.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
      ),
      dividerTheme: DividerThemeData(
        color: ext.cardBorder,
        thickness: 1,
      ),
    );
  }
}
