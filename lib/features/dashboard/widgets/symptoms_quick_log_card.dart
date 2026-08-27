import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Quick Symptoms Logging & Summary Card for Cycle Awareness Dashboard.
class SymptomsQuickLogCard extends StatelessWidget {
  final Set<String> activeSymptoms;
  final ValueChanged<String>? onToggleSymptom;
  final VoidCallback? onEditTap;
  final VoidCallback? onAddSymptomTap;

  const SymptomsQuickLogCard({
    super.key,
    this.activeSymptoms = const {'Bloating', 'Cramps', 'Breast', 'Mood'},
    this.onToggleSymptom,
    this.onEditTap,
    this.onAddSymptomTap,
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
          // 1. Header: Symptoms + Edit Link
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Symptoms',
                style: AppTextStyles.subtitle.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                  color: const Color(0xFF1E1A3C),
                ),
              ),
              InkWell(
                onTap: onEditTap,
                borderRadius: BorderRadius.circular(4.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 2.0,
                  ),
                  child: Text(
                    'Edit',
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFF6C449B),
                      fontWeight: FontWeight.w700,
                      fontSize: 11.5,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // 2. 4 Symptom Badges Row (Bloating, Cramps, Breast, Mood)
          Row(
            children: [
              Expanded(
                child: _buildSymptomBadge(
                  icon: Icons.bubble_chart_rounded,
                  label: 'Bloating',
                  bgColor: const Color(0xFFFDE8EF),
                  iconColor: const Color(0xFFE84D75),
                  isSelected: activeSymptoms.contains('Bloating'),
                ),
              ),
              Expanded(
                child: _buildSymptomBadge(
                  icon: Icons.local_fire_department_rounded,
                  label: 'Cramps',
                  bgColor: const Color(0xFFFFF0EB),
                  iconColor: const Color(0xFFFFAA8A),
                  isSelected: activeSymptoms.contains('Cramps'),
                ),
              ),
              Expanded(
                child: _buildSymptomBadge(
                  icon: Icons.favorite_rounded,
                  label: 'Breast',
                  bgColor: const Color(0xFFFDE8EF),
                  iconColor: const Color(0xFFE84D75),
                  isSelected: activeSymptoms.contains('Breast'),
                ),
              ),
              Expanded(
                child: _buildSymptomBadge(
                  icon: Icons.sentiment_satisfied_alt_rounded,
                  label: 'Mood',
                  bgColor: const Color(0xFFEDE4F7),
                  iconColor: const Color(0xFF6C449B),
                  isSelected: activeSymptoms.contains('Mood'),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm + 2.0),

          // 3. "+ Add symptom" Action Pill Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onAddSymptomTap,
              borderRadius: AppRadius.pill,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE8EF),
                  borderRadius: AppRadius.pill,
                  border: Border.all(
                    color: const Color(0xFFFFD4E2),
                    width: 1.0,
                  ),
                ),
                child: Center(
                  child: Text(
                    '+ Add symptom',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFE84D75),
                      fontSize: 11.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomBadge({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color iconColor,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onToggleSymptom?.call(label),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34.0,
            height: 34.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? bgColor : const Color(0xFFF7F5F9),
              border: Border.all(
                color: isSelected ? iconColor : const Color(0xFFEFE9F3),
                width: isSelected ? 1.2 : 1.0,
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                color: isSelected ? iconColor : const Color(0xFF9E8EAA),
                size: 17.0,
              ),
            ),
          ),
          const SizedBox(height: 3.0),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontSize: 9.5,
              color: isSelected
                  ? const Color(0xFF1E1A3C)
                  : const Color(0xFF7A708A),
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
