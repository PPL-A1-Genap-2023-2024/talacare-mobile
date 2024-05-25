import 'package:shared_preferences/shared_preferences.dart';

const int secondsInTwoHours = 7200;

Future<int> checkPlayerAppUsage(
    {SharedPreferences? prefs, DateTime? dateNow}) async {
  prefs ??= await SharedPreferences.getInstance();
  dateNow ??= DateTime.now();
  DateAndDurationPair dateAndDuration = await loadUsageData(prefs);
  DateTime date = dateAndDuration.date;
  int duration = dateAndDuration.duration;
  if (date.year == dateNow.year &&
      date.month == dateNow.month &&
      date.day == dateNow.day) {
    return secondsInTwoHours - duration;
  } else {
    await prefs.setInt('duration', 0);
    await prefs.setInt('lastLogin', dateNow.millisecondsSinceEpoch);
    return secondsInTwoHours;
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

Future<void> saveUsageData(
    {SharedPreferences? prefs, required int newDurationInMillisecond}) async {
  try {
    prefs ??= await SharedPreferences.getInstance();
    int newDuration = (newDurationInMillisecond / 1000).round();
    int duration = prefs.getInt('duration') ?? 0;
    int totalDuration = duration + newDuration;
    await prefs.setInt('duration', totalDuration);
  } catch (e) {}
}

class DateAndDurationPair {
  late int duration;
  late DateTime date;
  DateAndDurationPair(this.duration, this.date);
}
