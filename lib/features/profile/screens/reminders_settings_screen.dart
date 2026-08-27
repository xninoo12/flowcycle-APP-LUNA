import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Comprehensive Reminders & Alerts settings screen.
class RemindersSettingsScreen extends StatefulWidget {
  const RemindersSettingsScreen({super.key});

  @override
  State<RemindersSettingsScreen> createState() =>
      _RemindersSettingsScreenState();
}

class _RemindersSettingsScreenState extends State<RemindersSettingsScreen> {
  bool _periodAlert = true;
  String _periodAlertTiming = '2 days before';
  bool _ovulationAlert = true;
  bool _latePeriodAlert = true;
  bool _dailyLogReminder = true;
  TimeOfDay _dailyLogTime = const TimeOfDay(hour: 21, minute: 0);
  bool _pillReminder = false;
  TimeOfDay _pillTime = const TimeOfDay(hour: 9, minute: 0);
  String _pillName = 'Daily Pill';
  bool _bbtReminder = false;
  TimeOfDay _bbtTime = const TimeOfDay(hour: 7, minute: 0);
  bool _dailyTips = true;
  bool _weeklyDigest = false;
  bool _emailAlerts = false;
  bool _discreetMode = false;

  @override
  void initState() {
    super.initState();
    final svc = NotificationService.instance;
    _periodAlert = svc.periodAlerts;
    _periodAlertTiming = '${svc.periodDaysBefore} days before';
    _ovulationAlert = svc.fertileWindowAlerts;
    _dailyLogReminder = svc.dailyLogReminders;
    _dailyLogTime = svc.dailyLogTime;
    _pillReminder = svc.pillReminderEnabled;
    _pillTime = svc.pillReminderTime;
    _pillName = svc.pillName;
    _dailyTips = svc.aiHealthTips;
    _discreetMode = svc.discreetMode;
  }

  void _syncNotificationService() {
    final svc = NotificationService.instance;
    final days = int.tryParse(_periodAlertTiming.split(' ').first) ?? 2;
    svc.updatePeriodAlerts(enabled: _periodAlert, daysBefore: days);
    svc.updateFertileWindowAlerts(enabled: _ovulationAlert);
    svc.updateDailyLogReminder(enabled: _dailyLogReminder, time: _dailyLogTime);
    svc.updatePillReminder(
      enabled: _pillReminder,
      time: _pillTime,
      name: _pillName,
    );
    svc.updateAiHealthTips(enabled: _dailyTips);
    svc.updateDiscreetMode(enabled: _discreetMode);
  }

