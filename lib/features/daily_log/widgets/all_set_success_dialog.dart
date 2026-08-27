import 'package:flutter/material.dart';

/// Celebratory "All Set!" summary popup dialog matching exact UI specifications.
class AllSetSuccessDialog extends StatelessWidget {
  final String moodText;
  final String flowText;
  final String sleepText;
  final String energyText;
  final VoidCallback? onViewLog;
  final VoidCallback? onDone;

  const AllSetSuccessDialog({
    super.key,
    this.moodText = 'Good 😊',
    this.flowText = 'Light',
    this.sleepText = '7h 30m',
    this.energyText = 'Medium',
    this.onViewLog,
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 24.0,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 22.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button at top-right
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 24.0,
                  height: 24.0,
                  color: Colors.transparent,
                  child: const Center(
                    child: Icon(
                      Icons.close_rounded,
                      size: 16.0,
                      color: Color(0xFF7A708A),
                    ),
                  ),
                ),
              ),
            ),

            // 1. Glowing Purple Checkmark Badge
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: const Color(0xFFF3EDFA),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C5CE7).withValues(alpha: 0.18),
                    blurRadius: 16.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 54.0,
                  height: 54.0,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF9D84EB), Color(0xFF7C5CE7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14.0),

            // 2. All Set! Title & Subtitle
            const Text(
              'All Set!',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E1A3C),
                letterSpacing: -0.3,
              ),
            ),

            const SizedBox(height: 3.0),

            const Text(
              'Your log has been saved\nsuccessfully.',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF7A708A),
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16.0),

            // 3. Today's Summary Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF8FC),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: const Color(0xFFEFE9F3), width: 1.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Summary",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E1A3C),
                    ),
                  ),

                  const SizedBox(height: 10.0),

                  _buildSummaryItem(
                    label: 'Mood',
                    value: moodText,
                    trailingWidget: const Text(
                      '😊',
                      style: TextStyle(fontSize: 13.0),
                    ),
                  ),
                  const SizedBox(height: 7.0),
                  _buildSummaryItem(
                    label: 'Flow',
                    value: flowText,
                    trailingWidget: const Icon(
                      Icons.water_drop_rounded,
                      size: 13.0,
                      color: Color(0xFFE11D48),
                    ),
                  ),
                  const SizedBox(height: 7.0),
                  _buildSummaryItem(
                    label: 'Sleep',
                    value: sleepText,
                    trailingWidget: const Icon(
                      Icons.nightlight_round,
                      size: 13.0,
                      color: Color(0xFF7C5CE7),
                    ),
                  ),
                  const SizedBox(height: 7.0),
                  _buildSummaryItem(
                    label: 'Energy',
                    value: energyText,
                    trailingWidget: const Icon(
                      Icons.bolt_rounded,
                      size: 13.0,
                      color: Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16.0),

            // 4. Action Buttons (View Log & Done)
            SizedBox(
              width: double.infinity,
              height: 42.0,
              child: OutlinedButton(
                onPressed: onViewLog ?? () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF7C5CE7),
                  side: const BorderSide(color: Color(0xFFEDE5F6), width: 1.0),
                  backgroundColor: const Color(0xFFFAF8FC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                ),
                child: const Text(
                  'View Log',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7C5CE7),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8.0),

            SizedBox(
              width: double.infinity,
              height: 42.0,
              child: ElevatedButton(
                onPressed: onDone ?? () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C5CE7),
                  foregroundColor: Colors.white,
                  elevation: 2.0,
                  shadowColor: const Color(0xFF7C5CE7).withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String value,
    required Widget trailingWidget,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: Color(0xFF7A708A),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E1A3C),
              ),
            ),
            const SizedBox(width: 4.0),
            trailingWidget,
          ],
        ),
      ],
    );
  }
}
