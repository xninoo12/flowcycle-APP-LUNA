import 'package:flutter/material.dart';

/// Privacy explainer and quick-action tip card for FlowCycle Calendar.
class CalendarPrivacyTipCard extends StatelessWidget {
  final VoidCallback? onTipTap;

  const CalendarPrivacyTipCard({
    super.key,
    this.onTipTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: const Color(0xFFF1ECF5),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Purple Lock-Heart Circular Badge
          Container(
            width: 42.0,
            height: 42.0,
            decoration: const BoxDecoration(
              color: Color(0xFFF3E8FF),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: const [
                Icon(
                  Icons.favorite_rounded,
                  color: Color(0xFF8B5CF6),
                  size: 22.0,
                ),
                Positioned(
                  bottom: 9.0,
                  right: 9.0,
                  child: Icon(
                    Icons.lock_rounded,
                    color: Colors.white,
                    size: 10.0,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10.0),

          // 2. Sex Logged (Private) Explainer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Sex Logged (Private)',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1A3C),
                  ),
                ),
                SizedBox(height: 2.0),
                Text(
                  'Days marked with this heart with lock mean sexual intercourse was logged and kept private.',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7A708A),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 8.0),

          // 3. Green Tap & Hold Tip Box
          GestureDetector(
            onTap: onTipTap,
            child: Container(
              width: 110.0,
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: const Color(0xFFA7F3D0),
                  width: 0.8,
                ),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.touch_app_rounded,
                    color: Color(0xFF10B981),
                    size: 18.0,
                  ),
                  SizedBox(width: 4.0),
                  Expanded(
                    child: Text(
                      'Tap & hold a day to edit, add notes or lock it.',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF047857),
                        height: 1.2,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
