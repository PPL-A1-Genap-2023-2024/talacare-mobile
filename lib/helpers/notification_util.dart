import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationUtilities {
  static NotificationUtilities _instance =
      NotificationUtilities._internal();

  static NotificationUtilities getInstance() {
    return _instance;
  }

  NotificationUtilities._internal();

  FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void setInstance(NotificationUtilities instance) {
    _instance = instance;
  }

  static void setPlugin(FlutterLocalNotificationsPlugin notificationsPlugin) {
    notificationsPlugin = notificationsPlugin;
  }

  Future<void> initNotification() async {
    getTimeZone().then((location) => tz.setLocalLocation(location));
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('launch_background');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> requestPermission() async {
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

  Future<void> scheduleReminder(id, hour, minute) async {
    await notificationsPlugin.zonedSchedule(
        id,
        'Pengingat Minum Obat',
        'Jangan lupa minum obat kelasi besi, ya!',
        getTime(hour, minute),
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

  Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
  }

  tz.TZDateTime getTime(hour, minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<tz.Location> getTimeZone() async {
    String locationName;
    try {
      locationName = await FlutterTimezone.getLocalTimezone();
    } catch (e) {
      locationName = "Asia/Bangkok";
    }
    return tz.getLocation(locationName);
  }
}
