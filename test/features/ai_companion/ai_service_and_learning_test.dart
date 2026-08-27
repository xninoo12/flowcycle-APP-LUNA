import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/core/services/ai_service.dart';
import 'package:flowcycle/features/ai_companion/ai_companion_screen.dart';
import 'package:flowcycle/features/ai_companion/chat/ai_chat_screen.dart';
import 'package:flowcycle/features/ai_companion/learn/ai_learning_section.dart';
import 'package:flowcycle/features/ai_companion/widgets/ai_api_key_sheet.dart';
import 'package:flowcycle/features/learn/learn_screen.dart';
import 'package:flowcycle/shared/models/app_mode.dart';
import 'package:flowcycle/shared/models/user_profile.dart';
import 'package:flowcycle/shared/providers/app_scope.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';

void main() {
  late CycleDataController controller;

  setUp(() {
    controller = CycleDataController();
    AiService.instance.setApiKey(null); // Reset API key before tests
  });

  Widget buildTestable(Widget child) {
    return MaterialApp(
      home: AppScope(controller: controller, child: child),
    );
  }

  group('AI Service, Companion & Unified Learning Hub Comprehensive Test Suite', () {
    test(
      '1. AiService: manages API key and generates cycle-aware clinical fallback responses',
      () async {
        final aiService = AiService.instance;
        expect(aiService.hasApiKey, isFalse);

        aiService.setApiKey('test_gemini_key_123');
        expect(aiService.hasApiKey, isTrue);
        expect(aiService.apiKey, 'test_gemini_key_123');

        aiService.setApiKey(null);
        expect(aiService.hasApiKey, isFalse);

        final profileTtc = UserProfile(
          name: 'Amina',
          mode: AppMode.tryingToConceive,
          averageCycleLength: 28,
          typicalPeriodDuration: 5,
          lastPeriodStartDate: DateTime.now().subtract(const Duration(days: 9)),
        );

        // Test food response in Follicular phase
        final foodReply = await aiService.generateAiResponse(
          userPrompt: 'What should I eat today?',
          userProfile: profileTtc,
          cycleDay: 9,
          phaseName: 'Follicular Phase',
        );
        expect(foodReply, contains('Follicular Phase'));
        expect(foodReply, contains('estrogen is rising'));

        // Test fertility response in TTC mode
        final fertilityReply = await aiService.generateAiResponse(
          userPrompt: 'How can I boost my conception chances?',
          userProfile: profileTtc,
          cycleDay: 13,
          phaseName: 'Ovulatory Phase',
        );
        expect(fertilityReply, contains('Trying to Conceive'));
        expect(fertilityReply, contains('conception window'));

        // Test sleep response
        final sleepReply = await aiService.generateAiResponse(
          userPrompt: 'I feel tired and have poor sleep',
          userProfile: profileTtc,
          cycleDay: 22,
          phaseName: 'Luteal Phase',
        );
        expect(sleepReply, contains('progesterone'));
      },
    );

    testWidgets('2. AiApiKeySheet: inputs, saves, and clears Gemini API key', (
      tester,
    ) async {
      bool keyUpdated = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AiApiKeySheet(onKeyUpdated: () => keyUpdated = true),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('AI Intelligence Configuration'), findsOneWidget);
      expect(find.text('Active: FlowCycle Clinical Engine'), findsOneWidget);

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'AIzaSyDemoKey12345');
      await tester.pumpAndSettle();

      // Tap Save
      await tester.tap(find.text('Save & Activate AI Engine'));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(keyUpdated, isTrue);
      expect(AiService.instance.apiKey, 'AIzaSyDemoKey12345');
    });

    testWidgets(
      '3. AiCompanionScreen: header opens AI API Key sheet and smart reminders',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(buildTestable(const AiCompanionScreen()));
        await tester.pumpAndSettle();

        expect(find.text('AI Companion'), findsOneWidget);
        expect(find.byIcon(Icons.vpn_key_outlined), findsOneWidget);
        expect(find.byType(AiLearningSection), findsOneWidget);

        // Verify no "min read" badge is present in the learning section
        expect(find.textContaining('min read'), findsNothing);

        // Tap AI Key button
        await tester.tap(find.byIcon(Icons.vpn_key_outlined));
        await tester.pumpAndSettle();

        expect(find.byType(AiApiKeySheet), findsOneWidget);
      },
    );

    testWidgets(
      '4. AiChatScreen: sending message invokes AiService and appends response',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(buildTestable(const AiChatScreen()));
        await tester.pumpAndSettle();

        expect(find.textContaining('FlowCycle AI Companion'), findsOneWidget);

        final textField = find.byType(TextField);
        await tester.enterText(textField, 'What foods help with energy today?');
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pumpAndSettle();

        expect(find.text('What foods help with energy today?'), findsOneWidget);
        // AI reply added
        expect(find.textContaining('Phase'), findsAtLeast(1));
      },
    );

    testWidgets(
      '5. LearnScreen: renders Educational Library with AI integration',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(buildTestable(const LearnScreen()));
        await tester.pumpAndSettle();

        expect(find.text('Health Library'), findsOneWidget);
        expect(find.text('AI-Powered Health Wisdom'), findsOneWidget);
        expect(find.byType(AiLearningSection), findsOneWidget);
        expect(find.textContaining('min read'), findsNothing);
      },
    );
  });
}
