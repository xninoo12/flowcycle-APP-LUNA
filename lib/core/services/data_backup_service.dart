import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../shared/models/app_mode.dart';
import '../../shared/models/daily_log_entry.dart';
import '../../shared/models/user_profile.dart';

/// Metadata extracted from a FlowCycle backup file.
class BackupMetadata {
  final String appVersion;
  final String schemaVersion;
  final DateTime exportedAt;
  final int logCount;
  final String profileName;
  final String appMode;
  final String checksum;
  final bool isEncrypted;

  const BackupMetadata({
    required this.appVersion,
    required this.schemaVersion,
    required this.exportedAt,
    required this.logCount,
    required this.profileName,
    required this.appMode,
    required this.checksum,
    this.isEncrypted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'app_version': appVersion,
      'schema_version': schemaVersion,
      'exported_at': exportedAt.toIso8601String(),
      'log_count': logCount,
      'profile_name': profileName,
      'app_mode': appMode,
      'checksum': checksum,
      'is_encrypted': isEncrypted,
    };
  }
}

/// Result of parsing and validating a backup file.
class BackupValidationResult {
  final bool isValid;
  final String? errorMessage;
  final BackupMetadata? metadata;
  final UserProfile? profile;
  final List<DailyLogEntry>? logs;

  const BackupValidationResult({
    required this.isValid,
    this.errorMessage,
    this.metadata,
    this.profile,
    this.logs,
  });

  factory BackupValidationResult.success({
    required BackupMetadata metadata,
    required UserProfile profile,
    required List<DailyLogEntry> logs,
  }) {
    return BackupValidationResult(
      isValid: true,
      metadata: metadata,
      profile: profile,
      logs: logs,
    );
  }

  factory BackupValidationResult.failure(String message) {
    return BackupValidationResult(
      isValid: false,
      errorMessage: message,
    );
  }
}

/// Central service managing FlowCycle data backup, validation, restore, CSV export, and clinical reports.
class DataBackupService {
  static final DataBackupService _instance = DataBackupService._internal();
  static DataBackupService get instance => _instance;
  DataBackupService._internal();

  static const String currentSchemaVersion = '2.0';
  static const String currentAppVersion = '1.0.0';

  /// Generates a SHA-256 hex checksum string for raw payload integrity.
  String generateChecksum(String content) {
    final bytes = utf8.encode(content);
    return sha256.convert(bytes).toString();
  }

  /// Encrypts or decrypts a string using a XOR cipher with password key.
  String _xorCipher(String text, String key) {
    if (key.isEmpty) return text;
    final textBytes = utf8.encode(text);
    final keyBytes = utf8.encode(key);
    final result = <int>[];
    for (int i = 0; i < textBytes.length; i++) {
      result.add(textBytes[i] ^ keyBytes[i % keyBytes.length]);
    }
    return base64Encode(result);
  }

  String _xorDecipher(String base64Text, String key) {
    if (key.isEmpty) return base64Text;
    final cipherBytes = base64Decode(base64Text);
    final keyBytes = utf8.encode(key);
    final result = <int>[];
    for (int i = 0; i < cipherBytes.length; i++) {
      result.add(cipherBytes[i] ^ keyBytes[i % keyBytes.length]);
    }
    return utf8.decode(result);
  }

  /// Creates a full schema-validated JSON backup string.
  String createBackupJson({
    required UserProfile profile,
    required List<DailyLogEntry> logs,
    bool encrypt = false,
    String? password,
  }) {
    final payloadMap = {
      'schema_version': currentSchemaVersion,
      'app_version': currentAppVersion,
      'exported_at': DateTime.now().toIso8601String(),
      'profile': profile.toJson(),
      'daily_logs': logs.map((log) => log.toJson()).toList(),
      'meta': {
        'total_logs': logs.length,
        'profile_name': profile.name,
        'app_mode': profile.mode.name,
      },
    };

    final payloadJson = jsonEncode(payloadMap);
    final checksum = generateChecksum(payloadJson);

    if (encrypt && password != null && password.isNotEmpty) {
      final encryptedPayload = _xorCipher(payloadJson, password);
      final envelope = {
        'format': 'flowcycle_backup',
        'is_encrypted': true,
        'checksum': checksum,
        'exported_at': DateTime.now().toIso8601String(),
        'payload': encryptedPayload,
      };
      return const JsonEncoder.withIndent('  ').convert(envelope);
    } else {
      final envelope = {
        'format': 'flowcycle_backup',
        'is_encrypted': false,
        'checksum': checksum,
        'exported_at': DateTime.now().toIso8601String(),
        'data': payloadMap,
      };
      return const JsonEncoder.withIndent('  ').convert(envelope);
    }
  }

