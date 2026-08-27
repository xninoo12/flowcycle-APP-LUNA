import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_names.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/models/app_mode.dart';
import '../../shared/providers/app_scope.dart';
import 'widgets/about_flowcycle_sheet.dart';
import 'widgets/appearance_theme_card.dart';
import 'widgets/app_preferences_sheet.dart';
import 'widgets/contact_support_dialog.dart';
import 'widgets/edit_profile_sheet.dart';
import 'widgets/help_center_sheet.dart';
import 'widgets/notification_center_sheet.dart';
import 'widgets/pin_lock_dialog.dart';
import 'widgets/profile_header_hero.dart';
import 'widgets/profile_metrics_row.dart';
import 'widgets/profile_preferences_card.dart';
import 'widgets/profile_privacy_data_card.dart';
import 'widgets/profile_privacy_matters_banner.dart';
import 'widgets/profile_support_about_card.dart';
import 'widgets/privacy_security_sheet.dart';
import 'widgets/rate_app_dialog.dart';
import 'widgets/reminders_settings_sheet.dart';
import 'widgets/theme_picker_sheet.dart';

/// Complete Profile Screen with all features wired as interactive individual popups/sheets.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _passcodeStatus = 'Off';
  String _selectedLanguage = 'English';
  String _selectedUnits = 'Metric (°C, kg)';

  void _showActionFeedback(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFFFF4D79),
      ),
    );
  }

  void _openEditProfileSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const EditProfileSheet(),
    );
  }

  void _openNotificationsCenter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const NotificationCenterSheet(),
    );
  }

  void _openRemindersSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const RemindersSettingsSheet(),
    );
  }

  void _openPreferencesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AppPreferencesSheet(
        currentLanguage: _selectedLanguage,
        currentUnits: _selectedUnits,
        onLanguageChanged: (lang) => setState(() => _selectedLanguage = lang),
        onUnitsChanged: (u) => setState(() => _selectedUnits = u),
      ),
    );
  }

  void _openLanguagePickerSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => LanguageSelectionSheet(
        selectedLanguage: _selectedLanguage,
        onLanguageSelected: (lang) => setState(() => _selectedLanguage = lang),
      ),
    );
  }

  void _openUnitsPickerSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => UnitsSelectionSheet(
        selectedUnits: _selectedUnits,
        onUnitsSelected: (u) => setState(() => _selectedUnits = u),
      ),
    );
  }

  void _openPrivacySecuritySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PrivacySecuritySheet(
        onOpenPasscode: () {
          Navigator.of(ctx).pop();
          _openPasscodeDialog();
        },
      ),
    );
  }

  void _openCloudBackupSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const CloudBackupSheet(),
    );
  }

  void _openExportDataSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const ExportDataSheet(),
    );
  }

  void _openPrivacyDetailsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const PrivacyDetailsSheet(),
    );
  }

  void _openHelpCenterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const HelpCenterSheet(),
    );
  }

  void _openThemePickerSheet() {
    final currentTheme = AppScope.of(context).selectedThemeId;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ThemePickerSheet(
        currentThemeId: currentTheme,
      ),
    );
  }

  void _openContactSupport() {
    showDialog(
      context: context,
      builder: (ctx) => const ContactSupportDialog(),
    );
  }

  void _openRateApp() {
    showDialog(context: context, builder: (ctx) => const RateAppDialog());
  }

  void _openAboutSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AboutFlowcycleSheet(),
    );
  }

  void _openPasscodeDialog() {
    showDialog(
      context: context,
      builder: (ctx) => PinLockDialog(
        onPinCompleted: (pin) {
          setState(() {
            _passcodeStatus = pin.isNotEmpty ? 'On' : 'Off';
          });
          _showActionFeedback(
            pin.isNotEmpty ? 'Passcode lock activated 🔒' : 'Passcode turned off',
          );
        },
      ),
    );
  }

  void _toggleCurrentMode() {
    final controller = AppScope.of(context);
    final isTtc = controller.currentMode == AppMode.tryingToConceive;
    final newMode = isTtc ? AppMode.cycleAwareness : AppMode.tryingToConceive;
    controller.setAppMode(newMode);
    _showActionFeedback(
      newMode == AppMode.cycleAwareness
          ? 'Switched to Cycle Awareness Mode 🌸'
          : 'Switched to Trying to Conceive Mode 💗',
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final userProfile = controller.userProfile;
    final totalDays = userProfile.averageCycleLength;
    final now = DateTime.now();
    final daysSinceStart = now
        .difference(userProfile.lastPeriodStartDate)
        .inDays;
    final currentCycleDay = ((daysSinceStart % totalDays) + 1).clamp(
      1,
      totalDays,
    );

    final isTtc = controller.currentMode == AppMode.tryingToConceive;
    final currentModeName = isTtc ? 'Trying to\nConceive' : 'Cycle\nAwareness';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Top Header & Hero Visual (Brand, Actions, Avatar, Crown, Butterfly, Name, Status)
                ProfileHeaderHero(
                  userName: userProfile.name,
                  onEditName: _openEditProfileSheet,
                  onNotificationTap: _openNotificationsCenter,
                  onSettingsTap: _openPreferencesSheet,
                  onAvatarTap: _openEditProfileSheet,
                ),

                const SizedBox(height: 10.0),

                // 2. 4-Item Metric Row (Cycle Day, Sex Logged, Days Logged, Current Mode)
                ProfileMetricsRow(
                  currentCycleDay: currentCycleDay,
                  totalCycleDays: totalDays,
                  sexLoggedCount: 4,
                  daysLoggedCount: 21,
                  currentModeName: currentModeName,
                  onCycleDayTap: () {
                    try {
                      context.go(AppRoutes.calendarPath);
                    } catch (_) {}
                  },
                  onSexLoggedTap: () {
                    try {
                      context.push(AppRoutes.dailyLogPath);
                    } catch (_) {}
                  },
                  onDaysLoggedTap: () {
                    try {
                      context.go(AppRoutes.calendarPath);
                    } catch (_) {}
                  },
                  onCurrentModeTap: _toggleCurrentMode,
                ),

                const SizedBox(height: 10.0),

                // 3. "Appearance" Theme Card (Pink Swatches & Chevron)
                AppearanceThemeCard(
                  selectedThemeId: controller.selectedThemeId,
                  onThemeSelected: (themeId) {
                    controller.setTheme(themeId);
                    final name = themeId == 'navy'
                        ? 'Midnight Indigo'
                        : themeId.substring(0, 1).toUpperCase() +
                            themeId.substring(1);
                    _showActionFeedback('Theme switched to $name ✨');
                  },
                  onMoreTap: _openThemePickerSheet,
                ),

                const SizedBox(height: 10.0),

                // 4. "Privacy & Data" Card (Green Theme)
                ProfilePrivacyDataCard(
                  passcodeStatus: _passcodeStatus,
                  onPrivacySettingsTap: _openPrivacySecuritySheet,
                  onPasscodeBiometricsTap: _openPasscodeDialog,
                  onBackupRestoreTap: _openCloudBackupSheet,
                  onExportDeleteTap: _openExportDataSheet,
                ),

                const SizedBox(height: 10.0),

                // 5. "Preferences" Card (Purple Theme)
                ProfilePreferencesCard(
                  currentLanguage: _selectedLanguage,
                  currentUnits: _selectedUnits,
                  onLanguageTap: _openLanguagePickerSheet,
                  onUnitsTap: _openUnitsPickerSheet,
                ),

                const SizedBox(height: 10.0),

                // 6. "Support & About" Card (Blue Theme, 2x2 Grid)
                ProfileSupportAboutCard(
                  onHelpCenterTap: _openHelpCenterSheet,
                  onRateAppTap: _openRateApp,
                  onContactUsTap: _openContactSupport,
                  onAboutTap: _openAboutSheet,
                ),

                const SizedBox(height: 10.0),

                // 7. "Your privacy matters" Bottom Banner
                ProfilePrivacyMattersBanner(
                  onLearnMore: _openPrivacyDetailsSheet,
                ),

                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
