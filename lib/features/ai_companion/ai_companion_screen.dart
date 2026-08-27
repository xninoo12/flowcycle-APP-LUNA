import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_names.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/providers/app_scope.dart';
import '../profile/widgets/edit_profile_sheet.dart';
import 'chat/widgets/ai_quick_chat_sheet.dart';
import 'learn/ai_learning_section.dart';
import 'reminders/smart_reminders_sheet.dart';
import 'widgets/ai_chat_history_section.dart';
import 'widgets/ai_chat_history_sheet.dart';
import 'widgets/ai_companion_header.dart';
import 'widgets/ai_companion_hero_card.dart';
import 'widgets/ai_disclaimer_banner.dart';
import 'widgets/ai_medical_disclaimer_sheet.dart';
import 'widgets/ai_prompt_carousel.dart';
import 'widgets/ai_prompt_explorer_sheet.dart';
import 'widgets/ai_today_insight_card.dart';
import 'widgets/ai_today_insight_detail_sheet.dart';

/// Primary AI Companion Screen for FlowCycle with all features wired as interactive individual popups.
class AiCompanionScreen extends StatefulWidget {
  const AiCompanionScreen({super.key});

  @override
  State<AiCompanionScreen> createState() => _AiCompanionScreenState();
}

class _AiCompanionScreenState extends State<AiCompanionScreen> {
  void _openQuickChat([String? prompt]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AiQuickChatSheet(initialPrompt: prompt),
    );
  }

  void _openPromptExplorer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AiPromptExplorerSheet(
        onPromptSelected: _openQuickChat,
      ),
    );
  }

  void _openChatHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AiChatHistorySheet(
        onChatSelected: _openQuickChat,
        onNewChat: () => _openQuickChat(null),
      ),
    );
  }

  void _openSmartReminders() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const SmartRemindersSheet(),
    );
  }

  void _openTodayInsightDetail() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AiTodayInsightDetailSheet(
        onAskAiPrompt: _openQuickChat,
      ),
    );
  }

  void _openMedicalDisclaimer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AiMedicalDisclaimerSheet(),
    );
  }

  void _openEditProfileSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const EditProfileSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = AppScope.of(context).userProfile;
    final userName = userProfile.name;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. AI Companion Header (Title ✨ 🌸, Subtitle, Bell 🔔, Avatar)
                AiCompanionHeader(
                  onNotificationTap: _openSmartReminders,
                  onProfileTap: _openEditProfileSheet,
                ),

                const SizedBox(height: 10.0),

                // 2. Open-Space Hero Section ("Hi Amina 👋", Description, "Chat with me ✨", Mascot)
                AiCompanionHeroCard(
                  userName: userName,
                  onChatTap: () => _openQuickChat('Hi!'),
                ),

                const SizedBox(height: 10.0),

                // 3. "Try asking me ✨" Horizontal Prompt Capsule Cards Carousel
                AiPromptCarousel(
                  onPromptSelected: _openQuickChat,
                  onViewAll: _openPromptExplorer,
                ),

                const SizedBox(height: 10.0),

                // 4. "AI Learning & Daily Wisdom" Illustrated Carousel Section (Opens Article Reader popup)
                AiLearningSection(onTopicAskAi: _openQuickChat),

                const SizedBox(height: 10.0),

                // 5. "Today's Insight ✦" Card (Opens Today's Insight popup sheet)
                AiTodayInsightCard(
                  onTap: _openTodayInsightDetail,
                ),

                const SizedBox(height: 10.0),

                // 6. "Let's talk" Chat History Section (Recent chats & New chat ⊕)
                AiChatHistorySection(
                  onNewChat: () => _openQuickChat(null),
                  onChatSelected: (chat) => _openQuickChat(chat.title),
                  onViewAllChats: _openChatHistory,
                ),

                const SizedBox(height: 10.0),

                // 7. Medical Disclaimer Banner (Opens Medical Disclaimer popup sheet)
                AiDisclaimerBanner(
                  onLearnMore: _openMedicalDisclaimer,
                ),

                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
