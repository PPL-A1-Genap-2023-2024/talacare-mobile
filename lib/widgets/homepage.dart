import 'package:flutter/material.dart';
import 'package:talacare/export_data/screens/export_page.dart';
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
  final GlobalKey _exportButtonKey = GlobalKey();

  GlobalKey getExportButtonKey() {
    return _exportButtonKey;
  }

  GlobalKey getPlayButtonKey() {
    return _playButtonKey;
  }

  GlobalKey getSettingsButtonKey() {
    return _settingsButtonKey;
  }

  @override
  State<HomePage> createState() => _HomePageState(
      playButtonKey: _playButtonKey, exportButtonKey: _exportButtonKey);
}

class _HomePageState extends State<HomePage> {
  final GlobalKey playButtonKey;
  final GlobalKey exportButtonKey;
  _HomePageState({required this.playButtonKey, required this.exportButtonKey});

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
          backgroundColor: const Color(0xfff2c293),
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Image.asset("assets/images/Button/LogoutButton.png"),
                iconSize: 50,
                onPressed: () async {
                  await logout();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }));
                },
              ),
              IconButton(
                icon: Image.asset("assets/images/Button/SettingButton.png"),
                iconSize: 50,
                onPressed: () => (),
              ),
              IconButton(
                key: exportButtonKey,
                icon: Image.asset("assets/images/Button/SettingButton.png"),
                iconSize: 50,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ExportPage();
                  }));
                },
              ),
            ],
            backgroundColor: Colors.transparent,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CarouselSlider(
                  items: characterSelection,
                  options: CarouselOptions(
                    height: screenHeight * 0.3,
                    enableInfiniteScroll: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentCharacter =
                            PlayableCharacters.values[index].name;
                      });
                    },
                  )),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              IconButton(
                key: playButtonKey,
                icon: Image.asset("assets/images/Button/PlayButton.png"),
                iconSize: 50,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TalaCareGame(playedCharacter: currentCharacter);
                  }));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
