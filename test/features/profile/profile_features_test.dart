import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/profile/screens/app_preferences_screen.dart';
import 'package:flowcycle/features/profile/screens/edit_profile_screen.dart';
import 'package:flowcycle/features/profile/screens/help_center_screen.dart';
import 'package:flowcycle/features/profile/screens/privacy_security_screen.dart';
import 'package:flowcycle/features/profile/screens/reminders_settings_screen.dart';
import 'package:flowcycle/features/profile/widgets/about_flowcycle_sheet.dart';
import 'package:flowcycle/features/profile/widgets/contact_support_dialog.dart';
import 'package:flowcycle/features/profile/widgets/pin_lock_dialog.dart';
import 'package:flowcycle/features/profile/widgets/rate_app_dialog.dart';
import 'package:flowcycle/shared/providers/app_scope.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';
import 'package:flowcycle/shared/widgets/buttons/primary_button.dart';

void main() {
  group('Profile Features & Subscreens Comprehensive Test Suite', () {
    late CycleDataController controller;

    setUp(() {
      controller = CycleDataController.instance;
    });

    testWidgets(
      '1. EditProfileScreen: Name, Avatars, and Stepper adjustments',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          AppScope(
            controller: controller,
            child: const MaterialApp(home: EditProfileScreen()),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Edit Profile'), findsOneWidget);
        expect(find.text('Full Name'), findsOneWidget);

        // Select second avatar
        await tester.tap(find.text('🌺'));
        await tester.pumpAndSettle();

        // Adjust Cycle Length Stepper (+)
        final addButtons = find.byIcon(Icons.add_rounded);
        await tester.tap(addButtons.first);
        await tester.pumpAndSettle();

        // Enter new name
        await tester.enterText(find.byType(TextField), 'Elena');
        await tester.pumpAndSettle();

        // Tap Save Changes
        await tester.ensureVisible(
          find.widgetWithText(PrimaryButton, 'Save Changes'),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(PrimaryButton, 'Save Changes'));
        await tester.pumpAndSettle();

        expect(controller.userProfile.name, 'Elena');
      },
    );

    testWidgets(
      '2. RemindersSettingsScreen: Notification toggles and Timing picker',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const MaterialApp(home: RemindersSettingsScreen()),
        );
        await tester.pumpAndSettle();

        expect(find.text('Reminders & Alerts'), findsOneWidget);
        expect(find.text('Period Start Alert'), findsOneWidget);
        expect(find.text('Fertile Window & Ovulation'), findsOneWidget);

        // Tap Period timing picker
        await tester.tap(find.text('2 days before'));
        await tester.pumpAndSettle();

        expect(find.text('Period Reminder Timing'), findsOneWidget);
        await tester.tap(find.text('3 days before'));
        await tester.pumpAndSettle();

        expect(find.text('3 days before'), findsOneWidget);
      },
    );

    testWidgets('3. PinLockDialog: Enter and confirm 4-digit PIN', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      String? completedPin;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PinLockDialog(
              isSettingUp: true,
              onPinCompleted: (pin) {
                completedPin = pin;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Set Up 4-Digit PIN'), findsOneWidget);

      // Enter 1 2 3 4
      await tester.tap(find.text('1'));
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pump();
      await tester.tap(find.text('3'));
      await tester.pump();
      await tester.tap(find.text('4'));
      await tester.pumpAndSettle(const Duration(milliseconds: 300));

      expect(find.text('Confirm 4-Digit PIN'), findsOneWidget);

      // Re-enter 1 2 3 4
      await tester.tap(find.text('1'));
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pump();
      await tester.tap(find.text('3'));
      await tester.pump();
      await tester.tap(find.text('4'));
      await tester.pumpAndSettle();

      expect(completedPin, '1234');
    });

    testWidgets(
      '4. PrivacySecurityScreen: Cloud Backup and Export Data sheet',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const MaterialApp(home: PrivacySecurityScreen()),
        );
        await tester.pumpAndSettle();

        expect(find.text('Privacy & Data'), findsOneWidget);
        expect(find.text('Encrypted Cloud Backup'), findsOneWidget);

        // Tap Sync Now
        await tester.tap(find.text('Sync Now'));
        await tester.pumpAndSettle(const Duration(seconds: 1));
        expect(find.text('Last backup: Just now'), findsOneWidget);

        // Tap Export Cycle Data
        await tester.tap(find.text('Export Cycle Data'));
        await tester.pumpAndSettle();

        expect(find.text('Export Medical PDF Report'), findsOneWidget);
        expect(find.text('Export CSV Raw Data'), findsOneWidget);
        await tester.tap(find.text('Export Medical PDF Report'));
        await tester.pumpAndSettle();
      },
    );

    testWidgets('5. AppPreferencesScreen: Language and Units selection', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: AppPreferencesScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Preferences'), findsOneWidget);
      expect(find.text('App Language'), findsOneWidget);

      // Open Language sheet
      await tester.tap(find.text('English (US)'));
      await tester.pumpAndSettle();

      expect(find.text('Select App Language'), findsOneWidget);
      await tester.tap(find.text('Français (French)'));
      await tester.pumpAndSettle();

      expect(find.text('Français (French)'), findsOneWidget);
    });

    testWidgets(
      '6. HelpCenterScreen: Accordion expand/collapse and search filter',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const MaterialApp(home: HelpCenterScreen()));
        await tester.pumpAndSettle();

        expect(find.text('Help Center'), findsOneWidget);
        expect(
          find.text('How are my cycle phases calculated?'),
          findsOneWidget,
        );

        // Expand FAQ tile
        await tester.tap(find.text('How are my cycle phases calculated?'));
        await tester.pumpAndSettle();

        expect(find.textContaining('Menstrual (Days 1–5)'), findsOneWidget);

        // Search
        await tester.enterText(find.byType(TextField), 'Temperature');
        await tester.pumpAndSettle();

        expect(
          find.text('How should I measure Basal Body Temperature (BBT)?'),
          findsOneWidget,
        );
        expect(find.text('How are my cycle phases calculated?'), findsNothing);
      },
    );

    testWidgets('7. ContactSupportDialog: Enter message and send', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ContactSupportDialog())),
      );
      await tester.pumpAndSettle();

      expect(find.text('Contact Support'), findsOneWidget);
      await tester.enterText(
        find.byType(TextField),
        'Great app, love the design!',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Send Message'));
      await tester.pumpAndSettle(const Duration(seconds: 1));
    });

    testWidgets('8. RateAppDialog: Select rating and submit', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: RateAppDialog())),
      );
      await tester.pumpAndSettle();

      expect(find.text('Enjoying FlowCycle?'), findsOneWidget);
      await tester.tap(find.text('Submit Rating'));
      await tester.pumpAndSettle();
    });

    testWidgets('9. AboutFlowcycleSheet: Version and Disclaimer rendering', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AboutFlowcycleSheet())),
      );
      await tester.pumpAndSettle();

      expect(find.text('Version 1.2.3 (Build 142)'), findsOneWidget);
      expect(find.text('MEDICAL DISCLAIMER'), findsOneWidget);
    });
  });
}
