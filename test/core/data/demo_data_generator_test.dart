import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/core/data/demo_data_generator.dart';
import 'package:flowcycle/core/database/local_database_service.dart';
import 'package:flowcycle/shared/models/app_mode.dart';

void main() {
  group('DemoDataGenerator 6-Month Historical Seed Tests', () {
    setUp(() async {
      await LocalDatabaseService.instance.initialize(customPath: 'in_memory');
    });

    test('1. Populates 6 months of historical cycles and daily biomarker logs', () async {
      await DemoDataGenerator.instance.populate6MonthDemoHistory();

      final profile = LocalDatabaseService.instance.getProfile();
      expect(profile, isNotNull);
      expect(profile!.name, equals('Amina'));
      expect(profile.averageCycleLength, equals(28));
      expect(profile.mode, equals(AppMode.cycleAwareness));

      final allLogs = LocalDatabaseService.instance.getAllLogs();
      expect(allLogs.length, greaterThanOrEqualTo(100)); // ~140-170 logs populated

      final logsList = allLogs.values.toList();

      // Verify biphasic BBT data exists
      final logsWithBbt = logsList.where((l) => l.bbtTemperature != null).toList();
      expect(logsWithBbt.isNotEmpty, isTrue);
      expect(logsWithBbt.any((l) => l.bbtTemperature! > 98.0), isTrue); // Luteal higher BBT
      expect(logsWithBbt.any((l) => l.bbtTemperature! < 97.8), isTrue); // Follicular lower BBT

      // Verify symptoms exist
      final logsWithSymptoms = logsList.where((l) => l.symptoms.isNotEmpty).toList();
      expect(logsWithSymptoms.isNotEmpty, isTrue);

      // Verify cervical mucus exists
      final logsWithMucus = logsList.where((l) => l.cervicalMucus == 'Egg White').toList();
      expect(logsWithMucus.isNotEmpty, isTrue);
    });
  });
}
