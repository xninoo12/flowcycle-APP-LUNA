import 'package:flutter/material.dart';

/// Multi-select Symptoms chip selector with categorized options and custom symptom adder.
class SymptomsChipsSelector extends StatelessWidget {
  final Set<String> selectedSymptoms;
  final ValueChanged<String>? onToggleSymptom;
  final ValueChanged<String>? onAddCustomSymptom;

  static const List<String> availableSymptoms = [
    'Cramps',
    'Bloating',
    'Headache',
    'Backache',
    'Fatigue',
    'Tender Breasts',
    'Acne',
    'Nausea',
    'Mood Swings',
    'Ovulation Twinge',
    'Insomnia',
    'Pelvic Pressure',
  ];

  const SymptomsChipsSelector({
    super.key,
    required this.selectedSymptoms,
    this.onToggleSymptom,
    this.onAddCustomSymptom,
  });

  void _showAddCustomDialog(BuildContext context) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Text('➕', style: TextStyle(fontSize: 16)),
            SizedBox(width: 8),
            Text(
              'Add Custom Symptom',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1A3C),
              ),
            ),
          ],
        ),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'e.g. Dizziness, Cravings, Night Sweats',
            hintStyle: const TextStyle(fontSize: 12, color: Color(0xFFAAA3B8)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEFE9F3)),
            ),
          ),
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
              final text = textController.text.trim();
              if (text.isNotEmpty) {
                onAddCustomSymptom?.call(text);
                onToggleSymptom?.call(text);
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C5CE7),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Combine standard symptoms and any custom selected symptoms
    final allDisplaySymptoms = {
      ...availableSymptoms,
      ...selectedSymptoms,
    }.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Symptoms & Biomarkers',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1A3C),
              ),
            ),
            Text(
              'Select all that apply',
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w500,
                color: Color(0xFF7A708A),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8.0),

        // Chips Wrap
        Wrap(
          spacing: 6.0,
          runSpacing: 6.0,
          children: [
            ...allDisplaySymptoms.map((symptom) {
              final bool isSelected = selectedSymptoms.contains(symptom);
              return GestureDetector(
                onTap: () => onToggleSymptom?.call(symptom),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11.0,
                    vertical: 6.5,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF7C5CE7)
                        : const Color(0xFFFAF8FC),
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF7C5CE7)
                          : const Color(0xFFEFE9F3),
                      width: 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(
                                0xFF7C5CE7,
                              ).withValues(alpha: 0.25),
                              blurRadius: 4.0,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    symptom,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF4A4358),
                    ),
                  ),
                ),
              );
            }),
            // + Add Custom Button
            GestureDetector(
              onTap: () => _showAddCustomDialog(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 6.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: const Color(0xFF7C5CE7),
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.add_rounded, size: 14, color: Color(0xFF7C5CE7)),
                    SizedBox(width: 2),
                    Text(
                      'Custom',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7C5CE7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
