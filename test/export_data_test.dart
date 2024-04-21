import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/widgets/homepage.dart';

void main() {
  testWidgets('Export Data Button Existence Test', (WidgetTester tester) async {
    HomePage home = HomePage();
    await tester.pumpWidget(MaterialApp(home: home));
    await tester.pump();
    GlobalKey exportButtonKey = home.getExportButtonKey();
    final exportButtonFinder = find.byKey(exportButtonKey);
    expect(exportButtonFinder, findsOneWidget);
  });
}
