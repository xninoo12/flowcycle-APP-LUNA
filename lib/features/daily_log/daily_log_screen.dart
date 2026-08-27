import 'package:flutter/material.dart';
import '../../core/data/app_data_manager.dart';
import '../../shared/models/app_mode.dart';
import '../../shared/models/daily_log_entry.dart';
import '../../shared/providers/app_scope.dart';
import 'widgets/all_set_success_dialog.dart';
import 'widgets/bbt_temperature_field.dart';
import 'widgets/cervical_mucus_selector.dart';
import 'widgets/flow_intensity_selector.dart';
import 'widgets/intimacy_section.dart';
import 'widgets/lh_and_pregnancy_test_section.dart';
import 'widgets/log_date_field.dart';
import 'widgets/log_insights_analysis_sheet.dart';
import 'widgets/log_modal_header.dart';
import 'widgets/mood_selector_row.dart';
import 'widgets/nutrition_and_cravings_section.dart';
import 'widgets/self_care_section.dart';
import 'widgets/sleep_and_energy_section.dart';
import 'widgets/symptom_glossary_sheet.dart';
import 'widgets/symptoms_chips_selector.dart';
import 'widgets/workout_chips_selector.dart';

/// Primary Daily Log Modal / Screen matching exact specifications from design reference.
///
/// Features a Dual-Mode Adaptive architecture that dynamically tailors its clinical
/// logging sections, biomarkers, and AI feedback to either Trying to Conceive (TTC)
/// or Cycle Awareness mode.
class DailyLogScreen extends StatefulWidget {
  final bool isModal;
  final VoidCallback? onClose;
  final DateTime? initialDate;

  const DailyLogScreen({
    super.key,
    this.isModal = false,
    this.onClose,
    this.initialDate,
  });

  @override
  State<DailyLogScreen> createState() => _DailyLogScreenState();
}

class _DailyLogScreenState extends State<DailyLogScreen> {
  late DateTime _selectedDate;
  MoodState _selectedMood = MoodState.good;
  FlowLevel _selectedFlow = FlowLevel.light;
  final Set<String> _selectedSymptoms = {'Cramps', 'Fatigue'};
  int _sleepRating = 4;
  EnergyLevel _energyLevel = EnergyLevel.medium;

  // TTC Biomarkers
  String _selectedMucus = 'Egg-white';
  double? _bbtTemperature = 97.8;
  String _lhResult = 'Peak Surge ➕';
  String _hcgResult = 'Not Tested';
  String _intimacyStatus = 'Unprotected (Trying) 💕';
  final Set<String> _selectedSupplements = {'Prenatal Vitamin', 'CoQ10'};

  // Cycle Awareness Biomarkers
  String _selectedWorkout = 'Yoga / Stretch';
  int _waterGlasses = 7;
  final Set<String> _selectedCravings = {'Chocolate / Sweets 🍫'};
  final Set<String> _selectedSelfCare = {'Meditation / Breathwork 🧘'};

  // Notes
  final TextEditingController _notesController = TextEditingController();

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime(2025, 5, 24);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _loadExistingLog();
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _loadExistingLog() {
    final controller = AppScope.of(context);
    final existingLog = controller.getLogForDate(_selectedDate);
    if (existingLog != null) {
      setState(() {
        _selectedMood = _parseMood(existingLog.mood);
        _selectedFlow = _parseFlow(existingLog.flow);
        _selectedSymptoms.clear();
        _selectedSymptoms.addAll(existingLog.symptoms);
        _sleepRating = existingLog.sleepRating;
        _energyLevel = _parseEnergy(existingLog.energyLevel);

        _selectedMucus = existingLog.cervicalMucus.isNotEmpty
            ? existingLog.cervicalMucus
            : 'None';
        _bbtTemperature = existingLog.bbtTemperature ?? 97.8;
        _lhResult = existingLog.lhTestResult;
        _hcgResult = existingLog.hcgTestResult;
        _intimacyStatus = existingLog.intimacyStatus;
        _selectedSupplements.clear();
        _selectedSupplements.addAll(existingLog.supplements);

        _selectedWorkout = existingLog.workoutType;
        _waterGlasses = existingLog.waterGlasses;
        _selectedCravings.clear();
        _selectedCravings.addAll(existingLog.cravings);
        _selectedSelfCare.clear();
        _selectedSelfCare.addAll(existingLog.selfCare);
        _notesController.text = existingLog.notes;
      });
    }
  }

