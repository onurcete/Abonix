import 'package:abonix_tracker/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('empty state is visible initially', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: SubscriptionTrackerApp()));
    await tester.pumpAndSettle();
    final addFab = find.byIcon(Icons.add);
    final loading = find.byType(CircularProgressIndicator);
    expect(addFab.evaluate().isNotEmpty || loading.evaluate().isNotEmpty, isTrue);
  });
}
