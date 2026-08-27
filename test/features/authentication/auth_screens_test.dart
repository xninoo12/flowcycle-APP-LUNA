import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/authentication/login_screen.dart';
import 'package:flowcycle/features/authentication/register_screen.dart';
import 'package:flowcycle/features/authentication/forgot_password_screen.dart';
import 'package:flowcycle/shared/widgets/buttons/primary_button.dart';
import 'package:flowcycle/shared/widgets/inputs/primary_text_field.dart';

void main() {
  group('Authentication Flow Tests', () {
    testWidgets('LoginScreen renders and validates empty inputs', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Welcome Back'), findsOneWidget);

      // Scroll to Sign In button and tap with empty fields
      final signInBtn = find.widgetWithText(PrimaryButton, 'Sign In');
      await tester.ensureVisible(signInBtn);
      await tester.tap(signInBtn);
      await tester.pumpAndSettle();

      expect(find.text('Email address is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('RegisterScreen validates required fields and terms checkbox', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Create Your Account'), findsOneWidget);

      // Scroll to button and tap
      final createAccountFinder = find.widgetWithText(
        PrimaryButton,
        'Create Account',
      );
      await tester.ensureVisible(createAccountFinder);
      await tester.tap(createAccountFinder);
      await tester.pumpAndSettle();

      expect(find.text('Full name is required'), findsOneWidget);
      expect(find.text('Email address is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
      expect(
        find.text('Please accept the Terms of Service to continue'),
        findsOneWidget,
      );
    });

    testWidgets('ForgotPasswordScreen validates email and displays success', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: ForgotPasswordScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Forgot Password?'), findsOneWidget);

      final sendLinkBtn = find.widgetWithText(PrimaryButton, 'Send Reset Link');
      await tester.ensureVisible(sendLinkBtn);

      // Tap Send Reset Link with empty email
      await tester.tap(sendLinkBtn);
      await tester.pumpAndSettle();

      expect(find.text('Email address is required'), findsOneWidget);

      // Enter valid email
      final emailField = find.widgetWithText(PrimaryTextField, 'Email Address');
      await tester.enterText(emailField, 'test@flowcycle.app');
      await tester.tap(sendLinkBtn);
      await tester.pump(const Duration(milliseconds: 800));

      expect(find.text('Check Your Inbox'), findsOneWidget);
      expect(find.text('Back to Sign In'), findsOneWidget);
    });
  });
}
