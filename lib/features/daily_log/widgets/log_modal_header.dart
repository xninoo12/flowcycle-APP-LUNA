import 'package:flutter/material.dart';

/// Top header for the Log Modal with drag handle, title, and close button matching exact specs.
class LogModalHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onClose;

  const LogModalHeader({super.key, this.title = 'Log Your Day', this.onClose});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top drag handle
        Container(
          width: 36.0,
          height: 4.0,
          decoration: BoxDecoration(
            color: const Color(0xFFDCD6E5),
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),

        const SizedBox(height: 12.0),

        // Header Title Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 24.0), // Balance close button

            Text(
              title,
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1A3C),
                letterSpacing: -0.2,
              ),
            ),

            GestureDetector(
              onTap: onClose ?? () => Navigator.of(context).maybePop(),
              child: Container(
                width: 24.0,
                height: 24.0,
                color: Colors.transparent,
                child: const Center(
                  child: Icon(
                    Icons.close_rounded,
                    size: 17.0,
                    color: Color(0xFF1E1A3C),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
