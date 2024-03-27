import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:talacare/authentication/screens/login_page.dart';
import 'package:talacare/talacare.dart';
import 'package:talacare/widgets/overlays/pause_button.dart';
import 'package:talacare/widgets/overlays/pause_menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'authentication/firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
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
      }));
}