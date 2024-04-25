import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:talacare/export_data/screens/export_page.dart';
import 'package:talacare/widgets/homepage.dart';
import 'package:mockito/mockito.dart';

import 'export_data_test.mocks.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

@GenerateMocks([http.Client])
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
  testWidgets('Export Data Sucess Test', (WidgetTester tester) async {
    Uri uriExample = Uri.parse('http://127.0.0.1:8000/');
    MockClient client = MockClient();
    when(client.get(uriExample))
        .thenAnswer((_) async => Future.value(http.Response('Success', 200)));
    ExportPage exportPage = ExportPage(client: client);
    await tester.pumpWidget(MaterialApp(home: exportPage));

    GlobalKey sendEmailButtonKey = exportPage.getDownloadButtonKey();
    Finder sendEmailButton = find.byKey(sendEmailButtonKey);
    await tester.tap(sendEmailButton);
    await tester.pump();
    verify(client.get(uriExample)).called(1);
    expect(find.text('Berhasil Export Data'), findsOneWidget);
  });
  testWidgets('Export Data Failed Test', (WidgetTester tester) async {
    Uri uriExample = Uri.parse('http://127.0.0.1:8000/');
    MockClient client = MockClient();
    when(client.get(uriExample)).thenAnswer(
        (_) async => Future.value(http.Response('Internal Server Error', 500)));
    ExportPage exportPage = ExportPage(client: client);
    await tester.pumpWidget(MaterialApp(home: exportPage));

    GlobalKey sendEmailButtonKey = exportPage.getDownloadButtonKey();
    Finder sendEmailButton = find.byKey(sendEmailButtonKey);
    await tester.tap(sendEmailButton);
    await tester.pump();
    verify(client.get(uriExample)).called(1);
    expect(find.text('Gagal Export Data'), findsOneWidget);
  });
}
