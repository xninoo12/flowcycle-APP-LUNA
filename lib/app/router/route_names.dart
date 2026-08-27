/// Route names and URI path constants for FlowCycle navigation.
abstract final class AppRoutes {
  // Startup & Authentication
  static const String splash = 'splash';
  static const String splashPath = '/splash';

  static const String onboarding = 'onboarding';
  static const String onboardingPath = '/onboarding';

  static const String login = 'login';
  static const String loginPath = '/login';

  static const String register = 'register';
  static const String registerPath = '/register';

  static const String forgotPassword = 'forgot-password';
  static const String forgotPasswordPath = '/forgot-password';

  // Main Shell Tabs (Bottom Navigation)
  static const String home = 'home';
  static const String homePath = '/home';

  static const String calendar = 'calendar';
  static const String calendarPath = '/calendar';

  static const String dailyLog = 'daily-log';
  static const String dailyLogPath = '/daily-log';

  static const String insights = 'insights';
  static const String insightsPath = '/insights';

  static const String profile = 'profile';
  static const String profilePath = '/profile';

  // Secondary Features (Not in Bottom Nav)
  static const String aiCompanion = 'ai-companion';
  static const String aiCompanionPath = '/ai-companion';

  static const String aiChat = 'ai-chat';
  static const String aiChatPath = '/ai-companion/chat';

  static const String aiChatHistory = 'ai-chat-history';
  static const String aiChatHistoryPath = '/ai-companion/history';

  static const String learn = 'learn';
  static const String learnPath = '/learn';

  static const String patterns = 'patterns';
  static const String patternsPath = '/patterns';

  static const String settings = 'settings';
  static const String settingsPath = '/settings';

  static const String subscription = 'subscription';
  static const String subscriptionPath = '/subscription';

  // Profile Subscreens
  static const String editProfile = 'edit-profile';
  static const String editProfilePath = '/profile/edit';

  static const String remindersSettings = 'reminders-settings';
  static const String remindersSettingsPath = '/profile/reminders';

  static const String privacySecurity = 'privacy-security';
  static const String privacySecurityPath = '/profile/privacy';

  static const String appPreferences = 'app-preferences';
  static const String appPreferencesPath = '/profile/preferences';

  static const String helpCenter = 'help-center';
  static const String helpCenterPath = '/profile/help';
}
