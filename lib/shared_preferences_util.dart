import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List> fetchSchedule() async {
  var prefs = await SharedPreferences.getInstance();
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

Future<String> addSchedule(hour, minute) async {
  var prefs = await SharedPreferences.getInstance();
  if (!await checkIfDifferentSchedule(hour, minute)) {
    return "Sudah ada jadwal yang sama";
  }

  for (var i = 1; i < 4; i++) {
    var iteration = i.toString();
    if (!prefs.containsKey("hour_$iteration") &&
        !prefs.containsKey("minute_$iteration")) {
      prefs.setString("hour_$iteration", hour);
      prefs.setString("minute_$iteration", hour);
      return "Berhasil membuat jadwal";
    }
  }
  return "Jadwal hanya maksimal 3";
}

Future<bool> checkIfDifferentSchedule(hour, minute) async {
  var prefs = await SharedPreferences.getInstance();
  for (var i = 1; i < 4; i++) {
    var iteration = i.toString();
    if (!prefs.containsKey("hour_$iteration") &&
        !prefs.containsKey("minute_$iteration")) if (!prefs
                .containsKey("hour_$iteration") ==
            hour &&
        !prefs.containsKey("minute_$iteration") == minute) return false;
  }
  return true;
}

Future<String> editSchedule(hour, minute, id) async {
  var prefs = await SharedPreferences.getInstance();

  if (!await checkIfDifferentSchedule(hour, minute)) {
    return "Sudah ada jadwal yang sama";
  }

  prefs.setInt("hour_$id", hour);
  prefs.setInt("minute_$id", hour);

  return "Berhasil mengubah jadwal";
}

Future<String> deleteSchedule(id) async {
  var prefs = await SharedPreferences.getInstance();

  prefs.remove("hour_$id");
  prefs.remove("minute_$id");

  return "Berhasil menghapus jadwal";
}
