import 'package:flutter/material.dart';
import '../../../shared/models/app_mode.dart';

/// Celebratory algorithm calibration card matching the FlowCycle reference UI.
///
/// Features distinct icon badges with overlay checkmarks, clinical metrics,
/// active mode banner, and harmonious lilac/rose styling.
class OnboardingAlgorithmCalibrationCard extends StatelessWidget {
  final AppMode mode;
  final int cycleLength;
  final int periodDuration;

  const OnboardingAlgorithmCalibrationCard({
    super.key,
    required this.mode,
    required this.cycleLength,
    required this.periodDuration,
  });

  @override
  Widget build(BuildContext context) {
    final isTtc = mode == AppMode.tryingToConceive;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 22.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: const Color(0xFFF3E8EE),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1A3C).withValues(alpha: 0.04),
            blurRadius: 18.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header: ALGORITHM CALIBRATION + Complete Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ALGORITHM CALIBRATION',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF6B46C1),
                  letterSpacing: 1.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: const Color(0xFFA7F3D0),
                    width: 1.0,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF059669),
                      size: 13.0,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      'Complete',
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF059669),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20.0),

          // 2. Calibration Items
          _buildItem(
            icon: Icons.show_chart_rounded,
            title: 'Baseline Cycle Metrics',
            subtitle: '$cycleLength-day cycle • $periodDuration-day period',
          ),
          const SizedBox(height: 16.0),
          _buildItem(
            icon: Icons.water_drop_rounded,
            title: isTtc
                ? 'Conception & Ovulation Gauge'
                : '4-Phase Hormonal Mapping',
            subtitle: isTtc
                ? 'Fertile window calibrated with ovulation peak'
                : 'Follicular & luteal hormonal curves initialized',
          ),
          const SizedBox(height: 16.0),
          _buildItem(
            icon: Icons.auto_awesome_rounded,
            title: 'AI Companion & Insights',
            subtitle: isTtc
                ? 'Conception timing recommendations primed'
                : 'Cycle-synced lifestyle guidance primed',
          ),

          const SizedBox(height: 20.0),

          // 3. Active Mode Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              color: isTtc ? const Color(0xFFFFF0F5) : const Color(0xFFF3EDFA),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: isTtc
                    ? const Color(0xFFFFD1DC)
                    : const Color(0xFFE9D5FF),
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Text(
                  isTtc ? '💗' : '🌸',
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isTtc
                            ? 'Trying to Conceive Mode Active'
                            : 'Cycle Awareness Mode Active',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: isTtc
                              ? const Color(0xFFFF4D79)
                              : const Color(0xFF6B46C1),
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      const Text(
                        'You can change this anytime in settings.',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF7A708A),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 14.0,
                  color: isTtc
                      ? const Color(0xFFFF8DA1)
                      : const Color(0xFFB794F4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Double-layered Icon + Checkmark Badge
        SizedBox(
          width: 42.0,
          height: 42.0,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEEF3),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFFD1DC),
                    width: 1.0,
                  ),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: const Color(0xFFFF4D79),
                    size: 20.0,
                  ),
                ),
              ),
              Positioned(
                top: -2,
                left: -2,
                child: Container(
                  width: 16.0,
                  height: 16.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 1.5,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check,
                      size: 10.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 14.0),

        // Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1A3C),
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7A708A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
