import 'package:flutter/material.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../shared/widgets/buttons/primary_button.dart';

/// Modal bottom sheet popup for configuring reminders and notification preferences.
class RemindersSettingsSheet extends StatefulWidget {
  const RemindersSettingsSheet({super.key});

  @override
  State<RemindersSettingsSheet> createState() => _RemindersSettingsSheetState();
}

class _RemindersSettingsSheetState extends State<RemindersSettingsSheet> {
  bool _periodAlert = true;
  bool _fertileAlert = true;
  bool _ovulationAlert = true;
  bool _dailyLogPrompt = true;
  bool _wellnessInsights = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF4D79),
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
        _reminderTime = picked;
      });
    }
  }

  void _triggerTestNotification() {
    NotificationService.instance.showInAppNotification(
      title: '🌸 FlowCycle Reminder',
      body: 'Your fertile window begins tomorrow! Log your symptoms today. ✨',
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test notification sent! 🔔'),
        backgroundColor: Color(0xFFFF4D79),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _savePreferences() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reminder preferences saved ✨'),
        backgroundColor: Color(0xFFFF4D79),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime =
        '${_reminderTime.hourOfPeriod == 0 ? 12 : _reminderTime.hourOfPeriod}:${_reminderTime.minute.toString().padLeft(2, '0')} ${_reminderTime.period == DayPeriod.am ? 'AM' : 'PM'}';

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
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
                  // Reminder Time Row
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: const Color(0xFFE8E2EE),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 38.0,
                              height: 38.0,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF0F5),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.access_time_filled_rounded,
                                  color: Color(0xFFFF4D79),
                                  size: 20.0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Daily Reminder Time',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1E1A3C),
                                  ),
                                ),
                                Text(
                                  formattedTime,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFFF4D79),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        OutlinedButton(
                          onPressed: _selectTime,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFFD1DC)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 6.0,
                            ),
                          ),
                          child: const Text(
                            'Edit Time',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFF4D79),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // Toggles Section
                  const Text(
                    'Cycle Alert Channels',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E1A3C),
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  _buildToggleTile(
                    emoji: '🩸',
                    title: 'Period Prediction',
                    subtitle: 'Alert 2 days before your expected period',
                    value: _periodAlert,
                    onChanged: (v) => setState(() => _periodAlert = v),
                  ),
                  const SizedBox(height: 10.0),

                  _buildToggleTile(
                    emoji: '🌿',
                    title: 'Fertile Window',
                    subtitle: 'Alerts when your 6-day fertile window opens',
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
                  const SizedBox(height: 10.0),

                  _buildToggleTile(
                    emoji: '📝',
                    title: 'Daily Symptom Log',
                    subtitle: 'Gentle evening reminder to log your daily flow & mood',
                    value: _dailyLogPrompt,
                    onChanged: (v) => setState(() => _dailyLogPrompt = v),
                  ),
                  const SizedBox(height: 10.0),

                  _buildToggleTile(
                    emoji: '💡',
                    title: 'Phase Wellness Insights',
                    subtitle: 'Hormone-synced nutrition & exercise tips',
                    value: _wellnessInsights,
                    onChanged: (v) => setState(() => _wellnessInsights = v),
                  ),

                  const SizedBox(height: 20.0),

                  // Test notification button
                  Center(
                    child: TextButton.icon(
                      onPressed: _triggerTestNotification,
                      icon: const Icon(
                        Icons.send_rounded,
                        size: 16.0,
                        color: Color(0xFFFF4D79),
                      ),
                      label: const Text(
                        'Send Test In-App Notification',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFF4D79),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12.0),

                  // Save Button
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
}
