import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_names.dart';
import '../../core/data/app_data_manager.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/flow_cycle_theme_extension.dart';
import '../../shared/models/app_mode.dart';
import '../../shared/providers/app_scope.dart';
import '../../shared/widgets/brand/flow_cycle_brand_header.dart';
import '../../shared/widgets/buttons/primary_button.dart';
import 'models/onboarding_state.dart';
import 'providers/onboarding_state_provider.dart';
import 'widgets/choose_mode_hero.dart';
import 'widgets/choose_mode_trust_row.dart';
import 'widgets/mode_selection_card.dart';
import 'widgets/onboarding_algorithm_calibration_card.dart';
import 'widgets/onboarding_calendar_picker.dart';
import 'widgets/onboarding_header.dart';
import 'widgets/onboarding_irregular_cycle_sheet.dart';
import 'widgets/onboarding_number_stepper.dart';
import 'widgets/onboarding_why_we_ask_sheet.dart';
import 'widgets/personalized_multi_select_card.dart';
import 'widgets/personalized_single_select_card.dart';
import 'widgets/step3_why_it_matters_card.dart';

/// Progressive Adaptive Onboarding Screen covering Goal Selection (Choose Mode), Shared Setup,
/// Personalized Questions, and automatic "You're all set!" pop-up transition (1.5s) to Home Dashboard.
class OnboardingScreen extends StatefulWidget {
  final AppMode? initialMode;
  final DateTime? initialLastPeriod;
  final int? initialCycleLength;
  final int? initialPeriodDuration;
  final String? initialTtcDuration;
  final List<String>? initialCycleGoals;
  final Duration transitionDelay;
  final VoidCallback? onComplete;

  const OnboardingScreen({
    super.key,
    this.initialMode,
    this.initialLastPeriod,
    this.initialCycleLength,
    this.initialPeriodDuration,
    this.initialTtcDuration,
    this.initialCycleGoals,
    this.transitionDelay = const Duration(milliseconds: 1500),
    this.onComplete,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final OnboardingController _controller;
  bool _isShowingCompletion = false;
  Timer? _transitionTimer;

  static const List<String> _ttcOptions = [
    'Just starting',
    'Less than 3 months',
    '3–6 months',
    '6–12 months',
    'More than 1 year',
  ];

  static const List<_CycleGoalOption> _cycleGoalOptions = [
    _CycleGoalOption(
      title: 'Understand my cycle',
      subtitle: 'Learn about your cycle phases\nand patterns.',
      icon: Icons.donut_large_rounded,
    ),
    _CycleGoalOption(
      title: 'Predict my period',
      subtitle: 'Get accurate predictions for\nyour next period.',
      icon: Icons.calendar_today_rounded,
    ),
    _CycleGoalOption(
      title: 'Track symptoms',
      subtitle: 'Monitor physical & emotional\nsymptoms.',
      icon: Icons.health_and_safety_rounded,
    ),
    _CycleGoalOption(
      title: 'Improve wellbeing',
      subtitle: 'Build healthy habits and\nimprove self-care.',
      icon: Icons.spa_rounded,
    ),
    _CycleGoalOption(
      title: 'Learn & educate',
      subtitle: 'Get expert-backed insights\nand tips.',
      icon: Icons.auto_stories_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = OnboardingController(
      initialMode: widget.initialMode,
      initialLastPeriod: widget.initialLastPeriod,
      initialCycleLength: widget.initialCycleLength,
      initialPeriodDuration: widget.initialPeriodDuration,
      initialTtcDuration: widget.initialTtcDuration,
      initialCycleGoals: widget.initialCycleGoals,
    );
    _controller.addListener(_handleStateChange);
  }

  @override
  void dispose() {
    _transitionTimer?.cancel();
    _controller.removeListener(_handleStateChange);
    _controller.dispose();
    super.dispose();
  }

  void _handleStateChange() {
    setState(() {});
  }

  void _handleBack() {
    if (_isShowingCompletion) return;

    if (_controller.currentStep > 1) {
      _controller.previousStep();
    } else {
      try {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(AppRoutes.loginPath);
        }
      } catch (_) {}
    }
  }

  void _openWhyWeAskSheet(int step) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => OnboardingWhyWeAskSheet(step: step),
    );
  }

