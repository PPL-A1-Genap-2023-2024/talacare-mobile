import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talacare/helpers/time_limit.dart';

import 'schedule_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  testWidgets('Allow Less Than 2 Hours On Same Day Test',
      (WidgetTester tester) async {
    MockSharedPreferences mockPrefs = MockSharedPreferences();
    DateTime dateNow = DateTime.now();
    int duration = 6000;
    when(mockPrefs.getInt('duration')).thenReturn(duration);
    when(mockPrefs.getInt('lastLogin'))
        .thenReturn(dateNow.millisecondsSinceEpoch);
    bool result = await checkPlayerAppUsage(prefs: mockPrefs);
    expect(result, true);
    verify(mockPrefs.getInt('duration')).called(1);
    verify(mockPrefs.getInt('lastLogin')).called(1);
  });
  testWidgets('Prevent More Than 2 Hours On Same Day Test',
      (WidgetTester tester) async {
    MockSharedPreferences mockPrefs = MockSharedPreferences();
    DateTime dateNow = DateTime.now();
    int duration = 8000;
    when(mockPrefs.getInt('duration')).thenReturn(duration);
    when(mockPrefs.getInt('lastLogin'))
        .thenReturn(dateNow.millisecondsSinceEpoch);
    bool result = await checkPlayerAppUsage(prefs: mockPrefs);
    expect(result, false);
    verify(mockPrefs.getInt('duration')).called(1);
    verify(mockPrefs.getInt('lastLogin')).called(1);
  });

  testWidgets('Allow More Than 2 Hours On Different Day Test',
      (WidgetTester tester) async {
    MockSharedPreferences mockPrefs = MockSharedPreferences();
    DateTime dateNow = DateTime.now();
    DateTime dateLastLogin = DateTime(2024, 5, 15);
    int duration = 8000;
    when(mockPrefs.getInt('duration')).thenReturn(duration);
    when(mockPrefs.getInt('lastLogin'))
        .thenReturn(dateLastLogin.millisecondsSinceEpoch);
    when(mockPrefs.setInt('duration', 0)).thenAnswer((_) async => true);
    when(mockPrefs.setInt('lastLogin', dateNow.millisecondsSinceEpoch))
        .thenAnswer((_) async => true);
    bool result = await checkPlayerAppUsage(prefs: mockPrefs, dateNow: dateNow);
    expect(result, true);
    verify(mockPrefs.getInt('duration')).called(1);
    verify(mockPrefs.getInt('lastLogin')).called(1);
    verify(mockPrefs.setInt('duration', 0)).called(1);
    verify(mockPrefs.setInt('lastLogin', dateNow.millisecondsSinceEpoch))
        .called(1);
  });
}
