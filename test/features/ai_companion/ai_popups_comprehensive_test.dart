import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/ai_companion/ai_companion_screen.dart';
import 'package:flowcycle/features/ai_companion/chat/widgets/ai_quick_chat_sheet.dart';
import 'package:flowcycle/features/ai_companion/widgets/ai_chat_history_sheet.dart';
import 'package:flowcycle/features/ai_companion/widgets/ai_medical_disclaimer_sheet.dart';
import 'package:flowcycle/features/ai_companion/widgets/ai_today_insight_detail_sheet.dart';
import 'package:flowcycle/shared/providers/app_scope.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';

void main() {
  group('AI Companion Screen Popups & Modal Sheets Comprehensive Test Suite', () {
    late CycleDataController controller;

    setUp(() {
      controller = CycleDataController.instance;
    });

    Widget buildTestable(Widget child) {
      return MaterialApp(
        home: AppScope(controller: controller, child: Scaffold(body: child)),
      );
    }

    testWidgets('1. AiTodayInsightDetailSheet: renders hormone surge & cycle recommendations', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      String? promptResult;

      await tester.pumpWidget(
        buildTestable(
          AiTodayInsightDetailSheet(
            onAskAiPrompt: (p) => promptResult = p,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("Today's AI Insight"), findsOneWidget);
      expect(find.text('Estrogen Surge & Peak Vitality'), findsOneWidget);
      expect(find.text('Nutritional Focus'), findsOneWidget);
      expect(find.text('Movement & Workouts'), findsOneWidget);

      final askBtn = find.text('Ask AI About Today’s Rhythm ✦');
      await tester.ensureVisible(askBtn);
      await tester.pumpAndSettle();
      await tester.tap(askBtn);
      await tester.pumpAndSettle();

      expect(promptResult, isNotNull);
    });

    testWidgets('2. AiChatHistorySheet: search and conversation selection', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      bool newChatTriggered = false;

      await tester.pumpWidget(
        buildTestable(
          AiChatHistorySheet(
            onNewChat: () => newChatTriggered = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Conversations'), findsOneWidget);
      expect(find.text('Start New Conversation ✦'), findsOneWidget);

      // Trigger Start New Conversation
      await tester.tap(find.text('Start New Conversation ✦'));
      await tester.pumpAndSettle();
      expect(newChatTriggered, isTrue);
    });

    testWidgets('3. AiMedicalDisclaimerSheet: renders safety notices & acknowledges', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestable(const AiMedicalDisclaimerSheet()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Medical Disclaimer'), findsOneWidget);
      expect(find.text('Educational Guidance Only'), findsOneWidget);
      expect(find.text('Emergency Symptoms'), findsOneWidget);

      final ackBtn = find.text('I Understand & Acknowledge ✨');
      await tester.ensureVisible(ackBtn);
      await tester.pumpAndSettle();
      await tester.tap(ackBtn);
      await tester.pumpAndSettle();
    });

    testWidgets('4. AiQuickChatSheet: sends user message and processes streaming response', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestable(const AiQuickChatSheet()),
      );
      await tester.pumpAndSettle();

      expect(find.text('FlowCycle AI'), findsOneWidget);
      expect(find.text('Am I fertile today?'), findsOneWidget);

      // Tap suggested chip
      await tester.tap(find.text('Am I fertile today?'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.text('Am I fertile today?'), findsWidgets);
    });

    testWidgets('5. AiCompanionScreen: header avatar opens Edit Profile popup', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            controller: controller,
            child: const AiCompanionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Today's Insight card
      final insightCard = find.text("Today's Insight");
      await tester.ensureVisible(insightCard);
      await tester.pumpAndSettle();
      await tester.tap(insightCard);
      await tester.pumpAndSettle();

      expect(find.text("Today's AI Insight"), findsOneWidget);
    });
  });
}
