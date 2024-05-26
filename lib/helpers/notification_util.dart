import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationUtilities {
  static NotificationUtilities _instance = NotificationUtilities._internal();

  static NotificationUtilities getInstance() {
    return _instance;
  }

  NotificationUtilities._internal();

  FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void setInstance(NotificationUtilities instance) {
    _instance = instance;
  }

  void setPlugin(FlutterLocalNotificationsPlugin notificationsPlugin) {
    _notificationsPlugin = notificationsPlugin;
  }

  static const _settings = InitializationSettings(
      android: AndroidInitializationSettings('launch_background'));

  Future<void> initNotification({settings = _settings}) async {
    getTimeZone().then((location) => tz.setLocalLocation(location));

    _notificationsPlugin.initialize(settings);
  }

  Future<void> requestPermission() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestExactAlarmsPermission();
  }

  Future<void> scheduleReminder(id, hour, minute) async {
    await _notificationsPlugin.zonedSchedule(
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
    await _notificationsPlugin.cancel(id);
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
