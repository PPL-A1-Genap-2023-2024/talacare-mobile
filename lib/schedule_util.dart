import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

List fetchSchedule(SharedPreferences prefs) {
  var schedule = [];
  for (var i = 1; i < 4; i++) {
    var iteration = i.toString();
    int? hour = prefs.getInt("hour_$iteration");
    int? minute = prefs.getInt("minute_$iteration");
    if (hour != null && minute != null) {
      schedule.add(TimeOfDay(hour: hour, minute: minute));
    }
  }

  return schedule;
}

String addSchedule(hour, minute, SharedPreferences prefs) {
  if (!checkIfDifferentSchedule(hour, minute, prefs)) {
    return "Sudah ada jadwal yang sama";
  }

  for (var i = 1; i < 4; i++) {
    var iteration = i.toString();
    if (!prefs.containsKey("hour_$iteration") &&
        !prefs.containsKey("minute_$iteration")) {
      prefs.setInt("hour_$iteration", hour);
      prefs.setInt("minute_$iteration", minute);
      return "Berhasil membuat jadwal";
    }
  }
  return "Jadwal hanya maksimal 3";
}

bool checkIfDifferentSchedule(hour, minute, SharedPreferences prefs) {
  for (var i = 1; i < 4; i++) {
    var iteration = i.toString();
    if (prefs.containsKey("hour_$iteration") &&
        prefs.containsKey("minute_$iteration")) {
      if (!(prefs.getInt("hour_$iteration") == hour) &&
          !(prefs.getInt("minute_$iteration") == minute)) {
        return false;
      }
    }
  }
  return true;
}

String editSchedule(hour, minute, id, SharedPreferences prefs) {
  if (!checkIfDifferentSchedule(hour, minute, prefs)) {
    return "Sudah ada jadwal yang sama";
  }

  prefs.setInt("hour_$id", hour);
  prefs.setInt("minute_$id", minute);

  return "Berhasil mengubah jadwal";
}

String deleteSchedule(id, SharedPreferences prefs) {
  prefs.remove("hour_$id");
  prefs.remove("minute_$id");

  return "Berhasil menghapus jadwal";
}
