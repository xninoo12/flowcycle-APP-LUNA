import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/ai_companion/chat/ai_chat_screen.dart';
import 'package:flowcycle/features/ai_companion/chat/widgets/chat_input_bar.dart';
import 'package:flowcycle/features/ai_companion/chat/widgets/chat_message_bubble.dart';

void main() {
  group('Live AI Chat Screen Tests', () {
    testWidgets('Renders Live AI Chat screen components with high fidelity', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: AiChatScreen()));
      await tester.pumpAndSettle();

      // 1. Header
      expect(find.text('AI Companion'), findsOneWidget);
      expect(find.text('● Online & Ready to help'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);

      // 2. Initial AI Greeting & Disclaimer
      expect(find.textContaining('AI health assistant'), findsOneWidget);
      expect(find.byType(ChatMessageBubble), findsAtLeastNWidgets(1));
      expect(find.text('What should I eat today? 🥗'), findsOneWidget);

      // 3. Bottom Input Bar
      expect(find.byType(ChatInputBar), findsOneWidget);
      expect(find.text('Ask me anything about your cycle...'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);
    });

    testWidgets(
      'Sending a message adds user bubble and triggers simulated AI response',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const MaterialApp(home: AiChatScreen()));
        await tester.pumpAndSettle();

        // Enter text and send
        await tester.enterText(
          find.byType(TextField),
          'What foods are good for fertility?',
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
        await tester.pump();

        // Check that user message appeared
        expect(find.text('What foods are good for fertility?'), findsOneWidget);

        // Advance time for AI response
        await tester.pump(const Duration(milliseconds: 700));
        await tester.pumpAndSettle();

        // Check AI response bubble appeared
        expect(find.byType(ChatMessageBubble), findsAtLeastNWidgets(2));
        expect(find.textContaining('Nutrition'), findsOneWidget);
      },
    );
  });
}
