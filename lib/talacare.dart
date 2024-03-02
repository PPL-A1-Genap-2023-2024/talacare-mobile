import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/layout.dart';
import 'package:talacare/components/dpad.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/components/level.dart';
import 'package:flame/image_composition.dart';
import 'helpers/directions.dart';

class TalaCare extends FlameGame with HasKeyboardHandlerComponents {

  late final CameraComponent cam;
  Player player = Player(character: 'Adam');

  late final DPad dPad;

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    final world = Level(
      player: player,
      levelName: 'Level-01'
    );

    cam = CameraComponent.withFixedResolution(world: world, width: 360, height: 640);
    cam.viewfinder.anchor = Anchor.topLeft;


    final Image dPadImage = await images.load('D_Pad/D-Pad.png');
    dPad = DPad()
      ..sprite = Sprite(dPadImage)
      ..anchor=Anchor.bottomCenter;

    cam.viewport.add(AlignComponent(
      child:dPad,
      alignment: Anchor.bottomCenter,
    ));
    addAll([cam, world]);

    return super.onLoad();
  }

  void changeDirection(Direction direction) {
    player.direction = direction;
  }
}