import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talacare/helpers/notification_util.dart';
import 'package:talacare/helpers/schedule_util.dart';
import 'package:mockito/annotations.dart';
import 'schedule_test.mocks.dart';
import 'package:timezone/data/latest_all.dart' as tz;

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
@GenerateNiceMocks([MockSpec<NotificationUtilities>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Schedule_Functions', () {
    late MockSharedPreferences mockPrefs;
    late MockNotificationUtilities mockNotifs;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      mockNotifs = MockNotificationUtilities();
      NotificationUtilities.setInstance(mockNotifs);
      tz.initializeTimeZones();
    });
    test('Add schedule', () async {
      when(mockPrefs.containsKey("hour_1")).thenReturn(false);
      when(mockPrefs.containsKey("minute_1")).thenReturn(false);
      when(mockPrefs.getInt("hour_1")).thenReturn(null);
      when(checkIfDifferentSchedule(8, 30, mockPrefs)).thenReturn(true);
      when(mockNotifs.scheduleReminder(1, 8, 30))
          .thenAnswer((realInvocation) => Completer<void>().future);
      String result = addSchedule(8, 30, mockPrefs);
      expect(result, "Berhasil membuat jadwal");
    });

    test('Fetching schedule', () {
      when(mockPrefs.getInt("hour_1")).thenReturn(9);
      when(mockPrefs.getInt("minute_1")).thenReturn(45);
      List schedule = fetchSchedule(mockPrefs);
      expect(schedule.length, 1);
    });

    test('Edit schedule', () {
      when(mockNotifs.scheduleReminder(1, 10, 15))
          .thenAnswer((realInvocation) => Completer<void>().future);
      addSchedule(10, 15, mockPrefs);

      when(mockNotifs.cancelNotification(1)).thenAnswer((realInvocation) => Completer<void>().future);
      when(mockNotifs.scheduleReminder(1, 11, 30)).thenAnswer((realInvocation) => Completer<void>().future);
      String result = editSchedule(11, 30, 1, mockPrefs);
      expect(result, "Berhasil mengubah jadwal");

      when(mockPrefs.getInt("hour_1")).thenReturn(11);
      when(mockPrefs.getInt("minute_1")).thenReturn(30);
      List schedule = fetchSchedule(mockPrefs);

      expect(schedule.length, 1);
      expect(schedule[0][0].hour, 11);
      expect(schedule[0][0].minute, 30);
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
      List expectedSchedule = [
        [TimeOfDay(hour: 10, minute: 0), 2],
        [TimeOfDay(hour: 10, minute: 5), 1]
      ];
      List sortedSchedule = sortSchedule(schedule);
      expect(sortedSchedule, expectedSchedule);
    });

    test('Checking schedules for same time', () {
      when(mockPrefs.containsKey("hour_1")).thenReturn(true);
      when(mockPrefs.containsKey("minute_1")).thenReturn(true);
      when(mockPrefs.getInt("hour_1")).thenReturn(10);
      when(mockPrefs.getInt("minute_1")).thenReturn(5);
      var result = checkIfDifferentSchedule(10, 5, mockPrefs);
      expect(result, false);
    });
  });
}
