import 'dart:async';
import 'dart:ui';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/layout.dart';
import 'package:talacare/components/dpad.dart';
import 'package:talacare/components/event.dart';
import 'package:talacare/components/level.dart';
import 'helpers/directions.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/components/point.dart';
import 'package:flame/image_composition.dart';

class TalaCare extends FlameGame with HasCollisionDetection {
  late final CameraComponent cam;
  late final DPad dPad;
  @override
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

    dPad = DPad()
    ..sprite = await loadSprite('D_Pad/D-Pad.png');

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