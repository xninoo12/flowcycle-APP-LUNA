import 'package:flutter/material.dart';
import '../../../shared/models/app_mode.dart';

/// 2-Column Key Metrics Row for FlowCycle Dashboards.
///
/// Displays Next Period + Fertile Window in Cycle Awareness Mode,
/// or Ovulation Prediction + Best Days to Try in TTC Mode.
class DualMetricsRow extends StatelessWidget {
  final AppMode mode;
  final int daysUntilNextPeriod;
  final String nextPeriodDateText;
  final String fertileWindowText;
  final String fertilePeakText;
  final String ovulationDateText;
  final String ovulationCountdownText;
  final String bestDaysRangeText;
  final String bestDaysChanceText;
  final VoidCallback? onNextPeriodTap;
  final VoidCallback? onFertilityTap;

  const DualMetricsRow({
    super.key,
    required this.mode,
    this.daysUntilNextPeriod = 12,
    this.nextPeriodDateText = 'Jun 5, 2025',
    this.fertileWindowText = 'May 29 – Jun 3',
    this.fertilePeakText = 'High chance: May 31 – Jun 2',
    this.ovulationDateText = 'May 27',
    this.ovulationCountdownText = 'In 3 days',
    this.bestDaysRangeText = 'May 24 – May 28',
    this.bestDaysChanceText = 'High Chance',
    this.onNextPeriodTap,
    this.onFertilityTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCycle = mode == AppMode.cycleAwareness;

    return Row(
      children: [
        // Left Card
        Expanded(
          child: isCycle
              ? _buildNextPeriodCard()
              : _buildTtcOvulationCard(),
        ),

        const SizedBox(width: 12.0),

        // Right Card
        Expanded(
          child: isCycle
              ? _buildFertileWindowCard()
              : _buildTtcBestDaysCard(),
        ),
      ],
    );
  }

  Widget _buildNextPeriodCard() {
    return _buildContainer(
      onTap: onNextPeriodTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.water_drop_rounded,
                size: 14.0,
                color: Color(0xFFFF4D79),
              ),
              SizedBox(width: 4.0),
              Expanded(
                child: Text(
                  'Next Period',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7A708A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.calendar_month_rounded,
                size: 14.0,
                color: Color(0xFFFFB3C6),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  '$daysUntilNextPeriod',
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 24.0,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFFF4D79),
                    height: 1.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4.0),
              const Text(
                'days',
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF7A708A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Text(
            nextPeriodDateText,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8C829A),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFertileWindowCard() {
    return _buildContainer(
      onTap: onFertilityTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.spa_rounded,
                size: 14.0,
                color: Color(0xFF10B981),
              ),
              SizedBox(width: 4.0),
              Expanded(
                child: Text(
                  'Fertile Window',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF10B981),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            fertileWindowText,
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w800,
              color: Color(0xFF10B981),
              letterSpacing: -0.2,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4.0),
          Text(
            fertilePeakText,
            style: const TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF7A708A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTtcOvulationCard() {
    return _buildContainer(
      onTap: onFertilityTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.track_changes_rounded,
                size: 14.0,
                color: Color(0xFFE81B54),
              ),
              SizedBox(width: 4.0),
              Expanded(
                child: Text(
                  'Ovulation',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1A3C),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            ovulationDateText,
            style: const TextStyle(
              fontFamily: 'serif',
              fontSize: 22.0,
              fontWeight: FontWeight.w900,
              color: Color(0xFFE81B54),
              height: 1.0,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4.0),
          Text(
            ovulationCountdownText,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF7A708A),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTtcBestDaysCard() {
    return _buildContainer(
      onTap: onFertilityTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.favorite_rounded,
                size: 14.0,
                color: Color(0xFFE81B54),
              ),
              SizedBox(width: 4.0),
              Expanded(
                child: Text(
                  'Best Days to Try',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1A3C),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            bestDaysRangeText,
            style: const TextStyle(
              fontFamily: 'serif',
              fontSize: 15.0,
              fontWeight: FontWeight.w900,
              color: Color(0xFFE81B54),
              letterSpacing: -0.2,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4.0),
          Text(
            bestDaysChanceText,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF7A708A),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildContainer({required Widget child, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 12.0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: const Color(0xFFF3E8EE),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E1A3C).withValues(alpha: 0.03),
                blurRadius: 10.0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
