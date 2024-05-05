import 'dart:developer';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:talacare/notification_util.dart';
import 'package:talacare/reminder.dart';
import 'package:talacare/talacare.dart';
import 'package:http/http.dart' as http;
import 'package:talacare/widgets/overlays/pause_button.dart';
import 'package:talacare/widgets/overlays/pause_menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NotificationUtilities.initNotification();
  tz.initializeTimeZones();
  NotificationUtilities.requestPermission();
  runApp(MyApp()); //TODO:REMOVE THIS

  /*
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  TalaCare game = TalaCare();
  runApp(GameWidget(
      game: kDebugMode ? TalaCare() : game,
      initialActiveOverlays: const [
        PauseButton.id
      ],
      overlayBuilderMap: {
        PauseButton.id: (BuildContext context, TalaCare gameRef) => PauseButton(
              gameRef: gameRef,
            ),
        PauseMenu.id: (BuildContext context, TalaCare gameRef) => PauseMenu(
              gameRef: gameRef,
            )
      }));*/
}

//TODO: REMOVE THIS
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Reminder(),
    );
  }
}
