import 'package:flutter/foundation.dart';
import '../../core/database/local_database_service.dart';
import '../../features/dashboard/models/cycle_dashboard_state.dart';
import '../models/app_mode.dart';
import '../models/daily_log_entry.dart';
import '../models/user_profile.dart';

/// Central reactive state controller for user cycle profile, daily logged
/// metrics, and global application mode with automatic local database persistence.
class CycleDataController extends ChangeNotifier {
  static final CycleDataController instance = CycleDataController._internal();

  factory CycleDataController() => instance;

  CycleDataController._internal() {
    _initDefaultState();
    _hydrateFromLocalDatabase();
  }

  late UserProfile _userProfile;
  late AppMode _currentMode;
  String _selectedThemeId = 'pink';
  final Map<String, DailyLogEntry> _logEntries = {};

  UserProfile get userProfile => _userProfile;
  UserProfile get profile => _userProfile;
  AppMode get currentMode => _currentMode;
  String get selectedThemeId => _selectedThemeId;
  Map<String, DailyLogEntry> get logEntries => Map.unmodifiable(_logEntries);
  DailyLogEntry? get todayLog => _logEntries[_formatDateKey(DateTime.now())];

  Future<void> _hydrateFromLocalDatabase() async {
    final savedProfile = LocalDatabaseService.instance.getProfile();
    if (savedProfile != null) {
      _userProfile = savedProfile;
      _currentMode = savedProfile.mode;
    }
    final savedTheme = LocalDatabaseService.instance.getSetting('app_theme');
    if (savedTheme != null && savedTheme is String && savedTheme.isNotEmpty) {
      _selectedThemeId = savedTheme;
    }
    final savedLogs = LocalDatabaseService.instance.getAllLogs();
    if (savedLogs.isNotEmpty) {
      _logEntries.addAll(savedLogs);
    }
    notifyListeners();
  }

  Future<void> reloadFromDatabase() async {
    await _hydrateFromLocalDatabase();
  }

  void setTheme(String themeId) {
    if (_selectedThemeId == themeId) return;
    _selectedThemeId = themeId;
    LocalDatabaseService.instance.saveSetting('app_theme', themeId);
    notifyListeners();
  }

  void updateProfile(UserProfile profile) {
    _userProfile = profile;
    _currentMode = profile.mode;
    LocalDatabaseService.instance.saveProfile(_userProfile);
    notifyListeners();
  }

  void resetToDefaults() {
    _logEntries.clear();
    _initDefaultState();
    notifyListeners();
  }

  void _initDefaultState() {
    final now = DateTime.now();
    _userProfile = UserProfile(
      name: 'Amina',
      averageCycleLength: 28,
      typicalPeriodDuration: 5,
      lastPeriodStartDate: now.subtract(const Duration(days: 12)),
      mode: AppMode.tryingToConceive,
      focusGoal: 'Track my cycle & fertile window',
      cycleGoals: const ['Understand my cycle'],
      ttcDuration: 'Just starting',
    );
    _currentMode = _userProfile.mode;

    // Seed default baseline entries for today and recent days
    final todayKey = _formatDateKey(now);
    _logEntries[todayKey] = DailyLogEntry(
      date: now,
      mood: 'Good',
      flow: 'Light',
      symptoms: const ['Bloating', 'Cramps'],
      sleepRating: 4,
      sleepDuration: '7h 20m',
      energyLevel: 'Medium',
      intercourse: true,
    );

    // Baseline historical day
    final yesterday = now.subtract(const Duration(days: 1));
    _logEntries[_formatDateKey(yesterday)] = DailyLogEntry(
      date: yesterday,
      mood: 'Great',
      flow: 'Light',
      symptoms: const ['Bloating'],
      sleepRating: 5,
      sleepDuration: '8h 00m',
      energyLevel: 'High',
      intercourse: false,
    );

    // Seed historical period days
    _seedPeriodLogs(
      _userProfile.lastPeriodStartDate,
      _userProfile.typicalPeriodDuration,
    );
  }

  void _seedPeriodLogs(DateTime startDate, int duration) {
    for (int i = 0; i < duration; i++) {
      final date = startDate.add(Duration(days: i));
      final key = _formatDateKey(date);

      String flow = 'Medium';
      if (i == 0 || i == 1) {
        flow = 'Heavy';
      } else if (i == 2) {
        flow = 'Medium';
      } else if (i == 3) {
        flow = 'Light';
      } else {
        flow = 'Spotting';
      }

      _logEntries[key] = DailyLogEntry(
        date: date,
        mood: i == 0 ? 'Tired' : 'Good',
        flow: flow,
        symptoms: i < 2 ? const ['Cramps', 'Bloating'] : const ['Bloating'],
        sleepRating: 4,
        sleepDuration: '7h 20m',
        energyLevel: i < 2 ? 'Low' : 'Medium',
      );
    }
  }

