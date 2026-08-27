import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'route_names.dart';
import 'main_shell.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/authentication/login_screen.dart';
import '../../features/authentication/register_screen.dart';
import '../../features/authentication/forgot_password_screen.dart';
import '../../features/dashboard/home_screen.dart';
import '../../features/calendar/calendar_screen.dart';
import '../../features/daily_log/daily_log_screen.dart';
import '../../features/insights/insights_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/reminders_settings_screen.dart';
import '../../features/profile/screens/privacy_security_screen.dart';
import '../../features/profile/screens/app_preferences_screen.dart';
import '../../features/profile/screens/help_center_screen.dart';
import '../../features/ai_companion/ai_companion_screen.dart';
import '../../features/ai_companion/chat/ai_chat_screen.dart';
import '../../features/ai_companion/chat/screens/ai_chat_history_screen.dart';
import '../../features/learn/learn_screen.dart';
import '../../features/patterns/patterns_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/subscription/subscription_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

/// Central GoRouter configuration for FlowCycle.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splashPath,
  debugLogDiagnostics: true,
  routes: [
    // Standalone Startup & Authentication routes
    GoRoute(
      path: AppRoutes.splashPath,
      name: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboardingPath,
      name: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.loginPath,
      name: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.registerPath,
      name: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPasswordPath,
      name: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    // Main App Shell with exactly 5 bottom navigation tabs: Home, Calendar, Log, Insights, AI Companion
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        // Tab 1: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.homePath,
              name: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // Tab 2: Calendar
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.calendarPath,
              name: AppRoutes.calendar,
              builder: (context, state) => const CalendarScreen(),
            ),
          ],
        ),

        // Tab 3: Daily Log
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.dailyLogPath,
              name: AppRoutes.dailyLog,
              builder: (context, state) => const DailyLogScreen(),
            ),
          ],
        ),

        // Tab 4: Insights
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.insightsPath,
              name: AppRoutes.insights,
              builder: (context, state) => const InsightsScreen(),
            ),
          ],
        ),

        // Tab 5: AI Companion
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.aiCompanionPath,
              name: AppRoutes.aiCompanion,
              builder: (context, state) => const AiCompanionScreen(),
            ),
          ],
        ),
      ],
    ),

    // Secondary & Modals routes (Root Navigator)
    GoRoute(
      path: AppRoutes.aiChatPath,
      name: AppRoutes.aiChat,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final initialPrompt = extra?['prompt'] as String?;
        return AiChatScreen(initialPrompt: initialPrompt);
      },
    ),
    GoRoute(
      path: AppRoutes.aiChatHistoryPath,
      name: AppRoutes.aiChatHistory,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AiChatHistoryScreen(),
    ),
    GoRoute(
      path: AppRoutes.profilePath,
      name: AppRoutes.profile,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.editProfilePath,
      name: AppRoutes.editProfile,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.remindersSettingsPath,
      name: AppRoutes.remindersSettings,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RemindersSettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.privacySecurityPath,
      name: AppRoutes.privacySecurity,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PrivacySecurityScreen(),
    ),
    GoRoute(
      path: AppRoutes.appPreferencesPath,
      name: AppRoutes.appPreferences,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AppPreferencesScreen(),
    ),
    GoRoute(
      path: AppRoutes.helpCenterPath,
      name: AppRoutes.helpCenter,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const HelpCenterScreen(),
    ),
    GoRoute(
      path: AppRoutes.learnPath,
      name: AppRoutes.learn,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LearnScreen(),
    ),
    GoRoute(
      path: AppRoutes.patternsPath,
      name: AppRoutes.patterns,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PatternsScreen(),
    ),
    GoRoute(
      path: AppRoutes.settingsPath,
      name: AppRoutes.settings,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.subscriptionPath,
      name: AppRoutes.subscription,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SubscriptionScreen(),
    ),
  ],
);
