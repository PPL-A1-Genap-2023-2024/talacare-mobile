import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talacare/helpers/playable_characters.dart';
import 'package:talacare/main.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:talacare/helpers/audio_manager.dart';

class HomePage extends StatefulWidget {
  static const String id = 'HomePage';
  HomePage({super.key});

  final GlobalKey _playButtonKey = GlobalKey();

  GlobalKey getPlayButtonKey() {
    return _playButtonKey;
  }

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late final AppLifecycleListener _listener;

  final CarouselController _controller = CarouselController();

  String currentCharacter = 'tala';

  List<Image> characterSelection = [
    Image.asset("assets/images/Characters_free/tala.png", fit:BoxFit.cover,),
    Image.asset("assets/images/Characters_free/talia.png", fit:BoxFit.cover,)
  ];

  Future<void> logout() async {
    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
    }
  }

  Future<void> startGame() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return TalaCareGame(playedCharacter: currentCharacter);
      }),
    );
  }

  /* App Life Cycle Listener */
  @override
  void initState(){
    super.initState();

    AudioManager.getInstance().playBackgroundMusic();
    _listener = AppLifecycleListener(
      onPause: _onPause,
      onResume: _onResume,
    );
  }

  @override
  void dispose(){
    _listener.dispose();

    super.dispose();
  }

  void _onPause(){
    AudioManager.getInstance().pauseBackgroundMusic();
  }

  void _onResume(){
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
                    onPressed: () => _controller.previousPage(),
                  ),
                  Flexible(
                    child:  CarouselSlider(
                        items: characterSelection,
                        carouselController: _controller,
                        options: CarouselOptions(
                          height: screenHeight * 0.3,
                          enableInfiniteScroll: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentCharacter = PlayableCharacters.values[index].name;
                            });
                          },
                        )
                    ),
                  ),
                  IconButton(
                    icon: Image.asset(
                      "assets/images/Button/tombol_next.png",
                      width: 50,
                    ),
                    onPressed: () => _controller.nextPage(),
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
                        color: Color(0xff745573 ),
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
                        color: Color(0xff745573 ),
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
              IconButton(
                key: widget.getPlayButtonKey(),
                icon: Image.asset(
                  "assets/images/Button/tombol_mulai.png",
                ),
                onPressed: () async {
                  // Future.delayed(Duration(seconds: 2), () {
                  //   AudioManager.getInstance().stopBackgroundMusic();
                  // });
                  await startGame();
                  AudioManager.getInstance().stopBackgroundMusic();
                },
              ),

              /* Tombol Pengaturan Reminder */
              // IconButton(
              //   icon: Image.asset(
              //     "assets/images/Button/tombol_pengaturan.png",
              //   ),
              //   onPressed: () => (),
              // ),

              /* Tombol Logout */
              IconButton(
                icon: Image.asset(
                  "assets/images/Button/tombol_keluar.png",
                ),
                onPressed: () async {
                  await logout();
                  await Future.delayed(Duration(milliseconds: 500));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return AuthenticationWrapper();
                    }),
                  );
                }
              ),
            ],
          ),
        ),
      );
  }
}

