import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FlowCycleApp());
    expect(find.byType(FlowCycleApp), findsOneWidget);
  });
}