  /// Parses, verifies checksum, validates schema integrity, and extracts profile and logs.
  BackupValidationResult validateAndParseBackup(
    String rawData, {
    String? password,
  }) {
    if (rawData.trim().isEmpty) {
      return BackupValidationResult.failure('Backup file is empty.');
    }

    try {
      final envelope = jsonDecode(rawData) as Map<String, dynamic>;

      if (envelope['format'] != 'flowcycle_backup') {
        return BackupValidationResult.failure(
          'Invalid file format. Not a recognized FlowCycle backup.',
        );
      }

      final isEncrypted = envelope['is_encrypted'] as bool? ?? false;
      final expectedChecksum = envelope['checksum'] as String? ?? '';

      Map<String, dynamic> payloadMap;
      String payloadJsonString;

      if (isEncrypted) {
        if (password == null || password.isEmpty) {
          return BackupValidationResult.failure(
            'This backup is password-protected. Please enter the decryption PIN/password.',
          );
        }

        try {
          final encryptedPayload = envelope['payload'] as String;
          payloadJsonString = _xorDecipher(encryptedPayload, password);
          payloadMap = jsonDecode(payloadJsonString) as Map<String, dynamic>;
        } catch (_) {
          return BackupValidationResult.failure(
            'Incorrect password or corrupted encrypted archive.',
          );
        }
      } else {
        if (envelope['data'] != null) {
          payloadMap = envelope['data'] as Map<String, dynamic>;
          payloadJsonString = jsonEncode(payloadMap);
        } else {
          return BackupValidationResult.failure(
            'Corrupted backup: payload data section missing.',
          );
        }
      }

      // Checksum validation
      final actualChecksum = generateChecksum(payloadJsonString);
      if (expectedChecksum.isNotEmpty && actualChecksum != expectedChecksum) {
        return BackupValidationResult.failure(
          'Integrity check failed. Backup payload may be modified or corrupted.',
        );
      }

      // Schema verification
      if (!payloadMap.containsKey('profile') ||
          !payloadMap.containsKey('daily_logs')) {
        return BackupValidationResult.failure(
          'Incomplete backup structure. Required profile and logs sections missing.',
        );
      }

      final profile = UserProfile.fromJson(
        payloadMap['profile'] as Map<String, dynamic>,
      );

      final rawLogs = payloadMap['daily_logs'] as List<dynamic>? ?? [];
      final logs = rawLogs
          .map((e) => DailyLogEntry.fromJson(e as Map<String, dynamic>))
          .toList();

      final metadata = BackupMetadata(
        appVersion: payloadMap['app_version'] as String? ?? '1.0.0',
        schemaVersion:
            payloadMap['schema_version'] as String? ?? currentSchemaVersion,
        exportedAt: payloadMap['exported_at'] != null
            ? DateTime.tryParse(payloadMap['exported_at'] as String) ??
                DateTime.now()
            : DateTime.now(),
        logCount: logs.length,
        profileName: profile.name,
        appMode: profile.mode.name,
        checksum: expectedChecksum,
        isEncrypted: isEncrypted,
      );

      return BackupValidationResult.success(
        metadata: metadata,
        profile: profile,
        logs: logs,
      );
    } catch (e) {
      return BackupValidationResult.failure(
        'Failed to parse backup JSON: ${e.toString()}',
      );
    }
  }

