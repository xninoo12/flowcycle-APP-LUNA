import 'package:flutter/material.dart';

/// Design tokens and aesthetic flourishing attributes for a FlowCycle appearance theme.
@immutable
class FlowCycleThemeExtension extends ThemeExtension<FlowCycleThemeExtension> {
  final String id;
  final String name;
  final String emoji;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color scaffoldBackground;
  final Color cardBackground;
  final Color cardBorder;
  final Color containerLight;
  final Color textPrimary;
  final Color textSecondary;
  final Color chipBackground;
  final Color chipBorder;
  final LinearGradient primaryGradient;
  final LinearGradient secondaryGradient;
  final LinearGradient heroGradient;
  final Color auraGlow;
  final bool isDark;

  const FlowCycleThemeExtension({
    required this.id,
    required this.name,
    required this.emoji,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.scaffoldBackground,
    required this.cardBackground,
    required this.cardBorder,
    required this.containerLight,
    required this.textPrimary,
    required this.textSecondary,
    required this.chipBackground,
    required this.chipBorder,
    required this.primaryGradient,
    required this.secondaryGradient,
    required this.heroGradient,
    required this.auraGlow,
    required this.isDark,
  });

  @override
  FlowCycleThemeExtension copyWith({
    String? id,
    String? name,
    String? emoji,
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? scaffoldBackground,
    Color? cardBackground,
    Color? cardBorder,
    Color? containerLight,
    Color? textPrimary,
    Color? textSecondary,
    Color? chipBackground,
    Color? chipBorder,
    LinearGradient? primaryGradient,
    LinearGradient? secondaryGradient,
    LinearGradient? heroGradient,
    Color? auraGlow,
    bool? isDark,
  }) {
    return FlowCycleThemeExtension(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBorder: cardBorder ?? this.cardBorder,
      containerLight: containerLight ?? this.containerLight,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      chipBackground: chipBackground ?? this.chipBackground,
      chipBorder: chipBorder ?? this.chipBorder,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      secondaryGradient: secondaryGradient ?? this.secondaryGradient,
      heroGradient: heroGradient ?? this.heroGradient,
      auraGlow: auraGlow ?? this.auraGlow,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  FlowCycleThemeExtension lerp(
    ThemeExtension<FlowCycleThemeExtension>? other,
    double t,
  ) {
    if (other is! FlowCycleThemeExtension) return this;
    return FlowCycleThemeExtension(
      id: t < 0.5 ? id : other.id,
      name: t < 0.5 ? name : other.name,
      emoji: t < 0.5 ? emoji : other.emoji,
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      secondary: Color.lerp(secondary, other.secondary, t) ?? secondary,
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      scaffoldBackground:
          Color.lerp(scaffoldBackground, other.scaffoldBackground, t) ??
              scaffoldBackground,
      cardBackground:
          Color.lerp(cardBackground, other.cardBackground, t) ?? cardBackground,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t) ?? cardBorder,
      containerLight:
          Color.lerp(containerLight, other.containerLight, t) ?? containerLight,
      textPrimary:
          Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
      textSecondary:
          Color.lerp(textSecondary, other.textSecondary, t) ?? textSecondary,
      chipBackground:
          Color.lerp(chipBackground, other.chipBackground, t) ?? chipBackground,
      chipBorder: Color.lerp(chipBorder, other.chipBorder, t) ?? chipBorder,
      primaryGradient: LinearGradient.lerp(
            primaryGradient,
            other.primaryGradient,
            t,
          ) ??
          primaryGradient,
      secondaryGradient: LinearGradient.lerp(
            secondaryGradient,
            other.secondaryGradient,
            t,
          ) ??
          secondaryGradient,
      heroGradient: LinearGradient.lerp(
            heroGradient,
            other.heroGradient,
            t,
          ) ??
          heroGradient,
      auraGlow: Color.lerp(auraGlow, other.auraGlow, t) ?? auraGlow,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}

/// Convenient extension on BuildContext to access the active FlowCycle theme.
extension FlowCycleThemeContext on BuildContext {
  FlowCycleThemeExtension get flowTheme =>
      Theme.of(this).extension<FlowCycleThemeExtension>() ??
      const FlowCycleThemeExtension(
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
}
