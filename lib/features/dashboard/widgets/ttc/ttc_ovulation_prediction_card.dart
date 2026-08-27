import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Ovulation Prediction card with biological visualization for TTC Dashboard.
class TtcOvulationPredictionCard extends StatelessWidget {
  final int daysUntilOvulation;
  final String predictedDateText;
  final VoidCallback? onInfoTap;

  const TtcOvulationPredictionCard({
    super.key,
    this.daysUntilOvulation = 1,
    this.predictedDateText = 'May 27',
    this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.large,
        border: Border.all(color: const Color(0xFFEFE9F3), width: 1.0),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(AppSpacing.sm + 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header: Title + Info Icon
          Row(
            children: [
              Flexible(
                child: Text(
                  'Ovulation prediction',
                  style: AppTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.0,
                    color: const Color(0xFF1E1A3C),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4.0),
              GestureDetector(
                onTap: onInfoTap,
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFF8C7C92),
                  size: 14.0,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // 2. Metrics & 3D Egg Cell Visualizer Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Days Countdown + Predicted Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$daysUntilOvulation day',
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1A3C),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 1.0),
                    Text(
                      'until ovulation',
                      style: AppTextStyles.caption.copyWith(
                        color: const Color(0xFF7A708A),
                        fontSize: 10.5,
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      predictedDateText,
                      style: AppTextStyles.caption.copyWith(
                        color: const Color(0xFFE84D75),
                        fontWeight: FontWeight.w800,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 4.0),

              // Right: 3D Egg Cell Ovulation Graphic
              _buildEggCellIllustration(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEggCellIllustration() {
    return Container(
      width: 52.0,
      height: 52.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFFFF85A1),
            const Color(0xFFFFBCC9),
            const Color(0xFFFFEEF3).withValues(alpha: 0.2),
          ],
          stops: const [0.3, 0.7, 1.0],
        ),
      ),
      child: Center(
        child: Container(
          width: 28.0,
          height: 28.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFF4E7E),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF4E7E).withValues(alpha: 0.35),
                blurRadius: 8.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.blur_on_rounded, color: Colors.white, size: 18.0),
          ),
        ),
      ),
    );
  }
}
