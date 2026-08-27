import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';

/// Clinical glossary sheet explaining symptoms, cervical fluid cues, and hormone biomarkers.
class SymptomGlossarySheet extends StatefulWidget {
  const SymptomGlossarySheet({super.key});

  @override
  State<SymptomGlossarySheet> createState() => _SymptomGlossarySheetState();
}

class _SymptomGlossarySheetState extends State<SymptomGlossarySheet> {
  String _searchQuery = '';

  static const List<Map<String, String>> glossaryItems = [
    {
      'term': 'Egg-white Cervical Mucus (Spinnbarkeit)',
      'category': 'Cervical Fluid',
      'emoji': '💧',
      'meaning':
          'Clear, stretchy, raw egg-white texture. Signifies peak estrogen and indicates maximum fertility. Provides alkaline protection for sperm motility.',
    },
    {
      'term': 'Creamy Cervical Fluid',
      'category': 'Cervical Fluid',
      'emoji': '🥛',
      'meaning':
          'Lotion-like or milky texture. Indicates early follicular rising estrogen or early luteal progesterone. Mild fertility.',
    },
    {
      'term': 'Sticky / Dry Cervical Fluid',
      'category': 'Cervical Fluid',
      'emoji': '🍂',
      'meaning':
          'Thick or absent fluid. Typical immediately post-period or during the late luteal phase when progesterone is dominant. Low fertility.',
    },
    {
      'term': 'Ovulation Test (LH Surge)',
      'category': 'Hormones',
      'emoji': '🧪',
      'meaning':
          'A dark positive line indicates the Luteinizing Hormone (LH) surge. Ovulation typically follows within 24–36 hours.',
    },
    {
      'term': 'Basal Body Temperature (BBT) Shift',
      'category': 'Biomarkers',
      'emoji': '🌡️',
      'meaning':
          'A sustained 0.5–1.0°F temperature elevation confirms that ovulation has occurred and progesterone is actively being produced by the corpus luteum.',
    },
    {
      'term': 'Mittelschmerz (Ovulation Pain)',
      'category': 'Symptoms',
      'emoji': '⚡',
      'meaning':
          'Mild, one-sided lower abdominal twinge caused by normal follicle rupture and egg release from the ovary.',
    },
    {
      'term': 'Menstrual Cramps (Dysmenorrhea)',
      'category': 'Symptoms',
      'emoji': '🩸',
      'meaning':
          'Uterine contractions triggered by prostaglandins shedding the endometrial lining. Warmth, magnesium, and hydration provide relief.',
    },
    {
      'term': 'Breast Tenderness (Mastalgia)',
      'category': 'Symptoms',
      'emoji': '🌸',
      'meaning':
          'Common in the luteal phase due to elevated progesterone expanding glandular tissue in the breasts.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = glossaryItems.where((item) {
      final query = _searchQuery.toLowerCase();
      final term = item['term']!.toLowerCase();
      final category = item['category']!.toLowerCase();
      final meaning = item['meaning']!.toLowerCase();
      return term.contains(query) ||
          category.contains(query) ||
          meaning.contains(query);
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
                    const Text('📖', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(
                      'Symptom & Biomarker Guide',
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
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search symptoms, mucus textures, tests...',
                hintStyle: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFFAAA3B8),
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF7A708A),
                  size: 18,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFEFE9F3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFEFE9F3)),
                ),
              ),
            ),
          ),

          const Divider(height: 1, color: Color(0xFFEFE9F3)),

          // List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = filtered[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppRadius.medium,
                    border: Border.all(color: const Color(0xFFEFE9F3)),
                    boxShadow: AppShadows.card,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item['emoji']!,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item['term']!,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E1A3C),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3EDFA),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item['category']!,
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF7C5CE7),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['meaning']!,
                        style: AppTextStyles.caption.copyWith(
                          color: const Color(0xFF4A4259),
                          fontSize: 11.5,
                          height: 1.35,
                        ),
                      ),
                    ],
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
