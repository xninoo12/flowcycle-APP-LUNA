import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Interactive password strength indicator evaluating complexity and providing visual feedback.
class PasswordStrengthMeter extends StatelessWidget {
  final String password;

  const PasswordStrengthMeter({super.key, required this.password});

  int _calculateStrength(String pass) {
    if (pass.isEmpty) return 0;
    int score = 0;
    if (pass.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(pass) && RegExp(r'[a-z]').hasMatch(pass)) {
      score++;
    }
    if (RegExp(r'[0-9]').hasMatch(pass)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(pass)) score++;
    return score;
  }

  Color _getStrengthColor(int score) {
    switch (score) {
      case 1:
        return const Color(0xFFEF4444); // Red
      case 2:
        return const Color(0xFFF59E0B); // Amber
      case 3:
        return const Color(0xFF3B82F6); // Blue
      case 4:
        return const Color(0xFF10B981); // Emerald Green
      default:
        return const Color(0xFFE5E5EB); // Inactive grey
    }
  }

  String _getStrengthLabel(int score) {
    switch (score) {
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return 'Enter password';
    }
  }

  @override
  Widget build(BuildContext context) {
    final score = _calculateStrength(password);
    final color = _getStrengthColor(score);
    final label = _getStrengthLabel(score);

    if (password.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Password strength:',
              style: AppTextStyles.caption.copyWith(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: List.generate(4, (index) {
            final isActive = index < score;
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index < 3 ? 6 : 0),
                decoration: BoxDecoration(
                  color: isActive ? color : const Color(0xFFEDEDF2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            _buildRequirement('8+ chars', password.length >= 8),
            _buildRequirement(
              'A-Z & a-z',
              RegExp(r'[A-Z]').hasMatch(password) &&
                  RegExp(r'[a-z]').hasMatch(password),
            ),
            _buildRequirement('Number', RegExp(r'[0-9]').hasMatch(password)),
            _buildRequirement(
              'Symbol',
              RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRequirement(String text, bool isMet) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isMet ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
          size: 11,
          color: isMet ? const Color(0xFF10B981) : const Color(0xFFA59FA9),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isMet ? FontWeight.w600 : FontWeight.w500,
            color: isMet ? const Color(0xFF1E1A22) : const Color(0xFFA59FA9),
          ),
        ),
      ],
    );
  }
}
