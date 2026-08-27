import 'package:flutter/material.dart';
import '../../../core/services/notification_service.dart';

/// Modal bottom sheet for configuring AI Smart Reminders & Notifications.
class SmartRemindersSheet extends StatefulWidget {
  const SmartRemindersSheet({super.key});

  @override
  State<SmartRemindersSheet> createState() => _SmartRemindersSheetState();
}

class _SmartRemindersSheetState extends State<SmartRemindersSheet> {
  late bool _periodAlerts;
  late bool _fertileAlerts;
  late bool _dailyLogReminders;
  late bool _aiDailyTip;
  final String _dailyLogTime = '8:00 PM';
  final String _periodAlertTime = '2:00 PM';

  @override
  void initState() {
    super.initState();
    final svc = NotificationService.instance;
    _periodAlerts = svc.periodAlerts;
    _fertileAlerts = svc.fertileWindowAlerts;
    _dailyLogReminders = svc.dailyLogReminders;
    _aiDailyTip = svc.aiHealthTips;
  }

  void _savePreferences() {
    final svc = NotificationService.instance;
    svc.updatePeriodAlerts(enabled: _periodAlerts);
    svc.updateFertileWindowAlerts(enabled: _fertileAlerts);
    svc.updateDailyLogReminder(enabled: _dailyLogReminders);
    svc.updateAiHealthTips(enabled: _aiDailyTip);

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Smart reminders preferences updated!'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF7C5CE7),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 24.0),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Drag Handle
              Center(
                child: Container(
                  width: 36.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCD6E5),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),

              const SizedBox(height: 14.0),

              // Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Smart Reminders',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E1A3C),
                      letterSpacing: -0.2,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 28.0,
                      height: 28.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF4F0F8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 16.0,
                        color: Color(0xFF5A5068),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4.0),

              const Text(
                'Personalized alerts powered by your cycle insights.',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7A708A),
                ),
              ),

              const SizedBox(height: 16.0),

              // 1. Period Alerts Card
              _buildReminderCard(
                icon: Icons.notifications_active_rounded,
                iconColor: const Color(0xFF7C5CE7),
                title: 'Period Alerts',
                subtitle: '2 days before expected flow • $_periodAlertTime',
                value: _periodAlerts,
                onChanged: (val) => setState(() => _periodAlerts = val),
              ),

              const SizedBox(height: 10.0),

              // 2. Fertile Window Alerts Card
              _buildReminderCard(
                icon: Icons.water_drop_rounded,
                iconColor: const Color(0xFFE11D48),
                title: 'Fertile Window alerts',
                subtitle: 'Notifies when your peak chance begins',
                value: _fertileAlerts,
                onChanged: (val) => setState(() => _fertileAlerts = val),
              ),

              const SizedBox(height: 10.0),

              // 3. Daily Log Reminders Card
              _buildReminderCard(
                icon: Icons.edit_calendar_rounded,
                iconColor: const Color(0xFF10B981),
                title: 'Daily Log reminders',
                subtitle: 'Gentle evening nudge • $_dailyLogTime',
                value: _dailyLogReminders,
                onChanged: (val) => setState(() => _dailyLogReminders = val),
              ),

              const SizedBox(height: 10.0),

              // 4. AI Daily Health Tip Card
              _buildReminderCard(
                icon: Icons.lightbulb_outline_rounded,
                iconColor: const Color(0xFFF59E0B),
                title: 'AI Daily Health Tip',
                subtitle: 'Morning cycle wisdom and nutrition ideas',
                value: _aiDailyTip,
                onChanged: (val) => setState(() => _aiDailyTip = val),
              ),

              const SizedBox(height: 20.0),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 44.0,
                child: ElevatedButton(
                  onPressed: _savePreferences,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C5CE7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    elevation: 2.0,
                  ),
                  child: const Text(
                    'Save Preferences',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReminderCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8FC),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFEFE9F3), width: 1.0),
      ),
      child: Row(
        children: [
          Container(
            width: 36.0,
            height: 36.0,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18.0, color: iconColor),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1A3C),
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7A708A),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF7C5CE7),
            activeTrackColor: const Color(0xFFE5DBFF),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFE0D8E6),
          ),
        ],
      ),
    );
  }
}
