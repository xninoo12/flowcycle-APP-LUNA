import 'package:flutter/material.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Top header for the FlowCycle Main Dashboard.
///
/// Features circular female profile avatar on the left, greeting "Good morning, Amina 👋",
/// dynamic subtitle ("You're in tune with your body ✨" or "You're one step closer to your goal ✨"),
/// and notification bell with pink unread badge.
class DashboardTopHeader extends StatelessWidget {
  final String userName;
  final String? subtitle;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const DashboardTopHeader({
    super.key,
    this.userName = 'Amina',
    this.subtitle,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSubtitle = subtitle ?? "You're in tune with your body ✨";
    final notificationService = NotificationService.instance;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Profile Avatar + Greeting
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Female Profile Avatar
              Semantics(
                button: true,
                label: 'Profile',
                child: GestureDetector(
                  onTap: onProfileTap ?? () {},
                  child: Container(
                    width: 42.0,
                    height: 42.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFEEF3),
                      border: Border.all(
                        color: const Color(0xFFFFD1DC),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF4D79).withValues(alpha: 0.12),
                          blurRadius: 8.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/user_avatar.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Icon(
                            Icons.person_rounded,
                            color: Color(0xFFFF4D79),
                            size: 22.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.sm + 2.0),

              // Greeting & Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            'Good morning, $userName',
                            style: AppTextStyles.subtitle.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 17.5,
                              color: const Color(0xFF1E1A3C),
                              letterSpacing: -0.3,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        const Text('👋', style: TextStyle(fontSize: 15.0)),
                      ],
                    ),
                    const SizedBox(height: 1.0),
                    Text(
                      effectiveSubtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: const Color(0xFF8C829A),
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: AppSpacing.sm),

        // 2. Notifications Bell with Dynamic Pink Unread Badge
        ListenableBuilder(
          listenable: notificationService,
          builder: (context, _) {
            final unread = notificationService.unreadCount;
            return Semantics(
              button: true,
              label: 'Notifications',
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFFF3E8EE),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E1A3C).withValues(alpha: 0.03),
                          blurRadius: 8.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: Color(0xFF1E1A3C),
                        size: 22.0,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'Notifications',
                      onPressed: onNotificationTap ?? () {},
                    ),
                  ),
                  if (unread > 0)
                    Positioned(
                      top: 2.0,
                      right: 2.0,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF4D79),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          '$unread',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

