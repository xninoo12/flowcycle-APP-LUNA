import 'package:flutter/material.dart';
import '../../../core/theme/flow_cycle_theme_extension.dart';
import '../../../shared/widgets/brand/flow_cycle_brand_header.dart';

/// Top Header & Hero section for the Profile Screen matching the exact mockup.
///
/// Features:
/// - Brand logo (🌸 FlowCycle 🍃) with tagline ("Know your body. Live better. ✨")
/// - Top action buttons: Notification Bell (with unread dot) and Settings Gear
/// - Center portrait avatar with glowing aura and crown badge 👑
/// - Flying butterfly 🦋 with sparkle trail and botanical leaf accents
/// - User name (Amina 💗) with edit pencil icon (✏️) and status tags (Healthy • Confident • In control)
class ProfileHeaderHero extends StatelessWidget {
  final String userName;
  final VoidCallback? onEditName;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onAvatarTap;

  const ProfileHeaderHero({
    super.key,
    this.userName = 'Amina',
    this.onEditName,
    this.onNotificationTap,
    this.onSettingsTap,
    this.onAvatarTap,
  });

  String _cleanUserName(String name) {
    if (name.isEmpty) return 'Amina';
    return name.split('(').first.trim();
  }

  @override
  Widget build(BuildContext context) {
    final cleanName = _cleanUserName(userName);
    final theme = context.flowTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Top Header Row: Brand Logo + Tagline (Left) & Actions (Right)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Brand Logo & Tagline
            const FlowCycleBrandHeader(
              crossAxisAlignment: CrossAxisAlignment.start,
              size: BrandHeaderSize.standard,
              showTagline: true,
            ),

            // Right: Notification Bell (with unread dot) & Settings Gear
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Notification Bell with unread dot
                Container(
                  width: 38.0,
                  height: 38.0,
                  decoration: BoxDecoration(
                    color: theme.cardBackground,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.cardBorder,
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.isDark
                            ? Colors.black.withValues(alpha: 0.25)
                            : const Color(0xFF1E1A3C).withValues(alpha: 0.03),
                        blurRadius: 4.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.notifications_none_rounded,
                          color: theme.textPrimary,
                          size: 20.0,
                        ),
                        padding: EdgeInsets.zero,
                        tooltip: 'Notifications',
                        onPressed: onNotificationTap ?? () {},
                      ),
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: Container(
                          width: 7.0,
                          height: 7.0,
                          decoration: BoxDecoration(
                            color: theme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8.0),

                // Settings Gear Button
                Container(
                  width: 38.0,
                  height: 38.0,
                  decoration: BoxDecoration(
                    color: theme.cardBackground,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.cardBorder,
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.isDark
                            ? Colors.black.withValues(alpha: 0.25)
                            : const Color(0xFF1E1A3C).withValues(alpha: 0.03),
                        blurRadius: 4.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.settings_outlined,
                      color: theme.textPrimary,
                      size: 20.0,
                    ),
                    padding: EdgeInsets.zero,
                    tooltip: 'Settings',
                    onPressed: onSettingsTap ?? () {},
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 10.0),

        // 2. Hero Visual: Avatar + Crown + Butterfly + Botanical Sparks
        SizedBox(
          height: 100.0,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Left Botanical Leaves
              Positioned(
                left: 0,
                bottom: 0,
                child: Opacity(
                  opacity: 0.85,
                  child: Image.asset(
                    'assets/images/cycle_wellness_flower.png',
                    width: 70.0,
                    height: 70.0,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Text(
                      '🌸',
                      style: TextStyle(fontSize: 40.0),
                    ),
                  ),
                ),
              ),

              // Right Botanical Leaves
              Positioned(
                right: 0,
                bottom: 0,
                child: Opacity(
                  opacity: 0.85,
                  child: Image.asset(
                    'assets/images/ttc_flower.png',
                    width: 70.0,
                    height: 70.0,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Text(
                      '🌸',
                      style: TextStyle(fontSize: 40.0),
                    ),
                  ),
                ),
              ),

              // Center: Glowing Avatar Circle + Crown Badge
              GestureDetector(
                onTap: onAvatarTap ?? onEditName,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Outer Soft Aura Glow
                    Container(
                      width: 86.0,
                      height: 86.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.auraGlow.withValues(alpha: 0.32),
                            blurRadius: 18.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                    ),

                    // Avatar Circle with white and gold border
                    Container(
                      width: 76.0,
                      height: 76.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E1A3C).withValues(alpha: 0.12),
                            blurRadius: 10.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/profile_avatar_portrait.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            decoration: BoxDecoration(
                              gradient: theme.primaryGradient,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person_rounded,
                                color: Colors.white,
                                size: 40.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Crown Badge 👑 at Top Right of Avatar
                    Positioned(
                      top: -4.0,
                      right: -4.0,
                      child: Container(
                        width: 22.0,
                        height: 22.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFEF3C7),
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                              blurRadius: 4.0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            '👑',
                            style: TextStyle(fontSize: 11.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Flying 3D Butterfly 🦋 with golden sparkle trail on the right
              Positioned(
                right: 75.0,
                top: 8.0,
                child: SizedBox(
                  width: 50.0,
                  height: 45.0,
                  child: Stack(
                    children: [
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Image.asset(
                          'assets/images/profile_butterfly.png',
                          width: 32.0,
                          height: 32.0,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => const Text(
                            '🦋',
                            style: TextStyle(fontSize: 24.0),
                          ),
                        ),
                      ),
                      const Positioned(
                        left: 4,
                        bottom: 4,
                        child: Text(
                          '✦',
                          style: TextStyle(
                            color: Color(0xFFF59E0B),
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6.0),

        // 3. User Name Row: "Amina" + "💗" + Edit Pencil Button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              cleanName,
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 22.0,
                fontWeight: FontWeight.w900,
                color: theme.textPrimary,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(width: 4.0),
            const Text(
              '💗',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(width: 8.0),
            // Edit Profile Pill Button with word 'Edit' & pen icon
            InkWell(
              onTap: onEditName,
              borderRadius: BorderRadius.circular(14.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: theme.chipBackground,
                  borderRadius: BorderRadius.circular(14.0),
                  border: Border.all(
                    color: theme.chipBorder,
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primary.withValues(alpha: 0.1),
                      blurRadius: 4.0,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit_rounded,
                      size: 12.0,
                      color: theme.primary,
                    ),
                    const SizedBox(width: 3.5),
                    Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: theme.primary,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 4.0),

        // 4. Status Tags: "Healthy  •  Confident  •  In control"
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Healthy',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: theme.textSecondary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Text(
                '•',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: theme.primary,
                ),
              ),
            ),
            Text(
              'Confident',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: theme.textSecondary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Text(
                '•',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: theme.primary,
                ),
              ),
            ),
            Text(
              'In control',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: theme.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
