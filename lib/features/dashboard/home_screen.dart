import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_names.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/models/app_mode.dart';
import '../../shared/providers/app_scope.dart';
import '../ai_companion/reminders/smart_reminders_sheet.dart';
import '../profile/widgets/notification_center_sheet.dart';
import 'models/cycle_dashboard_state.dart';
import 'widgets/ai_companion_card.dart';
import 'widgets/cycle_ring_card.dart';
import 'widgets/cycle_ring_detail_sheet.dart';
import 'widgets/dashboard_top_header.dart';
import 'widgets/dual_metrics_row.dart';
import 'widgets/mode_segmented_switcher.dart';
import 'widgets/period_forecast_sheet.dart';
import 'widgets/quick_log_action_strip.dart';
import 'widgets/quick_log_sheets.dart';
import 'widgets/ttc/ttc_conception_window_sheet.dart';
import 'widgets/ttc/ttc_fertility_chance_sheet.dart';
import 'widgets/ttc/ttc_hero_cycle_card.dart';

/// Main Home Dashboard Screen for FlowCycle with global reactive data synchronization.
class HomeScreen extends StatefulWidget {
  final AppMode? initialMode;
  final DateTime? lastPeriodStartDate;
  final int averageCycleLength;
  final int typicalPeriodDuration;

  const HomeScreen({
    super.key,
    this.initialMode,
    this.lastPeriodStartDate,
    this.averageCycleLength = 28,
    this.typicalPeriodDuration = 5,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppMode? _localModeOverride;

  void _handleModeChange(AppMode newMode) {
    setState(() {
      _localModeOverride = newMode;
    });
    try {
      final controller = AppScope.read(context);
      controller.setAppMode(newMode);
    } catch (_) {}
  }

  void _navigateToCalendar() {
    try {
      context.go(AppRoutes.calendarPath);
    } catch (_) {}
  }

  void _navigateToDailyLog() {
    try {
      context.go(AppRoutes.dailyLogPath);
    } catch (_) {}
  }

  void _navigateToInsights() {
    try {
      context.go(AppRoutes.insightsPath);
    } catch (_) {}
  }

  void _navigateToAiCompanion() {
    try {
      context.push(AppRoutes.aiCompanionPath);
    } catch (_) {}
  }

  void _navigateToProfile() {
    try {
      context.push(AppRoutes.profilePath);
    } catch (_) {}
  }

  void _openNotificationsCenter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const NotificationCenterSheet(),
    );
  }

