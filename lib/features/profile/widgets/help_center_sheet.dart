import 'package:flutter/material.dart';
import 'contact_support_dialog.dart';

/// Modal bottom sheet popup for Help Center with searchable FAQs and accordion questions.
class HelpCenterSheet extends StatefulWidget {
  const HelpCenterSheet({super.key});

  @override
  State<HelpCenterSheet> createState() => _HelpCenterSheetState();
}

class _HelpCenterSheetState extends State<HelpCenterSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _searchQuery = '';

  static const List<String> _categories = [
    'All',
    'Cycle Tracking',
    'Fertility',
    'Privacy',
    'Troubleshooting',
  ];

  static const List<_FaqItem> _allFaqs = [
    _FaqItem(
      category: 'Cycle Tracking',
      question: 'How does FlowCycle predict my next period?',
      answer:
          'FlowCycle uses rolling Bayesian cycle averages combined with your logged luteal phase length, cervical mucus shifts, and basal body temperature readings to calculate your personalized period countdown.',
    ),
    _FaqItem(
      category: 'Cycle Tracking',
      question: 'What if my cycle is irregular?',
      answer:
          'FlowCycle dynamically adapts to irregular cycles by giving heavier weight to recent biomarker observations (fertile fluid, LH tests) rather than rigid 28-day assumptions.',
    ),
    _FaqItem(
      category: 'Fertility',
      question: 'When is my fertile window open?',
      answer:
          'Your fertile window is approximately 6 days long: the 5 days preceding ovulation plus ovulation day itself. Sperm can survive up to 5 days in fertile cervical mucus.',
    ),
    _FaqItem(
      category: 'Fertility',
      question: 'How do I log Basal Body Temperature (BBT)?',
      answer:
          'Measure your temperature immediately upon waking before getting out of bed. A sustained thermal rise of 0.2°C – 0.5°C confirms ovulation has occurred.',
    ),
    _FaqItem(
      category: 'Privacy',
      question: 'Where is my health data stored?',
      answer:
          'Your health logs are stored locally on your device in an encrypted database. We never sell or monetize your reproductive health data.',
    ),
    _FaqItem(
      category: 'Privacy',
      question: 'How do I set up a Passcode / PIN lock?',
      answer:
          'Go to Profile > Privacy & Data > Passcode & Biometrics to set a 4-digit PIN lock for instant app protection.',
    ),
    _FaqItem(
      category: 'Troubleshooting',
      question: 'How do I backup or transfer my data?',
      answer:
          'Open Profile > Privacy & Data > Encrypted Cloud Backup to sync your cycle history with your personal cloud account.',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openContactDialog() {
    showDialog(
      context: context,
      builder: (ctx) => const ContactSupportDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredFaqs = _allFaqs.where((faq) {
      final matchesCategory =
          _selectedCategory == 'All' || faq.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          faq.answer.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
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
                          Text('❓', style: TextStyle(fontSize: 18.0)),
                          SizedBox(width: 6.0),
                          Text(
                            'Help Center',
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
                        'Frequently asked questions and guides',
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

          const SizedBox(height: 12.0),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: const Color(0xFFE8E2EE)),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _searchQuery = v.trim()),
                decoration: const InputDecoration(
                  hintText: 'Search help topics...',
                  hintStyle: TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF9C93A8),
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Color(0xFF8B5CF6),
                    size: 20.0,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 12.0,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10.0),

          // Categories Horizontal Selector
          SizedBox(
            height: 36.0,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              itemCount: _categories.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: 8.0),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;

                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = category),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF8B5CF6)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(18.0),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF8B5CF6)
                            : const Color(0xFFE8E2EE),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF7A708A),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10.0),
          const Divider(height: 1.0, color: Color(0xFFEFE9F4)),

          // FAQs Accordion List
          Flexible(
            child: filteredFaqs.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text(
                        'No matching FAQ articles found.',
                        style: TextStyle(color: Color(0xFF7A708A)),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                    itemCount: filteredFaqs.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10.0),
                    itemBuilder: (context, index) {
                      final faq = filteredFaqs[index];
                      return Material(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Color(0xFFE8E2EE)),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                          ),
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 2.0,
                            ),
                            title: Text(
                              faq.question,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E1A3C),
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  bottom: 14.0,
                                ),
                                child: Text(
                                  faq.answer,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    color: Color(0xFF6B5F7D),
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Bottom Still Need Help Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _openContactDialog,
                    icon: const Icon(
                      Icons.mail_outline_rounded,
                      color: Color(0xFF8B5CF6),
                      size: 18.0,
                    ),
                    label: const Text(
                      'Still need help? Contact Us',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF8B5CF6),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFDDD6FE)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
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

class _FaqItem {
  final String category;
  final String question;
  final String answer;

  const _FaqItem({
    required this.category,
    required this.question,
    required this.answer,
  });
}
