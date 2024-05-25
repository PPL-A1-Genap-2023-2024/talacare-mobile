import 'package:http/http.dart' as http;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:talacare/talacare.dart';
import 'package:talacare/screens/homepage.dart';
import 'package:talacare/screens/login_page.dart';
import 'package:talacare/screens/export_page.dart';
import 'package:talacare/helpers/analytics_util.dart';
import 'package:talacare/helpers/role_checker.dart';
import 'package:talacare/helpers/notification_util.dart';
import 'package:talacare/helpers/audio_manager.dart';
import 'package:talacare/widgets/overlays/pause_button.dart';
import 'package:talacare/widgets/overlays/pause_menu.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:talacare/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  AnalyticsUtil.setInstance(FirebaseAnalytics.instance);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  runApp(MyApp());

  NotificationUtilities.initNotification();
  tz.initializeTimeZones();
  NotificationUtilities.requestPermission();
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
          String email = snapshot.data!.email!;
          Future<bool> isAdmin = checkRole(http.Client(), email);
          return FutureBuilder(
            future: isAdmin,
            builder: (context, AsyncSnapshot<bool> isAdminSnapshot) {
              if (isAdminSnapshot.hasData) {
                if (isAdminSnapshot.data!) {
                  return ExportPage(recipientEmail: email);
                } else {
                  return HomePage(email: email);
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          );
        } else {
          return LoginPage();
        }
      },
    );
  }
}

class TalaCareGame extends StatelessWidget {
  final String playedCharacter;
  final String email;
  TalaCareGame({required this.playedCharacter, this.email = ''});

  @override
  Widget build(BuildContext context) {
    final game = TalaCare(playedCharacter: playedCharacter, email: email);

    return GameWidget(
      game: kDebugMode
          ? TalaCare(playedCharacter: playedCharacter, email: email)
          : game,
      initialActiveOverlays: const [PauseButton.id],
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
