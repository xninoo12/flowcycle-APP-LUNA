import 'package:flutter/material.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/buttons/primary_button.dart';

/// Modal bottom sheet popup for configuring reminders and notification preferences.
class RemindersSettingsSheet extends StatefulWidget {
  const RemindersSettingsSheet({super.key});

  @override
  State<RemindersSettingsSheet> createState() => _RemindersSettingsSheetState();
}

class _RemindersSettingsSheetState extends State<RemindersSettingsSheet> {
  late bool _periodAlert;
  late int _periodDaysBefore;

  late bool _fertileAlert;
  late bool _ovulationAlert;
  late bool _dailyLogPrompt;
  late TimeOfDay _dailyLogTime;

  late bool _pillReminder;
  late TimeOfDay _pillTime;
  late TextEditingController _pillNameController;

  late bool _wellnessInsights;
  late bool _discreetMode;

  @override
  void initState() {
    super.initState();
    final svc = NotificationService.instance;
    _periodAlert = svc.periodAlerts;
    _periodDaysBefore = svc.periodDaysBefore;
    _fertileAlert = svc.fertileWindowAlerts;
    _ovulationAlert = true;
    _dailyLogPrompt = svc.dailyLogReminders;
    _dailyLogTime = svc.dailyLogTime;
    _pillReminder = svc.pillReminderEnabled;
    _pillTime = svc.pillReminderTime;
    _pillNameController = TextEditingController(text: svc.pillName);
    _wellnessInsights = svc.aiHealthTips;
    _discreetMode = svc.discreetMode;
  }

