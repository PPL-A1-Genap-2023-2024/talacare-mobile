import 'package:flutter/material.dart';
import 'package:talacare/talacare.dart';
import 'package:talacare/widgets/overlays/pause_button.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  static const String id = 'HomePage';
  final TalaCare gameRef;
  HomePage({super.key, required this.gameRef});

  final GlobalKey _playButtonKey = GlobalKey();

  GlobalKey getPlayButtonKey() {
    return _playButtonKey;
  }

  @override
  State<HomePage> createState() => _HomePageState(playButtonKey: _playButtonKey, gameRef: gameRef);
}

class _HomePageState extends State<HomePage> {
  final TalaCare gameRef;
  final GlobalKey playButtonKey;
  _HomePageState({required this.playButtonKey, required this.gameRef});

  List<Image> characterSelection = [
    Image.asset("assets/images/Menu/showcase/boy.png"),
    Image.asset("assets/images/Menu/showcase/girl.png")
  ];

  String currentCharacters = 'boy';

  void PlayGame(){
    gameRef.overlays.remove('HomePage');
    gameRef.overlays.add(PauseButton.id);
    gameRef.resumeEngine();
  }

  @override
  Widget build(BuildContext context) {
    gameRef.pauseEngine();
    double screenHeight = MediaQuery.of(context).size.height;

    return Material(
      color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CarouselSlider(
              items: characterSelection,
              options: CarouselOptions(
                height: screenHeight * 0.3,
                enableInfiniteScroll: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    gameRef.setCharacter(index);
                  });
                },
              )
          ),
          SizedBox(
            height: screenHeight * 0.05,
          ),
          IconButton(
            key: playButtonKey,
            icon: Image.asset("assets/images/Menu/PlayButton.png"),
            iconSize: 50,
            onPressed: () => PlayGame(),
          )
        ],
      )
    );
  }
}

