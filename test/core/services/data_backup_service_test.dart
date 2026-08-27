import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/core/services/data_backup_service.dart';
import 'package:flowcycle/shared/models/app_mode.dart';
import 'package:flowcycle/shared/models/daily_log_entry.dart';
import 'package:flowcycle/shared/models/user_profile.dart';

void main() {
  late DataBackupService backupService;
  late UserProfile sampleProfile;
  late List<DailyLogEntry> sampleLogs;

  setUp(() {
    backupService = DataBackupService.instance;
    sampleProfile = UserProfile(
      name: 'Maya Clinical',
      averageCycleLength: 29,
      typicalPeriodDuration: 5,
      lastPeriodStartDate: DateTime(2026, 8, 1),
      mode: AppMode.tryingToConceive,
      focusGoal: 'Conceive in 2026',
      cycleGoals: const ['Track ovulation', 'Monitor BBT'],
      ttcDuration: '3 months',
    );

    sampleLogs = [
      DailyLogEntry(
        date: DateTime(2026, 8, 1),
        mood: 'Good',
        flow: 'Medium',
        symptoms: const ['Cramps', 'Lower back ache'],
        bbtTemperature: 97.35,
        lhTestResult: 'Negative',
        cervicalMucus: 'Sticky',
        notes: 'Cycle start day 1',
      ),
      DailyLogEntry(
        date: DateTime(2026, 8, 14),
        mood: 'Great',
        flow: 'None',
        symptoms: const ['Mild cramps'],
        bbtTemperature: 97.42,
        lhTestResult: 'Peak Surge',
        cervicalMucus: 'Egg-white',
        notes: 'Ovulation peak surge confirmed',
      ),
      DailyLogEntry(
        date: DateTime(2026, 8, 16),
        mood: 'Calm',
        flow: 'None',
        symptoms: const ['Bloating'],
        bbtTemperature: 98.15,
        lhTestResult: 'Negative',
        cervicalMucus: 'Creamy',
        notes: 'Luteal temperature rise',
      ),
    ];
  });

  group('DataBackupService Comprehensive Test Suite', () {
    test('1. Creates plain JSON backup with valid structure and SHA-256 checksum', () {
      final jsonOutput = backupService.createBackupJson(
        profile: sampleProfile,
        logs: sampleLogs,
      );

      expect(jsonOutput, contains('flowcycle_backup'));
      expect(jsonOutput, contains('"is_encrypted": false'));
      expect(jsonOutput, contains('checksum'));
      expect(jsonOutput, contains('Maya Clinical'));

      final parsed = jsonDecode(jsonOutput) as Map<String, dynamic>;
      expect(parsed['format'], 'flowcycle_backup');
      expect(parsed['is_encrypted'], false);
      expect(parsed['checksum'], isNotEmpty);

      // Validate via service
      final result = backupService.validateAndParseBackup(jsonOutput);
      expect(result.isValid, isTrue);
      expect(result.metadata?.profileName, 'Maya Clinical');
      expect(result.metadata?.logCount, 3);
      expect(result.metadata?.appMode, 'tryingToConceive');
      expect(result.profile?.name, 'Maya Clinical');
      expect(result.logs?.length, 3);
      expect(result.logs?.first.symptoms, contains('Cramps'));
    });

    test('2. Creates password-encrypted backup and restores with correct password', () {
      const password = 'SecretPin_2026!';
      final encryptedJson = backupService.createBackupJson(
        profile: sampleProfile,
        logs: sampleLogs,
        encrypt: true,
        password: password,
      );

      final parsed = jsonDecode(encryptedJson) as Map<String, dynamic>;
      expect(parsed['is_encrypted'], isTrue);
      expect(parsed['payload'], isNotEmpty);

      // Attempt restore without password -> failure
      final failResult = backupService.validateAndParseBackup(encryptedJson);
      expect(failResult.isValid, isFalse);
      expect(failResult.errorMessage, contains('password-protected'));

      // Attempt restore with wrong password -> failure
      final wrongPassResult = backupService.validateAndParseBackup(
        encryptedJson,
        password: 'WrongPassword',
      );
      expect(wrongPassResult.isValid, isFalse);

      // Restore with correct password -> success
      final successResult = backupService.validateAndParseBackup(
        encryptedJson,
        password: password,
      );
      expect(successResult.isValid, isTrue);
      expect(successResult.metadata?.isEncrypted, isTrue);
      expect(successResult.profile?.name, 'Maya Clinical');
      expect(successResult.logs?.length, 3);
    });

    test('3. Rejects corrupted or tampered JSON payloads', () {
      final jsonOutput = backupService.createBackupJson(
        profile: sampleProfile,
        logs: sampleLogs,
      );

      // Tamper with content inside data without updating checksum
      final tampered = jsonOutput.replaceAll('Maya Clinical', 'Hacked Profile');
      final result = backupService.validateAndParseBackup(tampered);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('Integrity check failed'));
    });

    test('4. Generates clinical CSV with all biomarker columns', () {
      final csv = backupService.exportBiomarkersCsv(sampleLogs);

      expect(csv, contains('Date,Period Flow,Mood,Energy,Sleep Rating'));
      expect(csv, contains('2026-08-01,Medium,Good,Medium'));
      expect(csv, contains('2026-08-14,None,Great,Medium'));
      expect(csv, contains('97.35'));
      expect(csv, contains('Peak Surge'));
      expect(csv, contains('Egg-white'));
      expect(csv, contains('"Cramps, Lower back ache"'));
    });

    test('5. Generates structured clinical medical report for doctors', () {
      final report = backupService.generateClinicalReport(
        profile: sampleProfile,
        logs: sampleLogs,
      );

      expect(report, contains('FLOWCYCLE CLINICAL CYCLE REPORT'));
      expect(report, contains('Patient Name: Maya Clinical'));
      expect(report, contains('Tracking Mode: Trying to Conceive (TTC)'));
      expect(report, contains('Average Cycle Length: 29 days'));
      expect(report, contains('LH Peak Surges Detected: 1 positive surge(s)'));
    });
  });
}
