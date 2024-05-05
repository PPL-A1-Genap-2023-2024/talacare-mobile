import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talacare/schedule_util.dart';
import 'package:mockito/annotations.dart';
@GenerateNiceMocks([MockSpec<SharedPreferences>()])
import 'schedule_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Schedule Functions', () {
    late MockSharedPreferences mockPrefs;

    setUp(() {
      mockPrefs = new MockSharedPreferences();
    });
    test('Add schedule', () {
      when(mockPrefs.containsKey("hour_1")).thenReturn(false);
      when(mockPrefs.containsKey("minute_1")).thenReturn(false);
      when(mockPrefs.getInt("hour_1")).thenReturn(null);
      when(checkIfDifferentSchedule(8, 30, mockPrefs)).thenReturn(true);
      String result = addSchedule(8, 30, mockPrefs);
      expect(result, "Berhasil membuat jadwal");
    });

    test('Fetching schedule', () {
      when(mockPrefs.getInt("hour_1")).thenReturn(9);
      when(mockPrefs.getInt("minute_1")).thenReturn(45);
      List schedule = fetchSchedule(mockPrefs);
      expect(schedule.length, 1);
    });

    test('Edit_schedule', () {
      addSchedule(10, 15, mockPrefs);

      String result = editSchedule(11, 30, 1, mockPrefs);
      expect(result, "Berhasil mengubah jadwal");

      when(mockPrefs.getInt("hour_1")).thenReturn(11);
      when(mockPrefs.getInt("minute_1")).thenReturn(30);
      List schedule = fetchSchedule(mockPrefs);

      expect(schedule.length, 1);
      expect(schedule[0].hour, 11);
      expect(schedule[0].minute, 30);
    });

    test('Deleting a schedule', () {
      addSchedule(8, 0, mockPrefs);

      String result = deleteSchedule(1, mockPrefs);
      expect(result, "Berhasil menghapus jadwal");

      List schedule = fetchSchedule(mockPrefs);
      expect(schedule.length, 0);
    });

    test('Sorting a schedule', () {
      List schedule = [
        [TimeOfDay(hour: 10, minute: 5), 1],
        [TimeOfDay(hour: 10, minute: 0), 2]
      ];
      List expected_schedule = [
        [TimeOfDay(hour: 10, minute: 0), 2],
        [TimeOfDay(hour: 10, minute: 5), 1]
      ];
      List sorted_schedule = sortSchedule(schedule);
      expect(sorted_schedule, expected_schedule);
    });
  });
}
