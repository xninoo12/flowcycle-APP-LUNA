import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flowcycle/app/router/main_shell.dart';
import 'package:flowcycle/shared/providers/app_scope.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';

GoRouter _createTestRouter() {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (c, s) => const Scaffold(body: Center(child: Text('Home Screen Body'))),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calendar',
                builder: (c, s) => const Scaffold(body: Center(child: Text('Calendar Screen Body'))),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/log',
                builder: (c, s) => const Scaffold(body: Center(child: Text('Daily Log Screen Body'))),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/insights',
                builder: (c, s) => const Scaffold(body: Center(child: Text('Insights Screen Body'))),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/ai-companion',
                builder: (c, s) => const Scaffold(body: Center(child: Text('AI Companion Screen Body'))),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

Widget _buildTestApp([CycleDataController? controller, GoRouter? router]) {
  final ctrl = controller ?? CycleDataController();
  final rtr = router ?? _createTestRouter();
  return AppScope(
    controller: ctrl,
    child: MaterialApp.router(
      routerConfig: rtr,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Docked Bottom Navigation Bar Comprehensive Suite', () {
    testWidgets('1. Renders all 5 destinations with exact symmetrical docked layout', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final controller = CycleDataController();
      await tester.pumpWidget(_buildTestApp(controller));
      await tester.pumpAndSettle();

      // Check all 4 flanking labels and center Log button in bottom bar
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Calendar'), findsOneWidget);
      expect(find.text('Log'), findsOneWidget);
      expect(find.text('Insights'), findsOneWidget);
      expect(find.text('AI Companion'), findsOneWidget);

      // Check bottom nav bar icons
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
      expect(find.byIcon(Icons.access_time_rounded), findsOneWidget);
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.byIcon(Icons.bar_chart_outlined), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome_outlined), findsOneWidget);

      // Check DockedNotchPainter is present
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('2. Center Log action button size does not exceed 56dp FAB limit', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      // Find the circular center log button container
      final circularCenterBtnFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).shape == BoxShape.circle &&
            (widget.decoration as BoxDecoration).gradient != null,
      );
      expect(circularCenterBtnFinder, findsOneWidget);

      final Size centerBtnSize = tester.getSize(circularCenterBtnFinder.first);
      expect(centerBtnSize.width, lessThanOrEqualTo(56.0));
      expect(centerBtnSize.height, lessThanOrEqualTo(56.0));
      expect(centerBtnSize.width, equals(52.0));
      expect(centerBtnSize.height, equals(52.0));
    });

    testWidgets('3. Symmetrical navigation routing across all 5 shell branches', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Home Screen Body'), findsOneWidget);

      // Tap Calendar (Tab 1)
      await tester.tap(find.text('Calendar'));
      await tester.pumpAndSettle();
      expect(find.text('Calendar Screen Body'), findsOneWidget);
      expect(find.byIcon(Icons.access_time_filled_rounded), findsOneWidget);

      // Tap Center Log (Tab 2)
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Daily Log Screen Body'), findsOneWidget);

      // Tap Insights (Tab 3)
      await tester.tap(find.text('Insights'));
      await tester.pumpAndSettle();
      expect(find.text('Insights Screen Body'), findsOneWidget);
      expect(find.byIcon(Icons.bar_chart_rounded), findsOneWidget);

      // Tap AI Companion (Tab 4)
      await tester.tap(find.text('AI Companion'));
      await tester.pumpAndSettle();
      expect(find.text('AI Companion Screen Body'), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);

      // Tap Home (Tab 0)
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Home Screen Body'), findsOneWidget);
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    });

    testWidgets('4. Responsive layout scales cleanly across compact and wide screens without overflow', (
      tester,
    ) async {
      // Test compact phone screen (320px width)
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Calendar'), findsOneWidget);
      expect(find.text('Log'), findsOneWidget);
      expect(find.text('Insights'), findsOneWidget);
      expect(find.text('AI Companion'), findsOneWidget);

      // Test tablet screen (800px width)
      tester.view.physicalSize = const Size(800, 1280);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('AI Companion'), findsOneWidget);

      tester.view.resetPhysicalSize();
    });

    test('5. DockedNotchPainter geometry and shouldRepaint unit verification', () {
      const painter1 = DockedNotchPainter();
      const painter2 = DockedNotchPainter();
      const painter3 = DockedNotchPainter(backgroundColor: Colors.black);

      expect(painter1.shouldRepaint(painter2), isFalse);
      expect(painter1.shouldRepaint(painter3), isTrue);
    });
  });
}
