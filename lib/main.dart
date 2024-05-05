import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:talacare/authentication/screens/login_page.dart';
import 'package:talacare/talacare.dart';
import 'package:talacare/widgets/overlays/pause_button.dart';
import 'package:talacare/widgets/overlays/pause_menu.dart';
import 'package:talacare/widgets/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'authentication/firebase_options.dart';
import 'package:talacare/helpers/audio_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  runApp(MyApp());
  AudioManager.getInstance().playBackgroundMusic();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TalaCare',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data != null) {
          return HomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}

class TalaCareGame extends StatelessWidget {
  final String playedCharacter;
  TalaCareGame({required this.playedCharacter});

  @override
  Widget build(BuildContext context) {
    final game = TalaCare(playedCharacter: playedCharacter);

    return GameWidget(
      game: kDebugMode ? TalaCare(playedCharacter: playedCharacter) : game,
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
      },
    );
  }
}