import 'package:flutter/material.dart';
import '../../../shared/providers/cycle_data_controller.dart';

/// Interactive Quick-Log Sheets Suite for FlowCycle Main Dashboard.
class QuickLogSheets {
  /// 1. Flow Intensity Sheet
  static void showFlowSheet(
    BuildContext context,
    CycleDataController controller,
  ) {
    final currentFlow = controller.getTodayLog().flow;
    final options = ['Spotting', 'Light', 'Medium', 'Heavy', 'Very heavy'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BaseQuickSheet(
        title: 'Period Flow Intensity',
        emoji: '🩸',
        child: Column(
          children: options.map((flow) {
            final isSelected = currentFlow == flow;
            return _QuickOptionTile(
              label: flow,
              isSelected: isSelected,
              activeColor: const Color(0xFFFF4D79),
              onTap: () {
                final todayLog = controller.getTodayLog();
                controller.saveLogEntry(todayLog.copyWith(flow: flow));
                Navigator.pop(ctx);
                _showToast(context, 'Flow set to $flow 🩸');
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  /// 2. Mood Picker Sheet
  static void showMoodSheet(
    BuildContext context,
    CycleDataController controller,
  ) {
    final currentMood = controller.getTodayLog().mood;
    final moods = [
      {'label': 'Great', 'emoji': '🤩'},
      {'label': 'Good', 'emoji': '😊'},
      {'label': 'Neutral', 'emoji': '😐'},
      {'label': 'Tired', 'emoji': '😴'},
      {'label': 'Sad', 'emoji': '😔'},
      {'label': 'Anxious', 'emoji': '😰'},
      {'label': 'Irritable', 'emoji': '😤'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BaseQuickSheet(
        title: "How are you feeling today?",
        emoji: '✨',
        child: Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: moods.map((m) {
            final label = m['label']!;
            final emoji = m['emoji']!;
            final isSelected = currentMood == label;

            return Material(
              color: isSelected ? const Color(0xFFFEF3C7) : Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              child: InkWell(
                onTap: () {
                  final todayLog = controller.getTodayLog();
                  controller.saveLogEntry(todayLog.copyWith(mood: label));
                  Navigator.pop(ctx);
                  _showToast(context, 'Mood logged: $emoji $label');
                },
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFF59E0B)
                          : const Color(0xFFEFE9F3),
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 18.0)),
                      const SizedBox(width: 6.0),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected
                              ? const Color(0xFF92400E)
                              : const Color(0xFF1E1A3C),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// 3. Symptoms Multi-Select Sheet
  static void showSymptomsSheet(
    BuildContext context,
    CycleDataController controller,
  ) {
    final allSymptoms = [
      'Cramps',
      'Bloating',
      'Headache',
      'Tender Breasts',
      'Acne',
      'Fatigue',
      'Backache',
      'Nausea',
      'Insomnia',
      'Cravings',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final todayLog = controller.getTodayLog();
          final activeSymptoms = todayLog.symptoms.toSet();

          return _BaseQuickSheet(
            title: 'Track Symptoms',
            emoji: '🤒',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: allSymptoms.map((symptom) {
                    final isSelected = activeSymptoms.contains(symptom);

                    return Material(
                      color: isSelected ? const Color(0xFFF3E8FF) : Colors.white,
                      borderRadius: BorderRadius.circular(14.0),
                      child: InkWell(
                        onTap: () {
                          final updated = List<String>.from(todayLog.symptoms);
                          if (isSelected) {
                            updated.remove(symptom);
                          } else {
                            updated.add(symptom);
                          }
                          controller.saveLogEntry(todayLog.copyWith(symptoms: updated));
                          setSheetState(() {});
                        },
                        borderRadius: BorderRadius.circular(14.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14.0,
                            vertical: 10.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.0),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF8B5CF6)
                                  : const Color(0xFFEFE9F3),
                              width: isSelected ? 1.5 : 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isSelected) ...[
                                const Icon(
                                  Icons.check_circle_rounded,
                                  size: 14.0,
                                  color: Color(0xFF8B5CF6),
                                ),
                                const SizedBox(width: 4.0),
                              ],
                              Text(
                                symptom,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: isSelected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  color: isSelected
                                      ? const Color(0xFF6B21A8)
                                      : const Color(0xFF1E1A3C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  height: 46.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showToast(context, 'Symptoms updated ✨');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C5CE7),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 4. Sleep Tracker Sheet
  static void showSleepSheet(
    BuildContext context,
    CycleDataController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final todayLog = controller.getTodayLog();
          final currentRating = todayLog.sleepRating;

          return _BaseQuickSheet(
            title: 'Sleep Quality & Duration',
            emoji: '🌙',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sleep Quality Rating',
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7A708A),
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starIndex = index + 1;
                    final isFilled = starIndex <= currentRating;

                    return GestureDetector(
                      onTap: () {
                        controller.saveLogEntry(
                          todayLog.copyWith(sleepRating: starIndex),
                        );
                        setSheetState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Icon(
                          isFilled
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: const Color(0xFFF59E0B),
                          size: 38.0,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  height: 46.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showToast(context, 'Sleep logged: $currentRating / 5 stars ⭐');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    child: const Text(
                      'Save Sleep Log',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 5. Quick Notes Sheet
  static void showNotesSheet(
    BuildContext context,
    CycleDataController controller,
  ) {
    final noteController = TextEditingController(
      text: controller.getTodayLog().notes,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: _BaseQuickSheet(
          title: 'Daily Journal & Notes',
          emoji: '✏️',
          child: Column(
            children: [
              TextField(
                controller: noteController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Record symptoms, emotions, or reflections...',
                  hintStyle: const TextStyle(
                    fontSize: 13.0,
                    color: Color(0xFFA197B0),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF9F7FB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(color: Color(0xFFEDE8F2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(color: Color(0xFFEDE8F2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(color: Color(0xFF7C5CE7), width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                height: 46.0,
                child: ElevatedButton(
                  onPressed: () {
                    final todayLog = controller.getTodayLog();
                    controller.saveLogEntry(
                      todayLog.copyWith(notes: noteController.text),
                    );
                    Navigator.pop(ctx);
                    _showToast(context, 'Note saved ✏️');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: const Text(
                    'Save Note',
                    style: TextStyle(
                      fontSize: 14.5,
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

  /// 6. TTC Intercourse Sheet
  static void showTtcIntercourseSheet(
    BuildContext context,
    CycleDataController controller,
  ) {
    final isLogged = controller.getTodayLog().intercourse;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BaseQuickSheet(
        title: 'Log Conception Intercourse',
        emoji: '💜',
        child: Column(
          children: [
            _QuickOptionTile(
              label: 'Yes, had intercourse today 💕',
              isSelected: isLogged,
              activeColor: const Color(0xFFE81B54),
              onTap: () {
                final todayLog = controller.getTodayLog();
                controller.saveLogEntry(todayLog.copyWith(intercourse: true));
                Navigator.pop(ctx);
                _showToast(context, 'Logged intercourse for today! 💕');
              },
            ),
            _QuickOptionTile(
              label: 'No intercourse logged',
              isSelected: !isLogged,
              activeColor: const Color(0xFF7A708A),
              onTap: () {
                final todayLog = controller.getTodayLog();
                controller.saveLogEntry(todayLog.copyWith(intercourse: false));
                Navigator.pop(ctx);
                _showToast(context, 'Intercourse cleared');
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 7. TTC LH Test Result Sheet
  static void showTtcLhTestSheet(
    BuildContext context,
    CycleDataController controller,
  ) {
    final currentResult = controller.getTodayLog().lhTestResult;
    final options = [
      {'label': 'Positive / LH Peak Surge 🔴', 'val': 'Positive'},
      {'label': 'High / Faint Line 🟡', 'val': 'High'},
      {'label': 'Low / Negative ⚪', 'val': 'Negative'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BaseQuickSheet(
        title: 'Ovulation (LH) Test Strip',
        emoji: '🧪',
        child: Column(
          children: options.map((opt) {
            final isSelected = currentResult == opt['val'];

            return _QuickOptionTile(
              label: opt['label']!,
              isSelected: isSelected,
              activeColor: const Color(0xFF7C3AED),
              onTap: () {
                final todayLog = controller.getTodayLog();
                controller.saveLogEntry(
                  todayLog.copyWith(lhTestResult: opt['val']),
                );
                Navigator.pop(ctx);
                _showToast(context, 'LH Test recorded: ${opt['val']} 🧪');
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  /// 8. TTC Basal Body Temperature (BBT) Stepper Sheet
  static void showTtcBbtSheet(
    BuildContext context,
    CycleDataController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final todayLog = controller.getTodayLog();
          final double bbt = todayLog.bbtTemperature ?? 36.65;

          return _BaseQuickSheet(
            title: 'Basal Body Temperature (BBT)',
            emoji: '🌡️',
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_rounded, size: 36.0),
                      color: const Color(0xFFE81B54),
                      onPressed: () {
                        final newTemp = (bbt - 0.05).clamp(35.0, 39.0);
                        controller.saveLogEntry(
                          todayLog.copyWith(bbtTemperature: newTemp),
                        );
                        setSheetState(() {});
                      },
                    ),
                    const SizedBox(width: 14.0),
                    Text(
                      '${bbt.toStringAsFixed(2)} °C',
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 28.0,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFE81B54),
                      ),
                    ),
                    const SizedBox(width: 14.0),
                    IconButton(
                      icon: const Icon(Icons.add_circle_rounded, size: 36.0),
                      color: const Color(0xFFE81B54),
                      onPressed: () {
                        final newTemp = (bbt + 0.05).clamp(35.0, 39.0);
                        controller.saveLogEntry(
                          todayLog.copyWith(bbtTemperature: newTemp),
                        );
                        setSheetState(() {});
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  height: 46.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showToast(context, 'BBT saved: ${bbt.toStringAsFixed(2)} °C 🌡️');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE81B54),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    child: const Text(
                      'Save BBT',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 9. TTC Cervical Mucus Consistency Sheet
  static void showTtcCervicalMucusSheet(
    BuildContext context,
    CycleDataController controller,
  ) {
    final currentMucus = controller.getTodayLog().cervicalMucus;
    final options = [
      {'label': 'Egg White (Peak Fertility) 🎯', 'val': 'Egg white'},
      {'label': 'Watery / Clear (High Fertility) 💧', 'val': 'Watery'},
      {'label': 'Creamy (Fertile Transition) 🥛', 'val': 'Creamy'},
      {'label': 'Sticky / Thick 🧴', 'val': 'Sticky'},
      {'label': 'Dry / None 🌵', 'val': 'Dry'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BaseQuickSheet(
        title: 'Cervical Fluid Consistency',
        emoji: '💧',
        child: Column(
          children: options.map((opt) {
            final isSelected = currentMucus == opt['val'];

            return _QuickOptionTile(
              label: opt['label']!,
              isSelected: isSelected,
              activeColor: const Color(0xFFD97706),
              onTap: () {
                final todayLog = controller.getTodayLog();
                controller.saveLogEntry(
                  todayLog.copyWith(cervicalMucus: opt['val']),
                );
                Navigator.pop(ctx);
                _showToast(context, 'Cervical Fluid: ${opt['val']} 💧');
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  static void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xFF1E1A3C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _BaseQuickSheet extends StatelessWidget {
  final String title;
  final String emoji;
  final Widget child;

  const _BaseQuickSheet({
    required this.title,
    required this.emoji,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26.0)),
      ),
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 28.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 38.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: const Color(0xFFE2DCE8),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
          const SizedBox(height: 14.0),
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20.0)),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1A3C),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20.0),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(height: 18.0, color: Color(0xFFF1EBF5)),
          const SizedBox(height: 8.0),
          child,
        ],
      ),
    );
  }
}

class _QuickOptionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const _QuickOptionTile({
    required this.label,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        color: isSelected
            ? activeColor.withValues(alpha: 0.08)
            : const Color(0xFFFAF8FC),
        borderRadius: BorderRadius.circular(14.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(
                color: isSelected ? activeColor : const Color(0xFFEDE8F2),
                width: isSelected ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? activeColor : const Color(0xFF1E1A3C),
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle_rounded, color: activeColor, size: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
