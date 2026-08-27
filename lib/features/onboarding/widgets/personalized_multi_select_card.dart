import 'package:flutter/material.dart';

/// Multi-select row card for Personalized Onboarding questions (Cycle Awareness branch).
///
/// Features an icon container on the left, bold title, descriptive subtitle,
/// and a custom rounded checkbox selection indicator on the right.
class PersonalizedMultiSelectCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onToggle;

  const PersonalizedMultiSelectCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: isSelected,
      button: true,
      label: subtitle != null ? '$title: $subtitle' : title,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF8DA1)
                : const Color(0xFFF3E8EE),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0x1FFF4D79)
                  : const Color(0x081E1A3C),
              blurRadius: isSelected ? 14.0 : 8.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(20.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 14.0,
              ),
              child: Row(
                children: [
                  // 1. Left Icon Container
                  Container(
                    width: 44.0,
                    height: 44.0,
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
                        size: 22.0,
                      ),
                    ),
                  ),

                  const SizedBox(width: 14.0),

                  // 2. Title & Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E1A3C),
                            letterSpacing: -0.2,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2.0),
                          Text(
                            subtitle!,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF7A708A),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(width: 12.0),

                  // 3. Rounded Checkbox Indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: isSelected
                          ? const Color(0xFFFF4D79)
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFFF4D79)
                            : const Color(0xFFFFD6E2),
                        width: 1.5,
                      ),
                    ),
                    child: isSelected
                        ? const Center(
                            child: Icon(
                              Icons.check_rounded,
                              size: 16.0,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
