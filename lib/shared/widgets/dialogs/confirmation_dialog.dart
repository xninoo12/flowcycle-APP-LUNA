import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';

/// A modal confirmation dialog for confirming critical or destructive actions.
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final IconData? icon;
  final bool isDestructive;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.onCancel,
    this.icon,
    this.isDestructive = false,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    VoidCallback? onCancel,
    IconData? icon,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
        onCancel: onCancel,
        icon: icon,
        isDestructive: isDestructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color effectiveColor = isDestructive
        ? AppColors.error
        : AppColors.primaryRose;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: AppSpacing.paddingLg,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.large,
          boxShadow: AppShadows.elevated,
        ),
        padding: AppSpacing.paddingXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Container(
                width: 56.0,
                height: 56.0,
                decoration: BoxDecoration(
                  color: effectiveColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(icon, color: effectiveColor, size: 28.0),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            Text(
              title,
              style: AppTextStyles.heading3.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: cancelLabel,
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      onCancel?.call();
                    },
                    height: 46.0,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: PrimaryButton(
                    label: confirmLabel,
                    backgroundColor: isDestructive ? AppColors.error : null,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      onConfirm();
                    },
                    height: 46.0,
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
