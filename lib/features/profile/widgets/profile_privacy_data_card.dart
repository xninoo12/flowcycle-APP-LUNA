import 'package:flutter/material.dart';

/// "Privacy & Data" Card matching the exact mockup.
///
/// Features:
/// - Green shield badge + script title ("Privacy & Data")
/// - 4 interactive setting rows with green circular icon boxes
class ProfilePrivacyDataCard extends StatelessWidget {
  final String passcodeStatus;
  final VoidCallback? onPrivacySettingsTap;
  final VoidCallback? onPasscodeBiometricsTap;
  final VoidCallback? onBackupRestoreTap;
  final VoidCallback? onExportDeleteTap;

  const ProfilePrivacyDataCard({
    super.key,
    this.passcodeStatus = 'Off',
    this.onPrivacySettingsTap,
    this.onPasscodeBiometricsTap,
    this.onBackupRestoreTap,
    this.onExportDeleteTap,
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
          // 1. Header: Green Shield Badge + "Privacy & Data" Script Title
          Row(
            children: [
              Container(
                width: 38.0,
                height: 38.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.shield_outlined,
                    color: Color(0xFF10B981),
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
                      'Privacy & Data',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        fontSize: 16.0,
                        color: Color(0xFF10B981),
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 1.0),
                    Text(
                      'Manage your data and keep it secure.',
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
          const SizedBox(height: 4.0),

          // 2. Setting Rows
          _buildRow(
            icon: Icons.shield_outlined,
            title: 'Privacy & Data Settings',
            subtitle: 'Manage your data and privacy',
            onTap: onPrivacySettingsTap,
          ),
          const Divider(height: 1.0, color: Color(0xFFF7F4FB)),

          _buildRow(
            icon: Icons.lock_outline_rounded,
            title: 'Passcode & Biometrics',
            subtitle: 'Protect your app with a 4-digit PIN',
            valueText: passcodeStatus,
            onTap: onPasscodeBiometricsTap,
          ),
          const Divider(height: 1.0, color: Color(0xFFF7F4FB)),

          _buildRow(
            icon: Icons.cloud_outlined,
            title: 'Backup & Restore',
            subtitle: 'Back up your data to the cloud',
            onTap: onBackupRestoreTap,
          ),
          const Divider(height: 1.0, color: Color(0xFFF7F4FB)),

          _buildRow(
            icon: Icons.delete_outline_rounded,
            title: 'Export or Delete Data',
            subtitle: 'Export your data or delete account',
            onTap: onExportDeleteTap,
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required IconData icon,
    required String title,
    required String subtitle,
    String? valueText,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
          child: Row(
            children: [
              // Circular Green Icon Container
              Container(
                width: 32.0,
                height: 32.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: const Color(0xFF10B981),
                    size: 16.0,
                  ),
                ),
              ),

              const SizedBox(width: 10.0),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12.5,
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
                        fontSize: 10.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7A708A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Value Text (e.g. "Off")
              if (valueText != null)
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Text(
                    valueText,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7A708A),
                    ),
                  ),
                ),

              // Chevron >
              const Icon(
                Icons.chevron_right_rounded,
                size: 16.0,
                color: Color(0xFF7A708A),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
