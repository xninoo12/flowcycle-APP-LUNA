import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';

/// Basal Body Temperature (BBT) stepper field for TTC mode.
class BbtTemperatureField extends StatelessWidget {
  final double? temperature;
  final ValueChanged<double?> onTemperatureChanged;

  const BbtTemperatureField({
    super.key,
    required this.temperature,
    required this.onTemperatureChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currentTemp = temperature ?? 97.8;
    final isShift = currentTemp >= 98.2;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.medium,
        border: Border.all(color: const Color(0xFFEFE9F3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Text('🌡️', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Basal Body Temperature (BBT)',
                        style: AppTextStyles.subtitle.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 12.5,
                          color: const Color(0xFF1E1A3C),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isShift
                      ? const Color(0xFFFEF3C7)
                      : const Color(0xFFEBF3FC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isShift ? 'Thermal Shift ☀️' : 'Baseline Follicular',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isShift
                        ? const Color(0xFFD97706)
                        : const Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Minus 0.1
              IconButton(
                icon: const Icon(
                  Icons.remove_circle_outline_rounded,
                  color: Color(0xFF7C5CE7),
                  size: 28,
                ),
                onPressed: () {
                  final newTemp = (currentTemp - 0.1);
                  onTemperatureChanged(
                    double.parse(newTemp.toStringAsFixed(1)),
                  );
                },
              ),
              const SizedBox(width: 12),
              // Temperature Value Display
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF8FC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5DBFF)),
                ),
                child: Text(
                  '${currentTemp.toStringAsFixed(1)} °F',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1A3C),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Plus 0.1
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline_rounded,
                  color: Color(0xFF7C5CE7),
                  size: 28,
                ),
                onPressed: () {
                  final newTemp = (currentTemp + 0.1);
                  onTemperatureChanged(
                    double.parse(newTemp.toStringAsFixed(1)),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
