import 'package:flutter/material.dart';

/// Single-choice selectable row card for Personalized Onboarding questions (TTC branch).
///
/// Displays text option with a clear active check/radio indicator, soft background tint,
/// and subtle active border highlight.
class PersonalizedSingleSelectCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onSelect;

  const PersonalizedSingleSelectCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
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
            onTap: onSelect,
            borderRadius: BorderRadius.circular(20.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
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
                              size: 15.0,
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
