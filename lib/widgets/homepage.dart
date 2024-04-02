import 'package:flutter/material.dart';
import 'package:talacare/helpers/playableCharacters.dart';
import 'package:talacare/talacare.dart';
import 'package:talacare/widgets/overlays/pause_button.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  static const String id = 'HomePage';
  final TalaCare gameRef;
  HomePage({super.key, required this.gameRef});

  final GlobalKey _playButtonKey = GlobalKey();
  final GlobalKey _settingsButtonKey = GlobalKey();

  GlobalKey getPlayButtonKey() {
    return _playButtonKey;
  }

  GlobalKey getSettingsButtonKey() {
    return _settingsButtonKey;
  }

  @override
  State<HomePage> createState() => _HomePageState(playButtonKey: _playButtonKey, gameRef: gameRef);
}

class _HomePageState extends State<HomePage> {
  final TalaCare gameRef;
  final GlobalKey playButtonKey;
  _HomePageState({required this.playButtonKey, required this.gameRef});

  List<Image> characterSelection = [
    Image.asset("assets/images/Characters_free/boy.png"),
    Image.asset("assets/images/Characters_free/girl.png")
  ];

  String currentCharacter = 'boy';

  void PlayGame(){
    gameRef.overlays.remove('HomePage');
    gameRef.overlays.add(PauseButton.id);
    gameRef.resumeEngine();
  }

  @override
  Widget build(BuildContext context) {
    gameRef.pauseEngine();
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
                onPressed: () => (),
              ),
              IconButton(
                icon: Image.asset("assets/images/Button/SettingButton.png"),
                iconSize: 50,
                onPressed: () => (),
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
                        currentCharacter = PlayableCharacters.values[index].name;
                        gameRef.player.changeCharacter(currentCharacter);
                        gameRef.player.onLoad();
                      });
                    },
                  )
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              IconButton(
                key: playButtonKey,
                icon: Image.asset("assets/images/Button/PlayButton.png"),
                iconSize: 50,
                onPressed: () => PlayGame(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

