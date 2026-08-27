import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/route_names.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';

/// Modal explorer sheet displaying categorized prompt cards for AI conversation.
class AiPromptExplorerSheet extends StatefulWidget {
  final ValueChanged<String>? onPromptSelected;

  const AiPromptExplorerSheet({super.key, this.onPromptSelected});

  @override
  State<AiPromptExplorerSheet> createState() => _AiPromptExplorerSheetState();
}

class _AiPromptExplorerSheetState extends State<AiPromptExplorerSheet> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Cycle & Flow',
    'Fertility & TTC',
    'Food & Recipes',
    'Mood & Energy',
    'Sleep & Rest',
  ];

  final List<Map<String, String>> _allPrompts = [
    {
      'title': 'What should I eat during my follicular phase?',
      'subtitle': 'Nutrition to fuel rising energy and follicle growth',
      'category': 'Food & Recipes',
      'emoji': '🥗',
    },
    {
      'title': 'How do I detect my fertile window accurately?',
      'subtitle': 'Cervical mucus and BBT temperature signals',
      'category': 'Fertility & TTC',
      'emoji': '💧',
    },
    {
      'title': 'Why am I craving carbs during luteal phase?',
      'subtitle': 'Progesterone metabolic shifts and blood sugar tips',
      'category': 'Mood & Energy',
      'emoji': '🥐',
    },
    {
      'title': 'Natural ways to ease menstrual cramps',
      'subtitle': 'Magnesium, heat therapy, and gentle stretches',
      'category': 'Cycle & Flow',
      'emoji': '🌸',
    },
    {
      'title': 'How to optimize deep sleep before my period',
      'subtitle': 'Bedtime rituals and temperature regulation',
      'category': 'Sleep & Rest',
      'emoji': '🌙',
    },
    {
      'title': 'Best supplements for egg quality when TTC',
      'subtitle': 'CoQ10, folate, and antioxidant recommendations',
      'category': 'Fertility & TTC',
      'emoji': '💊',
    },
    {
      'title': 'What workouts fit my current cycle phase?',
      'subtitle': 'Syncing HIIT, strength, and yoga with hormones',
      'category': 'Mood & Energy',
      'emoji': '🧘‍♀️',
    },
    {
      'title': 'Is spotting between periods normal?',
      'subtitle': 'Ovulation spotting vs hormonal imbalances',
      'category': 'Cycle & Flow',
      'emoji': '🩸',
    },
    {
      'title': 'Herbal teas to support hormone balance',
      'subtitle': 'Spearmint, raspberry leaf, and chamomile benefits',
      'category': 'Food & Recipes',
      'emoji': '🍵',
    },
    {
      'title': 'How stress impacts ovulation timing',
      'subtitle': 'Cortisol-progesterone interplay and relaxation',
      'category': 'Sleep & Rest',
      'emoji': '✨',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _triggerPrompt(String prompt) {
    Navigator.pop(context);
    if (widget.onPromptSelected != null) {
      widget.onPromptSelected!(prompt);
    } else {
      try {
        context.push(AppRoutes.aiChatPath, extra: {'prompt': prompt});
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _allPrompts.where((p) {
      final matchesCategory =
          _selectedCategory == 'All' || p['category'] == _selectedCategory;
      final q = _searchQuery.toLowerCase();
      final matchesSearch =
          q.isEmpty ||
          p['title']!.toLowerCase().contains(q) ||
          p['subtitle']!.toLowerCase().contains(q);
      return matchesCategory && matchesSearch;
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFFFAF8FC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 14, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      '✦',
                      style: TextStyle(
                        color: Color(0xFF7C64E8),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'AI Prompt Explorer',
                      style: AppTextStyles.subtitle.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E1A3C),
                      ),
                    ),
                  ],
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

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Container(
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
                  hintText: 'Search health topics & questions...',
                  hintStyle: TextStyle(color: Color(0xFFAAA3B8), fontSize: 13),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Color(0xFF7C64E8),
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),

          // Categories Horizontal Scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(
                      cat,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF7A708A),
                        fontSize: 12,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFF7C64E8),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFF7C64E8)
                            : const Color(0xFFEDE8E0),
                      ),
                    ),
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 1, color: Color(0xFFEFE9F3)),

          // Prompts List
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No matching questions found',
                      style: TextStyle(color: Color(0xFF7A708A)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final p = filtered[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: AppRadius.medium,
                          border: Border.all(color: const Color(0xFFEFE9F3)),
                          boxShadow: AppShadows.card,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: AppRadius.medium,
                            onTap: () => _triggerPrompt(p['title']!),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF3EDFA),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        p['emoji']!,
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p['title']!,
                                          style: AppTextStyles.body.copyWith(
                                            fontWeight: FontWeight.w800,
                                            color: const Color(0xFF1E1A3C),
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          p['subtitle']!,
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
                                    color: Color(0xFF7C64E8),
                                    size: 14,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
