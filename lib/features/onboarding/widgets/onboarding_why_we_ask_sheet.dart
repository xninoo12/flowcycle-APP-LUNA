import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';

/// Educational sheet explaining medical rationale and privacy for each onboarding step.
class OnboardingWhyWeAskSheet extends StatelessWidget {
  final int step;

  const OnboardingWhyWeAskSheet({super.key, required this.step});

  Map<String, String> _getStepContent() {
    switch (step) {
      case 1:
        return {
          'icon': '🎯',
          'title': 'Why Choose a Primary Goal?',
          'rationale':
              'FlowCycle uses different mathematical algorithms for Cycle Awareness vs Trying to Conceive. Setting your goal activates dedicated fertility predictors, biomarker trackers, or cycle-syncing insights tailored specifically to you.',
          'medicalFact':
              'Clinical studies show that mode-specific tracking improves prediction accuracy by over 34% compared to generic trackers.',
        };
      case 2:
        return {
          'icon': '🩸',
          'title': 'Why Last Period Start Date?',
          'rationale':
              'Your Last Menstrual Period (LMP) is Day 1 of your current cycle. Gynecologists and reproductive endocrinologists use this date as the foundational anchor to calculate your current cycle day and project your ovulation window.',
          'medicalFact':
              'Even an estimated date gives our algorithms enough baseline data to start mapping your hormonal phases.',
        };
      case 3:
        return {
          'icon': '🗓️',
          'title': 'Why Average Cycle Length?',
          'rationale':
              'The standard cycle is 28 days, but healthy human cycles range between 21 and 35 days. The follicular phase varies person to person, so your average cycle length allows FlowCycle to pinpoint your estimated ovulation day (typically 14 days before your next period).',
          'medicalFact':
              'As you log future cycles, FlowCycle automatically adjusts this average dynamically with rolling weighted averages.',
        };
      case 4:
        return {
          'icon': '⏳',
          'title': 'Why Period Duration?',
          'rationale':
              'Knowing how many days your menstrual bleeding typically lasts (usually 3 to 7 days) allows FlowCycle to forecast when endometrial shedding finishes and your high-energy follicular phase begins.',
          'medicalFact':
              'Period duration helps distinguish normal flow from early follicular spotting.',
        };
      case 5:
      default:
        return {
          'icon': '✨',
          'title': 'Why Personalized Questions?',
          'rationale':
              'Your goals and fertility history allow our AI Companion to provide phase-specific recommendations on workouts, nutrition, supplements, and intercourse timing that match your unique lifestyle.',
          'medicalFact':
              'Personalized tracking provides greater proactive wellness insights compared to one-size-fits-all advice.',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = _getStepContent();

    return Container(
      height: MediaQuery.of(context).size.height * 0.72,
      decoration: const BoxDecoration(
        color: Color(0xFFFAF8FC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 14, 8),
            child: Row(
              children: [
                Text(content['icon']!, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    content['title']!,
                    style: AppTextStyles.subtitle.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1E1A3C),
                      fontSize: 14.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFF7A708A),
                    size: 22,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFEFE9F3)),

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rationale Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.medium,
                      border: Border.all(color: const Color(0xFFEFE9F3)),
                      boxShadow: AppShadows.card,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'HOW WE USE THIS INFORMATION',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF7C5CE7),
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          content['rationale']!,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF1E1A3C),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Medical Insight Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EDFA),
                      borderRadius: AppRadius.medium,
                      border: Border.all(color: const Color(0xFFDDD6FE)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('💡', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            content['medicalFact']!,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF5B21B6),
                              fontWeight: FontWeight.w600,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Privacy Assurance
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.medium,
                      border: Border.all(color: const Color(0xFFEFE9F3)),
                      boxShadow: AppShadows.card,
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: Color(0xFF10B981),
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Your health data is encrypted on your device and never sold or shared with third parties.',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF4A4259),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Got it button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C5CE7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Got it, thanks!',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
