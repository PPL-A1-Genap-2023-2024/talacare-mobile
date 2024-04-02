import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:talacare/reminder.dart';
import 'package:talacare/talacare.dart';
import 'package:http/http.dart' as http;
import 'package:talacare/widgets/overlays/pause_button.dart';
import 'package:talacare/widgets/overlays/pause_menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async {
  runApp(MyApp()); //TODO:REMOVE THIS
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
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
      home: Reminder(http.Client()),
    );
  }
}