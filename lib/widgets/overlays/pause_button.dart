import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:talacare/talacare.dart';

import 'pause_menu.dart';

class PauseButton extends StatelessWidget {
  static const String id = 'PauseButton';
  final TalaCare gameRef;
  final GlobalKey _pauseButtonKey = GlobalKey();
  PauseButton({super.key, required this.gameRef});

  GlobalKey getPauseButtonKey() {
    return _pauseButtonKey;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topRight,
        child: IconButton(
          key: _pauseButtonKey,
          iconSize: 40,
          splashColor: Colors.white,
          icon: const Icon(
            Icons.pause,
            color: Colors.white,
          ),
          onPressed: () {
            FlameAudio.bgm.pause();
            gameRef.pauseEngine();
            gameRef.overlays.add(PauseMenu.id);
            gameRef.overlays.remove(PauseButton.id);
          },
        ));
  }
}
