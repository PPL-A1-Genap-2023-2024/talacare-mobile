import 'dart:async';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/layout.dart';
import 'package:talacare/components/dpad.dart';
import 'package:talacare/components/event.dart';
import 'package:talacare/components/level.dart';
import 'helpers/directions.dart';
import 'package:talacare/components/hud/hud.dart';
import 'package:talacare/components/item_container.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/components/point.dart';

class TalaCare extends FlameGame with HasCollisionDetection {
  late final CameraComponent cam;
  Player player = Player(character: 'Adam');
  int playerHealth = 4;


  late final DPad dPad;
  @override
  late final World world;
  late AlignComponent eventAnchor;
  bool eventIsActive = false;
  int level = 1;
  int score = 0;
  
  final bool isWidgetTesting;
  TalaCare({this.isWidgetTesting = false});

  @override
  FutureOr<void> onLoad() async {
    if (!isWidgetTesting) {
      // Load all images into cache
      await images.loadAllImages();

      world = Level(player: player, levelName: 'Level-0$level');
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
      cam.viewport.add(Hud());
    }


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

  Future<void> enterDoor() async {
    level = 2;
    final double screenWidth = cam.viewport.size.x;

    ItemContainer itemContainer = ItemContainer(
      size: Vector2(screenWidth * 9 / 10, 100)
    );

    cam.viewport.add(itemContainer);
  }

}