import 'package:flutter/material.dart';

/// "Preferences" Card matching the exact mockup.
///
/// Features:
/// - Purple globe badge + script title ("Preferences")
/// - 2 interactive rows: Language (English >) and Units (Metric (°C, kg) >)
class ProfilePreferencesCard extends StatelessWidget {
  final String currentLanguage;
  final String currentUnits;
  final VoidCallback? onLanguageTap;
  final VoidCallback? onUnitsTap;

  const ProfilePreferencesCard({
    super.key,
    this.currentLanguage = 'English',
    this.currentUnits = 'Metric (°C, kg)',
    this.onLanguageTap,
    this.onUnitsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: const Color(0xFFF1ECF5),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1A3C).withValues(alpha: 0.025),
            blurRadius: 10.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header: Purple Globe Badge + "Preferences" Script Title
          Row(
            children: [
              Container(
                width: 38.0,
                height: 38.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFEDE9FE),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.language_rounded,
                    color: Color(0xFF8B5CF6),
                    size: 20.0,
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Preferences',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        fontSize: 16.0,
                        color: Color(0xFF8B5CF6),
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 1.0),
                    Text(
                      'Customize your app experience.',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7A708A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10.0),
          const Divider(height: 1.0, color: Color(0xFFF1ECF5)),
          const SizedBox(height: 4.0),

          // 2. Setting Rows
          _buildRow(
            icon: Icons.language_rounded,
            title: 'Language',
            subtitle: 'Choose your app language',
            valueText: currentLanguage,
            onTap: onLanguageTap,
          ),
          const Divider(height: 1.0, color: Color(0xFFF7F4FB)),

          _buildRow(
            icon: Icons.sell_outlined,
            title: 'Units',
            subtitle: 'Temperature, weight and more',
            valueText: currentUnits,
            onTap: onUnitsTap,
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required String valueText,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
          child: Row(
            children: [
              // Circular Purple Icon Container
              Container(
                width: 32.0,
                height: 32.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFEDE9FE),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: const Color(0xFF8B5CF6),
                    size: 16.0,
                  ),
                ),
              ),

              const SizedBox(width: 10.0),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E1A3C),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1.0),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7A708A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Value Text (e.g. "English", "Metric (°C, kg)")
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Text(
                  valueText,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8B5CF6),
                  ),
                ),
              ),

              // Chevron >
              const Icon(
                Icons.chevron_right_rounded,
                size: 16.0,
                color: Color(0xFF8B5CF6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