  void _openIrregularCycleSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => OnboardingIrregularCycleSheet(
        onUseDefaultEstimate: () {
          final now = DateTime.now();
          _controller.setLastPeriodStartDate(
            now.subtract(const Duration(days: 14)),
          );
          _controller.setAverageCycleLength(28);
          _controller.setTypicalPeriodDuration(5);
        },
      ),
    );
  }

  void _handleContinue() {
    if (!_controller.canProceed || _isShowingCompletion) return;

    if (_controller.currentStep < _controller.state.totalSteps) {
      _controller.nextStep();
    } else {
      // Step 5 Complete: Save completion state and initialize app data directly from onboarding
      _controller.completeOnboarding();

      final mode = _controller.state.selectedMode ?? AppMode.cycleAwareness;
      final cycleLength = _controller.state.averageCycleLength ?? 28;
      final periodDuration = _controller.state.typicalPeriodDuration ?? 5;
      final lastPeriod =
          _controller.state.lastPeriodStartDate ??
          DateTime.now().subtract(const Duration(days: 13));

      final cycleGoals = _controller.state.cycleAwarenessGoals.isNotEmpty
          ? _controller.state.cycleAwarenessGoals
          : ['Understand my cycle'];
      final ttcDuration =
          _controller.state.tryingToConceiveDuration ?? 'Just starting';
      final focusGoal = mode == AppMode.tryingToConceive
          ? ttcDuration
          : cycleGoals.first;

      try {
        final cycleController = AppScope.read(context);
        cycleController.initializeFromOnboarding(
          mode: mode,
          lastPeriodStartDate: lastPeriod,
          averageCycleLength: cycleLength,
          typicalPeriodDuration: periodDuration,
          focusGoal: focusGoal,
          cycleGoals: cycleGoals,
          ttcDuration: ttcDuration,
        );
      } catch (_) {}

      // Trigger unified pipeline ingestion, baseline period synthesis, and reminder scheduling
      AppDataManager.instance.handleOnboardingCompletion(_controller.state);

      setState(() {
        _isShowingCompletion = true;
      });

      // Automatically transitions to Home Dashboard after 1.5 seconds (no manual button needed)
      _transitionTimer = Timer(widget.transitionDelay, () {
        if (!mounted) return;
        if (widget.onComplete != null) {
          widget.onComplete!();
        } else {
          try {
            context.go(AppRoutes.homePath);
          } catch (_) {}
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFAF7F5),
              Color(0xFFFFF6F8),
              Color(0xFFFAF6F3),
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Corner Petals Accent
            Positioned(
              left: -20,
              bottom: 40,
              child: Opacity(
                opacity: 0.25,
                child: Icon(
                  Icons.local_florist_rounded,
                  size: 80,
                  color: AppColors.primaryRose.withValues(alpha: 0.4),
                ),
              ),
            ),
            Positioned(
              right: -25,
              bottom: 80,
              child: Opacity(
                opacity: 0.20,
                child: Icon(
                  Icons.eco_rounded,
                  size: 70,
                  color: AppColors.primaryRose.withValues(alpha: 0.4),
                ),
              ),
            ),

            SafeArea(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _isShowingCompletion
                    ? _buildCompletionTransitionView()
                    : _buildOnboardingFlowView(state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Celebratory "You're all set!" Pop-up / Full-Screen view matching the reference design.
  /// Automatically proceeds to the dashboard after 1.5 seconds.
  Widget _buildCompletionTransitionView() {
    final theme = context.flowTheme;
    final state = _controller.state;
    final mode = state.selectedMode ?? AppMode.cycleAwareness;
    final cycleLength = state.averageCycleLength ?? 28;
    final periodDuration = state.typicalPeriodDuration ?? 5;

    return Container(
      key: const ValueKey<String>('completion_view'),
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
      child: Center(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 0. Top Brand Header: 🌸 FlowCycle 🍃 + Tagline
              const FlowCycleBrandHeader(
                crossAxisAlignment: CrossAxisAlignment.center,
                size: BrandHeaderSize.standard,
                showTagline: true,
              ),
              const SizedBox(height: 12.0),

              // 1. Serene Hero Woman Illustration with Botanical Laurels
              SizedBox(
                height: 120.0,
                child: Image.asset(
                  'assets/images/choose_mode_woman_hero.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.favorite_rounded,
                    color: theme.primary,
                    size: 70.0,
                  ),
                ),
              ),

              const SizedBox(height: 12.0),

              // 2. Celebratory Serif Heading & Sparkle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You're all set!",
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 27.0,
                      fontWeight: FontWeight.w900,
                      color: theme.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 6.0),
                  const Text(
                    '✨',
                    style: TextStyle(fontSize: 22.0),
                  ),
                ],
              ),

              const SizedBox(height: 4.0),

              Text(
                'Your FlowCycle experience is ready.',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: theme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 14.0),

              // 3. Delicate Centered Botanical Petal Motif
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40.0,
                    height: 1.0,
                    color: theme.chipBorder,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '🌸',
                      style: TextStyle(fontSize: 13.0),
                    ),
                  ),
                  Container(
                    width: 40.0,
                    height: 1.0,
                    color: theme.chipBorder,
                  ),
                ],
              ),

              const SizedBox(height: 16.0),

              // 4. Algorithm Calibration Checklist Card
              OnboardingAlgorithmCalibrationCard(
                mode: mode,
                cycleLength: cycleLength,
                periodDuration: periodDuration,
              ),

              const SizedBox(height: 14.0),

              // 5. "We're excited to be part of your journey" Encouragement Card
              _buildExcitementBannerCard(theme),

              const SizedBox(height: 20.0),

              // 6. Privacy Tagline (Auto-navigates without manual button)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_rounded,
                    size: 13.0,
                    color: theme.primary,
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    'Your data is private and secure.',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: theme.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExcitementBannerCard(FlowCycleThemeExtension theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: theme.containerLight,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: theme.chipBorder,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36.0,
            height: 36.0,
            decoration: BoxDecoration(
              color: theme.cardBackground,
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.chipBorder,
                width: 1.0,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.favorite_rounded,
                color: theme.primary,
                size: 18.0,
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "We're excited to be part of your journey.",
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w800,
                    color: theme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  "Here's to feeling empowered every day.",
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: theme.primary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.eco_rounded,
            size: 20.0,
            color: theme.primary.withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingFlowView(OnboardingState state) {
    final theme = context.flowTheme;
    final headerInfo = _getHeaderInfo(state);
    final bool isStep1 = state.currentStep == 1;

    return Column(
      key: const ValueKey<String>('onboarding_flow_view'),
      children: [
        // 1. Fixed Header: Back Button + Progress Bar Indicator + Step Title & Rationale
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: OnboardingHeader(
            onBack: _handleBack,
            progress: state.currentStep / state.totalSteps,
            title: headerInfo.title,
            subtitle: headerInfo.subtitle,
            questionText: headerInfo.questionText,
            helperText: headerInfo.helperText,
            iconBadge: headerInfo.iconBadge,
            onWhyWeAsk: !isStep1 ? () => _openWhyWeAskSheet(state.currentStep) : null,
            showTitleAndSubtitle: !isStep1,
          ),
        ),

        // 2. Animated Step Body
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              child: _buildCurrentStepContent(state),
            ),
          ),
        ),

        // 3. Fixed Bottom Sticky Continue Button + Privacy Reassurance
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryButton(
                label: 'Continue',
                gradient: theme.primaryGradient,
                trailingIcon: Icons.arrow_forward_rounded,
                height: 52.0,
                onPressed: _controller.canProceed ? _handleContinue : null,
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_rounded,
                    size: 13.0,
                    color: theme.primary,
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    'Your data is private and secure.',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: theme.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
            ],
          ),
        ),
      ],
    );
  }

  _HeaderInfo _getHeaderInfo(OnboardingState state) {
    switch (state.currentStep) {
      case 1:
        return const _HeaderInfo(
          title: "Let's personalize FlowCycle for you",
          subtitle: 'Step 1 of 5 • Setup',
          questionText: 'What would you like to focus on?',
        );
      case 2:
        return const _HeaderInfo(
          title: 'Period History',
          subtitle: 'Step 2 of 5 • Setup',
          iconBadge: Icons.calendar_month_rounded,
          questionText: 'When did your last period start?',
          helperText: 'Select the first day of your last period.',
        );
      case 3:
        return const _HeaderInfo(
          title: 'Cycle Insights',
          subtitle: 'Step 3 of 5 • Setup',
          iconBadge: Icons.bar_chart_rounded,
          questionText: "What's your average cycle length?",
          helperText: 'This helps us personalize your predictions\nand insights just for you.',
        );
      case 4:
        return const _HeaderInfo(
          title: 'Period Duration',
          subtitle: 'Step 4 of 5 • Setup',
          iconBadge: Icons.water_drop_rounded,
          questionText: 'How long does your period usually last?',
          helperText: 'This helps us personalize your predictions\nand insights just for you.',
        );
      case 5:
        if (state.selectedMode == AppMode.tryingToConceive) {
          return const _HeaderInfo(
            title: 'Fertility Journey',
            subtitle: 'Step 5 of 5 • Questions',
            iconBadge: Icons.favorite_border_rounded,
            questionText: 'How long have you been trying to conceive?',
            helperText: 'This helps us tailor insights for you.',
          );
        } else {
          return const _HeaderInfo(
            title: 'Personalized Goals',
            subtitle: 'Step 5 of 5 • Questions',
            iconBadge: Icons.track_changes_rounded,
            questionText: 'What would you like to focus on?',
            helperText: 'Select all that apply. You can always\nupdate this later.',
          );
        }
      default:
        return const _HeaderInfo(title: 'Setup', subtitle: 'Onboarding');
    }
  }

  Widget _buildCurrentStepContent(OnboardingState state) {
    switch (state.currentStep) {
      case 1:
        return _buildStep1GoalSelection(state);
      case 2:
        return _buildStep2LastPeriodDate(state);
      case 3:
        return _buildStep3CycleLength(state);
      case 4:
        return _buildStep4PeriodDuration(state);
      case 5:
        return _buildStep5PersonalizedQuestions(state);
      default:
        return const SizedBox.shrink();
    }
  }

  /// Step 1: Goal Selection (Choose Mode)
  Widget _buildStep1GoalSelection(OnboardingState state) {
    return Column(
      key: const ValueKey<int>(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ChooseModeHero(),
        ModeSelectionCard(
          mode: AppMode.cycleAwareness,
          isSelected: state.selectedMode == AppMode.cycleAwareness,
          onSelect: () => _controller.selectMode(AppMode.cycleAwareness),
        ),
        const SizedBox(height: 12.0),
        ModeSelectionCard(
          mode: AppMode.tryingToConceive,
          isSelected: state.selectedMode == AppMode.tryingToConceive,
          onSelect: () => _controller.selectMode(AppMode.tryingToConceive),
        ),
        const SizedBox(height: 14.0),
        const ChooseModeTrustRow(),
        const SizedBox(height: 12.0),
      ],
    );
  }

  /// Step 2: Last Period Start Date
  Widget _buildStep2LastPeriodDate(OnboardingState state) {
    return Column(
      key: const ValueKey<int>(2),
      children: [
        const SizedBox(height: 6.0),
        OnboardingCalendarPicker(
          selectedDate: state.lastPeriodStartDate,
          maxDate: DateTime.now(),
          onDateSelected: _controller.setLastPeriodStartDate,
          onNotSureTap: _openIrregularCycleSheet,
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  /// Step 3: Average Cycle Length
  Widget _buildStep3CycleLength(OnboardingState state) {
    final cycleLength = state.averageCycleLength ?? 28;

    return Column(
      key: const ValueKey<int>(3),
      children: [
        const SizedBox(height: 8.0),
        OnboardingNumberStepper(
          value: cycleLength,
          min: 18,
          max: 60,
          unit: 'days',
          helperText: '21 – 35 days',
          decreaseSemanticLabel: 'Decrease cycle length',
          increaseSemanticLabel: 'Increase cycle length',
          onChanged: _controller.setAverageCycleLength,
        ),
        const SizedBox(height: 22.0),
        const Step3WhyItMattersCard(),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  /// Step 4: Typical Period Duration
  Widget _buildStep4PeriodDuration(OnboardingState state) {
    final periodDuration = state.typicalPeriodDuration ?? 5;

    return Column(
      key: const ValueKey<int>(4),
      children: [
        const SizedBox(height: 8.0),
        OnboardingNumberStepper(
          topIcon: Icons.calendar_month_rounded,
          value: periodDuration,
          min: 2,
          max: 14,
          unit: 'days',
          helperText: '2 – 10 days',
          decreaseSemanticLabel: 'Decrease period duration',
          increaseSemanticLabel: 'Increase period duration',
          onChanged: _controller.setTypicalPeriodDuration,
        ),
        const SizedBox(height: 22.0),
        const Step3WhyItMattersCard(
          title: 'Why it matters',
          description:
              'Knowing your average period duration helps us predict your next period and prepare better insights for you.',
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  /// Step 5: Mode-specific Questions
  Widget _buildStep5PersonalizedQuestions(OnboardingState state) {
    final isTtc = state.selectedMode == AppMode.tryingToConceive;

    if (isTtc) {
      return Column(
        key: const ValueKey<String>('step5_ttc'),
        children: [
          const SizedBox(height: AppSpacing.xs),
          ..._ttcOptions.map((option) {
            final isSelected = state.tryingToConceiveDuration == option;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: PersonalizedSingleSelectCard(
                title: option,
                isSelected: isSelected,
                onSelect: () =>
                    _controller.setTtcDuration(option),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.lg),
        ],
      );
    } else {
      return Column(
        key: const ValueKey<String>('step5_cycle_awareness'),
        children: [
          const SizedBox(height: AppSpacing.xs),
          ..._cycleGoalOptions.map((goal) {
            final isSelected = state.cycleAwarenessGoals.contains(goal.title);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: PersonalizedMultiSelectCard(
                title: goal.title,
                subtitle: goal.subtitle,
                icon: goal.icon,
                isSelected: isSelected,
                onToggle: () =>
                    _controller.toggleCycleAwarenessGoal(goal.title),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.lg),
        ],
      );
    }
  }
}

class _HeaderInfo {
  final String title;
  final String subtitle;
  final String? questionText;
  final String? helperText;
  final IconData? iconBadge;

  const _HeaderInfo({
    required this.title,
    required this.subtitle,
    this.questionText,
    this.helperText,
    this.iconBadge,
  });
}

class _CycleGoalOption {
  final String title;
  final String subtitle;
  final IconData icon;

  const _CycleGoalOption({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
