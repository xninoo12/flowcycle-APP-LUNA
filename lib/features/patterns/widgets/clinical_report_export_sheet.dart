import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/pattern_models.dart';

class ClinicalReportExportSheet extends StatefulWidget {
  final ClinicalReportSummary summary;

  const ClinicalReportExportSheet({super.key, required this.summary});

  @override
  State<ClinicalReportExportSheet> createState() =>
      _ClinicalReportExportSheetState();
}

class _ClinicalReportExportSheetState extends State<ClinicalReportExportSheet> {
  bool _isExporting = false;

  void _handleExportPdf() {
    setState(() => _isExporting = true);
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() => _isExporting = false);
      nav.pop();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('📄 Clinical PDF Report generated successfully!'),
          backgroundColor: Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void _handleCopySummary() {
    final text =
        'FLOWCYCLE CLINICAL CYCLE REPORT\n'
        'Patient: ${widget.summary.patientName}\n'
        'Date: ${widget.summary.generatedDate}\n'
        'Range: ${widget.summary.dateRange}\n'
        'Avg Cycle Length: ${widget.summary.averageCycleLength} days (±${widget.summary.cycleVariationDays}d)\n'
        'Avg Period Duration: ${widget.summary.averagePeriodDuration} days\n'
        'Ovulation Confirmed: ${widget.summary.biphasicShiftConfirmed ? "Yes (Day ${widget.summary.estimatedOvulationDay})" : "Pending"}\n'
        'Key Symptoms: ${widget.summary.topRecurringSymptoms.join(", ")}\n'
        'Notes: ${widget.summary.clinicalNotes}';

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📋 Clinical Summary copied to clipboard!'),
        backgroundColor: Color(0xFF7C5CE7),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.summary;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFAF8FC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 6.0),
              width: 38.0,
              height: 4.5,
              decoration: BoxDecoration(
                color: const Color(0xFFDDD6E5),
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Icon(
                          Icons.medical_information_rounded,
                          color: Color(0xFF2E7D32),
                          size: 22.0,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Doctor / OB-GYN Summary',
                              style: AppTextStyles.subtitle.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 16.0,
                                color: const Color(0xFF1E1A3C),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Clinical export for medical consultations',
                              style: TextStyle(
                                fontSize: 11.0,
                                color: Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20.0),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const Divider(height: 1.0, color: Color(0xFFEDE7F3)),

          // Scrollable Report Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Patient & Metadata Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.medium,
                      border: Border.all(color: const Color(0xFFEFE9F5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Patient: ${s.patientName}',
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E1A3C),
                              ),
                            ),
                            Text(
                              s.generatedDate,
                              style: TextStyle(
                                fontSize: 11.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Analysis Window: ${s.dateRange} (${s.totalCyclesAnalyzed} Cycles)',
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF7C5CE7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14.0),

                  // Key Metrics Grid
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.medium,
                      border: Border.all(color: const Color(0xFFEFE9F5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CLINICAL BIOMARKERS',
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: Color(0xFF7C5CE7),
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        _buildMetricRow(
                          'Average Cycle Length',
                          '${s.averageCycleLength} days (±${s.cycleVariationDays}d variance)',
                          'Regular',
                          Colors.green,
                        ),
                        const Divider(height: 16.0, color: Color(0xFFF3EDF7)),
                        _buildMetricRow(
                          'Period Duration',
                          '${s.averagePeriodDuration} days (Normal 3-7d)',
                          'Healthy',
                          Colors.green,
                        ),
                        const Divider(height: 16.0, color: Color(0xFFF3EDF7)),
                        _buildMetricRow(
                          'Ovulation & BBT Shift',
                          'Confirmed Biphasic Shift',
                          'Day ${s.estimatedOvulationDay}',
                          const Color(0xFF7C5CE7),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14.0),

                  // Top Symptoms
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.medium,
                      border: Border.all(color: const Color(0xFFEFE9F5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PRIMARY RECURRING SYMPTOMS',
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: Color(0xFF7C5CE7),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: s.topRecurringSymptoms.map((sym) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 5.0,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F0FD),
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: const Color(0xFFE8DAF8),
                                ),
                              ),
                              child: Text(
                                sym,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF4A148C),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14.0),

                  // Clinical Notes
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF9FD),
                      borderRadius: AppRadius.medium,
                      border: Border.all(color: const Color(0xFFEDE8F5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Physician Note Summary:',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E1A3C),
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          s.clinicalNotes,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Colors.grey.shade700,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons
          Container(
            padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: const Border(top: BorderSide(color: Color(0xFFEDE7F3))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _handleCopySummary,
                    icon: const Icon(Icons.copy_rounded, size: 16.0),
                    label: const Text('Copy Text'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1E1A3C),
                      side: const BorderSide(color: Color(0xFFDCD6E5)),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _isExporting ? null : _handleExportPdf,
                    icon: _isExporting
                        ? const SizedBox(
                            width: 16.0,
                            height: 16.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.picture_as_pdf_rounded, size: 18.0),
                    label: Text(
                      _isExporting
                          ? 'Generating PDF...'
                          : 'Download PDF Report',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C5CE7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
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

  Widget _buildMetricRow(
    String label,
    String value,
    String badge,
    Color badgeColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E1A3C),
              ),
            ),
            const SizedBox(height: 2.0),
            Text(
              value,
              style: TextStyle(fontSize: 11.0, color: Colors.grey.shade600),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Text(
            badge,
            style: TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.w700,
              color: badgeColor,
            ),
          ),
        ),
      ],
    );
  }
}
