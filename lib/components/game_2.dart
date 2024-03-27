import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/layout.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/talacare.dart';

import '../helpers/hospital_reason.dart';

class HospitalPuzzle extends World with HasGameRef<TalaCare> {
  final Player player;
  final HospitalReason reason;


  HospitalPuzzle({required this.player, required this.reason});

  @override
  FutureOr<void> onLoad() async {
    final background = SpriteComponent();
    background.sprite = await game.loadSprite("Hospital/hospital_setting.jpg");
    background.scale = Vector2.all(0.5625);
    gameRef.camera.backdrop = background;
    gameRef.camera.viewfinder.anchor = Anchor.center;
    gameRef.camera.viewport = FixedAspectRatioViewport(aspectRatio: 0.5625);

    final newButton = SpriteButtonComponent();
    newButton.button = await game.loadSprite('Hospital/okay.png');
    newButton.buttonDown = await game.loadSprite('Hospital/okay_pressed.png');
    newButton.onPressed = finishGame;
    gameRef.camera.viewport.add(AlignComponent(
      child: newButton,
      alignment: Anchor.center,
    ));
    return super.onLoad();
  }

  void finishGame() {
    gameRef.exitHospital();
  }
}