import 'package:flutter/material.dart';
import 'package:talacare/talacare.dart';
import 'package:talacare/widgets/overlays/pause_button.dart';

class HomePage extends StatelessWidget {
  static const String id = 'HomePage';
  final TalaCare gameRef;
  HomePage({super.key, required this.gameRef});

  final GlobalKey _playButtonKey = GlobalKey();

  GlobalKey getPlayButtonKey() {
    return _playButtonKey;
  }

  @override
  Widget build(BuildContext context) {
    gameRef.pauseEngine();
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 250,
          width: 300,
          decoration: const BoxDecoration(
            color: blackTextColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'TalaCare',
                style: TextStyle(
                  color: whiteTextColor,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                height: 75,
                child: ElevatedButton(
                  key: _playButtonKey,
                  onPressed: () {
                    gameRef.overlays.remove('HomePage');
                    gameRef.overlays.add(PauseButton.id);
                    gameRef.resumeEngine();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteTextColor,
                  ),
                  child: const Text(
                    'Play',
                    style: TextStyle(
                      fontSize: 40.0,
                      color: blackTextColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

