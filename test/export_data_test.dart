import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:talacare/config.dart';
import 'package:talacare/export_data/screens/export_page.dart';
import 'package:mockito/mockito.dart';

import 'export_data_test.mocks.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

@GenerateMocks([http.Client])
void main() {
  testWidgets('Export Page Widget Test', (WidgetTester tester) async {
    ExportPage home = ExportPage();
    await tester.pumpWidget(MaterialApp(home: home));
    await tester.pump();
    Finder getButtons = find.byType(IconButton);
    expect(getButtons, findsExactly(2));
  });
  testWidgets('Export Data Sucess Test', (WidgetTester tester) async {
    Uri uriExample = Uri.parse(urlBackEnd + '/export/send_email/');
    MockClient client = MockClient();
    when(client.post(
      uriExample,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'recipient_email': "",
      }),
    )).thenAnswer((_) async => Future.value(http.Response('Success', 200)));
    ExportPage exportPage = ExportPage(
      client: client,
      recipientEmail: "",
    );
    await tester.pumpWidget(MaterialApp(home: exportPage));

    GlobalKey sendEmailButtonKey = exportPage.getDownloadButtonKey();
    Finder sendEmailButton = find.byKey(sendEmailButtonKey);
    await tester.tap(sendEmailButton);
    await tester.pump();
    verify(client.post(
      uriExample,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'recipient_email': "",
      }),
    )).called(1);
    expect(find.text('Berhasil Export Data'), findsOneWidget);
  });
  testWidgets('Export Data Failed Test (Wrong Request)',
      (WidgetTester tester) async {
    Uri uriExample = Uri.parse(urlBackEnd + '/export/send_email/');
    MockClient client = MockClient();
    when(client.post(
      uriExample,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'recipient_email': "",
      }),
    )).thenAnswer(
        (_) async => Future.value(http.Response('Internal Server Error', 500)));
    ExportPage exportPage = ExportPage(
      client: client,
      recipientEmail: "",
    );
    await tester.pumpWidget(MaterialApp(home: exportPage));

    GlobalKey sendEmailButtonKey = exportPage.getDownloadButtonKey();
    Finder sendEmailButton = find.byKey(sendEmailButtonKey);
    await tester.tap(sendEmailButton);
    await tester.pump();
    verify(client.post(
      uriExample,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'recipient_email': "",
      }),
    )).called(1);
    expect(find.text('Gagal Export Data'), findsOneWidget);
  });
  testWidgets('Export Data Failed (Server Not Responding)',
      (WidgetTester tester) async {
    Uri uriExample = Uri.parse(urlBackEnd + '/export/send_email/');
    MockClient client = MockClient();
    when(client.post(
      uriExample,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'recipient_email': "",
      }),
    )).thenAnswer((_) async => throw Exception('Failed to fetch data'));
    ExportPage exportPage = ExportPage(
      client: client,
      recipientEmail: "",
    );
    await tester.pumpWidget(MaterialApp(home: exportPage));

    GlobalKey sendEmailButtonKey = exportPage.getDownloadButtonKey();
    Finder sendEmailButton = find.byKey(sendEmailButtonKey);
    await tester.tap(sendEmailButton);
    await tester.pump();
    verify(client.post(
      uriExample,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'recipient_email': "",
      }),
    )).called(1);
    expect(find.text('Gagal Export Data'), findsOneWidget);

    Finder button = find.byType(IconButton).last;
    await tester.tap(button);
    await tester.pump();
    expect(find.text('Gagal Export Data'), findsNothing);
  });
}
