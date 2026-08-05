// Basic smoke test: the app boots and shows the Home screen's calendar.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nestory/main.dart';

void main() {
  testWidgets('Nestory boots to the Home calendar', (WidgetTester tester) async {
    await tester.pumpWidget(const NestoryApp());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
  });
}
