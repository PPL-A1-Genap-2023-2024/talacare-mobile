import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/layout.dart';
import 'package:talacare/components/dpad.dart';
import 'package:talacare/components/event.dart';
import 'package:talacare/components/level.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/components/point.dart';
import 'package:flame/image_composition.dart';
import 'helpers/directions.dart';

class TalaCare extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {
  late final CameraComponent cam;
  late final DPad dPad;
  late final World world;
  late AlignComponent eventAnchor;
  Player player = Player(character: 'Adam');
  bool eventIsActive = false;
  int score = 0;

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    world = Level(player: player, levelName: 'Level-01');

    cam = CameraComponent(world: world);
    cam.viewfinder.anchor = Anchor.center;
    cam.viewfinder.zoom = 3;
    cam.viewport = FixedAspectRatioViewport(aspectRatio: 0.5625);
    
    cam.follow(player);

    final Image dPadImage = await images.load('D_Pad/D-Pad.png');
    dPad = DPad()
      ..sprite = Sprite(dPadImage)
      ..anchor = Anchor.bottomCenter;

    cam.viewport.add(AlignComponent(
      child: dPad,
      alignment: Anchor.bottomCenter,
    ));
    addAll([cam, world]);

    return super.onLoad();
  }

  void changeDirection(Direction direction) {
    player.direction = direction;
  }

  Future<void> onActivityStart(ActivityPoint point) async {
    if (!eventIsActive) {
      world.remove(point);
      eventAnchor = AlignComponent(
        child: ActivityEvent(variant: point.variant),
        alignment: Anchor.center
      );
      cam.viewport.add(eventAnchor);
      eventIsActive = true;
      score += 1;
    }
  }

  void onActivityEnd(ActivityEvent event) {
    if (eventIsActive) {
      eventAnchor.remove(event);
      cam.viewport.remove(eventAnchor);
      eventIsActive = false;
    }
  }
}