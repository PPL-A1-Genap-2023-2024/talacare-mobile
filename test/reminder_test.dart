import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talacare/reminder.dart';
import 'package:mockito/mockito.dart';
import 'package:talacare/schedule_util.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Test create reminder', (tester) async {
    final reminder = Reminder();

    await tester.pumpWidget(
      MaterialApp(
        home: reminder,
      ),
    );

    await tester.tap(find.text('Tambahkan Jadwal Baru'));
    await tester.pump();
    await tester.tap(find.text('Pilih Waktu'));
    await tester.pump();
    await tester.tap(find.text('Buat Jadwal'));
    await tester.pump();
  });
}
