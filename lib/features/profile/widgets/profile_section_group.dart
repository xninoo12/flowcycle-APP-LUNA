import 'package:flutter/material.dart';

/// Item specification for a profile settings row matching exact UI visuals.
class ProfileRowItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String? valueText;
  final Color? valueTextColor;
  final bool? isSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final VoidCallback? onTap;

  const ProfileRowItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.valueText,
    this.valueTextColor,
    this.isSwitch,
    this.switchValue = false,
    this.onSwitchChanged,
    this.onTap,
  });
}

/// A titled card group containing list items for settings categories.
class ProfileSectionGroup extends StatelessWidget {
  final String sectionTitle;
  final List<ProfileRowItem> items;

  const ProfileSectionGroup({
    super.key,
    required this.sectionTitle,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            sectionTitle,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14.0,
              color: Color(0xFF1E1A3C),
            ),
          ),
        ),

        // White Card Container
        Container(
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
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                _buildRow(items[i]),
                if (i < items.length - 1)
                  const Divider(
                    height: 1.0,
                    thickness: 0.8,
                    indent: 58.0,
                    endIndent: 16.0,
                    color: Color(0xFFF5F0FA),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow(ProfileRowItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.isSwitch == true
            ? () => item.onSwitchChanged?.call(!item.switchValue)
            : item.onTap,
        borderRadius: BorderRadius.circular(22.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular Icon Container
              Container(
                width: 38.0,
                height: 38.0,
                decoration: BoxDecoration(
                  color: item.iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(item.icon, color: item.iconColor, size: 19.0),
                ),
              ),

              const SizedBox(width: 12.0),

              // Title & Subtitle Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1A3C),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7A708A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8.0),

              // Trailing Switch / Value Text / Chevron
              if (item.isSwitch == true)
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: item.switchValue,
                    activeThumbColor: Colors.white,
                    activeTrackColor: const Color(0xFFE84D75),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color(0xFFE0D8E6),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: item.onSwitchChanged,
                  ),
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.valueText != null) ...[
                      Text(
                        item.valueText!,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: item.valueTextColor ?? const Color(0xFF8B5CF6),
                        ),
                      ),
                      const SizedBox(width: 4.0),
                    ],
                    Icon(
                      Icons.chevron_right_rounded,
                      color:
                          item.valueTextColor != null &&
                              item.valueTextColor == const Color(0xFFE84D75)
                          ? const Color(0xFFE84D75)
                          : const Color(0xFF8C7C92),
                      size: 18.0,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
