import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/route_names.dart';
import '../../../core/services/ai_service.dart';
import '../../../shared/models/app_mode.dart';
import '../../../shared/models/daily_log_entry.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/providers/app_scope.dart';

/// Interactive AI Cycle Harmony & Wellness Analysis View shown immediately upon saving a daily log.
///
/// Provides instant clinical synthesis of the user's logged symptoms, mood, and biomarkers
/// powered by the Groq AI Engine, accompanied by phase-smart dynamic rerouting navigation.
class AiCycleHarmonyPostLogView extends StatefulWidget {
  final DailyLogEntry logEntry;
  final VoidCallback? onClose;

  const AiCycleHarmonyPostLogView({
    super.key,
    required this.logEntry,
    this.onClose,
  });

  @override
  State<AiCycleHarmonyPostLogView> createState() =>
      _AiCycleHarmonyPostLogViewState();
}

class _AiCycleHarmonyPostLogViewState extends State<AiCycleHarmonyPostLogView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  String? _aiAnalysisText;
  bool _isLoadingAi = true;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _animController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateAiHarmonyAnalysis();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _generateAiHarmonyAnalysis() async {
    final controller = AppScope.of(context);
    final profile = controller.userProfile;
    final cycleDay = controller.currentCycleDay;
    final phaseName = controller.currentPhaseName;

    try {
      final prompt =
          'Please synthesize my logged data for today (Mood: ${widget.logEntry.mood}, Flow: ${widget.logEntry.flow}, Symptoms: ${widget.logEntry.symptoms.join(", ")}, Notes: "${widget.logEntry.notes}"). Provide concise, structured cycle harmony & wellness takeaways for Day $cycleDay ($phaseName).';

      final response = await AiService.instance.generateAiResponse(
        userPrompt: prompt,
        userProfile: profile,
        cycleDay: cycleDay,
        phaseName: phaseName,
        todayLog: widget.logEntry,
      );

      if (mounted) {
        setState(() {
          _aiAnalysisText = response;
          _isLoadingAi = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoadingAi = false;
        });
      }
    }
  }

  void _navigateTo(String routeName) {
    if (widget.onClose != null) {
      widget.onClose!();
    }
    try {
      context.goNamed(routeName);
    } catch (_) {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final userProfile = controller.userProfile;
    final isTtc = controller.currentMode == AppMode.tryingToConceive;
    final cycleDay = controller.currentCycleDay;
    final phaseName = controller.currentPhaseName;

    final isOvulatory = phaseName.toLowerCase().contains('ovulat') ||
        phaseName.toLowerCase().contains('fertile') ||
        (cycleDay >= 12 && cycleDay <= 16);
    final isMenstrualOrLutealPain =
        widget.logEntry.symptoms.any((s) =>
            s.toLowerCase().contains('cramp') ||
            s.toLowerCase().contains('pain') ||
            s.toLowerCase().contains('headache') ||
            s.toLowerCase().contains('fatigue')) ||
        phaseName.toLowerCase().contains('menstrual');

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFAF7F2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Drag Handle
              Container(
                width: 42.0,
                height: 4.5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2DCE8),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),

              const SizedBox(height: 16.0),

              // 1. Celebratory Animated Icon Badge
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 72.0,
                  height: 72.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B8B), Color(0xFF8B5CF6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B8B).withValues(alpha: 0.35),
                        blurRadius: 18.0,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 38.0,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12.0),

              // Title & User Affirmation
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Text(
                      'Log Recorded, ${userProfile.name}! ✨',
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 22.0,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1A3C),
                        letterSpacing: -0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14.0,
                        vertical: 5.0,
                      ),
                      decoration: BoxDecoration(
                        color: isTtc
                            ? const Color(0xFFFFF0F5)
                            : const Color(0xFFF3EDFA),
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: isTtc
                              ? const Color(0xFFFFD4E2)
                              : const Color(0xFFE5DBFF),
                        ),
                      ),
                      child: Text(
                        'Day $cycleDay • $phaseName',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w800,
                          color: isTtc
                              ? const Color(0xFFE11D48)
                              : const Color(0xFF7C5CE7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18.0),

              // 2. Today's Logged Summary Grid Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: const Color(0xFFF1ECF5),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E1A3C).withValues(alpha: 0.04),
                      blurRadius: 10.0,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text('📋', style: TextStyle(fontSize: 14.0)),
                        SizedBox(width: 6.0),
                        Text(
                          "TODAY'S LOG SNAPSHOT",
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: Color(0xFF7A708A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        _buildSnapshotChip(
                          icon: Icons.sentiment_satisfied_alt_rounded,
                          label: 'Mood: ${widget.logEntry.mood}',
                          color: const Color(0xFFF59E0B),
                        ),
                        _buildSnapshotChip(
                          icon: Icons.water_drop_rounded,
                          label: 'Flow: ${widget.logEntry.flow}',
                          color: const Color(0xFFE11D48),
                        ),
                        if (widget.logEntry.symptoms.isNotEmpty)
                          _buildSnapshotChip(
                            icon: Icons.healing_rounded,
                            label: widget.logEntry.symptoms.take(2).join(', ') +
                                (widget.logEntry.symptoms.length > 2
                                    ? ' +${widget.logEntry.symptoms.length - 2}'
                                    : ''),
                            color: const Color(0xFF8B5CF6),
                          ),
                        if (isTtc && widget.logEntry.bbtTemperature != null)
                          _buildSnapshotChip(
                            icon: Icons.thermostat_rounded,
                            label: '${widget.logEntry.bbtTemperature}°F',
                            color: const Color(0xFFEC4899),
                          ),
                        if (isTtc && widget.logEntry.cervicalMucus != 'None')
                          _buildSnapshotChip(
                            icon: Icons.water_rounded,
                            label: widget.logEntry.cervicalMucus,
                            color: const Color(0xFF06B6D4),
                          ),
                        if (!isTtc && widget.logEntry.workoutType != 'None')
                          _buildSnapshotChip(
                            icon: Icons.directions_run_rounded,
                            label: widget.logEntry.workoutType,
                            color: const Color(0xFF3B82F6),
                          ),
                        if (!isTtc && widget.logEntry.waterGlasses > 0)
                          _buildSnapshotChip(
                            icon: Icons.local_drink_rounded,
                            label: '${widget.logEntry.waterGlasses} glasses',
                            color: const Color(0xFF0EA5E9),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16.0),

              // 3. AI Cycle Harmony & Wellness Analysis Card (Powered by Groq)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF9FA), Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22.0),
                  border: Border.all(
                    color: const Color(0xFFFFD4E2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF4D79).withValues(alpha: 0.06),
                      blurRadius: 14.0,
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
                          padding: const EdgeInsets.all(6.0),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFFFF6B8B)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.white,
                            size: 14.0,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI Cycle Harmony & Wellness Analysis',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E1A3C),
                                ),
                              ),
                              Text(
                                'Personalized clinical hormone synthesis',
                                style: TextStyle(
                                  fontSize: 11.0,
                                  color: Color(0xFF7A708A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14.0),
                    const Divider(height: 1.0, color: Color(0xFFF6EEF2)),
                    const SizedBox(height: 14.0),
                    if (_isLoadingAi)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: Row(
                          children: const [
                            SizedBox(
                              width: 18.0,
                              height: 18.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFFF4D79),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.0),
                            Expanded(
                              child: Text(
                                'Luna is synthesizing your cycle hormones and symptoms...',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Color(0xFF7A708A),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Text(
                        _aiAnalysisText ??
                            'Your body is harmonizing gracefully on Day $cycleDay of your $phaseName. Stay hydrated and prioritize restorative rest!',
                        style: const TextStyle(
                          fontSize: 12.5,
                          height: 1.45,
                          color: Color(0xFF3B334A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20.0),

              // 4. Phase-Smart Reroute Destinations Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      'SMART NEXT ACTIONS',
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: Color(0xFF7A708A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  // Smart Button 1: Phase-Specific Primary
                  if (isOvulatory)
                    _buildRerouteButton(
                      title: 'View Fertile Window on Calendar 🗓️',
                      subtitle:
                          'Track ovulation peak & conception probability',
                      gradient: const [Color(0xFFFF4D79), Color(0xFFFF7597)],
                      onTap: () => _navigateTo(AppRoutes.calendar),
                    )
                  else if (isMenstrualOrLutealPain)
                    _buildRerouteButton(
                      title: 'Ask Luna AI for Comfort & Relief ✨',
                      subtitle:
                          'Get cycle-synced nutrition & pain relief advice',
                      gradient: const [Color(0xFF8B5CF6), Color(0xFF7C5CE7)],
                      onTap: () => _navigateTo(AppRoutes.aiCompanion),
                    )
                  else
                    _buildRerouteButton(
                      title: 'Explore Cycle Trends in Insights 📊',
                      subtitle: 'Review symptom patterns & hormone variations',
                      gradient: const [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                      onTap: () => _navigateTo(AppRoutes.insights),
                    ),

                  const SizedBox(height: 8.0),

                  // Smart Button 2: Secondary Return to Dashboard
                  SizedBox(
                    width: double.infinity,
                    height: 48.0,
                    child: OutlinedButton(
                      onPressed: () => _navigateTo(AppRoutes.home),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1E1A3C),
                        side: const BorderSide(
                          color: Color(0xFFE5DBFF),
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home_rounded, size: 18.0),
                          SizedBox(width: 8.0),
                          Text(
                            'Return to Dashboard',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSnapshotChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: color.withValues(alpha: 0.22),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.0, color: color),
          const SizedBox(width: 5.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRerouteButton({
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withValues(alpha: 0.3),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
