import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/route_names.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/app_mode.dart';
import '../../../shared/models/daily_log_entry.dart';

/// Modal detailing comprehensive biomarkers, logged data, and fertility cues for a selected day.
class DayDetailsModal extends StatelessWidget {
  final DateTime date;
  final int cycleDayNumber;
  final String phaseName;
  final String conceptionChance;
  final DailyLogEntry? logEntry;
  final AppMode mode;

  const DayDetailsModal({
    super.key,
    required this.date,
    required this.cycleDayNumber,
    required this.phaseName,
    required this.conceptionChance,
    this.logEntry,
    this.mode = AppMode.cycleAwareness,
  });

  String _formatDateString(DateTime dt) {
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
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDateString(date);
    final isTtc = mode == AppMode.tryingToConceive;
    final hasLog = logEntry != null;

    return Container(
      height: MediaQuery.of(context).size.height * 0.76,
      decoration: const BoxDecoration(
        color: Color(0xFFFAF8FC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Top Handle & Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 14, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('🗓️', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateStr,
                          style: AppTextStyles.subtitle.copyWith(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1E1A3C),
                            fontSize: 14.5,
                          ),
                        ),
                        Text(
                          'Cycle Day $cycleDayNumber • $phaseName',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7C5CE7),
                          ),
                        ),
                      ],
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

          const Divider(height: 1, color: Color(0xFFEFE9F3)),

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Conception / Phase Banner
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isTtc
                          ? const Color(0xFFFDE8EF)
                          : const Color(0xFFF3EDFA),
                      borderRadius: AppRadius.medium,
                      border: Border.all(
                        color: isTtc
                            ? const Color(0xFFFBCFE8)
                            : const Color(0xFFDDD6FE),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          isTtc ? '💗' : '✨',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isTtc
                                    ? 'Fertility Chance: $conceptionChance'
                                    : 'Phase: $phaseName',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                  color: isTtc
                                      ? const Color(0xFF9D174D)
                                      : const Color(0xFF5B21B6),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isTtc
                                    ? 'Cervical fluid cues and thermal markers support highest conception odds.'
                                    : 'Estrogen and progesterone support steady hormonal energy and focus.',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF4A4259),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'DAILY RECORDED BIOMARKERS',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF7A708A),
                      letterSpacing: 0.8,
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 8),

                  if (!hasLog)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.medium,
                        border: Border.all(color: const Color(0xFFEFE9F3)),
                      ),
                      child: const Center(
                        child: Text(
                          'No entries recorded for this day yet.\nTap below to log symptoms, flow, or intimacy.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8C7C92),
                            height: 1.4,
                          ),
                        ),
                      ),
                    )
                  else ...[
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricPill(
                            'Mood',
                            logEntry!.mood,
                            Icons.sentiment_satisfied_alt_rounded,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildMetricPill(
                            'Flow',
                            logEntry!.flow,
                            Icons.water_drop_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricPill(
                            'Mucus',
                            logEntry!.cervicalMucus.isNotEmpty
                                ? logEntry!.cervicalMucus
                                : 'None',
                            Icons.opacity_rounded,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildMetricPill(
                            'BBT',
                            logEntry!.bbtTemperature != null
                                ? '${logEntry!.bbtTemperature}°F'
                                : '36.65°C',
                            Icons.thermostat_outlined,
                          ),
                        ),
                      ],
                    ),
                    if (logEntry!.symptoms.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Text(
                        'LOGGED SYMPTOMS',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF7A708A),
                          letterSpacing: 0.8,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: logEntry!.symptoms.map((s) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE5DBFF),
                              ),
                            ),
                            child: Text(
                              s,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF7C5CE7),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    if (logEntry!.notes.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Text(
                        'DAILY NOTES & JOURNAL',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF7A708A),
                          letterSpacing: 0.8,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE5DBFF),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('📝', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                logEntry!.notes,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  height: 1.4,
                                  color: Color(0xFF2D264B),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),

          // Bottom Action
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: AppShadows.card,
              border: const Border(top: BorderSide(color: Color(0xFFEFE9F3))),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  try {
                    context.push(AppRoutes.dailyLogPath, extra: {'date': date});
                  } catch (_) {}
                },
                icon: const Icon(Icons.edit_note_rounded, size: 20),
                label: Text(
                  hasLog ? 'Edit Log For This Day' : 'Log For This Day',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C5CE7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricPill(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.medium,
        border: Border.all(color: const Color(0xFFEFE9F3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF7C5CE7), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 9.5,
                    color: Color(0xFF7A708A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1A3C),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
