import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/reminder.dart';
import 'package:talacare/reminder_create.dart';
import 'package:talacare/reminder_edit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Test create reminder', (tester) async {
    final reminder = Reminder();

    await tester.pumpWidget(
      MaterialApp(
        home: reminder,
      ),
    );

    await tester.tap(find.text('Buat Jadwal Baru'));
    await tester.pump();
    await tester.tap(find.text('Pilih Waktu'));
    await tester.pump();
    await tester.tap(find.text('Buat Jadwal'));
    await tester.pump();
    await tester.tap(find.byType(IconButton));
  });

  testWidgets('Test create reminder form', (tester) async {
    final form = ReminderCreateForm();

    await tester.pumpWidget(
      MaterialApp(
        home: form,
      ),
    );

    await tester.tap(find.text('Pilih Waktu'));
    await tester.pump();
    await tester.tap(find.text('Buat Jadwal'));
    await tester.pump();
  });

  testWidgets('Test edit reminder form', (tester) async {
    final form = ReminderEditForm(id: 1, currentHour: 10, currentMinute: 10);

    await tester.pumpWidget(
      MaterialApp(
        home: form,
      ),
    );

    await tester.tap(find.text('Pilih Waktu'));
    await tester.pump();
    await tester.tap(find.text('Ubah Jadwal'));
    await tester.pump();
  });
}
