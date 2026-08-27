import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Journal reflection and AI Companion entry point card for FlowCycle Dashboard.
class JournalPromptCard extends StatelessWidget {
  final VoidCallback? onPromptTap;
  final VoidCallback? onAddTap;

  const JournalPromptCard({super.key, this.onPromptTap, this.onAddTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.large,
        border: Border.all(color: const Color(0xFFEFE9F3), width: 1.0),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          // 1. 3D Notebook & Pen Illustration Container
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEEF3),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: const Color(0xFFFFD4E2), width: 1.0),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: const [
                Icon(
                  Icons.menu_book_rounded,
                  color: Color(0xFFE84D75),
                  size: 26.0,
                ),
                Positioned(
                  right: 6.0,
                  bottom: 6.0,
                  child: Icon(
                    Icons.edit_rounded,
                    color: Color(0xFF6C449B),
                    size: 14.0,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // 2. Prompt Text
          Expanded(
            child: InkWell(
              onTap: onPromptTap ?? onAddTap,
              borderRadius: BorderRadius.circular(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How are you feeling today? ✨',
                    style: AppTextStyles.subtitle.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                      color: const Color(0xFFE84D75),
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    'Write your thoughts, emotions or anything on your mind...',
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFF7A708A),
                      fontSize: 11.5,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.sm),

          // 3. Floating Plus Action Button
          GestureDetector(
            onTap: onAddTap ?? onPromptTap,
            child: Container(
              width: 38.0,
              height: 38.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFE84D75), Color(0xFFFF8FA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE84D75).withValues(alpha: 0.38),
                    blurRadius: 8.0,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.add_rounded, color: Colors.white, size: 24.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
