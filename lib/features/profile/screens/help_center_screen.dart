import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/contact_support_dialog.dart';

/// Interactive Help Center screen with searchable FAQ accordions and direct support contact.
class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How are my cycle phases calculated?',
      'category': 'Cycle Tracking',
      'answer':
          'FlowCycle analyzes your average cycle length and the first day of your last period to divide your cycle into 4 distinct phases: Menstrual (Days 1–5), Follicular (Days 6–13), Ovulation (Days 14–17), and Luteal (Days 18–28+). Logging consistently sharpens prediction accuracy over time.',
    },
    {
      'question': 'What does the Conception Probability Score mean?',
      'category': 'Trying to Conceive',
      'answer':
          'The Conception Probability Score estimates the likelihood of conception for any given day based on your estimated fertile window (the 5 days before ovulation plus ovulation day itself). Peak fertility typically occurs 24–48 hours before ovulation.',
    },
    {
      'question': 'How should I measure Basal Body Temperature (BBT)?',
      'category': 'Fertility Metrics',
      'answer':
          'Measure your BBT immediately upon waking up, before getting out of bed or speaking, using a two-decimal basal thermometer. A sustained temperature shift of ~0.3°C (0.5°F) indicates ovulation has occurred.',
    },
    {
      'question': 'Is my personal health data private and encrypted?',
      'category': 'Privacy & Security',
      'answer':
          'Yes. FlowCycle encrypts all cycle logs, symptoms, and health notes using AES-256 standards both in transit and at rest. We never sell your data to advertisers or third-party data brokers.',
    },
    {
      'question': 'How do I switch between Cycle Awareness and TTC mode?',
      'category': 'App Features',
      'answer':
          'You can switch modes instantly at any time from the top segmented switcher on your Dashboard or from the "Your Current Mode" card on your Profile tab. Your historical logs remain safely intact across both modes.',
    },
    {
      'question': 'What should I do if my cycle is irregular?',
      'category': 'Cycle Health',
      'answer':
          'Log your symptoms, flow intensity, and period start dates continuously. FlowCycle adjusts dynamically to your rolling cycle average. If cycles vary by more than 7–10 days regularly, consider exporting your PDF cycle report to discuss with your gynecologist.',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openContactSupport() {
    showDialog(
      context: context,
      builder: (context) => const ContactSupportDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredFaqs = _faqs.where((faq) {
      final q = faq['question']!.toLowerCase();
      final a = faq['answer']!.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return q.contains(query) || a.contains(query);
    }).toList();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
            'Help Center',
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
                // 1. Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppRadius.medium,
                    border: Border.all(color: const Color(0xFFEFE9F3)),
                    boxShadow: AppShadows.card,
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: const InputDecoration(
                      hintText: 'Search answers or questions...',
                      hintStyle: TextStyle(
                        color: Color(0xFFAAA3B8),
                        fontSize: 13.5,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 2. FAQ Accordion List
                Text(
                  'FREQUENTLY ASKED QUESTIONS',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF7A708A),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 10),

                if (filteredFaqs.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.medium,
                      border: Border.all(color: const Color(0xFFEFE9F3)),
                    ),
                    child: Center(
                      child: Text(
                        'No matching answers found for "$_searchQuery"',
                        style: const TextStyle(color: Color(0xFF7A708A)),
                      ),
                    ),
                  )
                else
                  ...filteredFaqs.map((faq) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: AppRadius.medium,
                        border: Border.all(color: const Color(0xFFEFE9F3)),
                        boxShadow: AppShadows.card,
                      ),
                      child: Material(
                        color: Colors.white,
                        borderRadius: AppRadius.medium,
                        child: Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            iconColor: AppColors.primary,
                            collapsedIconColor: const Color(0xFF7A708A),
                            tilePadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            title: Text(
                              faq['question']!,
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1E1A3C),
                                fontSize: 13.5,
                              ),
                            ),
                            subtitle: Text(
                              faq['category']!,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                child: Text(
                                  faq['answer']!,
                                  style: AppTextStyles.body.copyWith(
                                    color: const Color(0xFF7A708A),
                                    fontSize: 12.5,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                const SizedBox(height: 24),

                // 3. Contact Support Banner
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF0F5), Color(0xFFF3EBFB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: AppRadius.medium,
                    border: Border.all(color: const Color(0xFFFFD4E2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.support_agent_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Still have questions?',
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1E1A3C),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Our wellness team is here to assist you.',
                              style: AppTextStyles.caption.copyWith(
                                color: const Color(0xFF7A708A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _openContactSupport,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Contact Us',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