  void _openRemindersSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const SmartRemindersSheet(),
    );
  }

  void _openCycleRingDetailSheet(CycleDashboardState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CycleRingDetailSheet(
        currentDay: state.currentDay,
        totalDays: state.totalDays,
        phaseName: state.phaseName,
        phaseDescription: state.phaseDescription,
      ),
    );
  }

  void _openPeriodForecastSheet(CycleDashboardState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PeriodForecastSheet(
        daysRemaining: state.daysUntilNextPeriod,
        statusText: state.nextPeriodText,
      ),
    );
  }

  void _openTtcConceptionWindowSheet(CycleDashboardState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TtcConceptionWindowSheet(
        currentDay: state.currentDay,
        totalDays: state.totalDays,
        statusHeading: state.fertilityStatus,
        bestDaysText: state.bestDaysRangeText,
        ovulationCountdownText: state.ovulationCountdownText,
      ),
    );
  }

  void _openTtcFertilityChanceSheet(CycleDashboardState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TtcFertilityChanceSheet(
        percentage: state.phase == CyclePhase.ovulation
            ? 100
            : (state.fertilityChance == 'High' ? 85 : 30),
        level: state.fertilityChance,
      ),
    );
  }

  void _handleQuickAction(String actionId, AppMode mode) {
    final controller = AppScope.read(context);

    if (mode == AppMode.cycleAwareness) {
      switch (actionId) {
        case 'flow':
          QuickLogSheets.showFlowSheet(context, controller);
          break;
        case 'mood':
          QuickLogSheets.showMoodSheet(context, controller);
          break;
        case 'symptoms':
          QuickLogSheets.showSymptomsSheet(context, controller);
          break;
        case 'sleep':
          QuickLogSheets.showSleepSheet(context, controller);
          break;
        case 'notes':
          QuickLogSheets.showNotesSheet(context, controller);
          break;
        default:
          _navigateToDailyLog();
      }
    } else {
      switch (actionId) {
        case 'intercourse':
          QuickLogSheets.showTtcIntercourseSheet(context, controller);
          break;
        case 'lh_test':
          QuickLogSheets.showTtcLhTestSheet(context, controller);
          break;
        case 'bbt':
          QuickLogSheets.showTtcBbtSheet(context, controller);
          break;
        case 'cervical_mucus':
          QuickLogSheets.showTtcCervicalMucusSheet(context, controller);
          break;
        case 'notes':
          QuickLogSheets.showNotesSheet(context, controller);
          break;
        default:
          _navigateToDailyLog();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    CycleDashboardState? liveDashboardState;
    AppMode? activeGlobalMode;
    dynamic liveTodayLog;
    dynamic liveUserProfile;

    try {
      final cycleController = AppScope.of(context);
      liveDashboardState = cycleController.calculateCurrentCycleState();
      activeGlobalMode = cycleController.currentMode;
      liveTodayLog = cycleController.getTodayLog();
      liveUserProfile = cycleController.userProfile;
    } catch (_) {}

    final currentMode = _localModeOverride ??
        widget.initialMode ??
        activeGlobalMode ??
        AppMode.cycleAwareness;

    final isCycleAwareness = currentMode == AppMode.cycleAwareness;
    final todayLog = liveTodayLog;
    final userProfile = liveUserProfile;

    final cycleState = liveDashboardState ??
        CycleDashboardState(
          currentDay: 8,
          totalDays: 28,
          periodDuration: 5,
          phase: CyclePhase.follicular,
          phaseName: 'Follicular Phase',
          phaseDescription: 'Your body is preparing for ovulation.',
          daysUntilNextPeriod: 20,
          nextPeriodText: 'expected in 20 days',
          fertilityChance: 'Low',
          fertilityStatus: 'Low Fertility',
          selectedFlowIntensity: todayLog?.flow,
          selectedSymptoms: todayLog != null ? todayLog.symptoms.toSet() : {},
        );

    final userName = userProfile != null ? userProfile.name : 'Amina';

    return Scaffold(
      backgroundColor: isCycleAwareness
          ? const Color(0xFFFAF7FC)
          : const Color(0xFFFFF8FA),
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
                // 1. Top Header: Profile Avatar, Greeting, Notification Bell
                DashboardTopHeader(
                  userName: userName,
                  subtitle: isCycleAwareness
                      ? "You're in tune with your body ✨"
                      : "You're one step closer to your goal ✨",
                  onProfileTap: _navigateToProfile,
                  onNotificationTap: _openNotificationsCenter,
                ),

                const SizedBox(height: 12.0),

                // 2. Compact Segmented Mode Switcher
                ModeSegmentedSwitcher(
                  currentMode: currentMode,
                  onModeChanged: _handleModeChange,
                ),

                const SizedBox(height: 14.0),

                // 3. Dynamic Mode Content (Floating in Space!)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  child: isCycleAwareness
                      ? _buildCycleAwarenessDashboard(cycleState, todayLog)
                      : _buildTryingToConceiveDashboard(cycleState, todayLog),
                ),

                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 1. Cycle Awareness Dashboard Layout (Floating in Space)
  Widget _buildCycleAwarenessDashboard(
    CycleDashboardState state,
    dynamic todayLog,
  ) {
    return Column(
      key: const ValueKey<String>('cycle_awareness_dashboard'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Prominent Open-Space Hero Cycle Dial
        CycleRingCard(
          currentDay: state.currentDay,
          totalDays: state.totalDays,
          phaseName: state.phaseName,
          phaseDescription: state.phaseDescription,
          nextPeriodText: state.nextPeriodText,
          fertilityStatus: state.fertilityChance == 'High'
              ? 'High Fertility'
              : 'Low Fertility',
          onCalendarTap: _navigateToCalendar,
          onTap: () => _openCycleRingDetailSheet(state),
        ),

        const SizedBox(height: 20.0),

        // 2. Dual Key-Metrics Cards (Next Period + Fertile Window)
        DualMetricsRow(
          mode: AppMode.cycleAwareness,
          daysUntilNextPeriod: state.daysUntilNextPeriod,
          nextPeriodDateText: state.nextPeriodDateText,
          fertileWindowText: state.fertileWindowDatesText,
          fertilePeakText: 'Peak window: ${state.ovulationDateText}',
          onNextPeriodTap: () => _openPeriodForecastSheet(state),
          onFertilityTap: _navigateToInsights,
        ),

        const SizedBox(height: 22.0),

        // 3. 5-Button Quick Log Action Strip
        QuickLogActionStrip(
          mode: AppMode.cycleAwareness,
          onEditTap: _navigateToDailyLog,
          onActionTap: (actionId) =>
              _handleQuickAction(actionId, AppMode.cycleAwareness),
        ),

        const SizedBox(height: 22.0),

        // 4. AI Insight Guidance Card with Bot Avatar
        AiCompanionCard(
          mode: AppMode.cycleAwareness,
          onTap: _navigateToAiCompanion,
        ),

        const SizedBox(height: 12.0),
      ],
    );
  }

  /// 2. Trying to Conceive Dashboard Layout (Floating in Space)
  Widget _buildTryingToConceiveDashboard(
    CycleDashboardState state,
    dynamic todayLog,
  ) {
    return Column(
      key: const ValueKey<String>('trying_to_conceive_dashboard'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Prominent Open-Space Hero Conception Dial
        TtcHeroCycleCard(
          currentDay: state.currentDay,
          totalDays: state.totalDays,
          statusHeading: state.fertilityChance == 'High'
              ? 'High Fertility'
              : 'Low Fertility',
          bestDaysText: state.bestDaysRangeText,
          ovulationCountdownText: state.ovulationCountdownText,
          onLogIntercourse: _navigateToDailyLog,
          onTap: () => _openTtcConceptionWindowSheet(state),
        ),

        const SizedBox(height: 20.0),

        // 2. Dual Key-Metrics Cards (Ovulation + Best Days to Try)
        DualMetricsRow(
          mode: AppMode.tryingToConceive,
          ovulationDateText: state.ovulationDateText,
          ovulationCountdownText: state.ovulationCountdownText,
          bestDaysRangeText: state.bestDaysRangeText,
          bestDaysChanceText: state.bestDaysChanceText,
          onFertilityTap: () => _openTtcFertilityChanceSheet(state),
        ),

        const SizedBox(height: 22.0),

        // 3. 5-Button TTC Quick Log Action Strip
        QuickLogActionStrip(
          mode: AppMode.tryingToConceive,
          onEditTap: _navigateToDailyLog,
          onActionTap: (actionId) =>
              _handleQuickAction(actionId, AppMode.tryingToConceive),
        ),

        const SizedBox(height: 22.0),

        // 4. AI Fertility Guidance Card with Pink Bot Avatar
        AiCompanionCard(
          mode: AppMode.tryingToConceive,
          onTap: _navigateToAiCompanion,
        ),

        const SizedBox(height: 12.0),
      ],
    );
  }
}