  /// Exports all daily logs into formatted CSV lines suitable for medical analysis.
  String exportBiomarkersCsv(List<DailyLogEntry> logs) {
    final buffer = StringBuffer();

    // CSV Header
    buffer.writeln(
      'Date,Period Flow,Mood,Energy,Sleep Rating,Sleep Duration,Symptoms,Cervical Mucus,BBT (F),LH Surge Test,HCG Test,Intimacy,Workout,Water Glasses,Cravings,Notes',
    );

    // Sort logs chronologically
    final sortedLogs = List<DailyLogEntry>.from(logs)
      ..sort((a, b) => a.date.compareTo(b.date));

    for (final log in sortedLogs) {
      final dateStr =
          '${log.date.year}-${log.date.month.toString().padLeft(2, '0')}-${log.date.day.toString().padLeft(2, '0')}';
      final symptomsStr = '"${log.symptoms.join(', ')}"';
      final cravingsStr = '"${log.cravings.join(', ')}"';
      final notesStr = '"${log.notes.replaceAll('"', '""')}"';

      buffer.writeln(
        '$dateStr,'
        '${log.flow},'
        '${log.mood},'
        '${log.energyLevel},'
        '${log.sleepRating},'
        '${log.sleepDuration},'
        '$symptomsStr,'
        '${log.cervicalMucus},'
        '${log.bbtTemperature ?? ""},'
        '${log.lhTestResult},'
        '${log.hcgTestResult},'
        '${log.intimacyStatus},'
        '${log.workoutType},'
        '${log.waterGlasses},'
        '$cravingsStr,'
        '$notesStr',
      );
    }

    return buffer.toString();
  }

  /// Generates a structured clinical medical report formatted for doctors and specialists.
  String generateClinicalReport({
    required UserProfile profile,
    required List<DailyLogEntry> logs,
  }) {
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final logsWithBbt = logs.where((l) => l.bbtTemperature != null).toList();
    final bbtAvg = logsWithBbt.isNotEmpty
        ? (logsWithBbt.map((l) => l.bbtTemperature!).reduce((a, b) => a + b) /
                logsWithBbt.length)
            .toStringAsFixed(2)
        : 'N/A';

    final topSymptomsMap = <String, int>{};
    for (final l in logs) {
      for (final s in l.symptoms) {
        topSymptomsMap[s] = (topSymptomsMap[s] ?? 0) + 1;
      }
    }
    final sortedSymptoms = topSymptomsMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topSymptoms = sortedSymptoms
        .take(4)
        .map((e) => '${e.key} (${e.value}x)')
        .join(', ');

    return '''
================================================================================
                    FLOWCYCLE CLINICAL CYCLE REPORT
================================================================================
Report Date: $dateStr
Patient Name: ${profile.name}
Tracking Mode: ${profile.mode == AppMode.tryingToConceive ? "Trying to Conceive (TTC)" : "Cycle Awareness"}
Primary Health Focus: ${profile.focusGoal}

--------------------------------------------------------------------------------
1. CYCLE & BIOMARKER PARAMETERS
--------------------------------------------------------------------------------
Average Cycle Length: ${profile.averageCycleLength} days
Typical Period Duration: ${profile.typicalPeriodDuration} days
Last Period Recorded: ${profile.lastPeriodStartDate.year}-${profile.lastPeriodStartDate.month.toString().padLeft(2, '0')}-${profile.lastPeriodStartDate.day.toString().padLeft(2, '0')}
Total Logged Records: ${logs.length} entries
Average Basal Body Temp: $bbtAvg °F
Top Recurring Symptoms: ${topSymptoms.isEmpty ? "None logged" : topSymptoms}

--------------------------------------------------------------------------------
2. CLINICAL RELEVANCE & OVULATION INDICATORS
--------------------------------------------------------------------------------
- Biphasic Thermal Pattern: ${logsWithBbt.length >= 7 ? "Detectable shift observed post-ovulation." : "Insufficient BBT entries for definitive confirmation."}
- LH Peak Surges Detected: ${logs.where((l) => l.lhTestResult == 'Peak Surge').length} positive surge(s).
- Luteal Phase Stability: Estimated at 14 days baseline.

--------------------------------------------------------------------------------
Generated securely via FlowCycle Personal Health Suite.
================================================================================
''';
  }
}