  static String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Initialize and bind app parameters directly from Onboarding completion
  void initializeFromOnboarding({
    required AppMode mode,
    required DateTime lastPeriodStartDate,
    required int averageCycleLength,
    required int typicalPeriodDuration,
    String? focusGoal,
    List<String>? cycleGoals,
    String? ttcDuration,
    String? name,
  }) {
    _userProfile = _userProfile.copyWith(
      name: name ?? _userProfile.name,
      mode: mode,
      lastPeriodStartDate: lastPeriodStartDate,
      averageCycleLength: averageCycleLength,
      typicalPeriodDuration: typicalPeriodDuration,
      focusGoal: focusGoal ?? _userProfile.focusGoal,
      cycleGoals: cycleGoals ?? _userProfile.cycleGoals,
      ttcDuration: ttcDuration ?? _userProfile.ttcDuration,
    );

    _currentMode = mode;
    _seedPeriodLogs(lastPeriodStartDate, typicalPeriodDuration);
    LocalDatabaseService.instance.saveProfile(_userProfile);
    LocalDatabaseService.instance.saveAllDailyLogs(_logEntries.values);

    notifyListeners();
  }

  /// Update user profile parameters (e.g. from Onboarding or Settings)
  void updateUserProfile({
    String? name,
    int? averageCycleLength,
    int? typicalPeriodDuration,
    DateTime? lastPeriodStartDate,
    AppMode? mode,
    String? focusGoal,
    List<String>? cycleGoals,
    String? ttcDuration,
  }) {
    _userProfile = _userProfile.copyWith(
      name: name,
      averageCycleLength: averageCycleLength,
      typicalPeriodDuration: typicalPeriodDuration,
      lastPeriodStartDate: lastPeriodStartDate,
      mode: mode,
      focusGoal: focusGoal,
      cycleGoals: cycleGoals,
      ttcDuration: ttcDuration,
    );

    if (mode != null && mode != _currentMode) {
      _currentMode = mode;
    }

    if (lastPeriodStartDate != null) {
      _seedPeriodLogs(
        lastPeriodStartDate,
        typicalPeriodDuration ?? _userProfile.typicalPeriodDuration,
      );
      LocalDatabaseService.instance.saveAllDailyLogs(_logEntries.values);
    }

    LocalDatabaseService.instance.saveProfile(_userProfile);
    notifyListeners();
  }

  /// Global mode switcher (Cycle Awareness ⇋ Trying to Conceive)
  void setAppMode(AppMode mode) {
    if (_currentMode != mode) {
      _currentMode = mode;
      _userProfile = _userProfile.copyWith(mode: mode);
      LocalDatabaseService.instance.saveProfile(_userProfile);
      notifyListeners();
    }
  }

  /// Save or update a daily log entry
  void saveLogEntry(DailyLogEntry entry) {
    final key = _formatDateKey(entry.date);
    _logEntries[key] = entry;
    LocalDatabaseService.instance.saveDailyLog(entry);
    notifyListeners();
  }

  /// Alias for saveLogEntry
  void saveLog(DailyLogEntry entry) => saveLogEntry(entry);

  /// Retrieve the log entry for a specific date (if any)
  DailyLogEntry? getLogForDate(DateTime date) {
    final key = _formatDateKey(date);
    return _logEntries[key];
  }

  /// Retrieve the log entry for a specific day number in current month
  DailyLogEntry? getLogForDayNumber(int dayNumber) {
    final now = DateTime.now();
    final targetDate = DateTime(now.year, now.month, dayNumber);
    return getLogForDate(targetDate);
  }

  /// Retrieve today's log entry or fallback default
  DailyLogEntry getTodayLog() {
    final today = DateTime.now();
    return getLogForDate(today) ??
        DailyLogEntry(
          date: today,
          mood: 'Good',
          flow: 'Light',
          symptoms: const ['Bloating', 'Cramps'],
          sleepRating: 4,
          sleepDuration: '7h 20m',
          energyLevel: 'Medium',
          intercourse: true,
        );
  }

  /// Calculate live cycle dashboard state from user profile and today's log
  CycleDashboardState calculateCurrentCycleState([DateTime? targetDate]) {
    final todayLog = targetDate != null
        ? (getLogForDate(targetDate) ?? getTodayLog())
        : getTodayLog();

    return CycleDashboardState.calculate(
      lastPeriodStartDate: _userProfile.lastPeriodStartDate,
      averageCycleLength: _userProfile.averageCycleLength,
      typicalPeriodDuration: _userProfile.typicalPeriodDuration,
      selectedFlow: todayLog.flow,
      symptoms: todayLog.symptoms.toSet(),
    );
  }

  /// Current computed cycle day number
  int get currentCycleDay => calculateCurrentCycleState().currentDay;

  /// Current computed phase name (e.g. 'Menstrual Phase', 'Follicular Phase')
  String get currentPhaseName => calculateCurrentCycleState().phaseName;
}
