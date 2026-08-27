import 'dart:async';
import 'package:flutter/foundation.dart';
import '../database/local_database_service.dart';
import '../services/ai_service.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../../features/dashboard/models/cycle_dashboard_state.dart';
import '../../features/onboarding/models/onboarding_state.dart';
import '../../shared/models/app_mode.dart';
import '../../shared/models/daily_log_entry.dart';
import '../../shared/models/user_profile.dart';
import '../../shared/providers/cycle_data_controller.dart';

/// Central Unified Data Manager and Orchestrator for FlowCycle.
///
/// Manages data ingestion, transformation, atomic persistence, and reactive
/// cross-system synchronization across:
/// 1. Authentication & User Identity
/// 2. Onboarding Intake & Baseline Synthesis
/// 3. Daily Biomarker & Symptom Logs
/// 4. AI Companion Queries & Offline Chat Sessions
/// 5. Clinical Reminders & Backup Synchronization
class AppDataManager extends ChangeNotifier {
  static final AppDataManager instance = AppDataManager._internal();
  factory AppDataManager() => instance;
  AppDataManager._internal();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// Initializes the unified data pipeline, local database, and auth listener.
  Future<void> initialize({String? customStoragePath}) async {
    if (_isInitialized) return;

    await LocalDatabaseService.instance.initialize(
      customPath: customStoragePath,
      userScope: AuthService.instance.currentUser?.uid,
    );

    // Listen for auth state changes to re-scope database automatically
    AuthService.instance.authStateChanges.listen((user) {
      handleAuthUserSession(user);
    });

    _isInitialized = true;
  }

  // ===========================================================================
  // 1. Authentication Data Pipeline
  // ===========================================================================

  /// Synchronizes application data when user signs in, switches accounts, or logs out.
  Future<void> handleAuthUserSession(AuthUser? user) async {
    final uid = user?.uid;
    await LocalDatabaseService.instance.setUserScope(uid);
    await CycleDataController.instance.reloadFromDatabase();

    if (user != null) {
      final currentProfile = LocalDatabaseService.instance.getProfile();
      if (currentProfile == null) {
        // Initialize baseline profile with user's auth name
        final defaultProfile = UserProfile(
          name: user.displayName.isNotEmpty ? user.displayName : 'Amina',
          averageCycleLength: 28,
          typicalPeriodDuration: 5,
          lastPeriodStartDate: DateTime.now().subtract(const Duration(days: 12)),
          mode: AppMode.cycleAwareness,
        );
        await LocalDatabaseService.instance.saveProfile(defaultProfile);
        CycleDataController.instance.updateProfile(defaultProfile);
      }
    }

    notifyListeners();
  }

  // ===========================================================================
  // 2. Onboarding Data Pipeline
  // ===========================================================================

  /// Ingests completed onboarding intake, synthesizes baseline period history,
  /// schedules predictive smart reminders, and commits to local disk.
  Future<UserProfile> handleOnboardingCompletion(OnboardingState onboardingData) async {
    final now = DateTime.now();
    final lastPeriodDate = onboardingData.lastPeriodStartDate ?? now.subtract(const Duration(days: 14));
    final cycleLength = onboardingData.averageCycleLength ?? 28;
    final periodDuration = onboardingData.typicalPeriodDuration ?? 5;
    final mode = onboardingData.selectedMode ?? AppMode.cycleAwareness;

    final profile = UserProfile(
      name: AuthService.instance.currentUser?.displayName ?? 'Amina',
      averageCycleLength: cycleLength,
      typicalPeriodDuration: periodDuration,
      lastPeriodStartDate: lastPeriodDate,
      mode: mode,
      focusGoal: onboardingData.cycleAwarenessGoals.isNotEmpty
          ? onboardingData.cycleAwarenessGoals.first
          : 'Track my cycle & health',
      cycleGoals: onboardingData.cycleAwarenessGoals,
      ttcDuration: onboardingData.tryingToConceiveDuration,
    );

    // Save profile to disk
    await LocalDatabaseService.instance.saveProfile(profile);
    CycleDataController.instance.updateProfile(profile);

    // Synthesize historical period logs across 3 previous cycles
    final List<DailyLogEntry> seededLogs = _generateHistoricalPeriodLogs(
      mostRecentPeriodStart: lastPeriodDate,
      cycleLength: cycleLength,
      periodDuration: periodDuration,
      cyclesCount: 3,
    );

    await LocalDatabaseService.instance.saveAllDailyLogs(seededLogs);
    await CycleDataController.instance.reloadFromDatabase();

    // Schedule predictive smart reminders
    final nextPeriodDate = lastPeriodDate.add(Duration(days: cycleLength));
    final fertileStartDate = lastPeriodDate.add(Duration(days: (cycleLength - 14) - 5));

    await NotificationService.instance.scheduleCycleReminders(
      nextPeriodDate: nextPeriodDate,
      fertileWindowStartDate: fertileStartDate,
      periodReminderDaysAhead: 2,
      fertileReminderDaysAhead: 1,
    );

    await LocalDatabaseService.instance.saveSetting('has_completed_onboarding', true);

    notifyListeners();
    return profile;
  }

  // ===========================================================================
  // 3. Daily Biomarkers & Symptom Logs Pipeline
  // ===========================================================================

