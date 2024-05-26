import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:talacare/helpers/notification_util.dart';
import 'package:mockito/annotations.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'notification_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FlutterLocalNotificationsPlugin>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Notification functions', () {
    late MockFlutterLocalNotificationsPlugin mockPlugin;
    late NotificationUtilities notification;

    setUp(() {
      mockPlugin = MockFlutterLocalNotificationsPlugin();
      notification = NotificationUtilities.getInstance();
      notification.setPlugin(mockPlugin);
      tz.initializeTimeZones();
    });

    test('Initialize Notification', () async {
      const settings = InitializationSettings(
          android: AndroidInitializationSettings('launch_background'));
      when(mockPlugin.initialize(settings))
          .thenAnswer((realInvocation) async => true);
      await notification.initNotification(settings: settings);
    });

    /*
    test('Request Permission', () async {
      when(mockPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()!
              .requestNotificationsPermission())
          .thenAnswer((_) async => true);
      when(mockPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()!
              .requestExactAlarmsPermission())
          .thenAnswer((_) async => true);
      await notification.requestPermission();
    });
    */

    test('Schedule Reminder', () async {
      await when(mockPlugin.zonedSchedule(
              1,
              'Pengingat Minum Obat',
              'Jangan lupa minum obat kelasi besi, ya!',
              NotificationUtilities.getTime(1, 30),
              any,
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
              matchDateTimeComponents: DateTimeComponents.time));
      notification.scheduleReminder(1, 1, 30);
    });

    /*
    test('Cancel Notification', () async {
      when(mockPlugin.cancel(1)).thenAnswer((realInvocation) => Completer<void>().future);
      await notification.cancelNotification(1);
    });
    */
  });
}