  @override
  void dispose() {
    _pillNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDailyLogTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dailyLogTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7C5CE7),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E1A3C),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        _dailyLogTime = picked;
      });
    }
  }

  Future<void> _selectPillTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _pillTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFEC4899),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E1A3C),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        _pillTime = picked;
      });
    }
  }

  void _triggerTestNotification() {
    NotificationService.instance.triggerTestNotification(
      context,
      '🌸 FlowCycle: Period in $_periodDaysBefore Days',
      'Your estimated period starts soon. Self-care reminders and insights are active! ✨',
    );
  }

  void _savePreferences() {
    final svc = NotificationService.instance;
    svc.updatePeriodAlerts(enabled: _periodAlert, daysBefore: _periodDaysBefore);
    svc.updateFertileWindowAlerts(enabled: _fertileAlert);
    svc.updateDailyLogReminder(enabled: _dailyLogPrompt, time: _dailyLogTime);
    svc.updatePillReminder(
      enabled: _pillReminder,
      time: _pillTime,
      name: _pillNameController.text,
    );
    svc.updateAiHealthTips(enabled: _wellnessInsights);
    svc.updateDiscreetMode(enabled: _discreetMode);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification preferences saved ✨'),
        backgroundColor: Color(0xFF7C5CE7),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFAF7F2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      child: SafeArea(
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
                            Text('🔔', style: TextStyle(fontSize: 18.0)),
                            SizedBox(width: 6.0),
                            Text(
                              'Reminders & Alerts',
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
                          'Smart cycle notifications and timely prompts',
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
                    // 1. Discreet Lock-Screen Mode Banner
                    _buildDiscreetModeCard(),
                    const SizedBox(height: 18.0),

                    // 2. Period Prediction Alert Channel
                    _buildSectionTitle('CYCLE NOTIFICATIONS'),
                    _buildPeriodAlertCard(),
                    const SizedBox(height: 10.0),

                    // Fertile & Ovulation
                    _buildToggleTile(
                      emoji: '🌿',
                      title: 'Fertile Window & Ovulation',
                      subtitle: 'Alerts when your 6-day fertile window opens and LH peaks',
                      value: _fertileAlert,
                      onChanged: (v) => setState(() => _fertileAlert = v),
                    ),
                    const SizedBox(height: 10.0),

                    _buildToggleTile(
                      emoji: '✨',
                      title: 'Ovulation Day',
                      subtitle: 'Peak conception and LH surge notification',
                      value: _ovulationAlert,
                      onChanged: (v) => setState(() => _ovulationAlert = v),
                    ),
                    const SizedBox(height: 18.0),

                    // 3. Daily Logging & Medication Reminders
                    _buildSectionTitle('DAILY CHECK-INS & MEDICATION'),
                    _buildDailyLogCard(),
                    const SizedBox(height: 10.0),
                    _buildPillReminderCard(),
                    const SizedBox(height: 10.0),

                    _buildToggleTile(
                      emoji: '💡',
                      title: 'Phase Wellness Insights',
                      subtitle: 'Hormone-synced nutrition & exercise tips from AI',
                      value: _wellnessInsights,
                      onChanged: (v) => setState(() => _wellnessInsights = v),
                    ),
                    const SizedBox(height: 20.0),

                    // 4. Test Notification Simulation
                    Center(
                      child: OutlinedButton.icon(
                        onPressed: _triggerTestNotification,
                        icon: const Icon(
                          Icons.notifications_active_rounded,
                          size: 17.0,
                          color: Color(0xFF7C5CE7),
                        ),
                        label: Text(
                          _discreetMode
                              ? 'Simulate Discreet Push Notification 🛡️'
                              : 'Send Test In-App Notification 🔔',
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF7C5CE7),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFD6C8F7)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 10.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // 5. Save Button
                    PrimaryButton(
                      label: 'Save Notification Settings ✨',
                      gradient: AppGradients.dawnBloom,
                      height: 50.0,
                      onPressed: _savePreferences,
                    ),
                    const SizedBox(height: 12.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          color: Color(0xFF8B829D),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildDiscreetModeCard() {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: _discreetMode ? const Color(0xFFEBFDF5) : Colors.white,
        borderRadius: BorderRadius.circular(20.0),
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _discreetMode
                  ? const Color(0xFF10B981).withValues(alpha: 0.15)
                  : const Color(0xFFF1EDF8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.shield_outlined,
              color: _discreetMode
                  ? const Color(0xFF10B981)
                  : const Color(0xFF7C5CE7),
              size: 22,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Discreet Lock-Screen Mode',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1A3C),
                  ),
                ),
                SizedBox(height: 2.0),
                Text(
                  'Masks sensitive terms on lock screen with gentle self-care phrases',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF7A708A),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: _discreetMode,
            activeColor: const Color(0xFF10B981),
            onChanged: (v) => setState(() => _discreetMode = v),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodAlertCard() {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: const Color(0xFFE8E2EE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🩸', style: TextStyle(fontSize: 20.0)),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Period Prediction',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1A3C),
                      ),
                    ),
                    Text(
                      'Alert $_periodDaysBefore day${_periodDaysBefore > 1 ? 's' : ''} before your period',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF7A708A),
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: _periodAlert,
                activeColor: const Color(0xFFFF4D79),
                onChanged: (v) => setState(() => _periodAlert = v),
              ),
            ],
          ),
          if (_periodAlert) ...[
            const SizedBox(height: 12.0),
            const Divider(height: 1.0, color: Color(0xFFF1EDF8)),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Days in advance:',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5A5269),
                  ),
                ),
                Row(
                  children: [1, 2, 3].map((days) {
                    final isSelected = _periodDaysBefore == days;
                    return GestureDetector(
                      onTap: () => setState(() => _periodDaysBefore = days),
                      child: Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFFF4D79)
                              : const Color(0xFFF6F3F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$days day${days > 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF5A5269),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDailyLogCard() {
    final formattedTime = _formatTime(_dailyLogTime);

    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: const Color(0xFFE8E2EE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📝', style: TextStyle(fontSize: 20.0)),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Daily Symptom Log',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1A3C),
                      ),
                    ),
                    Text(
                      'Gentle reminder to log your daily flow & mood',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF7A708A),
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: _dailyLogPrompt,
                activeColor: const Color(0xFF7C5CE7),
                onChanged: (v) => setState(() => _dailyLogPrompt = v),
              ),
            ],
          ),
          if (_dailyLogPrompt) ...[
            const SizedBox(height: 10.0),
            const Divider(height: 1.0, color: Color(0xFFF1EDF8)),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: Color(0xFF7C5CE7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Prompt time: $formattedTime',
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7C5CE7),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: _selectDailyLogTime,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text(
                    'Change Time',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF7C5CE7),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPillReminderCard() {
    final formattedTime = _formatTime(_pillTime);

    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: const Color(0xFFE8E2EE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💊', style: TextStyle(fontSize: 20.0)),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pill & Medication Reminder',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1A3C),
                      ),
                    ),
                    Text(
                      'Daily alert for ${_pillNameController.text.isEmpty ? 'pill' : _pillNameController.text}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF7A708A),
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: _pillReminder,
                activeColor: const Color(0xFFEC4899),
                onChanged: (v) => setState(() => _pillReminder = v),
              ),
            ],
          ),
          if (_pillReminder) ...[
            const SizedBox(height: 12.0),
            const Divider(height: 1.0, color: Color(0xFFF1EDF8)),
            const SizedBox(height: 10.0),
            TextField(
              controller: _pillNameController,
              decoration: InputDecoration(
                labelText: 'Medication / Pill Name',
                labelStyle: const TextStyle(fontSize: 12),
                hintText: 'e.g. Birth Control, Prenatal, Iron',
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.alarm_rounded,
                      size: 16,
                      color: Color(0xFFEC4899),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Daily at: $formattedTime',
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFEC4899),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: _selectPillTime,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text(
                    'Change Time',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFEC4899),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildToggleTile({
    required String emoji,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
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
                    fontSize: 11.5,
                    color: Color(0xFF7A708A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: const Color(0xFFFF4D79),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}

