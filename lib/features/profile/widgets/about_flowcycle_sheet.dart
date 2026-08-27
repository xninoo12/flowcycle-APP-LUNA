import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';

/// Bottom sheet displaying About FlowCycle metadata, version, terms, and medical disclaimer.
class AboutFlowcycleSheet extends StatelessWidget {
  const AboutFlowcycleSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Grab handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE8E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // App Icon & Name
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F5),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFFD4E2), width: 2),
                ),
                child: const Center(
                  child: Text('🌸', style: TextStyle(fontSize: 32)),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'FlowCycle',
                style: AppTextStyles.title.copyWith(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E1A3C),
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF7F5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFEDE8E0)),
                ),
                child: Text(
                  'Version 1.2.3 (Build 142)',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF7A708A),
                    fontSize: 11.5,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Medical Disclaimer Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF7F5),
                  borderRadius: AppRadius.medium,
                  border: Border.all(color: const Color(0xFFEDE8E0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.medical_services_outlined,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'MEDICAL DISCLAIMER',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            letterSpacing: 0.8,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'FlowCycle is designed for menstrual cycle and fertility tracking. It should not be used as a standalone contraceptive method or as a substitute for professional medical diagnosis or clinical healthcare guidance.',
                      style: AppTextStyles.caption.copyWith(
                        color: const Color(0xFF7A708A),
                        height: 1.45,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Legal Links
              Container(
                decoration: BoxDecoration(
                  borderRadius: AppRadius.medium,
                  border: Border.all(color: const Color(0xFFEFE9F3)),
                  boxShadow: AppShadows.card,
                ),
                child: Material(
                  color: Colors.white,
                  borderRadius: AppRadius.medium,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.description_outlined,
                          color: Color(0xFF8B5CF6),
                          size: 20,
                        ),
                        title: const Text(
                          'Terms of Service',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: Color(0xFF7A708A),
                        ),
                        onTap: () {
                          try {
                            Navigator.pop(context);
                          } catch (_) {}
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Opening Terms of Service 📄'),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, color: Color(0xFFEFE9F3)),
                      ListTile(
                        leading: const Icon(
                          Icons.privacy_tip_outlined,
                          color: Color(0xFF8B5CF6),
                          size: 20,
                        ),
                        title: const Text(
                          'Privacy Policy',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: Color(0xFF7A708A),
                        ),
                        onTap: () {
                          try {
                            Navigator.pop(context);
                          } catch (_) {}
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Opening Privacy Policy 🛡️'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Text(
                '© 2026 FlowCycle Inc. Built with love for women everywhere.',
                style: AppTextStyles.caption.copyWith(
                  color: const Color(0xFFAAA3B8),
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
