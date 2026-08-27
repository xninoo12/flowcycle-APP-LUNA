import 'package:flutter/material.dart';
import '../../shared/models/app_mode.dart';
import '../../shared/models/user_profile.dart';

enum ReminderType { periodOnset, fertileWindow, dailyLog, aiHealthTip }

class ScheduledReminder {
  final String id;
  final ReminderType type;
  final String title;
  final String body;
  final String timeLabel;
  final bool isEnabled;

  const ScheduledReminder({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.timeLabel,
    required this.isEnabled,
  });
}

/// Central Notification & Local Reminder Engine for FlowCycle.
class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  static NotificationService get instance => _instance;

  NotificationService._internal();

  bool _periodAlerts = true;
  int _periodDaysBefore = 2; // 2 days before

  bool _fertileWindowAlerts = true;
  int _fertileDaysBefore = 1; // 1 day before

  bool _dailyLogReminders = true;
  TimeOfDay _dailyLogTime = const TimeOfDay(hour: 20, minute: 0); // 8:00 PM

  bool _aiHealthTips = true;

  // Getters
  bool get periodAlerts => _periodAlerts;
  int get periodDaysBefore => _periodDaysBefore;

  bool get fertileWindowAlerts => _fertileWindowAlerts;
  int get fertileDaysBefore => _fertileDaysBefore;

  bool get dailyLogReminders => _dailyLogReminders;
  TimeOfDay get dailyLogTime => _dailyLogTime;

  bool get aiHealthTips => _aiHealthTips;

  void showInAppNotification({String? title, String? body}) {
    notifyListeners();
  }

  void updatePeriodAlerts({required bool enabled, int? daysBefore}) {
    _periodAlerts = enabled;
    if (daysBefore != null) _periodDaysBefore = daysBefore;
    notifyListeners();
  }

  void updateFertileWindowAlerts({required bool enabled, int? daysBefore}) {
    _fertileWindowAlerts = enabled;
    if (daysBefore != null) _fertileDaysBefore = daysBefore;
    notifyListeners();
  }

  void updateDailyLogReminder({required bool enabled, TimeOfDay? time}) {
    _dailyLogReminders = enabled;
    if (time != null) _dailyLogTime = time;
    notifyListeners();
  }

  void updateAiHealthTips({required bool enabled}) {
    _aiHealthTips = enabled;
    notifyListeners();
  }

  /// Explicitly schedules cycle reminders given key milestone dates.
  Future<void> scheduleCycleReminders({
    required DateTime nextPeriodDate,
    required DateTime fertileWindowStartDate,
    int? periodReminderDaysAhead,
    int? fertileReminderDaysAhead,
  }) async {
    if (periodReminderDaysAhead != null) {
      _periodDaysBefore = periodReminderDaysAhead;
    }
    if (fertileReminderDaysAhead != null) {
      _fertileDaysBefore = fertileReminderDaysAhead;
    }
    notifyListeners();
  }

  /// Cancels all active and scheduled reminders.
  Future<void> cancelAllReminders() async {
    _periodAlerts = false;
    _fertileWindowAlerts = false;
    _dailyLogReminders = false;
    _aiHealthTips = false;
    notifyListeners();
  }

  /// Calculates upcoming reminder schedule based on user's active cycle
  List<ScheduledReminder> computeUpcomingReminders(UserProfile profile) {
    final reminders = <ScheduledReminder>[];
    final isTtc = profile.mode == AppMode.tryingToConceive;

    // 1. Period Reminder
    if (_periodAlerts) {
      final nextPeriodDate = profile.lastPeriodStartDate.add(
        Duration(days: profile.averageCycleLength),
      );
      final alertDate = nextPeriodDate.subtract(
        Duration(days: _periodDaysBefore),
      );

      reminders.add(
        ScheduledReminder(
          id: 'rem_period_onset',
          type: ReminderType.periodOnset,
          title: 'Period Approaching in $_periodDaysBefore Days 🌸',
          body:
              'Your estimated period starts on ${_formatShortDate(nextPeriodDate)}. Have self-care items ready!',
          timeLabel: '${_formatShortDate(alertDate)} at 9:00 AM',
          isEnabled: _periodAlerts,
        ),
      );
    }

    // 2. Fertile Window Reminder
    if (_fertileWindowAlerts) {
      final estOvulationDay = (profile.averageCycleLength - 14).clamp(10, 20);
      final fertileStartDate = profile.lastPeriodStartDate.add(
        Duration(days: estOvulationDay - 5),
      );
      final alertDate = fertileStartDate.subtract(
        Duration(days: _fertileDaysBefore),
      );

      reminders.add(
        ScheduledReminder(
          id: 'rem_fertile_window',
          type: ReminderType.fertileWindow,
          title: isTtc
              ? 'Peak Conception Window Opening 🌟'
              : 'Fertile Window Approaching 🌿',
          body: isTtc
              ? 'Your high-fertility window begins ${_formatShortDate(fertileStartDate)}. Log your BBT & cervical fluid!'
              : 'Estrogen is rising as your fertile window begins on ${_formatShortDate(fertileStartDate)}.',
          timeLabel: '${_formatShortDate(alertDate)} at 8:30 AM',
          isEnabled: _fertileWindowAlerts,
        ),
      );
    }

    // 3. Daily Log Reminder
    if (_dailyLogReminders) {
      reminders.add(
        ScheduledReminder(
          id: 'rem_daily_log',
          type: ReminderType.dailyLog,
          title: 'Evening Cycle Check-in 🌙',
          body:
              'How are you feeling tonight? Log today’s mood, symptoms, and self-care.',
          timeLabel: 'Daily at ${_formatTime(_dailyLogTime)}',
          isEnabled: _dailyLogReminders,
        ),
      );
    }

    // 4. AI Health Tip
    if (_aiHealthTips) {
      reminders.add(
        const ScheduledReminder(
          id: 'rem_ai_health_tip',
          type: ReminderType.aiHealthTip,
          title: 'Daily AI Cycle Wisdom ✨',
          body:
              'Personalized nutrition and hormonal tips tailored to today’s phase.',
          timeLabel: 'Daily at 10:00 AM',
          isEnabled: true,
        ),
      );
    }

    return reminders;
  }

  void triggerTestNotification(
    BuildContext context,
    String title,
    String body,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.notifications_active_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12.5,
                    ),
                  ),
                  Text(
                    body,
                    style: const TextStyle(
                      fontSize: 11.0,
                      color: Colors.white70,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF7C5CE7),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  String _formatShortDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
