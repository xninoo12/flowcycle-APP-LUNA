import 'package:flutter/material.dart';

/// Modal bottom sheet displaying detailed intimacy & sexual intercourse history and logging CTAs.
class IntercourseHistorySheet extends StatelessWidget {
  final int totalCount;
  final String monthName;
  final int year;
  final VoidCallback? onLogNewIntercourse;

  const IntercourseHistorySheet({
    super.key,
    this.totalCount = 2,
    this.monthName = 'May',
    this.year = 2025,
    this.onLogNewIntercourse,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28.0)),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Drag Handle
              Center(
                child: Container(
                  width: 44.0,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2DCE8),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // 2. Title & Count Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sexual Intercourse Log',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 20.0,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E1A3C),
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        '$monthName $year • $totalCount times recorded',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7A708A),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 42.0,
                    height: 42.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFE8EE),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.favorite_rounded,
                        color: Color(0xFFE81B54),
                        size: 22.0,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16.0),

              // 3. Privacy Assurance Banner
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F3FF),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: const Color(0xFFDDD6FE),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.lock_rounded,
                      color: Color(0xFF7C3AED),
                      size: 18.0,
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: Text(
                        'Intimacy entries are stored on-device with zero cloud telemetry and protected by your app lock.',
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5B21B6),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16.0),

              // 4. Logged Entries List
              const Text(
                'Recorded Intimacy Events',
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1A3C),
                ),
              ),
              const SizedBox(height: 10.0),

              _buildIntercourseTile(
                dateStr: 'Monday, May 19, 2025',
                cycleDay: 'Cycle Day 19 (Fertile Window)',
                type: 'Protected Intercourse 🛡️',
                isHighFertility: true,
              ),

              const SizedBox(height: 8.0),

              _buildIntercourseTile(
                dateStr: 'Tuesday, May 13, 2025',
                cycleDay: 'Cycle Day 13 (Pre-Ovulation)',
                type: 'Unprotected Intercourse 💜',
                isHighFertility: true,
              ),

              const SizedBox(height: 20.0),

              // 5. + Log New Intercourse CTA Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    onLogNewIntercourse?.call();
                  },
                  icon: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  label: const Text(
                    'Log Sexual Intercourse for Today',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE81B54),
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntercourseTile({
    required String dateStr,
    required String cycleDay,
    required String type,
    required bool isHighFertility,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7FC),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFFF1ECF5),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36.0,
            height: 36.0,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FE),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Center(
              child: Icon(
                Icons.favorite_rounded,
                color: Color(0xFF7C3AED),
                size: 18.0,
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E1A3C),
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  cycleDay,
                  style: const TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7A708A),
                  ),
                ),
                const SizedBox(height: 3.0),
                Text(
                  type,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7C3AED),
                  ),
                ),
              ],
            ),
          ),
          if (isHighFertility)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 3.0,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Text(
                'Fertile',
                style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF10B981),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
