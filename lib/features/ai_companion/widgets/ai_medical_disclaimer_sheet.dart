import 'package:flutter/material.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../shared/widgets/buttons/primary_button.dart';

/// Modal bottom sheet popup for AI Medical Disclaimer, boundaries, and emergency advice.
class AiMedicalDisclaimerSheet extends StatelessWidget {
  const AiMedicalDisclaimerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
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
                            'Medical Disclaimer',
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
                        'Clinical intelligence boundaries & emergency protocols',
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildNoticeCard(
                    icon: Icons.health_and_safety_rounded,
                    iconColor: const Color(0xFF8B5CF6),
                    title: 'Educational Guidance Only',
                    body:
                        'FlowCycle AI is an informational self-tracking tool designed to help you understand your menstrual and reproductive biomarkers. It is not intended as medical diagnosis, prescriptive treatment, or contraceptive guarantee.',
                  ),
                  const SizedBox(height: 12.0),
                  _buildNoticeCard(
                    icon: Icons.emergency_rounded,
                    iconColor: const Color(0xFFEF4444),
                    title: 'Emergency Symptoms',
                    body:
                        'If you experience acute severe pelvic pain, heavy hemorrhage (soaking >2 pads per hour), sudden fainting, high fever, or suspect ectopic pregnancy, seek immediate emergency medical care.',
                  ),
                  const SizedBox(height: 12.0),
                  _buildNoticeCard(
                    icon: Icons.auto_awesome_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    title: 'Evidence-Based Framework',
                    body:
                        'Our responses are grounded in clinical guidelines from the American College of Obstetricians and Gynecologists (ACOG) and peer-reviewed reproductive endocrinology literature.',
                  ),
                  const SizedBox(height: 24.0),
                  PrimaryButton(
                    label: 'I Understand & Acknowledge ✨',
                    gradient: AppGradients.dawnBloom,
                    height: 48.0,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String body,
  }) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(color: const Color(0xFFE8E2EE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.0,
            height: 36.0,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Icon(icon, color: iconColor, size: 20.0),
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
                const SizedBox(height: 3.0),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFF6B5F7D),
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
