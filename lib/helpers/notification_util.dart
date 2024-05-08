import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationUtilities {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initNotification() async {
    NotificationUtilities.getTimeZone()
        .then((location) => tz.setLocalLocation(location));
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('launch_background');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> requestPermission() async {
    if (await notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()!
            .requestNotificationsPermission() !=
        null) {
      await notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestExactAlarmsPermission();
    }
  }

  static Future<void> scheduleReminder(id, hour, minute) async {
    await notificationsPlugin.zonedSchedule(
        id,
        'Pengingat Minum Obat',
        'Jangan lupa minum obat kelasi besi, ya!',
        NotificationUtilities.getTime(hour, minute),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'channel1',
            'reminder channel',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  static Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
  }

  static tz.TZDateTime getTime(hour, minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static Future<tz.Location> getTimeZone() async {
    String locationName;
    try {
      locationName = await FlutterTimezone.getLocalTimezone();
    } catch (e) {
      locationName = "Asia/Bangkok";
    }
    return tz.getLocation(locationName);
  }
}
