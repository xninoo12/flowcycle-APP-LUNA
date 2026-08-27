import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../shared/models/app_mode.dart';
import '../../../shared/models/daily_log_entry.dart';
import '../../../shared/providers/app_scope.dart';

/// Interactive Quick Day Action Bottom Sheet triggered on long-pressing any calendar day.
class QuickDayActionSheet extends StatefulWidget {
  final DateTime date;
  final int cycleDayNumber;
  final String phaseName;
  final DailyLogEntry? initialLog;
  final AppMode mode;

  const QuickDayActionSheet({
    super.key,
    required this.date,
    required this.cycleDayNumber,
    required this.phaseName,
    this.initialLog,
    this.mode = AppMode.cycleAwareness,
  });

  @override
  State<QuickDayActionSheet> createState() => _QuickDayActionSheetState();
}

class _QuickDayActionSheetState extends State<QuickDayActionSheet> {
  late String _selectedFlow;
  late String _selectedIntimacy;
  final bool _isPrivateLocked = true;

  @override
  void initState() {
    super.initState();
    _selectedFlow = widget.initialLog?.flow ?? 'None';
    _selectedIntimacy = widget.initialLog?.intimacyStatus ?? 'None';
  }

  void _saveFlow(String flow) {
    setState(() {
      _selectedFlow = flow;
    });
    try {
      final controller = AppScope.read(context);
      final existing = controller.getLogForDate(widget.date);
      final updated = (existing ?? DailyLogEntry(date: widget.date)).copyWith(
        flow: flow == 'None' ? '' : flow,
      );
      controller.saveLogEntry(updated);
    } catch (_) {}
  }

  void _saveIntimacy(String intimacy) {
    setState(() {
      _selectedIntimacy = intimacy;
    });
    try {
      final controller = AppScope.read(context);
      final existing = controller.getLogForDate(widget.date);
      final updated = (existing ?? DailyLogEntry(date: widget.date)).copyWith(
        intimacyStatus: intimacy == 'None' ? '' : intimacy,
        intercourse: intimacy != 'None',
      );
      controller.saveLogEntry(updated);
    } catch (_) {}
  }

  String _formatDate(DateTime dt) {
    const months = [
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
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return '${days[dt.weekday - 1]}, ${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28.0)),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Drag Handle
              Center(
                child: Container(
                  width: 44.0,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2DCE8),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // 2. Date & Cycle Day Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDate(widget.date),
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1A3C),
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          'Cycle Day ${widget.cycleDayNumber} • ${widget.phaseName}',
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8B5CF6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF7FC),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: const Color(0xFFEFE9F3),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isPrivateLocked
                              ? Icons.lock_rounded
                              : Icons.lock_open_rounded,
                          size: 13.0,
                          color: const Color(0xFF8B5CF6),
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          _isPrivateLocked ? 'Private Log' : 'Standard',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF8B5CF6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16.0),
              const Divider(height: 1.0, color: Color(0xFFF1ECF5)),
              const SizedBox(height: 16.0),

              // 3. Quick Period Flow Selection
              const Text(
                'Log Menstrual Flow',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E1A3C),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  _buildFlowChip('None', '⚪'),
                  const SizedBox(width: 6.0),
                  _buildFlowChip('Spotting', '🌸'),
                  const SizedBox(width: 6.0),
                  _buildFlowChip('Light', '💧'),
                  const SizedBox(width: 6.0),
                  _buildFlowChip('Medium', '🩸'),
                  const SizedBox(width: 6.0),
                  _buildFlowChip('Heavy', '🔴'),
                ],
              ),

              const SizedBox(height: 16.0),

              // 4. Quick Intimacy / Sexual Intercourse Selection
              const Text(
                'Log Sexual Intercourse (Private 💜🔒)',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E1A3C),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  _buildIntimacyChip('None', '✕'),
                  const SizedBox(width: 6.0),
                  _buildIntimacyChip('Protected', '🛡️'),
                  const SizedBox(width: 6.0),
                  _buildIntimacyChip('Unprotected', '💜'),
                  const SizedBox(width: 6.0),
                  _buildIntimacyChip('High Libido', '✨'),
                ],
              ),

              const SizedBox(height: 20.0),

              // 5. Full Daily Log Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    try {
                      context.push(
                        AppRoutes.dailyLogPath,
                        extra: {'date': widget.date},
                      );
                    } catch (_) {}
                  },
                  icon: const Icon(
                    Icons.edit_note_rounded,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  label: const Text(
                    'Open Full Daily Log & Symptoms',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE81B54),
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlowChip(String label, String emoji) {
    final isSelected = _selectedFlow == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => _saveFlow(label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 7.0),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFE4E8) : const Color(0xFFFAF7FC),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFE81B54)
                  : const Color(0xFFEFE9F3),
              width: isSelected ? 1.4 : 0.8,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 13.0)),
              const SizedBox(height: 2.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFFE81B54)
                      : const Color(0xFF7A708A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntimacyChip(String label, String emoji) {
    final isSelected = _selectedIntimacy == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => _saveIntimacy(label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 7.0),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEDE9FE) : const Color(0xFFFAF7FC),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF7C3AED)
                  : const Color(0xFFEFE9F3),
              width: isSelected ? 1.4 : 0.8,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 13.0)),
              const SizedBox(height: 2.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF7C3AED)
                      : const Color(0xFF7A708A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
