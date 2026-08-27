import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/core/services/notification_service.dart';
import 'package:flowcycle/shared/models/app_mode.dart';
import 'package:flowcycle/shared/models/user_profile.dart';

void main() {
  late NotificationService service;

  setUp(() {
    service = NotificationService.instance;
  });

  group('NotificationService Comprehensive Test Suite', () {
    test(
      '1. Computes dynamic upcoming reminders based on user cycle and mode',
      () {
        final now = DateTime.now();
        final profile = UserProfile(
          name: 'Amina',
          mode: AppMode.tryingToConceive,
          averageCycleLength: 28,
          typicalPeriodDuration: 5,
          lastPeriodStartDate: now.subtract(const Duration(days: 10)),
        );

        final reminders = service.computeUpcomingReminders(profile);
        expect(reminders, isNotEmpty);

        // Verify period onset reminder
        final periodReminder = reminders.firstWhere(
          (r) => r.type == ReminderType.periodOnset,
        );
        expect(periodReminder.title, contains('Period Approaching'));
        expect(periodReminder.isEnabled, isTrue);

        // Verify fertile window reminder
        final fertileReminder = reminders.firstWhere(
          (r) => r.type == ReminderType.fertileWindow,
        );
        expect(fertileReminder.title, contains('Peak Conception Window'));

        // Verify daily log reminder
        final logReminder = reminders.firstWhere(
          (r) => r.type == ReminderType.dailyLog,
        );
        expect(logReminder.title, contains('Evening Cycle Check-in'));
      },
    );

    test('2. Updates notification preferences and persists toggles', () {
      service.updatePeriodAlerts(enabled: false, daysBefore: 3);
      expect(service.periodAlerts, isFalse);
      expect(service.periodDaysBefore, 3);

      service.updateFertileWindowAlerts(enabled: false, daysBefore: 2);
      expect(service.fertileWindowAlerts, isFalse);
      expect(service.fertileDaysBefore, 2);

      service.updateDailyLogReminder(
        enabled: true,
        time: const TimeOfDay(hour: 21, minute: 30),
      );
      expect(service.dailyLogReminders, isTrue);
      expect(service.dailyLogTime.hour, 21);
      expect(service.dailyLogTime.minute, 30);

      service.updateAiHealthTips(enabled: false);
      expect(service.aiHealthTips, isFalse);
    });

    testWidgets('3. Triggers test in-app notification without error', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => service.triggerTestNotification(
                  context,
                  'Test Alert 🔔',
                  'Your daily reminder has arrived.',
                ),
                child: const Text('Send Alert'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Send Alert'));
      await tester.pumpAndSettle();

      expect(find.text('Test Alert 🔔'), findsOneWidget);
      expect(find.text('Your daily reminder has arrived.'), findsOneWidget);
    });
  });
}
