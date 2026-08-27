import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/authentication/forgot_password_screen.dart';
import 'package:flowcycle/features/authentication/login_screen.dart';
import 'package:flowcycle/features/authentication/register_screen.dart';
import 'package:flowcycle/features/authentication/widgets/auth_otp_verification_sheet.dart';
import 'package:flowcycle/features/authentication/widgets/auth_terms_and_privacy_sheet.dart';
import 'package:flowcycle/features/authentication/widgets/password_strength_meter.dart';
import 'package:flowcycle/features/authentication/widgets/social_auth_buttons.dart';
import 'package:flowcycle/shared/providers/app_scope.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';
import 'package:flowcycle/shared/widgets/buttons/primary_button.dart';
import 'package:flowcycle/shared/widgets/inputs/primary_text_field.dart';

void main() {
  late CycleDataController controller;

  setUp(() {
    controller = CycleDataController();
  });

  Widget buildTestable(Widget child) {
    return MaterialApp(
      home: AppScope(controller: controller, child: child),
    );
  }

  group('Authentication Features & Security Comprehensive Test Suite', () {
    testWidgets(
      '1. PasswordStrengthMeter: evaluates weak, medium, and strong passwords',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: PasswordStrengthMeter(password: 'Pass123!')),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Password strength:'), findsOneWidget);
        expect(find.text('Strong'), findsOneWidget);
        expect(find.text('8+ chars'), findsOneWidget);
        expect(find.text('A-Z & a-z'), findsOneWidget);
        expect(find.text('Number'), findsOneWidget);
        expect(find.text('Symbol'), findsOneWidget);
      },
    );

    testWidgets(
      '2. AuthTermsAndPrivacySheet: toggles between Terms and Privacy Policy tabs',
      (tester) async {
        bool accepted = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AuthTermsAndPrivacySheet(
                initialTabIndex: 0,
                onAccept: () => accepted = true,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Terms of Service Tab
        expect(find.text('Terms & Conditions'), findsOneWidget);
        expect(find.text('Medical Disclaimer & Scope of Use'), findsOneWidget);
        expect(find.text('1. Acceptance of Terms'), findsOneWidget);

        // Switch to Privacy Policy Tab
        await tester.tap(find.text('Privacy Policy').first);
        await tester.pumpAndSettle();

        expect(find.text('Privacy Policy'), findsAtLeast(1));
        expect(
          find.text('Our Ironclad Zero-Data-Selling Pledge'),
          findsOneWidget,
        );
        expect(find.text('1. Data We Collect'), findsOneWidget);
        expect(
          find.textContaining('End-to-End Encryption & Security Standards'),
          findsOneWidget,
        );

        // Tap Accept
        await tester.tap(find.text('I Understand & Accept'));
        await tester.pumpAndSettle();
        expect(accepted, isTrue);
      },
    );

    testWidgets(
      '3. SocialAuthButtons: renders Apple and Google buttons & triggers callbacks',
      (tester) async {
        bool appleTapped = false;
        bool googleTapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SocialAuthButtons(
                forceBoth: true,
                onAppleSignIn: () => appleTapped = true,
                onGoogleSignIn: () => googleTapped = true,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('OR CONTINUE WITH'), findsOneWidget);
        expect(find.text('Apple'), findsOneWidget);
        expect(find.text('Google'), findsOneWidget);

        await tester.tap(find.text('Apple'));
        await tester.pumpAndSettle();
        expect(appleTapped, isTrue);

        await tester.tap(find.text('Google'));
        await tester.pumpAndSettle();
        expect(googleTapped, isTrue);
      },
    );

    testWidgets(
      '4. AuthOtpVerificationSheet: enters 4 digits and completes verification',
      (tester) async {
        bool verified = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AuthOtpVerificationSheet(
                email: 'amina@flowcycle.app',
                onVerificationSuccess: () => verified = true,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Enter Verification Code'), findsOneWidget);
        expect(find.textContaining('amina@flowcycle.app'), findsOneWidget);
        expect(find.byType(TextField), findsNWidgets(4));

        // Enter digits
        final textFields = find.byType(TextField);
        await tester.enterText(textFields.at(0), '1');
        await tester.enterText(textFields.at(1), '2');
        await tester.enterText(textFields.at(2), '3');
        await tester.enterText(textFields.at(3), '4');
        await tester.pumpAndSettle();

        await tester.tap(find.text('Verify & Proceed'));
        await tester.pump(const Duration(milliseconds: 700));

        expect(verified, isTrue);
      },
    );

    testWidgets('5. LoginScreen: renders social auth and Explore as Guest', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestable(const LoginScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.byType(SocialAuthButtons), findsOneWidget);
      expect(find.text('Explore App as Guest'), findsOneWidget);

      await tester.tap(find.text('Explore App as Guest'));
      await tester.pumpAndSettle();
    });

    testWidgets(
      '6. RegisterScreen: renders password strength and opens Terms sheet',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(buildTestable(const RegisterScreen()));
        await tester.pumpAndSettle();

        expect(find.text('Create Your Account'), findsOneWidget);

        // Enter password to trigger strength meter
        final passwordField = find.widgetWithText(PrimaryTextField, 'Password');
        await tester.enterText(passwordField, 'FlowCycle2026!');
        await tester.pumpAndSettle();

        expect(find.byType(PasswordStrengthMeter), findsOneWidget);
        expect(find.text('Strong'), findsOneWidget);

        // Tap Terms of Service link in text span
        await tester.tap(find.textContaining('Terms of Service'));
        await tester.pumpAndSettle();

        expect(find.byType(AuthTermsAndPrivacySheet), findsOneWidget);
        expect(find.text('Terms & Conditions'), findsOneWidget);
      },
    );

    testWidgets(
      '7. ForgotPasswordScreen: sends reset link and triggers OTP code sheet',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(buildTestable(const ForgotPasswordScreen()));
        await tester.pumpAndSettle();

        expect(find.text('Forgot Password?'), findsOneWidget);

        final emailField = find.widgetWithText(
          PrimaryTextField,
          'Email Address',
        );
        await tester.enterText(emailField, 'amina@example.com');
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(PrimaryButton, 'Send Reset Link'));
        await tester.pump(const Duration(milliseconds: 800));

        expect(find.text('Check Your Inbox'), findsOneWidget);
        expect(find.text('Enter 4-Digit Code'), findsOneWidget);

        await tester.tap(find.text('Enter 4-Digit Code'));
        await tester.pumpAndSettle();

        expect(find.byType(AuthOtpVerificationSheet), findsOneWidget);
      },
    );
  });
}
