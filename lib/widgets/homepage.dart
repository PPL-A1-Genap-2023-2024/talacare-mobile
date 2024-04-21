import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:talacare/helpers/playableCharacters.dart';
import 'package:talacare/main.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:talacare/authentication/screens/login_page.dart';

class HomePage extends StatefulWidget {
  static const String id = 'HomePage';
  HomePage({super.key});

  final GlobalKey _playButtonKey = GlobalKey();
  final GlobalKey _settingsButtonKey = GlobalKey();

  GlobalKey getPlayButtonKey() {
    return _playButtonKey;
  }

  GlobalKey getSettingsButtonKey() {
    return _settingsButtonKey;
  }

  @override
  State<HomePage> createState() => _HomePageState(playButtonKey: _playButtonKey);
}

class _HomePageState extends State<HomePage> {
  final GlobalKey playButtonKey;
  _HomePageState({required this.playButtonKey});
  final CarouselController _controller = CarouselController();

  List<Image> characterSelection = [
    Image.asset("assets/images/Characters_free/boy.png"),
    Image.asset("assets/images/Characters_free/girl.png")
  ];

  String currentCharacter = 'boy';

  Future<void> logout() async {
    final GoogleSignIn googleSign = GoogleSignIn();
    await googleSign.signOut();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage(""),
        //     fit: BoxFit.cover
        //   )
        // ),
        child: Scaffold(
          backgroundColor: const Color(0xffd7a9ec),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Yuk Pilih karaktermu dulu',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xff745573 ),
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

              Container(
                child: Text(
                  currentCharacter,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff745573 ),
                      fontSize: 16,
                      fontFamily: 'Fredoka One',
                      fontWeight: FontWeight.w400),
                ),
              ),

              SizedBox(
                height: screenHeight * 0.05,
              ),

              /* Tombol Mulai */
              IconButton(
                icon: Image.asset(
                  "assets/images/Button/tombol_mulai.png",
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context){
                        return TalaCareGame(playedCharacter: currentCharacter);
                      })
                  );
                },
              ),

              /* Tombol Pengaturan */
              IconButton(
                icon: Image.asset(
                  "assets/images/Button/tombol_pengaturan.png",
                ),
                onPressed: () => (),
              ),

              /* Tombol Logout */
              IconButton(
                icon: Image.asset(
                  "assets/images/Button/tombol_keluar.png",
                ),
                onPressed: () async {
                  await logout();
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context){
                        return LoginPage();
                      })
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

