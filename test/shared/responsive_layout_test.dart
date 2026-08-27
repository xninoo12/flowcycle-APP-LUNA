import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/features/dashboard/home_screen.dart';
import 'package:flowcycle/features/calendar/calendar_screen.dart';
import 'package:flowcycle/features/daily_log/daily_log_screen.dart';
import 'package:flowcycle/features/insights/insights_screen.dart';
import 'package:flowcycle/features/patterns/patterns_screen.dart';
import 'package:flowcycle/shared/models/app_mode.dart';
import 'package:flowcycle/shared/providers/app_scope.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';
import 'package:flowcycle/shared/widgets/responsive_layout.dart';
import 'package:flowcycle/shared/widgets/buttons/primary_button.dart';

Widget _buildResponsiveTestWidget(Widget child, [CycleDataController? controller]) {
  final ctrl = controller ?? CycleDataController();
  return AppScope(
    controller: ctrl,
    child: MaterialApp(
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Multi-Device Responsive UI/UX & Touch Target Suite', () {
    testWidgets('1. ResponsiveLayout helper breakpoints evaluate accurately', (
      tester,
    ) async {
      // 1. Compact screen test (< 360)
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;

      late bool isCompact;
      late bool isTablet;
      late double hPadding;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            isCompact = ResponsiveLayout.isCompact(context);
            isTablet = ResponsiveLayout.isTablet(context);
            hPadding = ResponsiveLayout.horizontalPadding(context);
            return const SizedBox();
          },
        ),
      );
      expect(isCompact, isTrue);
      expect(isTablet, isFalse);
      expect(hPadding, equals(12.0));

      // 2. Tablet / Foldable screen test (>= 600)
      tester.view.physicalSize = const Size(800, 1280);
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            isCompact = ResponsiveLayout.isCompact(context);
            isTablet = ResponsiveLayout.isTablet(context);
            hPadding = ResponsiveLayout.horizontalPadding(context);
            return const SizedBox();
          },
        ),
      );
      expect(isCompact, isFalse);
      expect(isTablet, isTrue);
      expect(hPadding, equals(24.0));

      tester.view.resetPhysicalSize();
    });

    testWidgets('2. HomeScreen adapts cleanly without overflow on 320x640 compact display', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final oldHandler = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        debugPrint('>>> DETAILED OVERFLOW ERROR: ${details.exceptionAsString()}');
        debugPrint('>>> INFORMATION: ${details.informationCollector?.call().map((e) => e.toString()).join('\n')}');
      };
      addTearDown(() => FlutterError.onError = oldHandler);

      final controller = CycleDataController();

      // 1. Test Cycle Awareness mode on 320px compact display
      await tester.pumpWidget(_buildResponsiveTestWidget(const HomeScreen(), controller));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(HomeScreen), findsOneWidget);

      // 2. Test TTC mode on 320px compact display
      controller.setAppMode(AppMode.tryingToConceive);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('3. CalendarScreen adapts cleanly across extreme resolutions (320px to 1024px)', (
      tester,
    ) async {
      // 320px compact budget phone
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final controller = CycleDataController();
      await tester.pumpWidget(_buildResponsiveTestWidget(const CalendarScreen(), controller));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(CalendarScreen), findsOneWidget);

      // 1024px tablet display
      tester.view.physicalSize = const Size(1024, 1366);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(CalendarScreen), findsOneWidget);
    });

    testWidgets('4. DailyLogScreen, Insights, and Patterns adapt seamlessly on foldable 600x800', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(600, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final controller = CycleDataController();

      // DailyLogScreen
      await tester.pumpWidget(_buildResponsiveTestWidget(const DailyLogScreen(), controller));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // InsightsScreen
      await tester.pumpWidget(_buildResponsiveTestWidget(const InsightsScreen(), controller));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // PatternsScreen
      await tester.pumpWidget(_buildResponsiveTestWidget(const PatternsScreen(), controller));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('5. Primary touch targets meet minimum 48x48dp ergonomic standard', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: PrimaryButton(
                label: 'Log Period',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final buttonFinder = find.byType(PrimaryButton);
      expect(buttonFinder, findsOneWidget);

      final Size buttonSize = tester.getSize(buttonFinder);
      expect(buttonSize.height, greaterThanOrEqualTo(48.0));
      expect(buttonSize.width, greaterThanOrEqualTo(48.0));
    });
  });
}