  MoodState _parseMood(String mood) {
    switch (mood.toLowerCase()) {
      case 'great':
        return MoodState.great;
      case 'good':
        return MoodState.good;
      case 'okay':
        return MoodState.okay;
      case 'low':
        return MoodState.low;
      case 'awful':
        return MoodState.awful;
      default:
        return MoodState.good;
    }
  }

  FlowLevel _parseFlow(String flow) {
    switch (flow.toLowerCase()) {
      case 'none':
        return FlowLevel.none;
      case 'spotting':
        return FlowLevel.spotting;
      case 'light':
        return FlowLevel.light;
      case 'medium':
        return FlowLevel.medium;
      case 'heavy':
        return FlowLevel.heavy;
      default:
        return FlowLevel.light;
    }
  }

  EnergyLevel _parseEnergy(String energy) {
    switch (energy.toLowerCase()) {
      case 'low':
        return EnergyLevel.low;
      case 'medium':
        return EnergyLevel.medium;
      case 'high':
        return EnergyLevel.high;
      default:
        return EnergyLevel.medium;
    }
  }

  void _toggleSymptom(String symptom) {
    setState(() {
      if (_selectedSymptoms.contains(symptom)) {
        _selectedSymptoms.remove(symptom);
      } else {
        _selectedSymptoms.add(symptom);
      }
    });
  }

