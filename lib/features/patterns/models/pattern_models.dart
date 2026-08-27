import 'package:flutter/material.dart';

/// Represents a symptom's correlation with menstrual cycle phases.
class SymptomPhaseCorrelation {
  final String symptomName;
  final String icon;
  final Color themeColor;
  final String dominantPhase;
  final int recurrencePercentage; // e.g. 85%
  final Map<String, double>
  phaseDistribution; // e.g. {'Menstrual': 0.85, 'Follicular': 0.05, ...}
  final String clinicalInsight;

  const SymptomPhaseCorrelation({
    required this.symptomName,
    required this.icon,
    required this.themeColor,
    required this.dominantPhase,
    required this.recurrencePercentage,
    required this.phaseDistribution,
    required this.clinicalInsight,
  });
}

/// Represents a single BBT temperature point across a menstrual cycle.
class BbtDataPoint {
  final int cycleDay;
  final double temperature; // in Fahrenheit, e.g. 97.4
  final bool isPostOvulation;
  final bool isCoverline;

  const BbtDataPoint({
    required this.cycleDay,
    required this.temperature,
    this.isPostOvulation = false,
    this.isCoverline = false,
  });
}

/// Represents an aggregated clinical cycle summary for doctor/OB-GYN consultation.
class ClinicalReportSummary {
  final String patientName;
  final String generatedDate;
  final String dateRange;
  final int totalCyclesAnalyzed;
  final double averageCycleLength;
  final double cycleVariationDays;
  final double averagePeriodDuration;
  final bool biphasicShiftConfirmed;
  final int estimatedOvulationDay;
  final List<String> topRecurringSymptoms;
  final String clinicalNotes;

  const ClinicalReportSummary({
    required this.patientName,
    required this.generatedDate,
    required this.dateRange,
    required this.totalCyclesAnalyzed,
    required this.averageCycleLength,
    required this.cycleVariationDays,
    required this.averagePeriodDuration,
    required this.biphasicShiftConfirmed,
    required this.estimatedOvulationDay,
    required this.topRecurringSymptoms,
    required this.clinicalNotes,
  });
}
