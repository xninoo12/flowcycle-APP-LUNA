import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/pattern_models.dart';

class SymptomCorrelationCard extends StatelessWidget {
  final List<SymptomPhaseCorrelation> correlations;

  const SymptomCorrelationCard({super.key, required this.correlations});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.large,
        border: Border.all(color: const Color(0xFFF0EBF5), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C5CE7).withValues(alpha: 0.05),
            blurRadius: 14.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8FF),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Icon(
                        Icons.hub_rounded,
                        color: Color(0xFF7C5CE7),
                        size: 20.0,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Flexible(
                      child: Text(
                        'Symptom Correlation Matrix',
                        style: AppTextStyles.subtitle.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 15.0,
                          color: const Color(0xFF1E1A3C),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F5FB),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Text(
                  'Phase Linked',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7C5CE7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14.0),
          Text(
            'How your logged symptoms naturally cluster across your cycle phases over time:',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16.0),

          // Correlation items
          ...correlations.map((corr) => _buildCorrelationItem(corr)),

          const SizedBox(height: 12.0),
          // Clinical takeaway box
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF7FC),
              borderRadius: AppRadius.medium,
              border: Border.all(color: const Color(0xFFE9E0F2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💡', style: TextStyle(fontSize: 16.0)),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    'Clinical Pattern: 85% of your cramps correlate with Day 1–2 prostaglandin surge. Early magnesium and heat therapy provide maximum relief before onset.',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF4A4458),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorrelationItem(SymptomPhaseCorrelation corr) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(corr.icon, style: const TextStyle(fontSize: 14.0)),
                    const SizedBox(width: 6.0),
                    Flexible(
                      child: Text(
                        corr.symptomName,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E1A3C),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                '${corr.recurrencePercentage}% in ${corr.dominantPhase}',
                style: TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w700,
                  color: corr.themeColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Container(
              height: 7.0,
              width: double.infinity,
              color: const Color(0xFFF0EBF5),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (corr.recurrencePercentage / 100).clamp(0.05, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: corr.themeColor,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            corr.clinicalInsight,
            style: TextStyle(
              fontSize: 10.5,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
