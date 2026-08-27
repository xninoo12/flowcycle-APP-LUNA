import 'package:flutter/material.dart';

/// User Account Card displaying avatar with camera badge, Amina Yusuf, email, joined date, and PRO badge.
class UserAccountCard extends StatelessWidget {
  final String userName;
  final VoidCallback? onEditName;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onProTap;

  const UserAccountCard({
    super.key,
    this.userName = 'Amina Yusuf',
    this.onEditName,
    this.onAvatarTap,
    this.onProTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.0),
        border: Border.all(color: const Color(0xFFF0EBF5), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1A3C).withValues(alpha: 0.04),
            blurRadius: 12.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. User Avatar with Camera Badge
          GestureDetector(
            onTap: onAvatarTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Pink Gradient Avatar Outer Ring
                Container(
                  width: 68.0,
                  height: 68.0,
                  padding: const EdgeInsets.all(2.5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFB8D0), Color(0xFFFF85A1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF0F5),
                      shape: BoxShape.circle,
                    ),
                    child: const ClipOval(
                      child: Center(
                        child: Icon(
                          Icons.person_rounded,
                          color: Color(0xFFE84D75),
                          size: 44.0,
                        ),
                      ),
                    ),
                  ),
                ),

                // Camera Action Badge
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 22.0,
                    height: 22.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE84D75),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.0),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 11.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 14.0),

          // 2. User Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name & Edit Icon
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E1A3C),
                          letterSpacing: -0.3,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    GestureDetector(
                      onTap: onEditName,
                      child: Container(
                        padding: const EdgeInsets.all(3.0),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFDE8EF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          color: Color(0xFFE84D75),
                          size: 10.5,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5.0),

                // Email
                Row(
                  children: const [
                    Icon(
                      Icons.mail_outline_rounded,
                      size: 13.0,
                      color: Color(0xFF8C7C92),
                    ),
                    SizedBox(width: 5.0),
                    Expanded(
                      child: Text(
                        'amina.yusuf@email.com',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF7A708A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 3.5),

                // Joined Date
                Row(
                  children: const [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 12.5,
                      color: Color(0xFF8C7C92),
                    ),
                    SizedBox(width: 5.0),
                    Expanded(
                      child: Text(
                        'Joined May 2024',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF7A708A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 6.0),

          // 3. PRO Badge
          GestureDetector(
            onTap: onProTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 6.0,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F0FD),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: const Color(0xFFEBE0FA), width: 1.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.workspace_premium_rounded,
                    color: Color(0xFF8B5CF6),
                    size: 15.0,
                  ),
                  SizedBox(width: 4.0),
                  Text(
                    'PRO',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF8B5CF6),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(width: 2.0),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF8B5CF6),
                    size: 15.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