  /// Ingests a 16-parameter daily biomarker entry, persists to disk, updates
  /// live controller state, and recalculates active cycle metrics.
  Future<void> handleDailyLogEntry(DailyLogEntry log, {bool updateReminders = true}) async {
    // 1. Commit to Local Database & Memory Controller
    await LocalDatabaseService.instance.saveDailyLog(log);
    CycleDataController.instance.saveLogEntry(log);

    // 2. Check if period flow was logged on a new date (period onset detection)
    final profile = CycleDataController.instance.userProfile;
    if (log.flow != 'None') {
      final daysDiff = log.date.difference(profile.lastPeriodStartDate).inDays;
      // If flow logged more than 18 days after previous period start, treat as new period onset
      if (daysDiff >= 18 && log.date.isAfter(profile.lastPeriodStartDate)) {
        final updatedProfile = profile.copyWith(lastPeriodStartDate: log.date);
        await LocalDatabaseService.instance.saveProfile(updatedProfile);
        CycleDataController.instance.updateProfile(updatedProfile);

        if (updateReminders) {
          final nextPeriod = log.date.add(Duration(days: profile.averageCycleLength));
          final fertileStart = log.date.add(Duration(days: (profile.averageCycleLength - 14) - 5));
          await NotificationService.instance.scheduleCycleReminders(
            nextPeriodDate: nextPeriod,
            fertileWindowStartDate: fertileStart,
          );
        }
      }
    }

    notifyListeners();
  }

  // ===========================================================================
  // 4. AI Companion & Intelligence Pipeline
  // ===========================================================================

  /// Orchestrates clinical context assembly, queries the AI Engine, and
  /// commits conversation messages to offline local storage.
  Future<String> handleAiChatInteraction({
    required String prompt,
    String sessionId = 'default_session',
    UserProfile? userProfile,
    int? cycleDay,
    String? phaseName,
    DailyLogEntry? todayLog,
  }) async {
    final now = DateTime.now();
    final profile = userProfile ?? CycleDataController.instance.userProfile;
    final log = todayLog ?? CycleDataController.instance.getLogForDate(now);

    final cycleState = CycleDashboardState.calculate(
      lastPeriodStartDate: profile.lastPeriodStartDate,
      averageCycleLength: profile.averageCycleLength,
      typicalPeriodDuration: profile.typicalPeriodDuration,
    );

    final activeCycleDay = cycleDay ?? cycleState.currentDay;
    final activePhaseName = phaseName ?? cycleState.phaseName;

    // 1. Save user message to offline chat session store
    await LocalDatabaseService.instance.saveAiChatMessage(
      sessionId: sessionId,
      sender: 'user',
      message: prompt,
      timestamp: now,
    );

    // 2. Query AI Service with live cycle context
    final aiResponse = await AiService.instance.generateAiResponse(
      userPrompt: prompt,
      userProfile: profile,
      cycleDay: activeCycleDay,
      phaseName: activePhaseName,
      todayLog: log,
    );

    // 3. Save AI response to offline chat session store
    await LocalDatabaseService.instance.saveAiChatMessage(
      sessionId: sessionId,
      sender: 'ai',
      message: aiResponse,
      timestamp: DateTime.now(),
    );

    notifyListeners();
    return aiResponse;
  }

  /// Retrieves conversation history for a specific session ID.
  List<Map<String, dynamic>> getAiChatHistory({String sessionId = 'default_session'}) {
    return LocalDatabaseService.instance.getAiChatSession(sessionId);
  }

  /// Clears an AI conversation session.
  Future<void> clearAiChatHistory({String sessionId = 'default_session'}) async {
    await LocalDatabaseService.instance.clearAiChatSession(sessionId);
    notifyListeners();
  }

  // ===========================================================================
  // 5. Account Data Purge Pipeline
  // ===========================================================================

  /// Purges all data associated with the active account (GDPR / HIPAA compliant).
  Future<void> handleAccountPurge() async {
    await LocalDatabaseService.instance.wipeAllData();
    await NotificationService.instance.cancelAllReminders();
    await CycleDataController.instance.reloadFromDatabase();
    notifyListeners();
  }

  // ===========================================================================
  // Internal Helpers
  // ===========================================================================

  List<DailyLogEntry> _generateHistoricalPeriodLogs({
    required DateTime mostRecentPeriodStart,
    required int cycleLength,
    required int periodDuration,
    required int cyclesCount,
  }) {
    final List<DailyLogEntry> logs = [];

    for (int cycle = 0; cycle < cyclesCount; cycle++) {
      final periodStart = mostRecentPeriodStart.subtract(Duration(days: cycle * cycleLength));

      for (int day = 0; day < periodDuration; day++) {
        final date = periodStart.add(Duration(days: day));
        final flowIntensity = day == 0
            ? 'Light'
            : (day == 1 || day == 2)
                ? 'Heavy'
                : (day == 3)
                    ? 'Medium'
                    : 'Light';

        logs.add(
          DailyLogEntry(
            date: date,
            flow: flowIntensity,
            mood: day < 2 ? 'Low Energy' : 'Calm',
            symptoms: day < 2 ? const ['Cramps', 'Bloating'] : const ['Mild Bloating'],
            energyLevel: day < 2 ? 'Low' : 'Medium',
          ),
        );
      }
    }

    return logs;
  }
}
