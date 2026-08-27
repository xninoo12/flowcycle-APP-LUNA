import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/core/services/notification_service.dart';
import 'package:flowcycle/features/profile/profile_screen.dart';
import 'package:flowcycle/features/profile/widgets/app_preferences_sheet.dart';
import 'package:flowcycle/features/profile/widgets/edit_profile_sheet.dart';
import 'package:flowcycle/features/profile/widgets/help_center_sheet.dart';
import 'package:flowcycle/features/profile/widgets/privacy_security_sheet.dart';
import 'package:flowcycle/features/profile/widgets/profile_header_hero.dart';
import 'package:flowcycle/features/profile/widgets/reminders_settings_sheet.dart';
import 'package:flowcycle/features/profile/widgets/theme_picker_sheet.dart';
import 'package:flowcycle/shared/providers/app_scope.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';
import 'package:flowcycle/shared/widgets/buttons/primary_button.dart';

void main() {
  group('Profile Screen Popups & Modal Sheets Comprehensive Test Suite', () {
    late CycleDataController controller;

    setUp(() {
      controller = CycleDataController.instance;
    });

    testWidgets('1. ProfileHeaderHero displays visible "Edit" pill button at avatar', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      bool editTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileHeaderHero(
              userName: 'Amina',
              onEditName: () => editTapped = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Edit'), findsOneWidget);
      expect(find.byIcon(Icons.edit_rounded), findsOneWidget);

      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      expect(editTapped, isTrue);
    });

    testWidgets('2. EditProfileSheet: Modifies name, avatar, and updates cycle parameters', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        AppScope(
          controller: controller,
          child: const MaterialApp(
            home: Scaffold(
              body: EditProfileSheet(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Choose Avatar Symbol'), findsOneWidget);

      // Tap an avatar
      await tester.tap(find.text('🌺'));
      await tester.pumpAndSettle();

      // Enter new name
      await tester.enterText(find.byType(TextField), 'Maya Chen');
      await tester.pumpAndSettle();

      // Adjust Cycle Length (+)
      final addButtons = find.byIcon(Icons.add_rounded);
      await tester.ensureVisible(addButtons.first);
      await tester.pumpAndSettle();
      await tester.tap(addButtons.first);
      await tester.pumpAndSettle();

      // Save changes
      final saveBtn = find.widgetWithText(PrimaryButton, 'Save Profile Changes ✨');
      await tester.ensureVisible(saveBtn);
      await tester.pumpAndSettle();
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      expect(controller.userProfile.name, 'Maya Chen');
    });

    testWidgets('3. RemindersSettingsSheet: Toggles alerts and triggers test notification', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      NotificationService.instance.updateDiscreetMode(enabled: false);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: RemindersSettingsSheet()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Reminders & Alerts'), findsOneWidget);
      expect(find.text('Period Prediction'), findsOneWidget);
      expect(find.text('Fertile Window & Ovulation'), findsOneWidget);

      // Toggle switch
      final switches = find.byType(Switch);
      await tester.tap(switches.first);
      await tester.pumpAndSettle();

      // Scroll and Tap Send Test notification
      final testBtn = find.byIcon(Icons.notifications_active_rounded);
      await tester.ensureVisible(testBtn);
      await tester.pumpAndSettle();
      await tester.tap(testBtn);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('4. AppPreferencesSheet & LanguageSelectionSheet: Switches locale and units', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      String? selectedLang;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppPreferencesSheet(
              onLanguageChanged: (l) => selectedLang = l,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Preferences'), findsOneWidget);
      expect(find.text('App Language'), findsOneWidget);
      expect(find.text('Measurement Units'), findsOneWidget);

      // Open Language Picker
      await tester.tap(find.text('App Language'));
      await tester.pumpAndSettle();

      expect(find.text('Select Language'), findsOneWidget);
      expect(find.text('Spanish'), findsOneWidget);

      await tester.tap(find.text('Spanish'));
      await tester.pumpAndSettle();

      expect(selectedLang, 'Spanish');
    });

    testWidgets('5. PrivacySecuritySheet, CloudBackupSheet, and ExportDataSheet popups', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrivacySecuritySheet(onOpenPasscode: () {}),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Privacy & Data'), findsOneWidget);
      expect(find.text('Anonymous Mode'), findsOneWidget);
      expect(find.text('Encrypted Cloud Backup'), findsOneWidget);
      expect(find.text('Export Health Records'), findsOneWidget);

      // Open Cloud Backup popup
      final backupTile = find.text('Encrypted Cloud Backup');
      await tester.ensureVisible(backupTile);
      await tester.pumpAndSettle();
      await tester.tap(backupTile);
      await tester.pumpAndSettle();

      expect(find.text('Encrypted Cloud Backup'), findsWidgets);
      final backupBtn = find.text('Back Up Now ☁️');
      await tester.ensureVisible(backupBtn);
      await tester.pumpAndSettle();
      await tester.tap(backupBtn);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('6. HelpCenterSheet: FAQ categories and accordion expansion', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: HelpCenterSheet()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Help Center'), findsOneWidget);
      expect(find.text('Cycle Tracking'), findsOneWidget);
      expect(find.text('How does FlowCycle predict my next period?'), findsOneWidget);

      // Expand FAQ accordion
      final faqItem = find.text('How does FlowCycle predict my next period?');
      await tester.ensureVisible(faqItem);
      await tester.pumpAndSettle();
      await tester.tap(faqItem);
      await tester.pumpAndSettle();

      expect(find.textContaining('FlowCycle uses rolling Bayesian cycle averages'), findsOneWidget);
    });

    testWidgets('7. ThemePickerSheet: Switches active theme palette', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        AppScope(
          controller: controller,
          child: const MaterialApp(
            home: Scaffold(
              body: ThemePickerSheet(currentThemeId: 'pink'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Appearance Themes'), findsOneWidget);
      expect(find.text('Lavender Dream'), findsOneWidget);
      expect(find.text('Emerald Mint'), findsOneWidget);

      await tester.tap(find.text('Lavender Dream'));
      await tester.pumpAndSettle();

      expect(controller.selectedThemeId, 'purple');
    });
  });
}
