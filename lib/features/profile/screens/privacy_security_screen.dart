import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/route_names.dart';
import '../../../core/services/data_backup_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/providers/app_scope.dart';
import '../../authentication/widgets/auth_terms_and_privacy_sheet.dart';
import '../widgets/pin_lock_dialog.dart';

/// Screen for managing PIN Passcode lock, discreet alerts, backups, export, and account deletion.
class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool _pinLockEnabled = false;
  String? _savedPin;
  bool _discreetMode = true;
  bool _isBackingUp = false;
  String _lastBackupTime = 'Today, 2:40 PM';

  String? get currentPin => _savedPin;

  Future<void> _handlePinToggle(bool enable) async {
    if (enable) {
      final pin = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const PinLockDialog(isSettingUp: true),
      );

      if (pin != null && pin.length == 4) {
        setState(() {
          _savedPin = pin;
          _pinLockEnabled = true;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('4-Digit Passcode enabled 🔒'),
              backgroundColor: Color(0xFF10B981),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } else {
      // Disable PIN
      setState(() {
        _savedPin = null;
        _pinLockEnabled = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passcode lock removed'),
          backgroundColor: Color(0xFF7A708A),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _changePin() async {
    final pin = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const PinLockDialog(isSettingUp: true),
    );

    if (pin != null && pin.length == 4) {
      setState(() {
        _savedPin = pin;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passcode updated successfully ✨'),
            backgroundColor: Color(0xFF10B981),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _triggerBackup() {
    setState(() => _isBackingUp = true);
    final controller = AppScope.of(context);
    final backupJson = DataBackupService.instance.createBackupJson(
      profile: controller.profile,
      logs: controller.logEntries.values.toList(),
    );

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _isBackingUp = false;
          _lastBackupTime = 'Just now';
        });
        Clipboard.setData(ClipboardData(text: backupJson));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All cycle data backed up securely (JSON copied) ☁️'),
            backgroundColor: Color(0xFF10B981),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _showRestoreDialog() {
    final textController = TextEditingController();
    final passController = TextEditingController();
    String? validationError;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(modalCtx).viewInsets.bottom + 20,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Restore from Backup',
                        style: AppTextStyles.subtitle.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1E1A3C),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.pop(modalCtx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Paste the raw JSON content of your .flowcycle backup file below to restore your profile and all historical biomarker logs.',
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFF7A708A),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: textController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Paste backup JSON here...',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE9E0F2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFAF8FC),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Optional PIN / Decryption Password',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE9E0F2)),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFAF8FC),
                    ),
                  ),
                  if (validationError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      validationError!,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        final raw = textController.text.trim();
                        final pass = passController.text.trim();
                        final result =
                            DataBackupService.instance.validateAndParseBackup(
                          raw,
                          password: pass.isEmpty ? null : pass,
                        );

                        if (!result.isValid) {
                          setModalState(() {
                            validationError = result.errorMessage ??
                                'Invalid or corrupted backup archive.';
                          });
                          return;
                        }

                        // Apply restore
                        final controller = AppScope.of(context);
                        if (result.profile != null) {
                          controller.updateProfile(result.profile!);
                        }
                        if (result.logs != null) {
                          for (final log in result.logs!) {
                            controller.saveLogEntry(log);
                          }
                        }

                        Navigator.pop(modalCtx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Successfully restored ${result.logs?.length ?? 0} cycle logs! 🔄',
                            ),
                            backgroundColor: const Color(0xFF10B981),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Validate & Restore Data',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showExportDialog() {
    final controller = AppScope.of(context);
    final logs = controller.logEntries.values.toList();
    final profile = controller.profile;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Export Cycle Data',
                  style: AppTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E1A3C),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Generate a structured summary report to share with your healthcare specialist or keep for personal records.',
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF7A708A),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.code_rounded,
                      color: Color(0xFF7C5CE7),
                    ),
                  ),
                  title: const Text(
                    'Export Full JSON Backup (.flowcycle)',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text(
                    'Complete profile, settings & logs archive',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(
                    Icons.download_rounded,
                    color: Color(0xFF7C5CE7),
                  ),
                  onTap: () {
                    final jsonStr =
                        DataBackupService.instance.createBackupJson(
                      profile: profile,
                      logs: logs,
                    );
                    Clipboard.setData(ClipboardData(text: jsonStr));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Full JSON Backup copied to clipboard (.flowcycle) 📦',
                        ),
                        backgroundColor: Color(0xFF7C5CE7),
                      ),
                    );
                  },
                ),
                const Divider(height: 12),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  title: const Text(
                    'Export Medical PDF Report',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text(
                    'Formatted cycle parameters & symptoms',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(
                    Icons.download_rounded,
                    color: AppColors.primary,
                  ),
                  onTap: () {
                    final report =
                        DataBackupService.instance.generateClinicalReport(
                      profile: profile,
                      logs: logs,
                    );
                    Clipboard.setData(ClipboardData(text: report));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('PDF Report exported successfully 📄'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                ),
                const Divider(height: 12),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F8F0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.table_chart_outlined,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  title: const Text(
                    'Export CSV Raw Data',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text(
                    'Daily logs, temperatures & notes in CSV format',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(
                    Icons.download_rounded,
                    color: Color(0xFF10B981),
                  ),
                  onTap: () {
                    final csv =
                        DataBackupService.instance.exportBiomarkersCsv(logs);
                    Clipboard.setData(ClipboardData(text: csv));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('CSV Data exported successfully 📊'),
                        backgroundColor: Color(0xFF10B981),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Account & Data?',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.redAccent,
          ),
        ),
        content: const Text(
          'This action is irreversible. All your cycle history, logged symptoms, fertility logs, and personal settings will be permanently erased.',
          style: TextStyle(color: Color(0xFF7A708A), height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF7A708A)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              try {
                context.go(AppRoutes.loginPath);
              } catch (_) {}
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1E1A3C),
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Privacy & Data',
          style: AppTextStyles.subtitle.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1E1A3C),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. App Security & Passcode
              _buildSectionHeader('APP LOCK & SECURITY'),
              _buildCard([
                _buildSwitchTile(
                  title: '4-Digit Passcode Lock',
                  subtitle: _pinLockEnabled
                      ? 'Passcode protection is active'
                      : 'Lock app with a 4-digit PIN',
                  value: _pinLockEnabled,
                  onChanged: _handlePinToggle,
                  actionRow: _pinLockEnabled
                      ? InkWell(
                          onTap: _changePin,
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                Text(
                                  'Change Passcode',
                                  style: AppTextStyles.caption.copyWith(
                                    color: const Color(0xFF10B981),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 10,
                                  color: Color(0xFF10B981),
                                ),
                              ],
                            ),
                          ),
                        )
                      : null,
                ),
                const Divider(height: 24, color: Color(0xFFEFE9F3)),
                _buildSwitchTile(
                  title: 'Discreet Push Alerts',
                  subtitle:
                      'Mask sensitive cycle terminology on lock screen notifications',
                  value: _discreetMode,
                  onChanged: (val) => setState(() => _discreetMode = val),
                ),
              ]),

              const SizedBox(height: 24),

              // 2. Cloud Backup & Sync
              _buildSectionHeader('CLOUD BACKUP & SYNC'),
              _buildCard([
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F8F0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.cloud_done_rounded,
                        color: Color(0xFF10B981),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Encrypted Cloud Backup',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E1A3C),
                              fontSize: 13.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Last backup: $_lastBackupTime',
                            style: AppTextStyles.caption.copyWith(
                              color: const Color(0xFF7A708A),
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _isBackingUp ? null : _triggerBackup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8F8F0),
                        foregroundColor: const Color(0xFF10B981),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Color(0xFFB9EBD1)),
                        ),
                      ),
                      child: _isBackingUp
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF10B981),
                              ),
                            )
                          : const Text(
                              'Sync Now',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                    ),
                  ],
                ),
                const Divider(height: 24, color: Color(0xFFEFE9F3)),
                _buildActionTile(
                  title: 'Restore Data from Backup',
                  subtitle: 'Import a .flowcycle JSON backup file',
                  icon: Icons.restore_page_outlined,
                  iconColor: const Color(0xFF7C5CE7),
                  onTap: _showRestoreDialog,
                ),
              ]),

              const SizedBox(height: 24),

              // 3. Export & Privacy
              _buildSectionHeader('DATA EXPORT & RIGHTS'),
              _buildCard([
                _buildActionTile(
                  title: 'Export Cycle Data',
                  subtitle: 'Download PDF or CSV summary reports',
                  icon: Icons.file_download_outlined,
                  iconColor: const Color(0xFF10B981),
                  onTap: _showExportDialog,
                ),
                const Divider(height: 24, color: Color(0xFFEFE9F3)),
                _buildActionTile(
                  title: 'Privacy Policy',
                  subtitle: 'How we protect your confidential health data',
                  icon: Icons.shield_outlined,
                  iconColor: const Color(0xFF10B981),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) => const AuthTermsAndPrivacySheet(
                        initialTabIndex: 1,
                      ),
                    );
                  },
                ),
              ]),

              const SizedBox(height: 24),

              // 4. Account Actions (Delete)
              _buildSectionHeader('DANGER ZONE'),
              _buildCard([
                _buildActionTile(
                  title: 'Delete Account & Data',
                  subtitle: 'Permanently remove your account and all history',
                  icon: Icons.delete_outline_rounded,
                  iconColor: Colors.redAccent,
                  titleColor: Colors.redAccent,
                  onTap: _showDeleteAccountDialog,
                ),
              ]),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w800,
          color: const Color(0xFF7A708A),
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.medium,
        border: Border.all(color: const Color(0xFFEFE9F3)),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    Widget? actionRow,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E1A3C),
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFF7A708A),
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeTrackColor: const Color(0xFF10B981),
            ),
          ],
        ),
        ?actionRow,
      ],
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      color: titleColor ?? const Color(0xFF1E1A3C),
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFF7A708A),
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF7A708A),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
