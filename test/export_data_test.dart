import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/export_data/screens/export_page.dart';
import 'package:talacare/widgets/homepage.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  testWidgets('Widget Button to Export Page Test', (WidgetTester tester) async {
    HomePage home = HomePage();
    await tester.pumpWidget(MaterialApp(home: home));
    await tester.pump();
    GlobalKey exportButtonKey = home.getExportButtonKey();
    Finder exportButtonFinder = find.byKey(exportButtonKey);
    expect(exportButtonFinder, findsOneWidget);
  });
  testWidgets('Navigate To Export Data and Go Back Test',
      (WidgetTester tester) async {
    HomePage home = HomePage();
    MockNavigatorObserver mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(MaterialApp(
      home: home,
      navigatorObservers: [mockObserver],
    ));
    await tester.pump();
    GlobalKey exportButtonKey = home.getExportButtonKey();
    Finder exportButtonFinder = find.byKey(exportButtonKey);
    expect(find.byType(ExportPage), findsNothing);

    await tester.tap(exportButtonFinder);
    await tester.pumpAndSettle();
    expect(find.byType(ExportPage), findsOne);
    expect(find.byType(HomePage), findsNothing);

    ExportPage exportPage = tester.widget(find.byType(ExportPage).first);
    GlobalKey backButtonKey = exportPage.getBackButtonKey();
    Finder backButtonFinder = find.byKey((backButtonKey));
    await tester.tap(backButtonFinder);
    await tester.pumpAndSettle();
    expect(find.byType(ExportPage), findsNothing);
    expect(find.byType(HomePage), findsOne);
  });
  testWidgets('Export Page Widget Test', (WidgetTester tester) async {
    ExportPage home = ExportPage();
    await tester.pumpWidget(MaterialApp(home: home));
    await tester.pump();
    Finder getButtons = find.byType(IconButton);
    expect(getButtons, findsExactly(2));
  });
}
