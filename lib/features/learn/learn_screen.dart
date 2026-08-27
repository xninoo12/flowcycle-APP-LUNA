import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/router/route_names.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/flow_cycle_theme_extension.dart';
import '../ai_companion/learn/ai_learning_section.dart';

/// Full Educational Health Library Screen for FlowCycle,
/// seamlessly integrated with the AI Companion knowledge engine.
class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  void _handleAskAi(BuildContext context, String topic) {
    try {
      context.push(
        AppRoutes.aiChatPath,
        extra: {'prompt': 'Can you teach me more about $topic?'},
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Starting AI consultation on: $topic'),
          backgroundColor: const Color(0xFF7C5CE7),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.flowTheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: theme.textPrimary,
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.homePath);
            }
          },
        ),
        title: Row(
          children: [
            Text(
              'Health Library',
              style: AppTextStyles.title.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: const Color(0xFF1E1A3C),
              ),
            ),
            const SizedBox(width: 6),
            const Text('📚', style: TextStyle(fontSize: 18)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.auto_awesome_rounded,
              color: Color(0xFF7C5CE7),
              size: 22,
            ),
            tooltip: 'Open AI Companion',
            onPressed: () {
              try {
                context.go(AppRoutes.aiCompanionPath);
              } catch (_) {}
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search & Explore Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C5CE7), Color(0xFF9F7AEA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C5CE7).withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.psychology_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI-Powered Health Wisdom',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Explore science-backed cycle guides and fertility research',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Educational Health Section
              AiLearningSection(
                onTopicAskAi: (topic) => _handleAskAi(context, topic),
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
