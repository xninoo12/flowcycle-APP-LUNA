import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Modal dialog for sending feedback or contacting customer support.
class ContactSupportDialog extends StatefulWidget {
  const ContactSupportDialog({super.key});

  @override
  State<ContactSupportDialog> createState() => _ContactSupportDialogState();
}

class _ContactSupportDialogState extends State<ContactSupportDialog> {
  String _selectedCategory = 'General Inquiry';
  final TextEditingController _messageController = TextEditingController();
  bool _isSubmitting = false;

  final List<String> _categories = [
    'General Inquiry',
    'Feature Suggestion',
    'Bug Report',
    'Data & Privacy',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final msg = _messageController.text.trim();
    if (msg.isEmpty) return;

    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        try {
          Navigator.pop(context);
        } catch (_) {}
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Message sent! Our support team will reply within 24h 💌',
            ),
            backgroundColor: Color(0xFF10B981),
            duration: Duration(seconds: 3),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF0F5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contact Support',
                        style: AppTextStyles.subtitle.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1E1A3C),
                        ),
                      ),
                      Text(
                        "We're here to help you",
                        style: AppTextStyles.caption.copyWith(
                          color: const Color(0xFF7A708A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Category Selector
            Text(
              'TOPIC',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF7A708A),
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7F5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEDE8E0)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary,
                  ),
                  items: _categories.map((c) {
                    return DropdownMenuItem(
                      value: c,
                      child: Text(
                        c,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.5,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedCategory = val);
                  },
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Message Box
            Text(
              'MESSAGE',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF7A708A),
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _messageController,
              maxLines: 4,
              style: const TextStyle(fontSize: 13.5, color: Color(0xFF1E1A3C)),
              decoration: InputDecoration(
                hintText: 'Describe how we can assist you...',
                hintStyle: const TextStyle(
                  color: Color(0xFFAAA3B8),
                  fontSize: 13,
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
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Actions
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF7A708A),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Send Message',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
}
