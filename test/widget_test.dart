// Basic smoke test: the app boots and shows the splash screen.

import 'package:flutter_test/flutter_test.dart';

import 'package:nestory/main.dart';

void main() {
  testWidgets('Nestory boots to the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const NestoryApp());
    await tester.pump();

    expect(find.text('NESTORY'), findsOneWidget);

    // Drain the splash's entrance animation and minimum-display timer so
    // no pending timers/tickers leak past the end of the test.
    await tester.pumpAndSettle(const Duration(seconds: 1));
  });
}
