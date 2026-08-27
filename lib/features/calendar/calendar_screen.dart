import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_names.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/models/app_mode.dart';
import '../../shared/providers/app_scope.dart';
import '../dashboard/widgets/mode_segmented_switcher.dart';
import 'widgets/calendar_filter_sheet.dart';
import 'widgets/calendar_header.dart';
import 'widgets/calendar_legend_sheet.dart';
import 'widgets/calendar_metrics_cards.dart';
import 'widgets/calendar_privacy_sheet.dart';
import 'widgets/calendar_privacy_tip_card.dart';
import 'widgets/day_details_modal.dart';
import 'widgets/fertile_window_hero_widget.dart';
import 'widgets/intercourse_history_sheet.dart';
import 'widgets/jump_to_date_modal.dart';
import 'widgets/logging_summary_sheet.dart';
import 'widgets/month_grid_card.dart';
import 'widgets/quick_day_action_sheet.dart';
import 'widgets/year_overview_grid.dart';

/// Full Interactive Calendar Screen for FlowCycle supporting both
/// Cycle Awareness Mode and Trying to Conceive (TTC) Mode with reactive data sync.
class CalendarScreen extends StatefulWidget {
  final AppMode? initialMode;
  final int initialSelectedDay;

  const CalendarScreen({
    super.key,
    this.initialMode,
    this.initialSelectedDay = 14,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  AppMode? _localModeOverride;
  late int _selectedDay;
  int _selectedMonth = 5;
  int _selectedYear = 2025;
  String _selectedTimeframe = 'Month';

  Map<String, bool> _activeFilters = {
    'period': true,
    'fertileWindow': true,
    'cervicalFluid': true,
    'intimacy': true,
    'symptoms': true,
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialSelectedDay;
  }

  void _handleModeChanged(AppMode newMode) {
    setState(() {
      _localModeOverride = newMode;
    });
    try {
      final controller = AppScope.read(context);
      controller.setAppMode(newMode);
    } catch (_) {}
  }

  void _handleDaySelected(int day) {
    setState(() {
      _selectedDay = day;
    });
    _openDayDetailsModal(day);
  }

  void _handleDayLongPressed(int day) {
    setState(() {
      _selectedDay = day;
    });
    _openQuickDayActionSheet(day);
  }

  void _handleTimeframeChanged(String timeframe) {
    setState(() {
      _selectedTimeframe = timeframe;
    });
  }

  void _handleTodayTap() {
    setState(() {
      _selectedDay = 14;
      _selectedMonth = 5;
      _selectedYear = 2025;
      _selectedTimeframe = 'Month';
    });
  }

  void _handlePrevMonth() {
    setState(() {
      if (_selectedMonth == 1) {
        _selectedMonth = 12;
        _selectedYear--;
      } else {
        _selectedMonth--;
      }
    });
  }

  void _handleNextMonth() {
    setState(() {
      if (_selectedMonth == 12) {
        _selectedMonth = 1;
        _selectedYear++;
      } else {
        _selectedMonth++;
      }
    });
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CalendarFilterSheet(
        currentFilters: _activeFilters,
        onApplyFilters: (newFilters) {
          setState(() {
            _activeFilters = newFilters;
          });
        },
      ),
    );
  }

  void _openLegendSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const CalendarLegendSheet(),
    );
  }

  void _openJumpToDateModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => JumpToDateModal(
        initialMonth: _selectedMonth,
        initialYear: _selectedYear,
        onDateSelected: (month, year) {
          setState(() {
            _selectedMonth = month;
            _selectedYear = year;
            _selectedTimeframe = 'Month';
          });
        },
      ),
    );
  }

  void _openMoreOptionsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Material(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2DCE8),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.palette_outlined,
                    color: Color(0xFF7C5CE7),
                  ),
                  title: const Text(
                    'Calendar Legend & Color Guide',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text('Explain all symbols, rings, and dots'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _openLegendSheet();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.calendar_month_outlined,
                    color: Color(0xFF7C5CE7),
                  ),
                  title: const Text(
                    'Jump to Specific Date',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text('Navigate to past or future cycles'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _openJumpToDateModal();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.tune_rounded,
                    color: Color(0xFF7C5CE7),
                  ),
                  title: const Text(
                    'Filter Calendar Overlays',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text('Customize visible biomarker layers'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _openFilterSheet();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.security_rounded,
                    color: Color(0xFF7C5CE7),
                  ),
                  title: const Text(
                    'Reproductive Privacy & App Lock',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text('Local encryption and intimacy lock details'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _openPrivacySheet();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openQuickDayActionSheet(int day) {
    try {
      final controller = AppScope.read(context);
      final logEntry = controller.getLogForDayNumber(day);
      final currentMode = _localModeOverride ?? widget.initialMode ?? controller.currentMode;
      final date = DateTime(_selectedYear, _selectedMonth, day);

      final isOvulation = day == 18;
      final isPeriod = day >= 4 && day <= 8;
      final isPreOvulation = day >= 12 && day <= 14;
      final isFertile = (day >= 15 && day <= 17) || day == 19 || day == 20;

      String phaseText = 'Luteal Phase';
      if (isOvulation) {
        phaseText = 'Ovulation Peak';
      } else if (isPeriod) {
        phaseText = 'Menstrual Phase';
      } else if (isPreOvulation || isFertile) {
        phaseText = 'Fertile Window';
      }

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => QuickDayActionSheet(
          date: date,
          cycleDayNumber: day,
          phaseName: phaseText,
          initialLog: logEntry,
          mode: currentMode,
        ),
      );
    } catch (_) {}
  }

  void _openDayDetailsModal(int day) {
    try {
      final controller = AppScope.read(context);
      final logEntry = controller.getLogForDayNumber(day);
      final currentMode =
          _localModeOverride ?? widget.initialMode ?? controller.currentMode;

      final isOvulation = day == 18;
      final isPeriod = day >= 4 && day <= 8;
      final isPreOvulation = day >= 12 && day <= 14;
      final isFertile = (day >= 15 && day <= 17) || day == 19 || day == 20;

      String phaseText = 'Luteal Phase';
      String chanceText = 'Low chance';

      if (isOvulation) {
        phaseText = 'Ovulation Peak';
        chanceText = 'High chance (38%)';
      } else if (isPeriod) {
        phaseText = 'Menstrual Phase';
        chanceText = 'Low chance';
      } else if (isPreOvulation || isFertile) {
        phaseText = 'Fertile Window';
        chanceText = 'High chance (26%)';
      }

      final date = DateTime(_selectedYear, _selectedMonth, day);

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => DayDetailsModal(
          date: date,
          cycleDayNumber: day,
          phaseName: phaseText,
          conceptionChance: chanceText,
          logEntry: logEntry,
          mode: currentMode,
        ),
      );
    } catch (_) {}
  }

  void _openIntercourseHistorySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => IntercourseHistorySheet(
        totalCount: 2,
        monthName: _getMonthAbbreviation(_selectedMonth),
        year: _selectedYear,
        onLogNewIntercourse: () {
          try {
            context.push(
              AppRoutes.dailyLogPath,
              extra: {
                'date': DateTime(_selectedYear, _selectedMonth, _selectedDay),
              },
            );
          } catch (_) {}
        },
      ),
    );
  }

  void _openLoggingSummarySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => LoggingSummarySheet(
        totalDaysLogged: 14,
        totalCycleDays: 28,
        onLogToday: () {
          try {
            context.push(
              AppRoutes.dailyLogPath,
              extra: {
                'date': DateTime(_selectedYear, _selectedMonth, _selectedDay),
              },
            );
          } catch (_) {}
        },
      ),
    );
  }

  void _openPrivacySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CalendarPrivacySheet(
        onConfigurePin: () {
          try {
            context.push(AppRoutes.profilePath);
          } catch (_) {}
        },
      ),
    );
  }

  String _getWeekdayAbbreviation(int day, int month, int year) {
    try {
      final dt = DateTime(year, month, day);
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[dt.weekday - 1];
    } catch (_) {
      return 'Wed';
    }
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    AppMode? activeGlobalMode;
    try {
      final controller = AppScope.of(context);
      activeGlobalMode = controller.currentMode;
    } catch (_) {}

    final currentMode = _localModeOverride ??
        widget.initialMode ??
        activeGlobalMode ??
        AppMode.cycleAwareness;

    final isTtc = currentMode == AppMode.tryingToConceive;
    final weekdayAbbr = _getWeekdayAbbreviation(_selectedDay, _selectedMonth, _selectedYear);
    final monthAbbr = _getMonthAbbreviation(_selectedMonth);

    // Contextual Phase Copy based on selected day
    final isFertileWindow = (_selectedDay >= 12 && _selectedDay <= 20);
    final isOvulationDay = _selectedDay == 18;
    final isPeriodDay = _selectedDay >= 4 && _selectedDay <= 8;

    String badgeText = 'CYCLE DAY $_selectedDay';
    String headingText = 'Low fertility chance';
    String subtitleText = 'Your hormone levels are in a stable phase.';

    if (isOvulationDay) {
      badgeText = 'OVULATION PEAK';
      headingText = 'Peak fertility chance (38%)';
      subtitleText = 'Your egg is ready for fertilization today.';
    } else if (isFertileWindow) {
      badgeText = 'FERTILE WINDOW';
      headingText = 'High fertility chance';
      subtitleText = 'Your body is getting close to ovulation.';
    } else if (isPeriodDay) {
      badgeText = 'MENSTRUAL PHASE';
      headingText = 'Menstrual cycle start';
      subtitleText = 'Rest and stay hydrated during your flow.';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7FC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Calendar Top Header
                CalendarHeader(
                  title: 'Calendar',
                  subtitle: isTtc
                      ? 'Track your fertility & conception window'
                      : 'Track your cycle & fertile window',
                  onBackTap: () {
                    try {
                      if (Navigator.of(context).canPop()) {
                        context.pop();
                      } else {
                        context.go(AppRoutes.homePath);
                      }
                    } catch (_) {
                      context.go(AppRoutes.homePath);
                    }
                  },
                  onCalendarTap: _openJumpToDateModal,
                  onMoreTap: _openMoreOptionsSheet,
                ),

                const SizedBox(height: 12.0),

                // 2. Mode Switcher (Cycle Awareness vs Trying to Conceive)
                ModeSegmentedSwitcher(
                  currentMode: currentMode,
                  onModeChanged: _handleModeChanged,
                ),

                const SizedBox(height: 12.0),

                // 3. Month View or Year Overview
                if (_selectedTimeframe == 'Year') ...[
                  YearOverviewGrid(
                    selectedYear: _selectedYear,
                    onMonthSelected: (month) {
                      setState(() {
                        _selectedMonth = month;
                        _selectedTimeframe = 'Month';
                      });
                    },
                  ),
                ] else ...[
                  // Month Grid Card with Controls, Days, Layer Filters & Legend
                  MonthGridCard(
                    selectedDay: _selectedDay,
                    selectedMonth: _selectedMonth,
                    selectedYear: _selectedYear,
                    selectedTimeframe: _selectedTimeframe,
                    activeFilters: _activeFilters,
                    onDaySelected: _handleDaySelected,
                    onDayLongPress: _handleDayLongPressed,
                    onTimeframeChanged: _handleTimeframeChanged,
                    onPrevMonth: _handlePrevMonth,
                    onNextMonth: _handleNextMonth,
                    onMonthDropdown: _openJumpToDateModal,
                    onTodayTap: _handleTodayTap,
                  ),

                  const SizedBox(height: 14.0),

                  // 4. Fertile Window Hero Widget (Sitting in Empty Space)
                  FertileWindowHeroWidget(
                    day: _selectedDay,
                    weekdayName: weekdayAbbr,
                    monthName: monthAbbr,
                    badgeText: badgeText,
                    headingText: headingText,
                    subtitleText: subtitleText,
                    onTap: () => _openDayDetailsModal(_selectedDay),
                  ),

                  const SizedBox(height: 12.0),

                  // 5. Dual Key-Metrics Cards (Sexual Intercourse Logged & Days Logged)
                  CalendarMetricsCards(
                    intercourseCount: 2,
                    daysLoggedCount: 14,
                    onIntercourseTap: _openIntercourseHistorySheet,
                    onDaysLoggedTap: _openLoggingSummarySheet,
                  ),

                  const SizedBox(height: 12.0),

                  // 6. Sex Logged (Private) & Tap Tip Card
                  CalendarPrivacyTipCard(
                    onTipTap: _openPrivacySheet,
                  ),
                ],

                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
