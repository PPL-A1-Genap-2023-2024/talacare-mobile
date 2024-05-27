import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talacare/components/button.dart';
import 'package:talacare/helpers/playable_characters.dart';
import 'package:talacare/helpers/time_limit.dart';
import 'package:talacare/main.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:talacare/helpers/audio_manager.dart';
import 'package:talacare/screens/reminder.dart';
import 'package:talacare/helpers/text_styles.dart';

class HomePage extends StatefulWidget {
  static const String id = 'HomePage';
  final String email;
  HomePage({super.key, this.email = ''});

  final GlobalKey _playButtonKey = GlobalKey();

  GlobalKey getPlayButtonKey() {
    return _playButtonKey;
  }

  @override
  State<HomePage> createState() => HomePageState(email: email);
}

class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late final AppLifecycleListener _listener;
  final String email;
  HomePageState({required this.email});
  final CarouselController _controller = CarouselController();

  String currentCharacter = 'tala';

  List<Image> characterSelection = [
    Image.asset(
      "assets/images/Characters_free/tala.png",
      fit: BoxFit.cover,
    ),
    Image.asset(
      "assets/images/Characters_free/talia.png",
      fit: BoxFit.cover,
    )
  ];

  Future<void> logout() async {
    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
    }
  }

  Future<void> startGame({String email = '', SharedPreferences? prefs}) async {
    prefs ??= await SharedPreferences.getInstance();
    int remainingTime = await checkPlayerAppUsage(prefs: prefs);
    if (remainingTime > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return TalaCareGame(
            playedCharacter: currentCharacter,
            email: email,
            remainingTime: remainingTime,
          );
        }),
      );
      AudioManager.getInstance().stopBackgroundMusic();
      FlameAudio.bgm.initialize();
      FlameAudio.bgm.play('bgm_game.mp3', volume: 0.5);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Peringatan",
              textAlign: TextAlign.center,
              style: AppTextStyles.h2,
            ),
            actions: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "Waktu bermain kamu hari ini sudah habis. Datang lagi besok, ya!",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.normal),
                  IconButton(
                    icon: Image.asset("assets/images/Button/BackButton.png"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
    }
  }

  /* App Life Cycle Listener */
  @override
  void initState() {
    super.initState();

    AudioManager.getInstance().playBackgroundMusic();
    _listener = AppLifecycleListener(
      onPause: _onPause,
      onResume: _onResume,
    );
  }

  @override
  void dispose() {
    _listener.dispose();

    super.dispose();
  }

  void _onPause() {
    AudioManager.getInstance().pauseBackgroundMusic();
  }

  void _onResume() {
    AudioManager.getInstance().playBackgroundMusic();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      child: Scaffold(
        backgroundColor: const Color(0xffe1827f),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Yuk pilih karaktermu dulu',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xff745573),
                  fontSize: 24,
                  fontFamily: 'Fredoka One',
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),

            /* Character Slider */
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    icon: Image.asset(
                      "assets/images/Button/tombol_prev.png",
                      width: 50,
                    ),
                    onPressed: () {
                      AudioManager.getInstance().playSoundEffect();
                      _controller.previousPage();
                    }),
                Flexible(
                  child: CarouselSlider(
                      items: characterSelection,
                      carouselController: _controller,
                      options: CarouselOptions(
                        height: screenHeight * 0.3,
                        enableInfiniteScroll: true,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentCharacter =
                                PlayableCharacters.values[index].name;
                          });
                        },
                      )),
                ),
                IconButton(
                  icon: Image.asset(
                    "assets/images/Button/tombol_next.png",
                    width: 50,
                  ),
                  onPressed: () {
                    AudioManager.getInstance().playSoundEffect();
                    _controller.nextPage();
                  },
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            if (currentCharacter == 'tala') ...[
              Container(
                child: const Text(
                  "Tala",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff745573),
                      fontSize: 16,
                      fontFamily: 'Fredoka One',
                      fontWeight: FontWeight.w400),
                ),
              ),
            ] else ...[
              Container(
                child: const Text(
                  "Talia",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff745573),
                      fontSize: 16,
                      fontFamily: 'Fredoka One',
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
            SizedBox(
              height: screenHeight * 0.05,
            ),

            /* Tombol Mulai */
            CustomButton(
                key: widget._playButtonKey,
                text: "Mulai",
                size: ButtonSize.medium,
                onPressed: () async {
                  await startGame(email: email);
                }),

            /* Tombol Pengaturan Reminder */
            IconButton(
                icon: Image.asset(
                  "assets/images/Button/tombol_pengaturan.png",
                ),
                onPressed: () async {
                  AudioManager.getInstance().playSoundEffect();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Reminder()),
                  );
                }),

            /* Tombol Logout */
            IconButton(
                icon: Image.asset(
                  "assets/images/Button/tombol_keluar.png",
                ),
                onPressed: () {
                  logout();
                  AudioManager.getInstance().playSoundEffect();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return AuthenticationWrapper();
                    }),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
