import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/dashboard/home_screen.dart';
import 'package:flowcycle/shared/models/app_mode.dart';
import 'package:flowcycle/shared/providers/app_scope.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';

void main() {
  late CycleDataController controller;

  setUp(() {
    controller = CycleDataController();
  });

  Widget buildTestable(Widget child) {
    return MaterialApp(
      home: AppScope(controller: controller, child: child),
    );
  }

  group('Dashboard Interactive Quick-Log Features & Sheets Suite', () {
    testWidgets('1. Flow Quick Log Sheet: selecting intensity updates controller', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      controller.setAppMode(AppMode.cycleAwareness);

      await tester.pumpWidget(
        buildTestable(const HomeScreen(initialMode: AppMode.cycleAwareness)),
      );
      await tester.pumpAndSettle();

      // Tap Flow Quick Action
      await tester.tap(find.text('Flow'));
      await tester.pumpAndSettle();

      expect(find.text('Period Flow Intensity'), findsOneWidget);
      expect(find.text('Heavy'), findsOneWidget);

      // Select Heavy
      await tester.tap(find.text('Heavy'));
      await tester.pumpAndSettle();

      expect(controller.getTodayLog().flow, equals('Heavy'));
    });

    testWidgets('2. Mood Quick Log Sheet: selecting mood updates controller', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      controller.setAppMode(AppMode.cycleAwareness);

      await tester.pumpWidget(
        buildTestable(const HomeScreen(initialMode: AppMode.cycleAwareness)),
      );
      await tester.pumpAndSettle();

      // Tap Mood Quick Action
      await tester.tap(find.text('Mood'));
      await tester.pumpAndSettle();

      expect(find.text('How are you feeling today?'), findsOneWidget);
      expect(find.text('Great'), findsOneWidget);

      // Select Great
      await tester.tap(find.text('Great'));
      await tester.pumpAndSettle();

      expect(controller.getTodayLog().mood, equals('Great'));
    });

    testWidgets('3. TTC Intercourse Quick Log: toggles intercourse status', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      controller.setAppMode(AppMode.tryingToConceive);

      await tester.pumpWidget(
        buildTestable(const HomeScreen(initialMode: AppMode.tryingToConceive)),
      );
      await tester.pumpAndSettle();

      // Tap Intercourse Quick Action
      await tester.tap(find.text('Intercourse'));
      await tester.pumpAndSettle();

      expect(find.text('Log Conception Intercourse'), findsOneWidget);

      // Select Yes
      await tester.tap(find.text('Yes, had intercourse today 💕'));
      await tester.pumpAndSettle();

      expect(controller.getTodayLog().intercourse, isTrue);
    });

    testWidgets('4. TTC LH Test Quick Log: records LH surge result', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      controller.setAppMode(AppMode.tryingToConceive);

      await tester.pumpWidget(
        buildTestable(const HomeScreen(initialMode: AppMode.tryingToConceive)),
      );
      await tester.pumpAndSettle();

      // Tap LH Test Quick Action
      await tester.tap(find.text('LH Test'));
      await tester.pumpAndSettle();

      expect(find.text('Ovulation (LH) Test Strip'), findsOneWidget);

      // Select Positive
      await tester.tap(find.text('Positive / LH Peak Surge 🔴'));
      await tester.pumpAndSettle();

      expect(controller.getTodayLog().lhTestResult, equals('Positive'));
    });

    testWidgets('5. TTC Cervical Mucus Quick Log: records egg white fluid', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      controller.setAppMode(AppMode.tryingToConceive);

      await tester.pumpWidget(
        buildTestable(const HomeScreen(initialMode: AppMode.tryingToConceive)),
      );
      await tester.pumpAndSettle();

      // Tap Cervical Mucus Quick Action
      await tester.tap(find.text('Cervical Mucus'));
      await tester.pumpAndSettle();

      expect(find.text('Cervical Fluid Consistency'), findsOneWidget);

      // Select Egg white
      await tester.tap(find.text('Egg White (Peak Fertility) 🎯'));
      await tester.pumpAndSettle();

      expect(controller.getTodayLog().cervicalMucus, equals('Egg white'));
    });
  });
}
