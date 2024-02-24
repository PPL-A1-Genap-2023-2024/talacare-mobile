import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:talacare/levels/level.dart';

class TalaCare extends FlameGame {

  late final CameraComponent cam;
  @override
  final world = Level(
    levelName: 'Level-01'
  );

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    cam = CameraComponent.withFixedResolution(world: world, width: 360, height: 640);
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]);


    return super.onLoad();
  }
}