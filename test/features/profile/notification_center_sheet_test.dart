import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/core/services/notification_service.dart';
import 'package:flowcycle/features/profile/widgets/notification_center_sheet.dart';
import 'package:flowcycle/shared/models/app_mode.dart';
import 'package:flowcycle/shared/providers/app_scope.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';

void main() {
  group('NotificationCenterSheet Comprehensive Test Suite', () {
    late CycleDataController controller;
    late NotificationService service;

    setUp(() {
      controller = CycleDataController.instance;
      service = NotificationService.instance;

      controller.updateUserProfile(
        name: 'Amina',
        mode: AppMode.cycleAwareness,
        averageCycleLength: 28,
        typicalPeriodDuration: 5,
        lastPeriodStartDate: DateTime.now().subtract(const Duration(days: 10)),
      );
    });

    testWidgets('1. Renders NotificationCenterSheet with Inbox and Scheduled tabs', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            controller: controller,
            child: const Scaffold(
              body: NotificationCenterSheet(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Notifications'), findsOneWidget);
      expect(find.textContaining('Inbox'), findsOneWidget);
      expect(find.textContaining('Scheduled'), findsOneWidget);
      expect(find.text('Customize Reminders & Alarms'), findsOneWidget);

      // Verify Inbox tab content
      expect(find.text('RECENT ALERTS'), findsOneWidget);
      expect(find.text('Mark all read'), findsOneWidget);

      // Tap Mark all read
      await tester.tap(find.text('Mark all read'));
      await tester.pumpAndSettle();

      expect(service.unreadCount, 0);

      // Switch to Scheduled tab
      await tester.tap(find.textContaining('Scheduled'));
      await tester.pumpAndSettle();

      expect(find.text('UPCOMING ACTIVE REMINDERS'), findsOneWidget);
      expect(find.textContaining('Period Approaching'), findsOneWidget);
      expect(find.textContaining('Active'), findsWidgets);
    });
  });
}
