import 'package:flutter/material.dart';

/// Top header for the Profile Screen matching exact UI specs.
class ProfileHeader extends StatelessWidget {
  final VoidCallback? onNotificationTap;

  const ProfileHeader({super.key, this.onNotificationTap});

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title, back button, and subtitle
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (canPop) ...[
              Padding(
                padding: const EdgeInsets.only(right: 12.0, top: 4.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).maybePop(),
                  child: Container(
                    width: 38.0,
                    height: 38.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFEFE9F3), width: 1.0),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16.0,
                      color: Color(0xFF1E1A3C),
                    ),
                  ),
                ),
              ),
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1A3C),
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 3.0),
                Text(
                  'Manage your account, preferences\nand app settings.',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7A708A),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Notification Bell with hot pink badge dot
        GestureDetector(
          onTap: onNotificationTap,
          child: Container(
            width: 42.0,
            height: 42.0,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFEFE9F3), width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E1A3C).withValues(alpha: 0.04),
                  blurRadius: 8.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF1E1A3C),
                  size: 23.0,
                ),
                Positioned(
                  top: 9.0,
                  right: 10.0,
                  child: Container(
                    width: 8.5,
                    height: 8.5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE84D75),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
