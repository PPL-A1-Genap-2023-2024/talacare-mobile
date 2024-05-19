import 'package:shared_preferences/shared_preferences.dart';

Future<bool> checkPlayerAppUsage(
    {SharedPreferences? prefs, DateTime? dateNow}) async {
  prefs ??= await SharedPreferences.getInstance();
  dateNow ??= DateTime.now();
  DateAndDurationPair dateAndDuration = await loadUsageData(prefs);
  DateTime date = dateAndDuration.date;
  int duration = dateAndDuration.duration;
  if (date.year == dateNow.year &&
      date.month == dateNow.month &&
      date.day == dateNow.day) {
    if (duration <= 7200) {
      return true;
    } else {
      return false;
    }
  } else {
    await prefs.setInt('duration', 0);
    await prefs.setInt('lastLogin', dateNow.millisecondsSinceEpoch);
    return true;
  }
}

Future<DateAndDurationPair> loadUsageData(SharedPreferences prefs) async {
  int duration = prefs.getInt('duration') ?? 0;
  int? storedDateTimeMilliseconds = prefs.getInt('lastLogin');
  DateTime dateTime = storedDateTimeMilliseconds != null
      ? DateTime.fromMillisecondsSinceEpoch(storedDateTimeMilliseconds)
      : DateTime.now();
  return DateAndDurationPair(duration, dateTime);
}

class DateAndDurationPair {
  late int duration;
  late DateTime date;
  DateAndDurationPair(this.duration, this.date);
}
