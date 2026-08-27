import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/shared/models/app_mode.dart';
import 'package:flowcycle/shared/providers/app_scope.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';
import 'package:flowcycle/features/ai_companion/ai_companion_screen.dart';
import 'package:flowcycle/features/ai_companion/chat/ai_chat_screen.dart';
import 'package:flowcycle/features/ai_companion/chat/screens/ai_chat_history_screen.dart';
import 'package:flowcycle/features/ai_companion/learn/models/article_item.dart';
import 'package:flowcycle/features/ai_companion/learn/widgets/article_detail_sheet.dart';
import 'package:flowcycle/features/ai_companion/learn/widgets/article_reader_modal.dart';
import 'package:flowcycle/features/ai_companion/widgets/ai_prompt_explorer_sheet.dart';

Widget _buildTestWidget(Widget child, [CycleDataController? controller]) {
  final ctrl = controller ?? CycleDataController();
  return AppScope(
    controller: ctrl,
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  group('AI Companion Comprehensive Feature & Subscreen Tests', () {
    testWidgets(
      '1. ArticleDetailSheet: Full article rendering and Ask AI CTA',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          _buildTestWidget(
            const ArticleDetailSheet(
              title: 'Hormonal Balance & Sleep',
              category: 'Hormone Health 🌸',
              summary:
                  'Understanding circadian rhythm and progesterone shifts.',
              takeaways: [
                'Sleep temperature regulation',
                'Magnesium glycinate support',
              ],
              sections: [
                {
                  'heading': 'Core Mechanism',
                  'body':
                      'Progesterone elevates body temperature in luteal phase.',
                },
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Hormonal Balance & Sleep'), findsOneWidget);
        expect(find.text('Hormone Health 🌸'), findsOneWidget);
        expect(find.text('KEY CLINICAL TAKEAWAYS'), findsOneWidget);
        expect(find.text('Sleep temperature regulation'), findsOneWidget);
        expect(find.text('Core Mechanism'), findsOneWidget);
        expect(find.text('Ask AI About This Article ✦'), findsOneWidget);

        await tester.tap(find.text('Ask AI About This Article ✦'));
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      '2. ArticleReaderModal: Category badge and takeaways rendering',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        bool askAiCalled = false;
        const article = ArticleItem(
          id: 'art_1',
          title: 'Cervical Fluid Tracking',
          category: 'Fertility',
          summary: 'How to track fertile window changes.',
          keyTakeaways: ['Egg-white mucus indicates peak fertility.'],
          themeColor: Color(0xFF7C64E8),
          icon: Icons.water_drop_rounded,
        );

        await tester.pumpWidget(
          _buildTestWidget(
            ArticleReaderModal(
              article: article,
              onAskAiPressed: () => askAiCalled = true,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Cervical Fluid Tracking'), findsOneWidget);
        expect(find.text('Fertility'), findsOneWidget);
        expect(find.text('AI Key Takeaways'), findsOneWidget);
        expect(
          find.text('Egg-white mucus indicates peak fertility.'),
          findsOneWidget,
        );

        await tester.tap(find.text('Ask AI About This Topic'));
        await tester.pumpAndSettle();
        expect(askAiCalled, isTrue);
      },
    );

    testWidgets(
      '3. AiPromptExplorerSheet: Category filtering, search, and selection',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        String? selectedPrompt;

        await tester.pumpWidget(
          _buildTestWidget(
            AiPromptExplorerSheet(onPromptSelected: (p) => selectedPrompt = p),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('AI Prompt Explorer'), findsOneWidget);
        expect(find.text('Cycle & Flow'), findsOneWidget);
        expect(find.text('Fertility & TTC'), findsOneWidget);

        // Filter by category
        await tester.tap(find.text('Fertility & TTC'));
        await tester.pumpAndSettle();

        expect(
          find.text('How do I detect my fertile window accurately?'),
          findsOneWidget,
        );

        // Search
        await tester.enterText(find.byType(TextField), 'supplements');
        await tester.pumpAndSettle();

        expect(
          find.text('Best supplements for egg quality when TTC'),
          findsOneWidget,
        );

        // Tap prompt card
        await tester.tap(
          find.text('Best supplements for egg quality when TTC'),
        );
        await tester.pumpAndSettle();

        expect(selectedPrompt, 'Best supplements for egg quality when TTC');
      },
    );

    testWidgets(
      '4. AiChatHistoryScreen: Search, delete, and new chat trigger',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(_buildTestWidget(const AiChatHistoryScreen()));
        await tester.pumpAndSettle();

        expect(find.text('Chat History'), findsOneWidget);
        expect(find.text('Luteal Phase Nutrition & Cravings'), findsOneWidget);
        expect(find.text('Start New Chat ✦'), findsOneWidget);

        // Search
        await tester.enterText(find.byType(TextField), 'Cramp');
        await tester.pumpAndSettle();

        expect(find.text('Period Cramp Relief & Gentle Yoga'), findsOneWidget);
        expect(find.text('Luteal Phase Nutrition & Cravings'), findsNothing);

        // Clear search
        await tester.enterText(find.byType(TextField), '');
        await tester.pumpAndSettle();

        // Delete first chat
        final deleteIcons = find.byIcon(Icons.delete_outline_rounded);
        expect(deleteIcons, findsWidgets);
        await tester.tap(deleteIcons.first);
        await tester.pumpAndSettle();

        expect(
          find.text('Deleted "Luteal Phase Nutrition & Cravings"'),
          findsOneWidget,
        );
      },
    );

    testWidgets('5. AiChatScreen: Text messaging, response, and action chips', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_buildTestWidget(const AiChatScreen()));
      await tester.pumpAndSettle();

      expect(find.text('AI Companion'), findsOneWidget);
      expect(find.text('What should I eat today? 🥗'), findsOneWidget);

      // Tap a quick reply
      await tester.tap(find.text('What should I eat today? 🥗'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();

      expect(find.textContaining('Phase'), findsAtLeast(1));

      // Test Copy chip
      final copyButtons = find.text('Copy');
      expect(copyButtons, findsWidgets);
      await tester.tap(copyButtons.first);
      await tester.pumpAndSettle();
      expect(find.text('Copied insight to clipboard 📋'), findsOneWidget);

      // Test Helpful chip
      final helpfulButtons = find.text('Helpful');
      expect(helpfulButtons, findsWidgets);
      await tester.tap(helpfulButtons.first);
      await tester.pumpAndSettle();
      expect(find.text('Thanks for your feedback! 👍'), findsOneWidget);

      // Dismiss snackbars
      ScaffoldMessenger.of(
        tester.element(find.byType(AiChatScreen)),
      ).clearSnackBars();
      await tester.pumpAndSettle();

      // Send custom text message
      await tester.enterText(
        find.byType(TextField),
        'How to improve sleep quality?',
      );
      await tester.testTextInput.receiveAction(TextInputAction.send);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pumpAndSettle();

      expect(find.textContaining('sleep'), findsAtLeast(1));
    });

    testWidgets(
      '6. AiCompanionScreen: Reactive username, prompt carousel, and history',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        final controller = CycleDataController();
        controller.updateUserProfile(
          name: 'Maya',
          averageCycleLength: 28,
          typicalPeriodDuration: 5,
          lastPeriodStartDate: DateTime.now().subtract(
            const Duration(days: 12),
          ),
          mode: AppMode.tryingToConceive,
        );

        await tester.pumpWidget(
          _buildTestWidget(const AiCompanionScreen(), controller),
        );
        await tester.pumpAndSettle();

        expect(find.text('Hi Maya'), findsOneWidget);
        expect(find.text('AI Companion'), findsOneWidget);
        expect(find.text('AI Learning & Daily Wisdom'), findsOneWidget);
        expect(find.text("Let's talk"), findsOneWidget);

        // Tap 'View all' prompts -> opens bottom sheet
        await tester.tap(find.text('View all'));
        await tester.pumpAndSettle();
        expect(find.text('AI Prompt Explorer'), findsOneWidget);
      },
    );
  });
}
