import 'package:flutter/material.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../shared/providers/app_scope.dart';
import '../../../shared/widgets/buttons/primary_button.dart';

/// Modal bottom sheet popup for Privacy & Data Management.
class PrivacySecuritySheet extends StatefulWidget {
  final VoidCallback? onOpenPasscode;

  const PrivacySecuritySheet({super.key, this.onOpenPasscode});

  @override
  State<PrivacySecuritySheet> createState() => _PrivacySecuritySheetState();
}

class _PrivacySecuritySheetState extends State<PrivacySecuritySheet> {
  bool _anonymousMode = false;
  bool _analyticsOptOut = true;

  void _openCloudBackup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const CloudBackupSheet(),
    );
  }

  void _openExportData() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const ExportDataSheet(),
    );
  }

  void _openDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => DeleteDataConfirmationDialog(
        onConfirmed: () {
          final controller = AppScope.read(context);
          controller.resetToDefaults();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('All local health data erased 🗑️'),
              backgroundColor: Color(0xFFE84855),
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _openPrivacyDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const PrivacyDetailsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFAF7F2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          const SizedBox(height: 12.0),
          Container(
            width: 44.0,
            height: 4.5,
            decoration: BoxDecoration(
              color: const Color(0xFFE2DCE8),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          const SizedBox(height: 14.0),

          // Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Text('🛡️', style: TextStyle(fontSize: 18.0)),
                          SizedBox(width: 6.0),
                          Text(
                            'Privacy & Data',
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 22.0,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E1A3C),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        'Local encryption, device security & data control',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF7A708A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFF7A708A),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14.0),
          const Divider(height: 1.0, color: Color(0xFFEFE9F4)),

          // Scrollable Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Anonymous Mode Toggle
                  _buildToggleCard(
                    icon: Icons.visibility_off_rounded,
                    title: 'Anonymous Mode',
                    subtitle: 'Hide your name and sensitive symptoms on screen',
                    value: _anonymousMode,
                    onChanged: (v) {
                      setState(() => _anonymousMode = v);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            v
                                ? 'Anonymous mode enabled 🕶️'
                                : 'Anonymous mode turned off',
                          ),
                          backgroundColor: const Color(0xFF10B981),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10.0),

                  // Zero-Tracking Toggle
                  _buildToggleCard(
                    icon: Icons.shield_outlined,
                    title: 'Zero Ad Tracking',
                    subtitle: 'Never share analytics or telemetry with 3rd parties',
                    value: _analyticsOptOut,
                    onChanged: (v) {
                      setState(() => _analyticsOptOut = v);
                    },
                  ),

                  const SizedBox(height: 10.0),

                  // 2. Passcode & Biometrics Action
                  _buildActionCard(
                    icon: Icons.lock_outline_rounded,
                    iconColor: const Color(0xFF10B981),
                    title: 'Passcode & Biometrics',
                    subtitle: 'Secure app access with 4-digit PIN or Face ID',
                    onTap: () {
                      widget.onOpenPasscode?.call();
                    },
                  ),

                  const SizedBox(height: 10.0),

                  // 3. Cloud Backup & Sync
                  _buildActionCard(
                    icon: Icons.cloud_sync_rounded,
                    iconColor: const Color(0xFF3B82F6),
                    title: 'Encrypted Cloud Backup',
                    subtitle: 'Sync securely across devices with zero-knowledge keys',
                    onTap: _openCloudBackup,
                  ),

                  const SizedBox(height: 10.0),

                  // 4. Export Health Data
                  _buildActionCard(
                    icon: Icons.file_download_outlined,
                    iconColor: const Color(0xFF8B5CF6),
                    title: 'Export Health Records',
                    subtitle: 'Download cycle history as PDF, CSV, or JSON',
                    onTap: _openExportData,
                  ),

                  const SizedBox(height: 10.0),

                  // 5. Delete All Data (Destructive)
                  _buildActionCard(
                    icon: Icons.delete_outline_rounded,
                    iconColor: const Color(0xFFEF4444),
                    title: 'Delete All Health Data',
                    subtitle: 'Permanently erase all logs from this device',
                    isDestructive: true,
                    onTap: _openDeleteDialog,
                  ),

                  const SizedBox(height: 16.0),

                  // Privacy Pledge Pill
                  InkWell(
                    onTap: _openPrivacyDetails,
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14.0,
                        vertical: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: const Color(0xFFA7F3D0),
                          width: 1.0,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.verified_user_rounded,
                            color: Color(0xFF059669),
                            size: 20.0,
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Text(
                              'Learn more about FlowCycle Zero-Knowledge Encryption >',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF065F46),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: const Color(0xFFE8E2EE),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36.0,
            height: 36.0,
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(icon, color: const Color(0xFF059669), size: 18.0),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1A3C),
                  ),
                ),
                const SizedBox(height: 1.5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF7A708A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: const Color(0xFF10B981),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.0),
          border: Border.all(
            color: isDestructive
                ? const Color(0xFFFECACA)
                : const Color(0xFFE8E2EE),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36.0,
              height: 36.0,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(icon, color: iconColor, size: 18.0),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: isDestructive
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF1E1A3C),
                    ),
                  ),
                  const SizedBox(height: 1.5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF7A708A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 13.0,
              color: isDestructive
                  ? const Color(0xFFDC2626)
                  : const Color(0xFF9C93A8),
            ),
          ],
        ),
      ),
    );
  }
}

