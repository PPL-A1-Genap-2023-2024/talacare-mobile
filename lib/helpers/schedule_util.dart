import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talacare/helpers/notification_util.dart';

List fetchSchedule(SharedPreferences prefs) {
  var schedule = [];
  for (var i = 1; i < 4; i++) {
    var iteration = i.toString();
    int? hour = prefs.getInt("hour_$iteration");
    int? minute = prefs.getInt("minute_$iteration");
    if (hour != null && minute != null) {
      schedule.add([TimeOfDay(hour: hour, minute: minute), i]);
    }
  }
  if (schedule.length > 1) schedule = sortSchedule(schedule);
  return schedule;
}

String addSchedule(hour, minute, SharedPreferences prefs) {
  if (!checkIfDifferentSchedule(hour, minute, prefs)) {
    return "Sudah ada jadwal dengan waktu yang sama, silahkan pilih waktu yang berbeda";
  }

  for (var i = 1; i < 4; i++) {
    var iteration = i.toString();
    if (!prefs.containsKey("hour_$iteration") &&
        !prefs.containsKey("minute_$iteration")) {
      NotificationUtilities.getInstance().scheduleReminder(i, hour, minute);
      prefs.setInt("hour_$iteration", hour);
      prefs.setInt("minute_$iteration", minute);
      return "Berhasil membuat jadwal";
    }
  }
  return "Jadwal hanya maksimal 3, silahkan ubah atau hapus jadwal lain";
}

bool checkIfDifferentSchedule(hour, minute, SharedPreferences prefs) {
  for (var i = 1; i < 4; i++) {
    var iteration = i.toString();
    if (prefs.containsKey("hour_$iteration") &&
        prefs.containsKey("minute_$iteration")) {
      if (prefs.getInt("hour_$iteration") == hour &&
          prefs.getInt("minute_$iteration") == minute) {
        return false;
      }
    }
  }
  return true;
}

String editSchedule(hour, minute, id, SharedPreferences prefs) {
  if (!checkIfDifferentSchedule(hour, minute, prefs)) {
    return "Sudah ada jadwal dengan waktu yang sama, silahkan pilih waktu yang berbeda";
  }
  NotificationUtilities.getInstance().cancelNotification(id);
  NotificationUtilities.getInstance().scheduleReminder(id, hour, minute);
  prefs.setInt("hour_$id", hour);
  prefs.setInt("minute_$id", minute);

  return "Berhasil mengubah jadwal";
}

String deleteSchedule(id, SharedPreferences prefs) {
  NotificationUtilities.getInstance().cancelNotification(id);
  prefs.remove("hour_$id");
  prefs.remove("minute_$id");

  return "Berhasil menghapus jadwal";
}

List sortSchedule(List schedule) {
  for (int i = 0; i < schedule.length - 1; i++) {
    int minimalIndex = i;
    for (int j = i + 1; j < schedule.length; j++) {
      if (schedule[j][0].hour < schedule[minimalIndex][0].hour) {
        minimalIndex = j;
      } else if (schedule[j][0].hour == schedule[minimalIndex][0].hour &&
          schedule[j][0].minute < schedule[minimalIndex][0].minute) {
        minimalIndex = j;
      }
    }
    List temp = schedule[minimalIndex];
    schedule[minimalIndex] = schedule[i];
    schedule[i] = temp;
  }
  return schedule;
}
