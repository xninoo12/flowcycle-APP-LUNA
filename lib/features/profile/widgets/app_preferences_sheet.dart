import 'package:flutter/material.dart';
import '../../../core/localization/locale_controller.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../shared/widgets/buttons/primary_button.dart';

/// Modal bottom sheet popup for App Preferences (Language, Units, Start of Week).
class AppPreferencesSheet extends StatefulWidget {
  final String currentLanguage;
  final String currentUnits;
  final ValueChanged<String>? onLanguageChanged;
  final ValueChanged<String>? onUnitsChanged;

  const AppPreferencesSheet({
    super.key,
    this.currentLanguage = 'English',
    this.currentUnits = 'Metric (°C, kg)',
    this.onLanguageChanged,
    this.onUnitsChanged,
  });

  @override
  State<AppPreferencesSheet> createState() => _AppPreferencesSheetState();
}

class _AppPreferencesSheetState extends State<AppPreferencesSheet> {
  late String _language;
  late String _units;
  String _startOfWeek = 'Monday';

  @override
  void initState() {
    super.initState();
    _language = widget.currentLanguage;
    _units = widget.currentUnits;
  }

  void _openLanguagePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => LanguageSelectionSheet(
        selectedLanguage: _language,
        onLanguageSelected: (lang) {
          setState(() => _language = lang);
          widget.onLanguageChanged?.call(lang);
        },
      ),
    );
  }

  void _openUnitsPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => UnitsSelectionSheet(
        selectedUnits: _units,
        onUnitsSelected: (u) {
          setState(() => _units = u);
          widget.onUnitsChanged?.call(u);
        },
      ),
    );
  }

  void _saveAll() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferences saved successfully ✨'),
        backgroundColor: Color(0xFF8B5CF6),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFAF7F2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          const SizedBox(height: 12.0),
          Container(
            width: 44.0,
            height: 4.5,
            decoration: BoxDecoration(
              color: const Color(0xFFE2DCE8),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          const SizedBox(height: 14.0),

          // Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Text('🌐', style: TextStyle(fontSize: 18.0)),
                          SizedBox(width: 6.0),
                          Text(
                            'Preferences',
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 22.0,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E1A3C),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        'Customize language, units, and regional options',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF7A708A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFF7A708A),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14.0),
          const Divider(height: 1.0, color: Color(0xFFEFE9F4)),

          // Scrollable Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Language Option Tile
                  _buildPreferenceActionTile(
                    emoji: '🗣️',
                    title: 'App Language',
                    subtitle: 'Current: $_language',
                    onTap: _openLanguagePicker,
                  ),

                  const SizedBox(height: 12.0),

                  // 2. Units Option Tile
                  _buildPreferenceActionTile(
                    emoji: '⚖️',
                    title: 'Measurement Units',
                    subtitle: 'Current: $_units',
                    onTap: _openUnitsPicker,
                  ),

                  const SizedBox(height: 12.0),

                  // 3. First Day of Week
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 14.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.0),
                      border: Border.all(
                        color: const Color(0xFFE8E2EE),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Text('📅', style: TextStyle(fontSize: 20.0)),
                            SizedBox(width: 12.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'First Day of Week',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1E1A3C),
                                  ),
                                ),
                                SizedBox(height: 1.5),
                                Text(
                                  'Calendar column alignment',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: Color(0xFF7A708A),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        DropdownButton<String>(
                          value: _startOfWeek,
                          underline: const SizedBox.shrink(),
                          items: const [
                            DropdownMenuItem(
                              value: 'Monday',
                              child: Text('Monday'),
                            ),
                            DropdownMenuItem(
                              value: 'Sunday',
                              child: Text('Sunday'),
                            ),
                          ],
                          onChanged: (v) {
                            if (v != null) {
                              setState(() => _startOfWeek = v);
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  // Save Button
                  PrimaryButton(
                    label: 'Save App Preferences ✨',
                    gradient: AppGradients.dawnBloom,
                    height: 50.0,
                    onPressed: _saveAll,
                  ),
                  const SizedBox(height: 12.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceActionTile({
    required String emoji,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.0),
          border: Border.all(
            color: const Color(0xFFE8E2EE),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20.0)),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E1A3C),
                    ),
                  ),
                  const SizedBox(height: 1.5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Color(0xFF8B5CF6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14.0,
              color: Color(0xFF8B5CF6),
            ),
          ],
        ),
      ),
    );
  }
}

