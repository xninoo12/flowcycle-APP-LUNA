import 'package:flutter/material.dart';

/// "Support & About" 2x2 Grid Card matching the exact mockup.
///
/// Features:
/// - Blue question mark badge + script title ("Support & About")
/// - 2x2 Grid:
///   1. Help Center | Rate FlowCycle
///   2. Contact Us  | About FlowCycle
class ProfileSupportAboutCard extends StatelessWidget {
  final VoidCallback? onHelpCenterTap;
  final VoidCallback? onRateAppTap;
  final VoidCallback? onContactUsTap;
  final VoidCallback? onAboutTap;

  const ProfileSupportAboutCard({
    super.key,
    this.onHelpCenterTap,
    this.onRateAppTap,
    this.onContactUsTap,
    this.onAboutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: const Color(0xFFF1ECF5),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1A3C).withValues(alpha: 0.025),
            blurRadius: 10.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header: Blue Badge + "Support & About" Script Title
          Row(
            children: [
              Container(
                width: 38.0,
                height: 38.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.help_outline_rounded,
                    color: Color(0xFF3B82F6),
                    size: 20.0,
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Support & About',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        fontSize: 16.0,
                        color: Color(0xFF3B82F6),
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 1.0),
                    Text(
                      'Get help and learn more about FlowCycle.',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7A708A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10.0),
          const Divider(height: 1.0, color: Color(0xFFF1ECF5)),
          const SizedBox(height: 6.0),

          // 2. Row 1: Help Center (Left) & Rate FlowCycle (Right)
          Row(
            children: [
              Expanded(
                child: _buildGridItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Help Center',
                  subtitle: 'Get help and answers',
                  onTap: onHelpCenterTap,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: _buildGridItem(
                  icon: Icons.star_border_rounded,
                  title: 'Rate FlowCycle',
                  subtitle: 'Share your feedback',
                  onTap: onRateAppTap,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8.0),

          // 3. Row 2: Contact Us (Left) & About FlowCycle (Right)
          Row(
            children: [
              Expanded(
                child: _buildGridItem(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Contact Us',
                  subtitle: "We're here to help",
                  onTap: onContactUsTap,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: _buildGridItem(
                  icon: Icons.info_outline_rounded,
                  title: 'About FlowCycle',
                  subtitle: 'Version, terms and privacy policy',
                  onTap: onAboutTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
          child: Row(
            children: [
              // Circular Blue Icon Container
              Container(
                width: 30.0,
                height: 30.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: const Color(0xFF3B82F6),
                    size: 15.0,
                  ),
                ),
              ),

              const SizedBox(width: 8.0),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E1A3C),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1.0),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 9.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7A708A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Chevron >
              const Icon(
                Icons.chevron_right_rounded,
                size: 14.0,
                color: Color(0xFF7A708A),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
