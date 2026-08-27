import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Track your fertility symptoms & biomarkers card for TTC Dashboard.
class TtcSymptomsTrackerCard extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onAddSymptom;

  const TtcSymptomsTrackerCard({super.key, this.onEdit, this.onAddSymptom});

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
          // 1. Header: Title + Edit Link
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Track your symptoms',
                  style: AppTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.0,
                    color: const Color(0xFF1E1A3C),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: onEdit,
                borderRadius: BorderRadius.circular(4.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 2.0,
                  ),
                  child: Text(
                    'Edit',
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFFE84D75),
                      fontWeight: FontWeight.w700,
                      fontSize: 11.5,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // 2. 4 Biomarker Badges Row (CM, OPK, BBT, LH Test)
          Row(
            children: [
              Expanded(
                child: _buildBiomarkerBadge(
                  icon: Icons.water_drop_outlined,
                  iconColor: const Color(0xFF5D9CEC),
                  bgColor: const Color(0xFFEBF3FC),
                  title: 'CM',
                  subtitle: 'Egg white',
                ),
              ),
              Expanded(
                child: _buildBiomarkerBadge(
                  icon: Icons.add_rounded,
                  iconColor: const Color(0xFF2E9E68),
                  bgColor: const Color(0xFFE6F8F0),
                  title: 'OPK',
                  subtitle: 'Positive',
                ),
              ),
              Expanded(
                child: _buildBiomarkerBadge(
                  icon: Icons.thermostat_outlined,
                  iconColor: const Color(0xFF8A64B8),
                  bgColor: const Color(0xFFF3EDFA),
                  title: 'BBT',
                  subtitle: '36.68 °C',
                ),
              ),
              Expanded(
                child: _buildBiomarkerBadge(
                  icon: Icons.text_fields_rounded,
                  iconColor: const Color(0xFFE84D75),
                  bgColor: const Color(0xFFFDE8EF),
                  title: 'LH Test',
                  subtitle: 'High',
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm + 2.0),

          // 3. "+ Add symptom" Action link
          Center(
            child: InkWell(
              onTap: onAddSymptom,
              borderRadius: BorderRadius.circular(4.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 2.0,
                ),
                child: Text(
                  '+ Add symptom',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFE84D75),
                    fontSize: 11.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiomarkerBadge({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32.0,
          height: 32.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor,
            border: Border.all(
              color: iconColor.withValues(alpha: 0.3),
              width: 1.0,
            ),
          ),
          child: Center(child: Icon(icon, color: iconColor, size: 16.0)),
        ),
        const SizedBox(height: 3.0),
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            fontSize: 9.5,
            color: const Color(0xFF1E1A3C),
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          subtitle,
          style: AppTextStyles.caption.copyWith(
            fontSize: 8.0,
            color: const Color(0xFF7A708A),
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
