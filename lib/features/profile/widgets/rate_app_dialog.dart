import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Modal dialog allowing the user to rate FlowCycle with 1 to 5 stars.
class RateAppDialog extends StatefulWidget {
  const RateAppDialog({super.key});

  @override
  State<RateAppDialog> createState() => _RateAppDialogState();
}

class _RateAppDialogState extends State<RateAppDialog> {
  int _rating = 5;
  final TextEditingController _feedbackController = TextEditingController();

  final List<String> _ratingTitles = [
    'Poor 😔',
    'Fair 😐',
    'Good 🙂',
    'Great 😊',
    'Loved it! 💖',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitRating() {
    try {
      Navigator.pop(context);
    } catch (_) {}
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Thank you for rating FlowCycle $_rating stars! ⭐'),
        backgroundColor: const Color(0xFF8B5CF6),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFF2ECFB),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('⭐', style: TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Enjoying FlowCycle?',
              style: AppTextStyles.subtitle.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E1A3C),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your feedback helps us empower more women worldwide.',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: const Color(0xFF7A708A),
              ),
            ),
            const SizedBox(height: 16),

            // Star Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starNum = index + 1;
                final isSelected = starNum <= _rating;
                return IconButton(
                  icon: Icon(
                    isSelected
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: isSelected
                        ? const Color(0xFFFFB800)
                        : const Color(0xFFD4CDDE),
                    size: 36,
                  ),
                  onPressed: () => setState(() => _rating = starNum),
                );
              }),
            ),

            Text(
              _ratingTitles[_rating - 1],
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _feedbackController,
              maxLines: 2,
              style: const TextStyle(fontSize: 13, color: Color(0xFF1E1A3C)),
              decoration: InputDecoration(
                hintText: 'Any extra thoughts or suggestions? (Optional)',
                hintStyle: const TextStyle(
                  color: Color(0xFFAAA3B8),
                  fontSize: 12.5,
                ),
                filled: true,
                fillColor: const Color(0xFFFAF7F5),
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFEDE8E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFEDE8E0)),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Maybe Later',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF7A708A),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitRating,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Submit Rating',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
