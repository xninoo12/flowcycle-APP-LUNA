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
          title: 'Medical Disclaimer & Educational Scope',
          body:
              'FlowCycle is an educational wellness and reproductive tracking tool. It is NOT a certified medical device, diagnostic provider, or substitute for professional medical care, and must NEVER be used as a standalone contraceptive method.',
          accentColor: const Color(0xFFE84D75),
          bgColor: const Color(0xFFFFF0F5),
        ),
        const SizedBox(height: 16),
        _buildSectionHeader('1. Eligibility & Your Account'),
        _buildParagraph(
          'You must meet the minimum legal age required to use FlowCycle in your jurisdiction. You are responsible for keeping your login credentials, PIN lock, and device secure, and for all activity occurring under your account.',
        ),
        _buildSectionHeader('2. What FlowCycle Provides'),
        _buildParagraph(
          'FlowCycle provides tools for menstrual cycle tracking, period history, fertile window and ovulation estimates, wellness and symptom tracking, intimacy observations, notes, reminders, data export, and AI informational assistance. Features may evolve over time.',
        ),
        _buildSectionHeader(
          '3. Not Medical Advice & No Doctor-Patient Relationship',
        ),
        _buildParagraph(
          'Cycle calculations, predictions, fertile window estimates, symptom insights, and AI responses are educational estimates and may contain inaccuracies. Do not rely on FlowCycle to diagnose conditions, prevent or achieve pregnancy, replace birth control, or handle medical emergencies. Always consult a qualified healthcare professional.',
        ),
        _buildSectionHeader('4. Fertility & Reproductive Disclaimer'),
        _buildParagraph(
          'FlowCycle does not guarantee conception, pregnancy prevention, or specific reproductive outcomes. Calendar predictions can vary due to irregular cycles, stress, illness, medications, and hormonal fluctuations.',
        ),
        _buildSectionHeader('5. AI Companion Guidelines'),
        _buildParagraph(
          'The AI Companion provides general educational support and guidance. AI responses are generated automatically, may be incomplete or inaccurate, and must never replace clinical medical advice or individualized diagnosis.',
        ),
        _buildSectionHeader('6. User Content & Intellectual Property'),
        _buildParagraph(
          'You retain full ownership of your logged cycle data, notes, and symptoms. FlowCycle\'s algorithms, predictive models, designs, branding, and interfaces are the exclusive intellectual property of FlowCycle.',
        ),
        _buildSectionHeader('7. Subscriptions, Termination & Deletion'),
        _buildParagraph(
          'In-app subscriptions and renewals are managed via your app store account (Apple App Store / Google Play). You may stop using the service and delete your account and associated data at any time.',
        ),
        _buildSectionHeader('8. Limitation of Liability & Contact'),
        _buildParagraph(
          'FlowCycle is provided on an "as is" and "as available" basis to the maximum extent permitted by applicable law. For questions about these Terms, contact legal@flowcycle.app or support@flowcycle.app.',
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
              'We NEVER sell, monetize, rent, or broker your intimate reproductive, period, fertility, or sexual health records to advertisers, data brokers, or third parties. Period.',
          accentColor: const Color(0xFF10B981),
          bgColor: const Color(0xFFEBFDF5),
        ),
        const SizedBox(height: 16),
        _buildSectionHeader('1. Information We Collect'),
        _buildParagraph(
          'Depending on the features you use, FlowCycle may collect:\n'
          '• Account Information: Name, email address, authentication credentials, and preferences.\n'
          '• Cycle & Fertility Data: Period dates, cycle length, ovulation observations, fertile windows, symptoms, flow intensity, and pregnancy/TTC goals.\n'
          '• Wellness & Intimacy (Optional): Mood, sleep, basal body temperature (BBT), workouts, notes, and intimacy observations.\n'
          '• Device & Technical Data: Device type, operating system, app version, and minimized crash/diagnostic logs.',
        ),
        _buildSectionHeader('2. How We Use Your Information'),
        _buildParagraph(
          'We use your data solely to operate FlowCycle, maintain your account, calculate cycle phases and fertile windows, provide personalized insights and reminders, secure your account, and maintain backups.',
        ),
        _buildSectionHeader('3. AI Companion Privacy Safeguards'),
        _buildParagraph(
          'Interactions with the AI Companion are anonymized and processed securely. Your intimate health logs and prompts are NEVER used to train external public LLM models.',
        ),
        _buildSectionHeader('4. How We Share Information'),
        _buildParagraph(
          'We do not sell your health data. We share information only with essential, trusted service providers (cloud hosting, database infrastructure, security, authentication) bound by strict confidentiality agreements, or when required by applicable law.',
        ),
        _buildSectionHeader('5. Data Security & Storage'),
        _buildParagraph(
          'We implement industry-standard AES-256 encryption at rest, TLS 1.3 encryption in transit, device-first local storage, and in-app PIN/biometric locks to protect your confidential information.',
        ),
        _buildSectionHeader('6. Your Privacy Choices & Data Rights'),
        _buildParagraph(
          'In accordance with global privacy best practices (GDPR, CCPA):\n'
          '• Access & Portability: Review and export your complete cycle history as PDF clinical reports or CSV files anytime.\n'
          '• Erasure: Permanently delete your account and all associated health records with a single tap.\n'
          '• Permissions: Control notification, biometric lock, and optional data permissions at any time.',
        ),
        _buildSectionHeader('7. Data Protection Contact'),
        _buildParagraph(
          'For inquiries regarding privacy, data rights, or security practices, contact our Data Protection Officer at privacy@flowcycle.app.',
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
