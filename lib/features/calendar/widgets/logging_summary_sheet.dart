import 'package:flutter/material.dart';

/// Modal bottom sheet displaying dynamic logging streak, statistics and breakdown.
class LoggingSummarySheet extends StatelessWidget {
  final int totalDaysLogged;
  final int totalCycleDays;
  final VoidCallback? onLogToday;

  const LoggingSummarySheet({
    super.key,
    this.totalDaysLogged = 0,
    this.totalCycleDays = 28,
    this.onLogToday,
  });

  @override
  Widget build(BuildContext context) {
    final consistencyPercent = ((totalDaysLogged / totalCycleDays) * 100).clamp(0, 100).toInt();

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

              // 2. Title & Streak Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Logging Streak & Insights',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 19.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1A3C),
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          '$totalDaysLogged of $totalCycleDays days logged • $consistencyPercent% consistency',
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7A708A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    width: 42.0,
                    height: 42.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEDE9FE),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.calendar_month_rounded,
                        color: Color(0xFF7C3AED),
                        size: 22.0,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16.0),

              // 3. Streak Progress Bar
              Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF7FC),
                  borderRadius: BorderRadius.circular(18.0),
                  border: Border.all(
                    color: const Color(0xFFF1ECF5),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '🔥 14-Day Active Streak',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E1A3C),
                          ),
                        ),
                        Text(
                          '$consistencyPercent%',
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF7C3AED),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: LinearProgressIndicator(
                        value: consistencyPercent / 100.0,
                        backgroundColor: const Color(0xFFE2DCE8),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF7C3AED),
                        ),
                        minHeight: 8.0,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16.0),

              // 4. Logged Categories Grid
              const Text(
                'Biomarkers Tracked',
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1A3C),
                ),
              ),
              const SizedBox(height: 10.0),

              Row(
                children: [
                  Expanded(
                    child: _buildCategoryCard(
                      icon: Icons.water_drop_rounded,
                      color: const Color(0xFFE81B54),
                      bgColor: const Color(0xFFFFE8EE),
                      title: 'Flow Logs',
                      count: '5 days',
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: _buildCategoryCard(
                      icon: Icons.mood_rounded,
                      color: const Color(0xFFF59E0B),
                      bgColor: const Color(0xFFFEF3C7),
                      title: 'Mood Logs',
                      count: '12 days',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10.0),

              Row(
                children: [
                  Expanded(
                    child: _buildCategoryCard(
                      icon: Icons.thermostat_rounded,
                      color: const Color(0xFF3B82F6),
                      bgColor: const Color(0xFFDBEAFE),
                      title: 'BBT Temps',
                      count: '14 entries',
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: _buildCategoryCard(
                      icon: Icons.favorite_rounded,
                      color: const Color(0xFF7C3AED),
                      bgColor: const Color(0xFFEDE9FE),
                      title: 'Intimacy',
                      count: '2 logs',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20.0),

              // 5. + Log Today CTA Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    onLogToday?.call();
                  },
                  icon: const Icon(
                    Icons.edit_calendar_rounded,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  label: const Text(
                    'Log Daily Biomarkers Today',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
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

  Widget _buildCategoryCard({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required String title,
    required String count,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7FC),
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: const Color(0xFFF1ECF5),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32.0,
            height: 32.0,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Icon(icon, color: color, size: 17.0),
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7A708A),
                  ),
                ),
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1A3C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
