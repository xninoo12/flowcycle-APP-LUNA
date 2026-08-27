import 'package:flutter/material.dart';

/// Date selection input field in the Log Modal matching exact UI specs.
class LogDateField extends StatelessWidget {
  final String dateText;
  final VoidCallback? onTap;

  const LogDateField({super.key, this.dateText = 'May 24, 2025', this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Date',
          style: TextStyle(
            fontSize: 11.0,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E1A3C),
          ),
        ),

        const SizedBox(height: 6.0),

        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 42.0,
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF8FC),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: const Color(0xFFEFE9F3), width: 1.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  dateText,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E1A3C),
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 15.0,
                  color: Color(0xFF7A708A),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
