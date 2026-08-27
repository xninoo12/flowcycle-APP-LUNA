import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/ai_companion/ai_companion_screen.dart';
import 'package:flowcycle/features/ai_companion/learn/ai_learning_section.dart';
import 'package:flowcycle/features/ai_companion/widgets/ai_chat_history_section.dart';
import 'package:flowcycle/features/ai_companion/widgets/ai_companion_header.dart';
import 'package:flowcycle/features/ai_companion/widgets/ai_companion_hero_card.dart';
import 'package:flowcycle/features/ai_companion/widgets/ai_disclaimer_banner.dart';
import 'package:flowcycle/features/ai_companion/widgets/ai_prompt_carousel.dart';
import 'package:flowcycle/features/ai_companion/widgets/ai_today_insight_card.dart';

void main() {
  group('AI Companion Screen Tests', () {
    testWidgets(
      'Renders all AI Companion screen components with exact visual fidelity',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const MaterialApp(home: AiCompanionScreen()));
        await tester.pumpAndSettle();

        // 1. Header with sparkles and pink lotus logo
        expect(find.byType(AiCompanionHeader), findsOneWidget);
        expect(find.text('AI Companion'), findsWidgets);
        expect(find.text('✨'), findsWidgets);
        expect(find.text('🌸'), findsWidgets);
        expect(
          find.text('Your personal fertility & TTC guide'),
          findsOneWidget,
        );

        // 2. Open-Space Hero Section
        expect(find.byType(AiCompanionHeroCard), findsOneWidget);
        expect(find.textContaining('Hi '), findsOneWidget);
        expect(find.text('Chat with me'), findsOneWidget);

        // 3. Prompt Carousel
        expect(find.byType(AiPromptCarousel), findsOneWidget);
        expect(find.text('Try asking me'), findsOneWidget);
        expect(find.text('View all'), findsOneWidget);

        // 4. Today's Insight Card
        expect(find.byType(AiTodayInsightCard), findsOneWidget);
        expect(find.text("Today's Insight"), findsOneWidget);

        // 5. AI Learning & Daily Wisdom Section
        expect(find.byType(AiLearningSection), findsOneWidget);
        expect(find.text('AI Learning & Daily Wisdom'), findsOneWidget);
        expect(find.textContaining('Understanding'), findsOneWidget);

        // 6. Chat History Section
        expect(find.byType(AiChatHistorySection), findsOneWidget);
        expect(find.text("Let's talk"), findsOneWidget);
        expect(find.text('New chat'), findsOneWidget);

        // 7. Medical Disclaimer Banner
        expect(find.byType(AiDisclaimerBanner), findsOneWidget);
        expect(find.text('AI Companion can make mistakes.'), findsOneWidget);
        expect(find.text('Learn more'), findsOneWidget);
      },
    );

    testWidgets('Tapping notification bell opens Smart Reminders sheet', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: AiCompanionScreen()));
      await tester.pumpAndSettle();

      // Tap Notification Bell
      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Smart Reminders'), findsOneWidget);
      expect(find.text('Period Alerts'), findsOneWidget);
      expect(find.text('Fertile Window alerts'), findsOneWidget);
      expect(find.text('Daily Log reminders'), findsOneWidget);
      expect(find.text('AI Daily Health Tip'), findsOneWidget);
      expect(find.text('Save Preferences'), findsOneWidget);
    });
  });
}
