import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Trust and Reassurance banner row (100% Private, Personalized, Expert-Backed)
/// for the Choose Mode screen.
class ChooseModeTrustRow extends StatelessWidget {
  const ChooseModeTrustRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: const Color(0xFFF3E8EE),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1A3C).withValues(alpha: 0.02),
            blurRadius: 10.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. 100% Private
          Expanded(
            child: _buildTrustItem(
              icon: Icons.verified_user_rounded,
              title: '100% Private',
              subtitle: 'Your data is safe\nand secure.',
            ),
          ),

          _buildDivider(),

          // 2. Personalized
          Expanded(
            child: _buildTrustItem(
              icon: Icons.nightlight_round,
              title: 'Personalized',
              subtitle: 'Insights tailored\njust for you.',
            ),
          ),

          _buildDivider(),

          // 3. Expert-Backed
          Expanded(
            child: _buildTrustItem(
              icon: Icons.workspace_premium_rounded,
              title: 'Expert-Backed',
              subtitle: 'Trusted by doctors\nand specialists.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 30.0,
          height: 30.0,
          decoration: BoxDecoration(
            color: const Color(0xFFFFEEF2),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFFFD1DC),
              width: 1.0,
            ),
          ),
          child: Center(
            child: Icon(
              icon,
              size: 15.0,
              color: AppColors.primaryRose,
            ),
          ),
        ),
        const SizedBox(width: 6.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1A3C),
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 1.0),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 9.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7A708A),
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: 4.0,
      height: 4.0,
      decoration: const BoxDecoration(
        color: Color(0xFFECCED8),
        shape: BoxShape.circle,
      ),
    );
  }
}
