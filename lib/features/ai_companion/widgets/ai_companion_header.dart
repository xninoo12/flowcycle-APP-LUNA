import 'package:flutter/material.dart';

/// Top header for the AI Companion Screen with pink lotus flower logo and actions.
class AiCompanionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const AiCompanionHeader({
    super.key,
    this.title = 'AI Companion',
    this.subtitle = 'Your personal fertility & TTC guide',
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Title Column + Sparkle + Pink Lotus Logo
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
                      title,
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontWeight: FontWeight.w900,
                        fontSize: 23.0,
                        color: Color(0xFF1E1A3C),
                        letterSpacing: -0.4,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  const Text('✨', style: TextStyle(fontSize: 16.0)),
                  const SizedBox(width: 4.0),
                  const Text('🌸', style: TextStyle(fontSize: 16.0)),
                ],
              ),
              const SizedBox(height: 2.0),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF7A708A),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        const SizedBox(width: 6.0),

        // 2. Notification Bell & Profile Avatar
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular Bell Button
            Container(
              width: 36.0,
              height: 36.0,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF1ECF5), width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E1A3C).withValues(alpha: 0.03),
                    blurRadius: 4.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFF1E1A3C),
                  size: 18.0,
                ),
                padding: EdgeInsets.zero,
                tooltip: 'Notifications',
                onPressed: onNotificationTap ?? () {},
              ),
            ),

            const SizedBox(width: 6.0),

            // User Profile Avatar
            GestureDetector(
              onTap: onProfileTap ?? () {},
              child: Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFFD4E2),
                    width: 1.5,
                  ),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD4E2), Color(0xFFFFEEF3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const ClipOval(
                  child: Center(
                    child: Icon(
                      Icons.person_rounded,
                      color: Color(0xFFE84855),
                      size: 20.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
