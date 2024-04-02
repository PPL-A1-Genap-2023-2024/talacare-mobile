import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:talacare/reminder.dart';
import 'package:http/http.dart' as http;

void main() {
  testWidgets('Test create reminder', (tester) async {
    final client = MockClient((request) async {
      expect(request.url, Uri.parse('http://localhost:8000/reminder/create'));
      expect(request.method, 'POST');
      return http.Response('Success', 200);
    });

    final reminder = Reminder(client);

    await tester.pumpWidget(
      MaterialApp(
        home: reminder,
      ),
    );

    await tester.tap(find.text('Tambahkan Jadwal Baru'));
    await tester.pump();
    await tester.tap(find.text('Pilih Waktu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Buat Jadwal'));
    await tester.pump();
  });

  testWidgets('Test edit reminder', (tester) async {
    String data = '''
    {
      "status": "OK",
      "message": "Schedule list fetched",
      "schedule": [
        {
          "id": 1,
          "hour": 21,
          "minute": 20
        }
      ]
    }
    ''';

    final client = MockClient((request) async {
      if (request.method == "POST") {
        expect(request.url, Uri.parse('http://localhost:8000/reminder/edit/1'));
        return http.Response("Success", 200);
      } else {
        expect(request.url, Uri.parse('http://localhost:8000/reminder/show'));
        return http.Response(data, 200);
      }
    });

    final reminder = Reminder(client);

    await tester.pumpWidget(
      MaterialApp(
        home: reminder,
      ),
    );

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();
    await tester.tap(find.text('Pilih Waktu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ubah Jadwal'));
    await tester.pump();
  });

  testWidgets('Test edit reminder', (tester) async {
    String data = '''
    {
      "status": "OK",
      "message": "Schedule list fetched",
      "schedule": [
        {
          "id": 1,
          "hour": 21,
          "minute": 20
        }
      ]
    }
    ''';

    final client = MockClient((request) async {
      if (request.method == "DELETE") {
        expect(
            request.url, Uri.parse('http://localhost:8000/reminder/delete/1'));
        return http.Response("Success", 200);
      } else {
        expect(request.url, Uri.parse('http://localhost:8000/reminder/show'));
        return http.Response(data, 200);
      }
    });

    final reminder = Reminder(client);

    await tester.pumpWidget(
      MaterialApp(
        home: reminder,
      ),
    );

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();
  });
}
