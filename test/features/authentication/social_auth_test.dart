import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/core/services/auth_service.dart';
import 'package:flowcycle/features/authentication/login_screen.dart';
import 'package:flowcycle/features/authentication/register_screen.dart';
import 'package:flowcycle/features/authentication/widgets/social_auth_buttons.dart';
import 'package:flowcycle/shared/providers/app_scope.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';

Widget _buildAuthTestWidget(Widget child, [CycleDataController? controller, TargetPlatform? platform]) {
  final ctrl = controller ?? CycleDataController();
  return AppScope(
    controller: ctrl,
    child: MaterialApp(
      theme: ThemeData(platform: platform ?? TargetPlatform.android),
      home: child,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Social Authentication (Google & Apple) & Backend Architecture Tests', () {
    setUp(() async {
      await AuthService.instance.signOut();
      debugDefaultTargetPlatformOverride = null;
    });

    tearDown(() {
      debugDefaultTargetPlatformOverride = null;
    });

    test('1. AuthService: Google Sign-In authenticates user session with Google metadata', () async {
      expect(AuthService.instance.isAuthenticated, isFalse);

      final result = await AuthService.instance.signInWithGoogle();

      expect(result.isSuccess, isTrue);
      expect(result.user, isNotNull);
      expect(result.user!.displayName, contains('Google'));
      expect(result.user!.email, contains('google'));
      expect(AuthService.instance.isAuthenticated, isTrue);
      expect(AuthService.instance.currentUser?.uid, equals('google_user_001'));
    });

    test('2. AuthService: Apple Sign-In authenticates user session with Apple relay metadata', () async {
      expect(AuthService.instance.isAuthenticated, isFalse);

      final result = await AuthService.instance.signInWithApple();

      expect(result.isSuccess, isTrue);
      expect(result.user, isNotNull);
      expect(result.user!.displayName, contains('Apple'));
      expect(result.user!.email, contains('appleid.com'));
      expect(AuthService.instance.isAuthenticated, isTrue);
      expect(AuthService.instance.currentUser?.uid, equals('apple_user_001'));
    });

    testWidgets('3. LoginScreen on Android: Shows Google Sign-In and triggers auth', (
      tester,
    ) async {
      await tester.pumpWidget(_buildAuthTestWidget(const LoginScreen(), null, TargetPlatform.android));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(SocialAuthButtons), findsOneWidget);
      expect(find.textContaining('Google'), findsOneWidget);

      // Tap Google button
      await tester.tap(find.textContaining('Google'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(AuthService.instance.isAuthenticated, isTrue);
      expect(find.textContaining('Signed in via Google'), findsOneWidget);
    });

    testWidgets('4. LoginScreen on iOS: Shows Apple Sign-In and triggers auth', (
      tester,
    ) async {
      await tester.pumpWidget(_buildAuthTestWidget(const LoginScreen(), null, TargetPlatform.iOS));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(SocialAuthButtons), findsOneWidget);
      expect(find.textContaining('Apple'), findsOneWidget);

      // Tap Apple button
      await tester.tap(find.textContaining('Apple'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(AuthService.instance.isAuthenticated, isTrue);
      expect(find.textContaining('Signed in via Apple'), findsOneWidget);
    });

    testWidgets('5. RegisterScreen on Android: Tapping Google signs up and synchronizes user profile', (
      tester,
    ) async {
      final controller = CycleDataController();
      await tester.pumpWidget(_buildAuthTestWidget(const RegisterScreen(), controller, TargetPlatform.android));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(SocialAuthButtons), findsOneWidget);

      // Scroll into view and tap Google button on register
      await tester.ensureVisible(find.textContaining('Google'));
      await tester.pump();
      await tester.tap(find.textContaining('Google'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(AuthService.instance.isAuthenticated, isTrue);
      expect(controller.userProfile.name, contains('Google'));
      expect(find.textContaining('Registered via Google'), findsOneWidget);
    });
  });
}
