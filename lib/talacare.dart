import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/components/level.dart';

class TalaCare extends FlameGame with HasKeyboardHandlerComponents {

  late final CameraComponent cam;
  Player player = Player(character: 'Adam');

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
    addAll([cam, world]);

    return super.onLoad();
  }
}