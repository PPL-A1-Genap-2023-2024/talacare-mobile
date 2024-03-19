import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/reminder.dart';

void main() {
  testWidgets('Test Scheduled Date Change When Selected Date', (tester) async {
    final form = ReminderForm();
    await tester.pumpWidget(
      MaterialApp(
        home: form,
      ),
    );
    final ReminderFormState formState = tester.state(find.byWidget(form));
    await tester.tap(find.text('Select date'));
    await tester.pump();
    await tester.tap(find.text('5'));
    await tester.pump();
    await tester.tap(find.text('OK'));
    await tester.pump();
    expect(formState.schedule, DateTime(2020, 1, 5));
  });
}
