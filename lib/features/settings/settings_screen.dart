import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/router/route_names.dart';
import '../../core/data/demo_data_generator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/models/app_mode.dart';
import '../../shared/providers/app_scope.dart';
import '../../shared/widgets/responsive_layout.dart';
import '../profile/widgets/profile_section_group.dart';

/// Complete Settings & Configuration Screen for FlowCycle.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFFE84D75),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
    );
  }

  void _handleLoadDemoData() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: const Text('Load Demo History 📊', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text(
          'This will populate 6 months (~180 days) of realistic historical cycles, biphasic BBT curves, and symptoms for testing Insights & Patterns.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF7A708A))),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await DemoDataGenerator.instance.populate6MonthDemoHistory();
              if (mounted) {
                _showFeedback('6-Month Demo History loaded successfully! ✨');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE84D75),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            child: const Text('Load Data'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final isTtc = controller.userProfile.mode == AppMode.tryingToConceive;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E1A3C)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Settings',
          style: AppTextStyles.subtitle.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1E1A3C),
          ),
        ),
        centerTitle: true,
      ),
      body: ResponsiveLayout(
        maxWidth: 640.0,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Mode Management
              ProfileSectionGroup(
                sectionTitle: 'Cycle Goal & Mode',
                items: [
                  ProfileRowItem(
                    title: 'Active Mode',
                    subtitle: isTtc ? 'Trying to Conceive' : 'Cycle Awareness',
                    icon: isTtc ? Icons.favorite_rounded : Icons.spa_rounded,
                    iconColor: isTtc ? const Color(0xFF2E9E68) : const Color(0xFFE84D75),
                    iconBgColor: isTtc ? const Color(0xFFE6F8F0) : const Color(0xFFFFF0F5),
                    valueText: isTtc ? 'TTC' : 'Track',
                    valueTextColor: isTtc ? const Color(0xFF2E9E68) : const Color(0xFFE84D75),
                    onTap: () {
                      controller.setAppMode(
                        isTtc ? AppMode.cycleAwareness : AppMode.tryingToConceive,
                      );
                      _showFeedback('Switched to ${!isTtc ? "Trying to Conceive" : "Cycle Awareness"} mode!');
                    },
                  ),
                  ProfileRowItem(
                    title: 'Cycle Parameters',
                    subtitle: 'Average ${controller.userProfile.averageCycleLength} days cycle, ${controller.userProfile.typicalPeriodDuration} days period',
                    icon: Icons.calendar_month_rounded,
                    iconColor: const Color(0xFF8B5CF6),
                    iconBgColor: const Color(0xFFF2ECFB),
                    onTap: () {
                      try {
                        context.push(AppRoutes.editProfilePath);
                      } catch (_) {}
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16.0),

              // 2. Preferences & Security
              ProfileSectionGroup(
                sectionTitle: 'System & Security',
                items: [
                  ProfileRowItem(
                    title: 'Reminders & Notifications',
                    subtitle: 'Period, ovulation & medication alerts',
                    icon: Icons.notifications_none_rounded,
                    iconColor: const Color(0xFFE84D75),
                    iconBgColor: const Color(0xFFFFF0F5),
                    onTap: () {
                      try {
                        context.push(AppRoutes.remindersSettingsPath);
                      } catch (_) {}
                    },
                  ),
                  ProfileRowItem(
                    title: 'Passcode & Biometrics',
                    subtitle: 'Protect your app with a 4-digit PIN',
                    icon: Icons.lock_outline_rounded,
                    iconColor: const Color(0xFF10B981),
                    iconBgColor: const Color(0xFFE8F8F0),
                    onTap: () {
                      try {
                        context.push(AppRoutes.privacySecurityPath);
                      } catch (_) {}
                    },
                  ),
                  ProfileRowItem(
                    title: 'Language & Regional Units',
                    subtitle: 'English, Metric (°C, kg)',
                    icon: Icons.language_rounded,
                    iconColor: const Color(0xFF8B5CF6),
                    iconBgColor: const Color(0xFFF2ECFB),
                    onTap: () {
                      try {
                        context.push(AppRoutes.appPreferencesPath);
                      } catch (_) {}
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16.0),

              // 3. Developer & Demo Tools
              ProfileSectionGroup(
                sectionTitle: 'Developer & Testing Tools',
                items: [
                  ProfileRowItem(
                    title: 'Load 6-Month Demo Data 📊',
                    subtitle: 'Populate 180 days of realistic cycles, BBT & symptoms',
                    icon: Icons.auto_graph_rounded,
                    iconColor: const Color(0xFFE84D75),
                    iconBgColor: const Color(0xFFFFF0F5),
                    onTap: _handleLoadDemoData,
                  ),
                ],
              ),

              const SizedBox(height: 24.0),
              Center(
                child: Text(
                  'FlowCycle v1.2.3 (Production Ready)',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                ),
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }
}
