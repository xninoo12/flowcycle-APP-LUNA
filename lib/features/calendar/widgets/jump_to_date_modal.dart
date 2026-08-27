import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

/// Modal picker allowing fast jumping to any past or future cycle month.
class JumpToDateModal extends StatefulWidget {
  final int initialMonth;
  final int initialYear;
  final void Function(int month, int year) onDateSelected;

  const JumpToDateModal({
    super.key,
    this.initialMonth = 5,
    this.initialYear = 2025,
    required this.onDateSelected,
  });

  @override
  State<JumpToDateModal> createState() => _JumpToDateModalState();
}

class _JumpToDateModalState extends State<JumpToDateModal> {
  late int _selectedMonth;
  late int _selectedYear;

  static const List<String> monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const List<int> availableYears = [2024, 2025, 2026, 2027];

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.initialMonth;
    _selectedYear = widget.initialYear;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFAF8FC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('🗓️', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        'Jump to Specific Date',
                        style: AppTextStyles.subtitle.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1E1A3C),
                          fontSize: 15,
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

              const Divider(height: 1, color: Color(0xFFEFE9F3)),
              const SizedBox(height: 14),

              // Year Selector Chips
              const Text(
                'SELECT YEAR',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF7A708A),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: availableYears.map((yr) {
                  final isSelected = _selectedYear == yr;
                  return ChoiceChip(
                    label: Text('$yr'),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedYear = yr),
                    selectedColor: const Color(0xFFF3EDFA),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFF7C5CE7)
                          : const Color(0xFF4A4259),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFF7C5CE7)
                            : const Color(0xFFEFE9F3),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Month Selector Grid
              const Text(
                'SELECT MONTH',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF7A708A),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.5,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  final monthNum = index + 1;
                  final isSelected = _selectedMonth == monthNum;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedMonth = monthNum),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF7C5CE7)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF7C5CE7)
                              : const Color(0xFFEFE9F3),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          monthNames[index],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w800
                                : FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF1E1A3C),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 18),

              // Confirm CTA
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onDateSelected(_selectedMonth, _selectedYear);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C5CE7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Jump to Selected Date',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
