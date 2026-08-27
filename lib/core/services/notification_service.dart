import 'package:flutter/material.dart';
import '../../shared/models/app_mode.dart';
import '../../shared/models/user_profile.dart';

enum ReminderType {
  periodOnset,
  fertileWindow,
  dailyLog,
  medicationPill,
  aiHealthTip,
  phaseShift,
}

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

class InAppNotificationItem {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final ReminderType type;
  final bool isRead;
  final String? actionRoute;

  const InAppNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.actionRoute,
  });

  InAppNotificationItem copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? timestamp,
    ReminderType? type,
    bool? isRead,
    String? actionRoute,
  }) {
    return InAppNotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      actionRoute: actionRoute ?? this.actionRoute,
    );
  }
}

/// Central Notification & Local Reminder Engine for FlowCycle.
class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  static NotificationService get instance => _instance;

  NotificationService._internal() {
    _initDefaultInbox();
  }

  bool _periodAlerts = true;
  int _periodDaysBefore = 2; // 2 days before

  bool _fertileWindowAlerts = true;
  int _fertileDaysBefore = 1; // 1 day before

  bool _dailyLogReminders = true;
  TimeOfDay _dailyLogTime = const TimeOfDay(hour: 20, minute: 0); // 8:00 PM

  bool _pillReminderEnabled = false;
  TimeOfDay _pillReminderTime = const TimeOfDay(hour: 9, minute: 0); // 9:00 AM
  String _pillName = 'Daily Pill';

  bool _aiHealthTips = true;
  bool _discreetMode = false;

  final List<InAppNotificationItem> _inbox = [];

  // Getters
  bool get periodAlerts => _periodAlerts;
  int get periodDaysBefore => _periodDaysBefore;

  bool get fertileWindowAlerts => _fertileWindowAlerts;
  int get fertileDaysBefore => _fertileDaysBefore;

  bool get dailyLogReminders => _dailyLogReminders;
  TimeOfDay get dailyLogTime => _dailyLogTime;

  bool get pillReminderEnabled => _pillReminderEnabled;
  TimeOfDay get pillReminderTime => _pillReminderTime;
  String get pillName => _pillName;

  bool get aiHealthTips => _aiHealthTips;
  bool get discreetMode => _discreetMode;

  List<InAppNotificationItem> get inbox => List.unmodifiable(_inbox);
  int get unreadCount => _inbox.where((item) => !item.isRead).length;

  void _initDefaultInbox() {
    final now = DateTime.now();
    _inbox.addAll([
      InAppNotificationItem(
        id: 'notif_welcome',
        title: 'Welcome to FlowCycle Notifications 🔔',
        body:
            'Smart cycle forecasts and personalized health prompts are now active.',
        timestamp: now.subtract(const Duration(hours: 3)),
        type: ReminderType.aiHealthTip,
        isRead: false,
      ),
      InAppNotificationItem(
        id: 'notif_phase_update',
        title: 'Phase Insight: Follicular Energy 🌿',
        body:
            'Estrogen is rising! Ideal time for high-energy tasks and strength training.',
        timestamp: now.subtract(const Duration(hours: 18)),
        type: ReminderType.phaseShift,
        isRead: false,
      ),
      InAppNotificationItem(
        id: 'notif_privacy_reminder',
        title: 'Discreet Mode Available 🛡️',
        body:
            'Enable Discreet Mode in Settings to mask sensitive terms on lock screen banners.',
        timestamp: now.subtract(const Duration(days: 1, hours: 2)),
        type: ReminderType.aiHealthTip,
        isRead: true,
      ),
    ]);
  }

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

  void updatePillReminder({
    required bool enabled,
    TimeOfDay? time,
    String? name,
  }) {
    _pillReminderEnabled = enabled;
    if (time != null) _pillReminderTime = time;
    if (name != null && name.trim().isNotEmpty) _pillName = name.trim();
    notifyListeners();
  }

  void updateAiHealthTips({required bool enabled}) {
    _aiHealthTips = enabled;
    notifyListeners();
  }

  void updateDiscreetMode({required bool enabled}) {
    _discreetMode = enabled;
    notifyListeners();
  }

  // --- Inbox Management ---
  void markAsRead(String id) {
    final index = _inbox.indexWhere((item) => item.id == id);
    if (index != -1 && !_inbox[index].isRead) {
      _inbox[index] = _inbox[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < _inbox.length; i++) {
      if (!_inbox[i].isRead) {
        _inbox[i] = _inbox[i].copyWith(isRead: true);
      }
    }
    notifyListeners();
  }

  void deleteNotification(String id) {
    _inbox.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearAllNotifications() {
    _inbox.clear();
    notifyListeners();
  }

  void addNotification({
    required String title,
    required String body,
    required ReminderType type,
    String? actionRoute,
  }) {
    _inbox.insert(
      0,
      InAppNotificationItem(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        body: body,
        timestamp: DateTime.now(),
        type: type,
        isRead: false,
        actionRoute: actionRoute,
      ),
    );
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
    _pillReminderEnabled = false;
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

      final originalTitle = 'Period Approaching in $_periodDaysBefore Days 🌸';
      final originalBody =
          'Your estimated period starts on ${_formatShortDate(nextPeriodDate)}. Have self-care items ready!';

      reminders.add(
        ScheduledReminder(
          id: 'rem_period_onset',
          type: ReminderType.periodOnset,
          title: _discreetMode
              ? 'FlowCycle: Time for self-care 🌸'
              : originalTitle,
          body: _discreetMode
              ? 'A gentle reminder from FlowCycle. Check in when you have a moment.'
              : originalBody,
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

      final originalTitle = isTtc
          ? 'Peak Conception Window Opening 🌟'
          : 'Fertile Window Approaching 🌿';
      final originalBody = isTtc
          ? 'Your high-fertility window begins ${_formatShortDate(fertileStartDate)}. Log your BBT & cervical fluid!'
          : 'Estrogen is rising as your fertile window begins on ${_formatShortDate(fertileStartDate)}.';

      reminders.add(
        ScheduledReminder(
          id: 'rem_fertile_window',
          type: ReminderType.fertileWindow,
          title: _discreetMode
              ? 'FlowCycle: Daily rhythm update 🌿'
              : originalTitle,
          body: _discreetMode
              ? 'Your personal health window is active. Open FlowCycle to review today’s notes.'
              : originalBody,
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
          title: _discreetMode
              ? 'Evening Check-in ✨'
              : 'Evening Cycle Check-in 🌙',
          body: _discreetMode
              ? 'Take a quick minute for your daily reflection.'
              : 'How are you feeling tonight? Log today’s mood, symptoms, and self-care.',
          timeLabel: 'Daily at ${_formatTime(_dailyLogTime)}',
          isEnabled: _dailyLogReminders,
        ),
      );
    }

    // 4. Medication / Pill Reminder
    if (_pillReminderEnabled) {
      reminders.add(
        ScheduledReminder(
          id: 'rem_medication_pill',
          type: ReminderType.medicationPill,
          title: _discreetMode
              ? 'Daily Health Reminder 💊'
              : '$_pillName Reminder 💊',
          body: _discreetMode
              ? 'Time for your scheduled wellness routine.'
              : 'Don’t forget to take your $_pillName today!',
          timeLabel: 'Daily at ${_formatTime(_pillReminderTime)}',
          isEnabled: _pillReminderEnabled,
        ),
      );
    }

    // 5. AI Health Tip
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
    final displayTitle = _discreetMode
        ? 'FlowCycle: Time for self-care 🌸'
        : title;
    final displayBody = _discreetMode
        ? 'A gentle reminder from FlowCycle. Check in when you have a moment.'
        : body;

    // Add to in-app inbox
    addNotification(
      title: displayTitle,
      body: displayBody,
      type: ReminderType.periodOnset,
    );

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
                    displayTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12.5,
                    ),
                  ),
                  Text(
                    displayBody,
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
