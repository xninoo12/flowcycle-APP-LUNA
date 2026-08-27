import 'package:flutter/material.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/providers/app_scope.dart';
import 'reminders_settings_sheet.dart';

/// Modal bottom sheet popup for the In-App Notification Center & Inbox.
class NotificationCenterSheet extends StatefulWidget {
  final int initialTabIndex;

  const NotificationCenterSheet({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<NotificationCenterSheet> createState() =>
      _NotificationCenterSheetState();
}

class _NotificationCenterSheetState extends State<NotificationCenterSheet> {
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    final notificationService = NotificationService.instance;
    final controller = AppScope.of(context);
    final profile = controller.userProfile;

    return ListenableBuilder(
      listenable: notificationService,
      builder: (context, _) {
        final inbox = notificationService.inbox;
        final unreadCount = notificationService.unreadCount;
        final scheduled = notificationService.computeUpcomingReminders(profile);

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFFFAF8FC),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                // Drag Handle
                Container(
                  width: 44,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2DCE8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 12),

                // Top Header Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C5CE7).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.notifications_active_rounded,
                          color: Color(0xFF7C5CE7),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Row(
                          children: [
                            const Text(
                              'Notifications',
                              style: TextStyle(
                                fontFamily: 'serif',
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E1A3C),
                              ),
                            ),
                            if (unreadCount > 0) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE84855),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$unreadCount new',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Color(0xFF7A708A),
                          size: 22,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),

                // Segmented Tab Switcher
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE8F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildTabButton(
                            index: 0,
                            title: 'Inbox ${unreadCount > 0 ? '($unreadCount)' : ''}',
                            icon: Icons.all_inbox_rounded,
                          ),
                        ),
                        Expanded(
                          child: _buildTabButton(
                            index: 1,
                            title: 'Scheduled (${scheduled.length})',
                            icon: Icons.schedule_rounded,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(height: 1, color: Color(0xFFEFE9F3)),

                // Content View
                Flexible(
                  child: _selectedTab == 0
                      ? _buildInboxView(context, notificationService, inbox)
                      : _buildScheduledView(context, scheduled, profile),
                ),

                // Bottom Action Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (ctx) => const RemindersSettingsSheet(),
                        );
                      },
                      icon: const Icon(Icons.tune_rounded, size: 18),
                      label: const Text(
                        'Customize Reminders & Alarms',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C5CE7),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabButton({
    required int index,
    required String title,
    required IconData icon,
  }) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected
                  ? const Color(0xFF7C5CE7)
                  : const Color(0xFF7A708A),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF1E1A3C)
                      : const Color(0xFF7A708A),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInboxView(
    BuildContext context,
    NotificationService service,
    List<InAppNotificationItem> inbox,
  ) {
    if (inbox.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C5CE7).withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.done_all_rounded,
                  color: Color(0xFF7C5CE7),
                  size: 36,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'You\'re all caught up!',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: Color(0xFF1E1A3C),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'No unread alerts or notifications right now.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF7A708A),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Actions Subheader
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RECENT ALERTS',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF8B829D),
                  fontSize: 10.5,
                  letterSpacing: 0.8,
                ),
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => service.markAllAsRead(),
                    icon: const Icon(
                      Icons.mark_email_read_outlined,
                      size: 14,
                      color: Color(0xFF7C5CE7),
                    ),
                    label: const Text(
                      'Mark all read',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7C5CE7),
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // List View
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            itemCount: inbox.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = inbox[index];
              return _buildNotificationCard(context, service, item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationService service,
    InAppNotificationItem item,
  ) {
    final (icon, iconColor, bgColor) = _getNotificationStyle(item.type);

    return InkWell(
      onTap: () {
        service.markAsRead(item.id);
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: item.isRead ? Colors.white : const Color(0xFFF6F3FC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: item.isRead
                ? const Color(0xFFEFE9F3)
                : const Color(0xFF7C5CE7).withValues(alpha: 0.3),
            width: item.isRead ? 1 : 1.5,
          ),
          boxShadow: AppShadows.subtle,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                item.isRead ? FontWeight.w700 : FontWeight.w900,
                            color: const Color(0xFF1E1A3C),
                          ),
                        ),
                      ),
                      if (!item.isRead) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF7C5CE7),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.body,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF5A5269),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatTimeAgo(item.timestamp),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFA59DB2),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                size: 16,
                color: Color(0xFFA59DB2),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => service.deleteNotification(item.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduledView(
    BuildContext context,
    List<ScheduledReminder> reminders,
    UserProfile profile,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'UPCOMING ACTIVE REMINDERS',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF8B829D),
                  fontSize: 10.5,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                NotificationService.instance.discreetMode
                    ? '🛡️ Discreet Mode ON'
                    : 'Standard Mode',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: NotificationService.instance.discreetMode
                      ? const Color(0xFF10B981)
                      : const Color(0xFF7A708A),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            itemCount: reminders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final reminder = reminders[index];
              return _buildScheduledCard(context, reminder);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildScheduledCard(BuildContext context, ScheduledReminder reminder) {
    final (icon, iconColor, bgColor) = _getNotificationStyle(reminder.type);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEFE9F3)),
        boxShadow: AppShadows.subtle,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        reminder.title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E1A3C),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBFDF5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF10B981).withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Text(
                        'Active',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  reminder.body,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF5A5269),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.alarm_on_rounded,
                      size: 13,
                      color: Color(0xFF7C5CE7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      reminder.timeLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7C5CE7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  (IconData, Color, Color) _getNotificationStyle(ReminderType type) {
    switch (type) {
      case ReminderType.periodOnset:
        return (
          Icons.water_drop_rounded,
          const Color(0xFFE84855),
          const Color(0xFFFFECEF),
        );
      case ReminderType.fertileWindow:
        return (
          Icons.auto_awesome_rounded,
          const Color(0xFFF59E0B),
          const Color(0xFFFEF3C7),
        );
      case ReminderType.dailyLog:
        return (
          Icons.edit_calendar_rounded,
          const Color(0xFF7C5CE7),
          const Color(0xFFEDE8F5),
        );
      case ReminderType.medicationPill:
        return (
          Icons.medication_rounded,
          const Color(0xFFEC4899),
          const Color(0xFFFDF2F8),
        );
      case ReminderType.phaseShift:
        return (
          Icons.spa_rounded,
          const Color(0xFF10B981),
          const Color(0xFFEBFDF5),
        );
      case ReminderType.aiHealthTip:
        return (
          Icons.psychology_rounded,
          const Color(0xFF6366F1),
          const Color(0xFFEEF2FF),
        );
    }
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes.clamp(1, 59)} min ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hr${diff.inHours == 1 ? '' : 's'} ago';
    } else {
      return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
    }
  }
}