  void _openGlossarySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const SymptomGlossarySheet(),
    );
  }

  void _openAiAnalysisSheet(DailyLogEntry logEntry, AppMode mode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => LogInsightsAnalysisSheet(entry: logEntry, mode: mode),
    );
  }

  String _formatDateString(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final monthName = months[date.month - 1];
    return '$monthName ${date.day}, ${date.year}';
  }

  void _handleSaveLog() {
    String moodSummary = 'Good';
    switch (_selectedMood) {
      case MoodState.great:
        moodSummary = 'Great';
        break;
      case MoodState.good:
        moodSummary = 'Good';
        break;
      case MoodState.okay:
        moodSummary = 'Okay';
        break;
      case MoodState.low:
        moodSummary = 'Low';
        break;
      case MoodState.awful:
        moodSummary = 'Awful';
        break;
    }

    String flowSummary = 'Light';
    switch (_selectedFlow) {
      case FlowLevel.none:
        flowSummary = 'None';
        break;
      case FlowLevel.spotting:
        flowSummary = 'Spotting';
        break;
      case FlowLevel.light:
        flowSummary = 'Light';
        break;
      case FlowLevel.medium:
        flowSummary = 'Medium';
        break;
      case FlowLevel.heavy:
        flowSummary = 'Heavy';
        break;
    }

    String energySummary = 'Medium';
    switch (_energyLevel) {
      case EnergyLevel.low:
        energySummary = 'Low';
        break;
      case EnergyLevel.medium:
        energySummary = 'Medium';
        break;
      case EnergyLevel.high:
        energySummary = 'High';
        break;
    }

    final controller = AppScope.of(context);
    final isTtc = controller.currentMode == AppMode.tryingToConceive;

    final logEntry = DailyLogEntry(
      date: _selectedDate,
      mood: moodSummary,
      flow: flowSummary,
      symptoms: _selectedSymptoms.toList(),
      sleepRating: _sleepRating,
      sleepDuration: '7h 30m',
      energyLevel: energySummary,
      intercourse: isTtc
          ? _intimacyStatus.contains('Unprotected') ||
                _intimacyStatus.contains('Protected')
          : flowSummary != 'Heavy',
      cervicalMucus: _selectedMucus,
      bbtTemperature: _bbtTemperature,
      lhTestResult: _lhResult,
      hcgTestResult: _hcgResult,
      intimacyStatus: _intimacyStatus,
      supplements: _selectedSupplements.toList(),
      workoutType: _selectedWorkout,
      waterGlasses: _waterGlasses,
      cravings: _selectedCravings.toList(),
      selfCare: _selectedSelfCare.toList(),
      notes: _notesController.text.trim(),
    );

    controller.saveLogEntry(logEntry);
    AppDataManager.instance.handleDailyLogEntry(logEntry);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AllSetSuccessDialog(
        moodText: moodSummary,
        flowText: flowSummary,
        sleepText: '7h 30m',
        energyText: energySummary,
        onViewLog: () {
          Navigator.of(ctx).pop();
          _openAiAnalysisSheet(logEntry, controller.currentMode);
        },
        onDone: () => Navigator.of(ctx).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final isTtc = controller.currentMode == AppMode.tryingToConceive;
    final dateString = _formatDateString(_selectedDate);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
          children: [
            // Top Modal Header with drag handle, title, guide icon, and close button
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 8.0),
              child: Row(
                children: [
                  Expanded(child: LogModalHeader(onClose: widget.onClose)),
                  IconButton(
                    icon: const Icon(
                      Icons.menu_book_outlined,
                      color: Color(0xFF7C5CE7),
                      size: 20,
                    ),
                    tooltip: 'Symptom & Mucus Guide',
                    onPressed: _openGlossarySheet,
                  ),
                ],
              ),
            ),

            const Divider(height: 1.0, color: Color(0xFFF2EDF7)),

            // Single-Scroll Compact Body
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mode-Adaptive Hero Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isTtc
                              ? [
                                  const Color(0xFFFFF0F5),
                                  const Color(0xFFFDE8EF),
                                ]
                              : [
                                  const Color(0xFFF5F3FF),
                                  const Color(0xFFECEBFE),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isTtc
                              ? const Color(0xFFFBCFE8)
                              : const Color(0xFFDDD6FE),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            isTtc ? '💗' : '✨',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              isTtc
                                  ? 'Trying to Conceive Mode • Peak Fertile Tracking'
                                  : 'Cycle Awareness Mode • Daily Energy & Syncing',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: isTtc
                                    ? const Color(0xFF9D174D)
                                    : const Color(0xFF5B21B6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14.0),

                    // 1. Date Field
                    LogDateField(
                      dateText: dateString,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedDate = picked;
                            _loadExistingLog();
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 14.0),

                    // 2. How are you feeling? (Mood)
                    MoodSelectorRow(
                      selectedMood: _selectedMood,
                      onMoodChanged: (mood) =>
                          setState(() => _selectedMood = mood),
                    ),

                    const SizedBox(height: 14.0),

                    // 3. Flow Intensity
                    FlowIntensitySelector(
                      selectedFlow: _selectedFlow,
                      onFlowChanged: (flow) =>
                          setState(() => _selectedFlow = flow),
                    ),

                    const SizedBox(height: 14.0),

                    // 4. Mode-Specific Logging Fields
                    if (isTtc) ...[
                      // TTC: Cervical Mucus Selector
                      CervicalMucusSelector(
                        selectedMucus: _selectedMucus,
                        onMucusChanged: (val) =>
                            setState(() => _selectedMucus = val),
                        onInfoTap: _openGlossarySheet,
                      ),

                      const SizedBox(height: 14.0),

                      // TTC: Basal Body Temperature (BBT)
                      BbtTemperatureField(
                        temperature: _bbtTemperature,
                        onTemperatureChanged: (val) =>
                            setState(() => _bbtTemperature = val),
                      ),

                      const SizedBox(height: 14.0),

                      // TTC: LH & HCG Strip Tests
                      LhAndPregnancyTestSection(
                        lhResult: _lhResult,
                        hcgResult: _hcgResult,
                        onLhChanged: (val) => setState(() => _lhResult = val),
                        onHcgChanged: (val) => setState(() => _hcgResult = val),
                      ),

                      const SizedBox(height: 14.0),

                      // TTC: Intimacy & Supplements
                      IntimacySection(
                        intimacyStatus: _intimacyStatus,
                        selectedSupplements: _selectedSupplements,
                        onIntimacyChanged: (val) =>
                            setState(() => _intimacyStatus = val),
                        onToggleSupplement: (sup) {
                          setState(() {
                            if (_selectedSupplements.contains(sup)) {
                              _selectedSupplements.remove(sup);
                            } else {
                              _selectedSupplements.add(sup);
                            }
                          });
                        },
                      ),
                    ] else ...[
                      // Cycle Awareness: Workouts
                      WorkoutChipsSelector(
                        selectedWorkout: _selectedWorkout,
                        onWorkoutChanged: (val) =>
                            setState(() => _selectedWorkout = val),
                      ),

                      const SizedBox(height: 14.0),

                      // Cycle Awareness: Hydration & Cravings
                      NutritionAndCravingsSection(
                        waterGlasses: _waterGlasses,
                        selectedCravings: _selectedCravings,
                        onWaterChanged: (val) =>
                            setState(() => _waterGlasses = val),
                        onToggleCraving: (crav) {
                          setState(() {
                            if (_selectedCravings.contains(crav)) {
                              _selectedCravings.remove(crav);
                            } else {
                              _selectedCravings.add(crav);
                            }
                          });
                        },
                      ),

                      const SizedBox(height: 14.0),

                      // Cycle Awareness: Self-Care
                      SelfCareSection(
                        selectedSelfCare: _selectedSelfCare,
                        onToggleSelfCare: (item) {
                          setState(() {
                            if (_selectedSelfCare.contains(item)) {
                              _selectedSelfCare.remove(item);
                            } else {
                              _selectedSelfCare.add(item);
                            }
                          });
                        },
                      ),
                    ],

                    const SizedBox(height: 14.0),

                    // 5. Symptoms Multi-select (Both modes)
                    SymptomsChipsSelector(
                      selectedSymptoms: _selectedSymptoms,
                      onToggleSymptom: _toggleSymptom,
                      onAddCustomSymptom: (newSym) {
                        setState(() => _selectedSymptoms.add(newSym));
                      },
                    ),

                    const SizedBox(height: 14.0),

                    // 6. Sleep Quality & Energy Level
                    SleepAndEnergySection(
                      sleepRating: _sleepRating,
                      sleepDurationText: '7h 30m',
                      energyLevel: _energyLevel,
                      onSleepRatingChanged: (rating) =>
                          setState(() => _sleepRating = rating),
                      onEnergyLevelChanged: (level) =>
                          setState(() => _energyLevel = level),
                    ),

                    const SizedBox(height: 14.0),

                    // 7. Personal Journal Notes
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text('📝', style: TextStyle(fontSize: 14)),
                            SizedBox(width: 6),
                            Text(
                              'Personal Notes & Reflections',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E1A3C),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _notesController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText:
                                'Add symptoms, sensations, doctor notes...',
                            hintStyle: const TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFFAAA3B8),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFFAF8FC),
                            contentPadding: const EdgeInsets.all(12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFEFE9F3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFEFE9F3),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20.0),

                    // 8. "Save Log" Button
                    SizedBox(
                      width: double.infinity,
                      height: 46.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9D84EB), Color(0xFF7C5CE7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14.0),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF7C5CE7,
                              ).withValues(alpha: 0.35),
                              blurRadius: 10.0,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _handleSaveLog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                          ),
                          child: const Text(
                            'Save Log',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
