import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/core/theme/app_theme.dart';
import 'package:flowcycle/core/theme/app_gradients.dart';
import 'package:flowcycle/features/profile/widgets/appearance_theme_card.dart';
import 'package:flowcycle/features/profile/widgets/theme_picker_sheet.dart';
import 'package:flowcycle/shared/providers/app_scope.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';
import 'package:flowcycle/shared/widgets/buttons/primary_button.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FlowCycle Theme System & Multi-Theme Flourish Suite', () {
    test('1. AppTheme returns distinct, flourishing ThemeData for all 5 themes', () {
      // 1. Rosé Bloom
      final roseTheme = AppTheme.getThemeById('pink');
      final roseExt = roseTheme.extension<FlowCycleThemeExtension>()!;
      expect(roseExt.id, 'pink');
      expect(roseExt.name, 'Rosé Bloom');
      expect(roseExt.emoji, '🌸');
      expect(roseExt.isDark, false);
      expect(roseTheme.scaffoldBackgroundColor, const Color(0xFFFAF7F2));

      // 2. Lavender Dream (purple / lavender)
      final lavenderTheme = AppTheme.getThemeById('purple');
      final lavenderExt = lavenderTheme.extension<FlowCycleThemeExtension>()!;
      expect(lavenderExt.id, 'purple');
      expect(lavenderExt.name, 'Lavender Dream');
      expect(lavenderExt.emoji, '💜');
      expect(lavenderExt.isDark, false);
      expect(lavenderTheme.scaffoldBackgroundColor, const Color(0xFFFAF7FD));

      // 3. Emerald Mint (mint / green)
      final mintTheme = AppTheme.getThemeById('mint');
      final mintExt = mintTheme.extension<FlowCycleThemeExtension>()!;
      expect(mintExt.id, 'mint');
      expect(mintExt.name, 'Emerald Mint');
      expect(mintExt.emoji, '🍃');
      expect(mintExt.isDark, false);
      expect(mintTheme.scaffoldBackgroundColor, const Color(0xFFF4FAF7));

      // 4. Sunset Amber (amber / sunset)
      final amberTheme = AppTheme.getThemeById('amber');
      final amberExt = amberTheme.extension<FlowCycleThemeExtension>()!;
      expect(amberExt.id, 'amber');
      expect(amberExt.name, 'Sunset Amber');
      expect(amberExt.emoji, '✨');
      expect(amberExt.isDark, false);
      expect(amberTheme.scaffoldBackgroundColor, const Color(0xFFFDFBF7));

      // 5. Midnight Indigo (navy / dark / midnight)
      final navyTheme = AppTheme.getThemeById('navy');
      final navyExt = navyTheme.extension<FlowCycleThemeExtension>()!;
      expect(navyExt.id, 'navy');
      expect(navyExt.name, 'Midnight Indigo');
      expect(navyExt.emoji, '🌙');
      expect(navyExt.isDark, true);
      expect(navyTheme.scaffoldBackgroundColor, const Color(0xFF0F172A));
      expect(navyTheme.brightness, Brightness.dark);
    });

    testWidgets('2. PrimaryButton adopts active theme gradient and glows', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.getThemeById('mint'),
          home: Scaffold(
            body: Center(
              child: PrimaryButton(
                label: 'Botanical Action',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Botanical Action'), findsOneWidget);

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(PrimaryButton),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      final gradient = decoration.gradient as LinearGradient;
      expect(gradient.colors, [const Color(0xFF10B981), const Color(0xFF6EE7B7)]);
    });

    testWidgets('3. AppearanceThemeCard renders all theme swatches and highlights active selection', (tester) async {
      String? selectedTheme;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.getThemeById('purple'),
          home: Scaffold(
            body: AppearanceThemeCard(
              selectedThemeId: 'purple',
              onThemeSelected: (id) => selectedTheme = id,
            ),
          ),
        ),
      );

      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Customize how the app looks.'), findsOneWidget);

      // Check mark icon is present on the selected swatch
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);

      // Tap the mint swatch
      await tester.tap(find.byType(GestureDetector).at(2));
      await tester.pumpAndSettle();

      expect(selectedTheme, 'mint');
    });

    testWidgets('4. ThemePickerSheet switches theme in CycleDataController with instant reactivity', (tester) async {
      final controller = CycleDataController.instance;
      controller.setTheme('pink');

      await tester.pumpWidget(
        AppScope(
          controller: controller,
          child: MaterialApp(
            theme: AppTheme.getThemeById('pink'),
            home: Scaffold(
              body: Builder(
                builder: (ctx) => ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: ctx,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => ThemePickerSheet(
                        currentThemeId: controller.selectedThemeId,
                      ),
                    );
                  },
                  child: const Text('Open Theme Sheet'),
                ),
              ),
            ),
          ),
        ),
      );

      // Open the sheet
      await tester.tap(find.text('Open Theme Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Appearance Themes'), findsOneWidget);
      expect(find.text('Rosé Bloom (Default)'), findsOneWidget);
      expect(find.text('Lavender Dream'), findsOneWidget);
      expect(find.text('Emerald Mint'), findsOneWidget);
      expect(find.text('Sunset Amber'), findsOneWidget);
      expect(find.text('Midnight Indigo'), findsOneWidget);

      // Tap Sunset Amber
      await tester.tap(find.text('Sunset Amber'));
      await tester.pumpAndSettle();

      expect(controller.selectedThemeId, 'amber');
    });

    test('5. AppGradients dynamic theme helpers return correct gradients', () {
      final roseGradient = AppGradients.forTheme('pink');
      expect(roseGradient.colors, [const Color(0xFFFF6B8B), const Color(0xFFFFA07A)]);

      final lavenderGradient = AppGradients.forTheme('purple');
      expect(lavenderGradient.colors, [const Color(0xFF8B5CF6), const Color(0xFFC084FC)]);

      final mintGradient = AppGradients.forTheme('mint');
      expect(mintGradient.colors, [const Color(0xFF10B981), const Color(0xFF6EE7B7)]);

      final amberGradient = AppGradients.forTheme('amber');
      expect(amberGradient.colors, [const Color(0xFFF59E0B), const Color(0xFFFCD34D)]);

      final navyGradient = AppGradients.forTheme('navy');
      expect(navyGradient.colors, [const Color(0xFF4F46E5), const Color(0xFF818CF8)]);
    });
  });
}
