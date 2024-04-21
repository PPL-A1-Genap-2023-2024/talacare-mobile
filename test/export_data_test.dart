import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/export_data/screens/export_page.dart';
import 'package:talacare/widgets/homepage.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  testWidgets('Export Data Button Existence Test', (WidgetTester tester) async {
    HomePage home = HomePage();
    await tester.pumpWidget(MaterialApp(home: home));
    await tester.pump();
    GlobalKey exportButtonKey = home.getExportButtonKey();
    final exportButtonFinder = find.byKey(exportButtonKey);
    expect(exportButtonFinder, findsOneWidget);
  });
  testWidgets('Navigate To Export Data Test', (WidgetTester tester) async {
    HomePage home = HomePage();
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(MaterialApp(
      home: home,
      navigatorObservers: [mockObserver],
    ));
    await tester.pump();
    GlobalKey exportButtonKey = home.getExportButtonKey();
    final exportButtonFinder = find.byKey(exportButtonKey);
    expect(find.byType(ExportPage), findsNothing);
    await tester.tap(exportButtonFinder);
    await tester.pumpAndSettle();
    expect(find.byType(ExportPage), findsOne);
  });
}
