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
    await tester.tap(find.text('Select time'));
    await tester.pumpAndSettle();
    var center = tester
        .getCenter(find.byKey(const ValueKey<String>('time-picker-dial')));
    await tester.tapAt(Offset(center.dx - 50, center.dy));
    await tester.pump();
    await tester.tapAt(Offset(center.dx - 50, center.dy));
    await tester.pump();
    await tester.tap(find.text('OK'));
    await tester.pump();
    expect(formState.schedule, TimeOfDay(hour: 9, minute: 45));
  });
}
