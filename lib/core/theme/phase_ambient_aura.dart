import 'package:flutter/material.dart';
import '../../features/dashboard/models/cycle_dashboard_state.dart';

/// Design tokens and gradient aura definitions tailored for each biological cycle phase.
class PhaseAmbientAura {
  static List<Color> getAuraColors(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return const [
          Color(0xFFFF5277),
          Color(0xFFFF758C),
          Color(0xFFFF7EB3),
        ];
      case CyclePhase.follicular:
        return const [
          Color(0xFF06D6A0),
          Color(0xFF118AB2),
          Color(0xFF48CAE4),
        ];
      case CyclePhase.ovulation:
        return const [
          Color(0xFF8B5CF6),
          Color(0xFFD946EF),
          Color(0xFFEC4899),
        ];
      case CyclePhase.luteal:
        return const [
          Color(0xFFF59E0B),
          Color(0xFFFF9F1C),
          Color(0xFFFF6B6B),
        ];
    }
  }

  static Color getPrimaryAuraColor(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return const Color(0xFFFF5277);
      case CyclePhase.follicular:
        return const Color(0xFF06D6A0);
      case CyclePhase.ovulation:
        return const Color(0xFF8B5CF6);
      case CyclePhase.luteal:
        return const Color(0xFFF59E0B);
    }
  }

  static LinearGradient getPhaseHeaderGradient(CyclePhase phase) {
    final colors = getAuraColors(phase);
    return LinearGradient(
      colors: [
        colors[0].withValues(alpha: 0.14),
        colors[1].withValues(alpha: 0.06),
        Colors.transparent,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }
}