  Future<void> _pickTime({
    required TimeOfDay initialTime,
    required ValueChanged<TimeOfDay> onPicked,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E1A3C),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      onPicked(picked);
    }
  }

  void _showTimingPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        final options = [
          'On the day',
          '1 day before',
          '2 days before',
          '3 days before',
          '5 days before',
        ];
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Period Reminder Timing',
                  style: AppTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E1A3C),
                  ),
                ),
                const SizedBox(height: 12),
                ...options.map((timing) {
                  final isSelected = _periodAlertTiming == timing;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      timing,
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
                      setState(() => _periodAlertTiming = timing);
                      _syncNotificationService();
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

  void _triggerTestReminder(String type) {
    final title = type == 'period'
        ? '🌸 FlowCycle: Period Approaching'
        : '✨ FlowCycle: Fertile Window Started';
    final body = type == 'period'
        ? 'Your next period is predicted to begin in $_periodAlertTiming. Have your supplies ready!'
        : 'High conception probability detected for the next 5 days!';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.notifications_active_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                  Text(body, style: const TextStyle(fontSize: 11.5, color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: type == 'period' ? const Color(0xFFE84D75) : const Color(0xFF8B5CF6),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF8FC),
        appBar: AppBar(
        backgroundColor: const Color(0xFFFAF8FC),
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
          'Reminders & Alerts',
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
              // Discreet Lock-Screen Privacy Banner
              Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: _discreetMode ? const Color(0xFFEBFDF5) : Colors.white,
                  borderRadius: AppRadius.large,
                  border: Border.all(
                    color: _discreetMode
                        ? const Color(0xFF10B981).withValues(alpha: 0.5)
                        : const Color(0xFFE8E2EE),
                    width: _discreetMode ? 1.5 : 1.0,
                  ),
                  boxShadow: AppShadows.subtle,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _discreetMode
                            ? const Color(0xFF10B981).withValues(alpha: 0.15)
                            : const Color(0xFFF1EDF8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.shield_outlined,
                        color: _discreetMode
                            ? const Color(0xFF10B981)
                            : const Color(0xFF7C5CE7),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Discreet Lock-Screen Mode',
                            style: AppTextStyles.body.copyWith(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1E1A3C),
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            'Masks sensitive terms on lock screen with gentle self-care phrases',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 11.0,
                              color: const Color(0xFF7A708A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: _discreetMode,
                      activeTrackColor: const Color(0xFF10B981),
                      onChanged: (v) {
                        setState(() => _discreetMode = v);
                        _syncNotificationService();
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 1. Cycle Predictions
              _buildSectionHeader('CYCLE PREDICTIONS'),
              _buildSettingsCard([
                _buildSwitchTile(
                  title: 'Period Start Alert',
                  subtitle: 'Get notified before your period is expected',
                  value: _periodAlert,
                  onChanged: (val) {
                    setState(() => _periodAlert = val);
                    _syncNotificationService();
                  },
                  actionRow: _periodAlert
                      ? InkWell(
                          onTap: _showTimingPicker,
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                Text(
                                  'Timing: ',
                                  style: AppTextStyles.caption.copyWith(
                                    color: const Color(0xFF7A708A),
                                  ),
                                ),
                                Text(
                                  _periodAlertTiming,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 10,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        )
                      : null,
                ),
                const Divider(height: 24, color: Color(0xFFEFE9F3)),
                _buildSwitchTile(
                  title: 'Fertile Window & Ovulation',
                  subtitle: 'Alerts when your high fertility window opens',
                  value: _ovulationAlert,
                  onChanged: (val) {
                    setState(() => _ovulationAlert = val);
                    _syncNotificationService();
                  },
                ),
                const Divider(height: 24, color: Color(0xFFEFE9F3)),
                _buildSwitchTile(
                  title: 'Late Period Alert',
                  subtitle: 'Gentle notification if your period is delayed',
                  value: _latePeriodAlert,
                  onChanged: (val) {
                    setState(() => _latePeriodAlert = val);
                    _syncNotificationService();
                  },
                ),
              ]),

              const SizedBox(height: 24),

              // 2. Daily Habits & Logging
              _buildSectionHeader('DAILY HABITS & MEDICATION'),
              _buildSettingsCard([
                _buildSwitchTile(
                  title: 'Daily Log Reminder',
                  subtitle: 'Evening check-in to log mood & symptoms',
                  value: _dailyLogReminder,
                  onChanged: (val) {
                    setState(() => _dailyLogReminder = val);
                    _syncNotificationService();
                  },
                  actionRow: _dailyLogReminder
                      ? InkWell(
                          onTap: () => _pickTime(
                            initialTime: _dailyLogTime,
                            onPicked: (t) {
                              setState(() => _dailyLogTime = t);
                              _syncNotificationService();
                            },
                          ),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.access_time_rounded,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _dailyLogTime.format(context),
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : null,
                ),
                const Divider(height: 24, color: Color(0xFFEFE9F3)),
                _buildSwitchTile(
                  title: 'Pill & Medication Reminder',
                  subtitle: 'Daily reminder for your contraception or vitamins',
                  value: _pillReminder,
                  onChanged: (val) {
                    setState(() => _pillReminder = val);
                    _syncNotificationService();
                  },
                  actionRow: _pillReminder
                      ? InkWell(
                          onTap: () => _pickTime(
                            initialTime: _pillTime,
                            onPicked: (t) {
                              setState(() => _pillTime = t);
                              _syncNotificationService();
                            },
                          ),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.access_time_rounded,
                                  size: 14,
                                  color: Color(0xFFEC4899),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$_pillName: ${_pillTime.format(context)}',
                                  style: AppTextStyles.caption.copyWith(
                                    color: const Color(0xFFEC4899),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : null,
                ),
                const Divider(height: 24, color: Color(0xFFEFE9F3)),
                _buildSwitchTile(
                  title: 'Basal Temperature Reminder',
                  subtitle: 'Morning alert to measure waking temperature',
                  value: _bbtReminder,
                  onChanged: (val) {
                    setState(() => _bbtReminder = val);
                    _syncNotificationService();
                  },
                  actionRow: _bbtReminder
                      ? InkWell(
                          onTap: () => _pickTime(
                            initialTime: _bbtTime,
                            onPicked: (t) {
                              setState(() => _bbtTime = t);
                              _syncNotificationService();
                            },
                          ),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.access_time_rounded,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _bbtTime.format(context),
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : null,
                ),
              ]),

              const SizedBox(height: 24),

              // 3. Motivation & Insights
              _buildSectionHeader('INSIGHTS & DIGESTS'),
              _buildSettingsCard([
                _buildSwitchTile(
                  title: 'Phase Insights & Tips',
                  subtitle:
                      'Encouraging daily tips tailored to your cycle phase',
                  value: _dailyTips,
                  onChanged: (val) {
                    setState(() => _dailyTips = val);
                    _syncNotificationService();
                  },
                ),
                const Divider(height: 24, color: Color(0xFFEFE9F3)),
                _buildSwitchTile(
                  title: 'Weekly Cycle Digest',
                  subtitle: 'A weekly summary of your logged trends',
                  value: _weeklyDigest,
                  onChanged: (val) => setState(() => _weeklyDigest = val),
                ),
                const Divider(height: 24, color: Color(0xFFEFE9F3)),
                _buildSwitchTile(
                  title: 'Email Notifications',
                  subtitle: 'Receive cycle digests to your registered email',
                  value: _emailAlerts,
                  onChanged: (val) => setState(() => _emailAlerts = val),
                ),
              ]),

              const SizedBox(height: 24),

              // 4. Test Notification Simulation Card
              _buildSectionHeader('SIMULATE ALARM / NOTIFICATION'),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF5F8), Color(0xFFF3EDFA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppRadius.large,
                  border: Border.all(color: const Color(0xFFFFD4E2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_active_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Preview Cycle Notifications',
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF1E1A3C),
                                ),
                              ),
                              Text(
                                'Test how cycle notifications appear on your phone',
                                style: AppTextStyles.caption.copyWith(
                                  color: const Color(0xFF7A708A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _triggerTestReminder('period'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Period Alert', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _triggerTestReminder('fertile'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B5CF6),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Fertile Alert', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
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
          color: const Color(0xFF7A708A),
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.large,
        boxShadow: AppShadows.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    Widget? actionRow,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
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
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeTrackColor: AppColors.primary,
            ),
          ],
        ),
        ?actionRow,
      ],
    );
  }
}
