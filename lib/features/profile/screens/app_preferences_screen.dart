import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/locale_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Screen for configuring language, measurement units, first day of week, and startup preferences.
class AppPreferencesScreen extends StatefulWidget {
  const AppPreferencesScreen({super.key});

  @override
  State<AppPreferencesScreen> createState() => _AppPreferencesScreenState();
}

class _AppPreferencesScreenState extends State<AppPreferencesScreen> {
  late String _selectedLanguage;
  String _selectedUnits = 'Metric (°C, kg)';
  String _firstDayOfWeek = 'Monday';
  String _defaultMode = 'Cycle Awareness';

  @override
  void initState() {
    super.initState();
    _selectedLanguage = LocaleController.instance.currentLanguageName;
  }

  final List<String> _languages = [
    'English (US)',
    'Español (Spanish)',
    'Français (French)',
    'Deutsch (German)',
    'العربية (Arabic)',
  ];

  final List<String> _unitsOptions = ['Metric (°C, kg)', 'Imperial (°F, lbs)'];

  void _showSelectorSheet({
    required String title,
    required List<String> options,
    required String currentValue,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E1A3C),
                  ),
                ),
                const SizedBox(height: 12),
                ...options.map((option) {
                  final isSelected = currentValue == option;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      option,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary
                            : const Color(0xFF1E1A3C),
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primary,
                          )
                        : null,
                    onTap: () {
                      onSelected(option);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1E1A3C),
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Preferences',
          style: AppTextStyles.subtitle.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1E1A3C),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Language & Regional
              _buildSectionHeader('LANGUAGE & REGIONAL'),
              _buildCard([
                _buildPreferenceRow(
                  title: 'App Language',
                  subtitle: 'Select your preferred interface language',
                  value: _selectedLanguage,
                  icon: Icons.language_rounded,
                  iconColor: const Color(0xFF8B5CF6),
                  onTap: () => _showSelectorSheet(
                    title: 'Select App Language',
                    options: _languages,
                    currentValue: _selectedLanguage,
                    onSelected: (val) {
                      setState(() => _selectedLanguage = val);
                      if (val.contains('Spanish') || val.contains('Español')) {
                        LocaleController.instance.setLanguageCode('es');
                      } else if (val.contains('French') ||
                          val.contains('Français')) {
                        LocaleController.instance.setLanguageCode('fr');
                      } else if (val.contains('German') ||
                          val.contains('Deutsch')) {
                        LocaleController.instance.setLanguageCode('de');
                      } else {
                        LocaleController.instance.setLanguageCode('en');
                      }
                    },
                  ),
                ),
                const Divider(height: 24, color: Color(0xFFEFE9F3)),
                _buildPreferenceRow(
                  title: 'First Day of the Week',
                  subtitle: 'Affects the calendar views',
                  value: _firstDayOfWeek,
                  icon: Icons.calendar_view_week_rounded,
                  iconColor: const Color(0xFF8B5CF6),
                  onTap: () => _showSelectorSheet(
                    title: 'First Day of Week',
                    options: ['Sunday', 'Monday'],
                    currentValue: _firstDayOfWeek,
                    onSelected: (val) => setState(() => _firstDayOfWeek = val),
                  ),
                ),
              ]),

              const SizedBox(height: 24),

              // 2. Units of Measurement
              _buildSectionHeader('UNITS OF MEASUREMENT'),
              _buildCard([
                _buildPreferenceRow(
                  title: 'Measurement System',
                  subtitle: 'Body temperature, weight & liquids',
                  value: _selectedUnits,
                  icon: Icons.straighten_rounded,
                  iconColor: const Color(0xFF8B5CF6),
                  onTap: () => _showSelectorSheet(
                    title: 'Measurement Units',
                    options: _unitsOptions,
                    currentValue: _selectedUnits,
                    onSelected: (val) => setState(() => _selectedUnits = val),
                  ),
                ),
              ]),

              const SizedBox(height: 24),

              // 3. App Launch Defaults
              _buildSectionHeader('DEFAULT APP STARTUP'),
              _buildCard([
                _buildPreferenceRow(
                  title: 'Default Home View',
                  subtitle: 'Mode active when you open the app',
                  value: _defaultMode,
                  icon: Icons.home_outlined,
                  iconColor: const Color(0xFF8B5CF6),
                  onTap: () => _showSelectorSheet(
                    title: 'Default Startup Mode',
                    options: ['Cycle Awareness', 'Trying to Conceive'],
                    currentValue: _defaultMode,
                    onSelected: (val) => setState(() => _defaultMode = val),
                  ),
                ),
              ]),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w800,
          color: const Color(0xFF7A708A),
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.medium,
        border: Border.all(color: const Color(0xFFEFE9F3)),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildPreferenceRow({
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E1A3C),
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFF7A708A),
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFF7A708A),
                  size: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
