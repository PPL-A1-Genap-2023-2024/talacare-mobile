import 'package:firebase_auth/firebase_auth.dart';
import 'package:talacare/helpers/color_palette.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:talacare/screens/login_page.dart';
import 'package:talacare/screens/export_page.dart';
import 'package:talacare/helpers/role_checker.dart';
import 'package:talacare/helpers/notification_util.dart';
import 'package:talacare/talacare.dart';
import 'package:talacare/widgets/overlays/pause_button.dart';
import 'package:talacare/widgets/overlays/pause_menu.dart';
import 'package:talacare/screens/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:talacare/firebase_options.dart';
import 'package:talacare/helpers/audio_manager.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  runApp(MyApp());

  await NotificationUtilities.initNotification();
  tz.initializeTimeZones();
  await NotificationUtilities.requestPermission();
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
          return _buildLoadingWidget();
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
                return _buildLoadingWidget();
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

Widget _buildLoadingWidget() {
  return SizedBox.expand(
    child: Container(
      color: AppColors.greenPrimary,
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.plum),
        ),
      ),
    ),
  );
}

class TalaCareGame extends StatelessWidget {
  final String playedCharacter;
  final String email;
  final int remainingTime;
  TalaCareGame({
    required this.playedCharacter,
    this.email = '',
    this.remainingTime = 1, // assign default value to make tests not error
  });

  @override
  Widget build(BuildContext context) {
    final game = TalaCare(
        playedCharacter: playedCharacter,
        email: email,
        remainingTime: remainingTime,
        context: context);

    return GameWidget(
      game: game,
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