/// Standalone popup modal bottom sheet for Cloud Backup & Sync.
class CloudBackupSheet extends StatelessWidget {
  const CloudBackupSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.65,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFAF7F2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12.0),
          Container(
            width: 44.0,
            height: 4.5,
            decoration: BoxDecoration(
              color: const Color(0xFFE2DCE8),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          const SizedBox(height: 14.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Row(
                    children: [
                      Text('☁️', style: TextStyle(fontSize: 18.0)),
                      SizedBox(width: 6.0),
                      Expanded(
                        child: Text(
                          'Encrypted Cloud Backup',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1A3C),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF7A708A)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1.0, color: Color(0xFFEFE9F4)),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(18.0),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Icon(
                          Icons.lock_rounded,
                          color: Color(0xFF3B82F6),
                          size: 22.0,
                        ),
                      ),
                      const SizedBox(width: 14.0),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Zero-Knowledge Sync',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E1A3C),
                              ),
                            ),
                            SizedBox(height: 2.0),
                            Text(
                              'End-to-end encrypted with your private key. Only you hold access.',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF6B5F7D),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                PrimaryButton(
                  label: 'Back Up Now ☁️',
                  gradient: AppGradients.dawnBloom,
                  height: 48.0,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Encrypted cloud backup created ✨'),
                        backgroundColor: Color(0xFFFF4D79),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Standalone popup modal bottom sheet for Exporting Health Data.
class ExportDataSheet extends StatelessWidget {
  const ExportDataSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.65,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFAF7F2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12.0),
          Container(
            width: 44.0,
            height: 4.5,
            decoration: BoxDecoration(
              color: const Color(0xFFE2DCE8),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          const SizedBox(height: 14.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Row(
                    children: [
                      Text('📄', style: TextStyle(fontSize: 18.0)),
                      SizedBox(width: 6.0),
                      Expanded(
                        child: Text(
                          'Export Health Data',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1A3C),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF7A708A)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1.0, color: Color(0xFFEFE9F4)),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildExportFormatTile(
                  context,
                  title: 'Doctor PDF Report',
                  subtitle: 'Formatted summary of cycles, BBT curves & symptoms',
                  icon: Icons.picture_as_pdf_rounded,
                  color: const Color(0xFFEF4444),
                ),
                const SizedBox(height: 10.0),
                _buildExportFormatTile(
                  context,
                  title: 'Raw Data Spreadsheet (CSV)',
                  subtitle: 'Daily entries, flow intensity, and basal readings',
                  icon: Icons.table_chart_rounded,
                  color: const Color(0xFF10B981),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportFormatTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title generated and ready to share ✨'),
            backgroundColor: const Color(0xFFFF4D79),
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
      },
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: const Color(0xFFE8E2EE)),
        ),
        child: Row(
          children: [
            Container(
              width: 36.0,
              height: 36.0,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Icon(icon, color: color, size: 20.0),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E1A3C),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF7A708A),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.download_rounded,
              color: Color(0xFFFF4D79),
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}

/// Standalone popup modal bottom sheet for "Your Privacy Matters" details.
class PrivacyDetailsSheet extends StatelessWidget {
  const PrivacyDetailsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFAF7F2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12.0),
          Container(
            width: 44.0,
            height: 4.5,
            decoration: BoxDecoration(
              color: const Color(0xFFE2DCE8),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          const SizedBox(height: 14.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Row(
                    children: [
                      Text('🛡️', style: TextStyle(fontSize: 18.0)),
                      SizedBox(width: 6.0),
                      Expanded(
                        child: Text(
                          'Your Privacy Pledge',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 20.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1A3C),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF7A708A)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1.0, color: Color(0xFFEFE9F4)),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: const [
                  _PledgeItem(
                    icon: Icons.enhanced_encryption_rounded,
                    title: 'Device-First Encrypted Storage',
                    body: 'Your sensitive menstrual, intimacy, and symptom logs are stored locally on your device with AES-256 encryption.',
                  ),
                  SizedBox(height: 14.0),
                  _PledgeItem(
                    icon: Icons.money_off_rounded,
                    title: 'We Never Sell Your Data',
                    body: 'FlowCycle does not sell, broker, or monetize your intimate reproductive health logs with data aggregators or advertisers.',
                  ),
                  SizedBox(height: 14.0),
                  _PledgeItem(
                    icon: Icons.shield_moon_rounded,
                    title: 'Zero Third-Party Trackers',
                    body: 'We do not embed behavioral advertising or social media surveillance trackers in FlowCycle.',
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

class _PledgeItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _PledgeItem({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFE8E2EE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF059669), size: 22.0),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1A3C),
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFF7A708A),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Standalone confirmation dialog for deleting all data.
class DeleteDataConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirmed;

  const DeleteDataConfirmationDialog({super.key, required this.onConfirmed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      backgroundColor: const Color(0xFFFAF7F2),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50.0,
              height: 50.0,
              decoration: const BoxDecoration(
                color: Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFEF4444),
                  size: 28.0,
                ),
              ),
            ),
            const SizedBox(height: 14.0),
            const Text(
              'Delete All Health Data?',
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 19.0,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E1A3C),
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'This action cannot be undone. All cycle logs, symptoms, and saved settings will be permanently erased from this device.',
              style: TextStyle(
                fontSize: 12.5,
                color: Color(0xFF7A708A),
                height: 1.35,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7A708A),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirmed();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: const Text(
                      'Delete Data',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