/// Standalone popup modal bottom sheet for Language Selection.
class LanguageSelectionSheet extends StatelessWidget {
  final String selectedLanguage;
  final ValueChanged<String> onLanguageSelected;

  const LanguageSelectionSheet({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageSelected,
  });

  static const List<Map<String, String>> _languages = [
    {'name': 'English', 'flag': '🇺🇸', 'native': 'English', 'code': 'en'},
    {'name': 'Spanish', 'flag': '🇪🇸', 'native': 'Español', 'code': 'es'},
    {'name': 'French', 'flag': '🇫🇷', 'native': 'Français', 'code': 'fr'},
    {'name': 'German', 'flag': '🇩🇪', 'native': 'Deutsch', 'code': 'de'},
    {'name': 'Japanese', 'flag': '🇯🇵', 'native': '日本語', 'code': 'ja'},
    {'name': 'Portuguese', 'flag': '🇧🇷', 'native': 'Português', 'code': 'pt'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.70,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFAF7F2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12.0),
          Container(
            width: 44.0,
            height: 4.5,
            decoration: BoxDecoration(
              color: const Color(0xFFE2DCE8),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          const SizedBox(height: 14.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text('🌐', style: TextStyle(fontSize: 18.0)),
                    SizedBox(width: 6.0),
                    Text(
                      'Select Language',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 20.0,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1A3C),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF7A708A)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1.0, color: Color(0xFFEFE9F4)),
          Flexible(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 14.0,
              ),
              itemCount: _languages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8.0),
              itemBuilder: (context, index) {
                final lang = _languages[index];
                final isSelected = lang['name'] == selectedLanguage;

                return InkWell(
                  onTap: () {
                    final code = lang['code'] ?? 'en';
                    LocaleController.instance.setLocale(Locale(code));
                    onLanguageSelected(lang['name']!);
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFF3E8FF) : Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF8B5CF6)
                            : const Color(0xFFE8E2EE),
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(lang['flag']!, style: const TextStyle(fontSize: 20.0)),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang['name']!,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: isSelected
                                      ? FontWeight.w900
                                      : FontWeight.w700,
                                  color: const Color(0xFF1E1A3C),
                                ),
                              ),
                              Text(
                                lang['native']!,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF7A708A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF8B5CF6),
                            size: 20.0,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Standalone popup modal bottom sheet for Measurement Units.
class UnitsSelectionSheet extends StatelessWidget {
  final String selectedUnits;
  final ValueChanged<String> onUnitsSelected;

  const UnitsSelectionSheet({
    super.key,
    required this.selectedUnits,
    required this.onUnitsSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isMetric = selectedUnits.contains('Metric');

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.55,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFAF7F2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12.0),
          Container(
            width: 44.0,
            height: 4.5,
            decoration: BoxDecoration(
              color: const Color(0xFFE2DCE8),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          const SizedBox(height: 14.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text('⚖️', style: TextStyle(fontSize: 18.0)),
                    SizedBox(width: 6.0),
                    Text(
                      'Measurement Units',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 20.0,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1A3C),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF7A708A)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1.0, color: Color(0xFFEFE9F4)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              children: [
                _buildUnitOption(
                  context,
                  title: 'Metric System',
                  subtitle: 'Temperature in Celsius (°C), Weight in Kilograms (kg)',
                  isSelected: isMetric,
                  onTap: () {
                    onUnitsSelected('Metric (°C, kg)');
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 10.0),
                _buildUnitOption(
                  context,
                  title: 'Imperial System',
                  subtitle: 'Temperature in Fahrenheit (°F), Weight in Pounds (lbs)',
                  isSelected: !isMetric,
                  onTap: () {
                    onUnitsSelected('Imperial (°F, lbs)');
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3E8FF) : Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFFE8E2EE),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                      color: const Color(0xFF1E1A3C),
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF7A708A),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF8B5CF6),
                size: 20.0,
              ),
          ],
        ),
      ),
    );
  }
}
