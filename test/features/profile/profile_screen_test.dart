import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/profile/profile_screen.dart';
import 'package:flowcycle/features/profile/widgets/appearance_theme_card.dart';
import 'package:flowcycle/features/profile/widgets/profile_header_hero.dart';
import 'package:flowcycle/features/profile/widgets/profile_metrics_row.dart';
import 'package:flowcycle/features/profile/widgets/profile_preferences_card.dart';
import 'package:flowcycle/features/profile/widgets/profile_privacy_data_card.dart';
import 'package:flowcycle/features/profile/widgets/profile_privacy_matters_banner.dart';
import 'package:flowcycle/features/profile/widgets/profile_support_about_card.dart';

void main() {
  group('Profile Screen Tests', () {
    testWidgets(
      'Renders all Profile screen components with exact visual fidelity',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
        await tester.pumpAndSettle();

        // 1. Header & Hero
        expect(find.byType(ProfileHeaderHero), findsOneWidget);
        expect(find.text('FlowCycle'), findsOneWidget);
        expect(find.text('Know your body. '), findsOneWidget);
        expect(find.text('Live better.'), findsOneWidget);
        expect(find.text('Amina'), findsOneWidget);
        expect(find.text('💗'), findsOneWidget);
        expect(find.text('Healthy'), findsOneWidget);
        expect(find.text('Confident'), findsOneWidget);
        expect(find.text('In control'), findsOneWidget);
        expect(find.text('👑'), findsOneWidget);

        // 2. 4-Item Metric Row
        expect(find.byType(ProfileMetricsRow), findsOneWidget);
        expect(find.text('Cycle Day'), findsOneWidget);
        expect(find.text('13'), findsOneWidget);
        expect(find.text('of 28'), findsOneWidget);
        expect(find.text('Sex Logged'), findsOneWidget);
        expect(find.text('4'), findsOneWidget);
        expect(find.text('Days Logged'), findsOneWidget);
        expect(find.text('21'), findsOneWidget);
        expect(find.text('Current Mode'), findsOneWidget);
        expect(find.textContaining('Conceive'), findsWidgets);

        // 3. Appearance Theme Card
        expect(find.byType(AppearanceThemeCard), findsOneWidget);
        expect(find.text('Appearance'), findsOneWidget);
        expect(find.text('Customize how the app looks.'), findsOneWidget);

        // 4. Privacy & Data Card
        expect(find.byType(ProfilePrivacyDataCard), findsOneWidget);
        expect(find.text('Privacy & Data'), findsOneWidget);
        expect(find.text('Privacy & Data Settings'), findsOneWidget);
        expect(find.text('Passcode & Biometrics'), findsOneWidget);
        expect(find.text('Backup & Restore'), findsOneWidget);
        expect(find.text('Export or Delete Data'), findsOneWidget);
        expect(find.text('Off'), findsOneWidget);

        // 5. Preferences Card
        expect(find.byType(ProfilePreferencesCard), findsOneWidget);
        expect(find.text('Preferences'), findsOneWidget);
        expect(find.text('Language'), findsOneWidget);
        expect(find.text('English'), findsOneWidget);
        expect(find.text('Units'), findsOneWidget);
        expect(find.text('Metric (°C, kg)'), findsOneWidget);

        // 6. Support & About Card (2x2 Grid)
        expect(find.byType(ProfileSupportAboutCard), findsOneWidget);
        expect(find.text('Support & About'), findsOneWidget);
        expect(find.text('Help Center'), findsOneWidget);
        expect(find.text('Contact Us'), findsOneWidget);
        expect(find.text('Rate FlowCycle'), findsOneWidget);
        expect(find.text('About FlowCycle'), findsOneWidget);

        // 7. Privacy Matters Banner
        expect(find.byType(ProfilePrivacyMattersBanner), findsOneWidget);
        expect(find.text('Your privacy matters'), findsOneWidget);
        expect(
          find.text('Your data is private, encrypted and never shared.'),
          findsOneWidget,
        );
      },
    );

    testWidgets('Tapping Current Mode in metrics row toggles mode', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Current Mode'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
