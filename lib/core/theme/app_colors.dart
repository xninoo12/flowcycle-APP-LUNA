import 'package:flutter/material.dart';

/// Semantic and core color palette for the FlowCycle application.
///
/// Designed to evoke a calm, elegant, modern, and premium wellness experience.
abstract final class AppColors {
  // Brand & Primary Accents
  static const Color primary = Color(0xFFE84D75);
  static const Color primaryRose = Color(0xFFE86A8D);
  static const Color primaryRoseLight = Color(0xFFFFEBF0);
  static const Color primaryRoseDark = Color(0xFFC74C70);

  // Calming Pastels
  static const Color softLavender = Color(0xFFB497D6);
  static const Color softLavenderLight = Color(0xFFF3EDFA);

  static const Color peach = Color(0xFFFFAA8A);
  static const Color peachLight = Color(0xFFFFEFE7);

  static const Color mintGreen = Color(0xFF7DD3B6);
  static const Color mintGreenLight = Color(0xFFE5F8F1);

  static const Color skyBlue = Color(0xFF78B7E8);
  static const Color skyBlueLight = Color(0xFFE8F4FD);

  // Background & Surface
  static const Color background = Color(0xFFFAF7F2); // Warm Cream
  static const Color backgroundSecondary = Color(0xFFF4EFEA);
  static const Color surface = Color(0xFFFFFFFF); // Pure White
  static const Color surfaceSecondary = Color(0xFFF9F9FB);

  // Greys & Borders
  static const Color lightGrey = Color(0xFFEDEDF2);
  static const Color border = Color(0xFFE5E5EB);
  static const Color divider = Color(0xFFEBEBF0);

  // Typography & Content
  static const Color textPrimary = Color(0xFF1E1A22); // Dark Text
  static const Color textSecondary = Color(0xFF726C78); // Secondary Muted
  static const Color textTertiary = Color(0xFFA59FA9); // Subdued / Placeholder
  static const Color textInverse = Color(0xFFFFFFFF);

  // Functional & Feedback
  static const Color success = Color(0xFF48BB78);
  static const Color warning = Color(0xFFED8936);
  static const Color error = Color(0xFFE53E3E);
  static const Color info = Color(0xFF4299E1);

  // Dedicated Cycle Phase Colors
  static const Color menstrualPhase = Color(0xFFE5536D); // Crimson Rose
  static const Color follicularPhase = Color(0xFFF59E7C); // Soft Coral
  static const Color fertileWindow = Color(0xFF3EBFB5); // Fresh Turquoise
  static const Color ovulation = Color(0xFF8E6CE6); // Vibrant Lilac
  static const Color lutealPhase = Color(0xFFEAA63B); // Warm Amber
}
