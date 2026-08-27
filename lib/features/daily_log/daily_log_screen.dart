import 'package:flutter/material.dart';
import '../../core/data/app_data_manager.dart';
import '../../shared/models/app_mode.dart';
import '../../shared/models/daily_log_entry.dart';
import '../../shared/providers/app_scope.dart';
import 'widgets/ai_cycle_harmony_post_log_view.dart';
import 'widgets/bbt_temperature_field.dart';
import 'widgets/cervical_mucus_selector.dart';
import 'widgets/flow_intensity_selector.dart';
import 'widgets/intimacy_section.dart';
import 'widgets/lh_and_pregnancy_test_section.dart';
import 'widgets/mood_selector_row.dart';
import 'widgets/nutrition_and_cravings_section.dart';
import 'widgets/self_care_section.dart';
import 'widgets/sleep_and_energy_section.dart';
import 'widgets/symptom_glossary_sheet.dart';
import 'widgets/symptoms_chips_selector.dart';
import 'widgets/workout_chips_selector.dart';

/// Primary Daily Log Screen matching the exact reference UI specifications.
///
/// Features a Dual-Mode Adaptive architecture across Cycle Awareness and TTC modes,
/// color-coded grouped sections (TODAY, BODY, LIFESTYLE, NOTES), and an automated
/// AI Cycle Harmony & Wellness Analysis post-save workflow with phase-smart rerouting.
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
  DailyLogEntry? _savedLogEntry;

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

    // Automatically transition to the AI Cycle Harmony & Wellness Analysis Screen
    setState(() {
      _savedLogEntry = logEntry;
    });
  }

  String _formatDateString(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final isTtc = controller.currentMode == AppMode.tryingToConceive;
    final dateString = _formatDateString(_selectedDate);

    // If log has been saved, display the Automated AI Cycle Harmony & Wellness Analysis View
    if (_savedLogEntry != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAF7F2),
        body: SafeArea(
          child: AiCycleHarmonyPostLogView(
            logEntry: _savedLogEntry!,
            onClose: widget.onClose,
          ),
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // 1. Top Header: (X) Close, ✨ Log Your Day ✨, (📖) Guide Book
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF7A708A),
                        size: 22.0,
                      ),
                      onPressed: widget.onClose ??
                          () => Navigator.of(context).maybePop(),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('✨', style: TextStyle(fontSize: 14.0)),
                              SizedBox(width: 4.0),
                              Flexible(
                                child: Text(
                                  'Log Your Day',
                                  style: TextStyle(
                                    fontFamily: 'serif',
                                    fontSize: 21.0,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF1E1A3C),
                                    letterSpacing: -0.4,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 4.0),
                              Text('✨', style: TextStyle(fontSize: 14.0)),
                            ],
                          ),
                          SizedBox(height: 2.0),
                          Text(
                            'Track how you feel and care for your body',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF7A708A),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.menu_book_rounded,
                        color: Color(0xFFFF4D79),
                        size: 22.0,
                      ),
                      tooltip: 'Symptom & Mucus Guide',
                      onPressed: _openGlossarySheet,
                    ),
                  ],
                ),
              ),

              const Divider(height: 1.0, color: Color(0xFFF1ECF5)),

              // 2. Scrollable Body with Grouped Sections
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mode Banner Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 12.0,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isTtc
                                ? [
                                    const Color(0xFFFFF0F5),
                                    const Color(0xFFFFEEF3)
                                  ]
                                : [
                                    const Color(0xFFFDF2F8),
                                    const Color(0xFFFAF5FF)
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: isTtc
                                ? const Color(0xFFFFD4E2)
                                : const Color(0xFFF1D5EA),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38.0,
                              height: 38.0,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isTtc
                                      ? [
                                          const Color(0xFFFF4D79),
                                          const Color(0xFFFF85A2)
                                        ]
                                      : [
                                          const Color(0xFFD946EF),
                                          const Color(0xFF8B5CF6)
                                        ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  isTtc ? '👶' : '✨',
                                  style: const TextStyle(fontSize: 18.0),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isTtc
                                        ? 'Trying to Conceive Mode'
                                        : 'Cycle Awareness Mode',
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w800,
                                      color: isTtc
                                          ? const Color(0xFFE11D48)
                                          : const Color(0xFFD946EF),
                                    ),
                                  ),
                                  Text(
                                    isTtc
                                        ? 'Fertility & Biomarkers'
                                        : 'Daily Energy & Syncing',
                                    style: const TextStyle(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF7A708A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: _openGlossarySheet,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Learn more',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: isTtc
                                          ? const Color(0xFFE11D48)
                                          : const Color(0xFFD946EF),
                                    ),
                                  ),
                                  const SizedBox(width: 2.0),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 11.0,
                                    color: isTtc
                                        ? const Color(0xFFE11D48)
                                        : const Color(0xFFD946EF),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12.0),

                      // Date Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 12.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: const Color(0xFFF1ECF5),
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1E1A3C)
                                  .withValues(alpha: 0.03),
                              blurRadius: 8.0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF0F5),
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: const Color(0xFFFFD4E2),
                                ),
                              ),
                              child: const Icon(
                                Icons.calendar_today_rounded,
                                color: Color(0xFFFF4D79),
                                size: 18.0,
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Date',
                                    style: TextStyle(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF7A708A),
                                    ),
                                  ),
                                  Text(
                                    dateString,
                                    style: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1E1A3C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.calendar_month_outlined,
                                color: Color(0xFF7A708A),
                                size: 22.0,
                              ),
                              onPressed: () async {
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
                          ],
                        ),
                      ),

                      const SizedBox(height: 18.0),

                      // ==========================================
                      // 1. TODAY SECTION (Coral / Pink)
                      // ==========================================
                      _buildSectionDivider('TODAY', const Color(0xFFFF3B69)),
                      const SizedBox(height: 12.0),

                      // Feeling Emojis Row
                      MoodSelectorRow(
                        selectedMood: _selectedMood,
                        onMoodChanged: (mood) =>
                            setState(() => _selectedMood = mood),
                      ),

                      const SizedBox(height: 14.0),

                      // Flow Drops Row
                      FlowIntensitySelector(
                        selectedFlow: _selectedFlow,
                        onFlowChanged: (flow) =>
                            setState(() => _selectedFlow = flow),
                      ),

                      const SizedBox(height: 18.0),

                      // ==========================================
                      // 2. BODY SECTION (Purple)
                      // ==========================================
                      _buildSectionDivider('BODY', const Color(0xFF8B5CF6)),
                      const SizedBox(height: 12.0),

                      // Symptoms Chips
                      SymptomsChipsSelector(
                        selectedSymptoms: _selectedSymptoms,
                        onToggleSymptom: _toggleSymptom,
                        onAddCustomSymptom: (newSym) {
                          setState(() => _selectedSymptoms.add(newSym));
                        },
                      ),

                      if (isTtc) ...[
                        const SizedBox(height: 14.0),

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

                        // TTC: LH & HCG Tests
                        LhAndPregnancyTestSection(
                          lhResult: _lhResult,
                          hcgResult: _hcgResult,
                          onLhChanged: (val) => setState(() => _lhResult = val),
                          onHcgChanged: (val) => setState(() => _hcgResult = val),
                        ),

                        const SizedBox(height: 14.0),

                        // TTC: Intimacy
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
                      ],

                      const SizedBox(height: 18.0),

                      // ==========================================
                      // 3. LIFESTYLE SECTION (Blue)
                      // ==========================================
                      _buildSectionDivider('LIFESTYLE', const Color(0xFF3B82F6)),
                      const SizedBox(height: 12.0),

                      if (!isTtc) ...[
                        // Workout Selector
                        WorkoutChipsSelector(
                          selectedWorkout: _selectedWorkout,
                          onWorkoutChanged: (val) =>
                              setState(() => _selectedWorkout = val),
                        ),

                        const SizedBox(height: 12.0),

                        // Hydration & Cravings
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

                        const SizedBox(height: 12.0),

                        // Self-Care
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

                      // Sleep & Energy Level
                      const SizedBox(height: 12.0),
                      SleepAndEnergySection(
                        sleepRating: _sleepRating,
                        sleepDurationText: '7h 30m',
                        energyLevel: _energyLevel,
                        onSleepRatingChanged: (rating) =>
                            setState(() => _sleepRating = rating),
                        onEnergyLevelChanged: (level) =>
                            setState(() => _energyLevel = level),
                      ),

                      const SizedBox(height: 18.0),

                      // ==========================================
                      // 4. NOTES SECTION (Orange)
                      // ==========================================
                      _buildSectionDivider('NOTES', const Color(0xFFF97316)),
                      const SizedBox(height: 12.0),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: const Color(0xFFF1ECF5),
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.edit_note_rounded,
                                  color: Color(0xFFF97316),
                                  size: 18.0,
                                ),
                                SizedBox(width: 6.0),
                                Text(
                                  'NOTES / JOURNAL',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1E1A3C),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            TextField(
                              controller: _notesController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText:
                                    'Anything you want to remember? Sensations, doctor notes...',
                                hintStyle: const TextStyle(
                                  fontSize: 12.0,
                                  color: Color(0xFFAAA3B8),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFFAF8FC),
                                contentPadding: const EdgeInsets.all(12.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFEFE9F3),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFEFE9F3),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24.0),

                      // 5. "✨ Save Today's Log" Bottom Gradient Button
                      Container(
                        width: double.infinity,
                        height: 52.0,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF4D79), Color(0xFF8B5CF6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18.0),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF4D79)
                                  .withValues(alpha: 0.35),
                              blurRadius: 14.0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _handleSaveLog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('✨', style: TextStyle(fontSize: 16.0)),
                              SizedBox(width: 8.0),
                              Text(
                                "Save Today's Log",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24.0),
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

  Widget _buildSectionDivider(String title, Color color) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: color.withValues(alpha: 0.25),
            thickness: 1.2,
          ),
        ),
        const SizedBox(width: 6.0),
        Container(
          width: 5.0,
          height: 5.0,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6.0),
        Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w900,
            fontSize: 12.0,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(width: 6.0),
        Container(
          width: 5.0,
          height: 5.0,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6.0),
        Expanded(
          child: Divider(
            color: color.withValues(alpha: 0.25),
            thickness: 1.2,
          ),
        ),
      ],
    );
  }
}
