import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_text_styles.dart';

/// Micro-banner that slides into view with smooth spring dynamics
/// to celebrate cycle milestones (e.g. Peak Fertility window opening, Period logged).
class PhaseCelebrationBanner extends StatefulWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color accentColor;
  final VoidCallback? onDismiss;

  const PhaseCelebrationBanner({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.auto_awesome_rounded,
    this.accentColor = AppColors.primary,
    this.onDismiss,
  });

  @override
  State<PhaseCelebrationBanner> createState() => _PhaseCelebrationBannerState();
}

class _PhaseCelebrationBannerState extends State<PhaseCelebrationBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.large,
            boxShadow: AppShadows.card,
            border: Border.all(
              color: widget.accentColor.withValues(alpha: 0.3),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: widget.accentColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  color: widget.accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E1A3C),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.message,
                      style: AppTextStyles.caption.copyWith(
                        color: const Color(0xFF7A708A),
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.onDismiss != null)
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF9E95AF)),
                  onPressed: () {
                    _controller.reverse().then((_) {
                      widget.onDismiss?.call();
                    });
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
