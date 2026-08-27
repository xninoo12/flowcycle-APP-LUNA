import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';

/// Comprehensive interactive legal sheet presenting FlowCycle's exclusive
/// Terms & Conditions and Privacy Policy with segmented tabs and medical data safeguards.
class AuthTermsAndPrivacySheet extends StatefulWidget {
  final int initialTabIndex;
  final VoidCallback? onAccept;

  const AuthTermsAndPrivacySheet({
    super.key,
    this.initialTabIndex = 0,
    this.onAccept,
  });

  @override
  State<AuthTermsAndPrivacySheet> createState() =>
      _AuthTermsAndPrivacySheetState();
}

class _AuthTermsAndPrivacySheetState extends State<AuthTermsAndPrivacySheet> {
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFFFAF8FC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Header Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 14, 8),
            child: Row(
              children: [
                const Icon(
                  Icons.verified_user_rounded,
                  color: Color(0xFF7C5CE7),
                  size: 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedTab == 0 ? 'Terms & Conditions' : 'Privacy Policy',
                    style: AppTextStyles.subtitle.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1E1A3C),
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFF7A708A),
                    size: 22,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Segmented Tab Switcher
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Container(
              height: 40,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE8F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTabButton(
                      index: 0,
                      title: 'Terms of Service',
                      icon: Icons.gavel_rounded,
                    ),
                  ),
                  Expanded(
                    child: _buildTabButton(
                      index: 1,
                      title: 'Privacy Policy',
                      icon: Icons.shield_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1, color: Color(0xFFEFE9F3)),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              child: _selectedTab == 0
                  ? _buildTermsContent()
                  : _buildPrivacyContent(),
            ),
          ),

          // Bottom Accept Action
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (widget.onAccept != null) {
                    widget.onAccept!();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C5CE7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'I Understand & Accept',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required int index,
    required String title,
    required IconData icon,
  }) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected
                  ? const Color(0xFF7C5CE7)
                  : const Color(0xFF7A708A),
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF1E1A3C)
                      : const Color(0xFF7A708A),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNoticeBanner(
          icon: Icons.info_outline_rounded,
          title: 'Medical Disclaimer & Scope of Use',
          body:
              'FlowCycle is designed exclusively as an educational wellness and reproductive cycle tracking tool. It is NOT a certified medical diagnostic device and must NEVER be used as a standalone contraceptive method.',
          accentColor: const Color(0xFFE84D75),
          bgColor: const Color(0xFFFFF0F5),
        ),
        const SizedBox(height: 16),
        _buildSectionHeader('1. Acceptance of Terms'),
        _buildParagraph(
          'By accessing or using the FlowCycle mobile application, you agree to be bound by these Terms of Service. If you do not agree with any portion of these terms, please discontinue use immediately.',
        ),
        _buildSectionHeader(
          '2. Health Information & No Doctor-Patient Relationship',
        ),
        _buildParagraph(
          'Any insights, predictions, conception windows, or AI responses provided within FlowCycle are for general informational purposes only. They do not constitute formal medical diagnosis, treatment, or professional medical advice. Always consult a qualified physician or healthcare provider regarding any menstrual, fertility, or hormonal concerns.',
        ),
        _buildSectionHeader('3. User Accounts & Security'),
        _buildParagraph(
          'You are responsible for safeguarding your login credentials and PIN locks. You agree to notify FlowCycle immediately of any unauthorized access to your account.',
        ),
        _buildSectionHeader('4. Proprietary Algorithms & Content'),
        _buildParagraph(
          'All software, mathematical cycle models, visual ring designs, and UI assets are the exclusive intellectual property of FlowCycle. Unauthorized duplication or reverse engineering is strictly prohibited.',
        ),
        _buildSectionHeader('5. Termination & Data Portability'),
        _buildParagraph(
          'You may terminate your account at any time. Upon account deletion, all personal cycle records and health logs will be permanently purged from our databases in accordance with our Privacy Policy.',
        ),
      ],
    );
  }

  Widget _buildPrivacyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNoticeBanner(
          icon: Icons.lock_outline_rounded,
          title: 'Our Ironclad Zero-Data-Selling Pledge',
          body:
              'We NEVER sell, monetize, rent, or share your intimate reproductive, period, or fertility data with advertisers, data brokers, or third parties. Period.',
          accentColor: const Color(0xFF10B981),
          bgColor: const Color(0xFFEBFDF5),
        ),
        const SizedBox(height: 16),
        _buildSectionHeader('1. Data We Collect'),
        _buildParagraph(
          'We collect only the information you explicitly provide to deliver cycle intelligence:\n'
          '• Biological cycle parameters (cycle length, period duration, LMP date).\n'
          '• Daily symptoms, cervical mucus observations, basal body temperature (BBT), and moods.\n'
          '• Account email and hashed authentication credentials.',
        ),
        _buildSectionHeader('2. End-to-End Encryption & Security Standards'),
        _buildParagraph(
          'All sensitive health entries are encrypted using industry-standard AES-256 encryption at rest and TLS 1.3 in transit. Only you hold the decryption keys to your personal health log.',
        ),
        _buildSectionHeader('3. GDPR, CCPA & HIPAA Best-Practice Compliance'),
        _buildParagraph(
          'FlowCycle adheres strictly to international privacy frameworks:\n'
          '• Right to Access: View and review all logged data at any time.\n'
          '• Right to Portability: Export complete cycle history as formatted CSV or PDF reports.\n'
          '• Right to Erasure: Instantly delete your profile and all associated data with 1 tap.',
        ),
        _buildSectionHeader('4. AI Companion & Privacy Safeguards'),
        _buildParagraph(
          'Interactions with the AI Companion are anonymized. Health prompts are processed securely and are NEVER used to train external public LLM models.',
        ),
        _buildSectionHeader('5. Privacy Officer Contact'),
        _buildParagraph(
          'For inquiries regarding our health privacy standards, reach our dedicated Data Protection Officer at privacy@flowcycle.app.',
        ),
      ],
    );
  }

  Widget _buildNoticeBanner({
    required IconData icon,
    required String title,
    required String body,
    required Color accentColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.medium,
        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textPrimary,
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1E1A3C),
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        color: Color(0xFF5A5269),
        height: 1.45,
      ),
    );
  }
}
