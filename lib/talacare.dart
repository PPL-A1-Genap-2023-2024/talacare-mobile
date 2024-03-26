import 'dart:async';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/layout.dart';
import 'package:flame/palette.dart';
import 'package:talacare/components/dpad.dart';
import 'package:talacare/components/event.dart';
import 'package:talacare/components/hospital_confirmation.dart';
import 'package:talacare/components/level.dart';
import 'helpers/directions.dart';
import 'package:talacare/components/hud/hud.dart';
import 'package:talacare/components/draggable_container.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/components/point.dart';
import 'package:talacare/components/silhouette_container.dart';

import 'helpers/hospital_reason.dart';

class TalaCare extends FlameGame with HasCollisionDetection {
  late final CameraComponent cam;
  Player player = Player(character: 'Adam');
  int playerHealth = 4;


  late final DPad dPad;
  late HospitalConfirmation confirmation;
  @override
  late final World world;
  late AlignComponent eventAnchor;
  late AlignComponent confirmationAnchor;
  late AlignComponent dpadAnchor;
  bool eventIsActive = false;
  bool confirmationIsActive = false;
  int level = 1;
  int score = 0;

  late Hud hud;
  late DraggableContainer draggableContainer;
  late RectangleComponent game2Background;
  late SilhouetteContainer silhouetteContainer;
  int game2Score = 0;
  
  final bool isWidgetTesting;
  TalaCare({this.isWidgetTesting = false});

  @override
  FutureOr<void> onLoad() async {
    if (!isWidgetTesting) {
      // Load all images into cache
      await images.loadAllImages();
      loadLevel();
      loadLevelOneComponents();
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

  Future<void> loadLevel() async {
    world = Level(player: player, levelName: 'Level-0$level');
    add(world);
  }

  Future<void> loadLevelOneComponents() async {
    cam = CameraComponent(world: world);
    cam.viewfinder.anchor = Anchor.center;
    cam.viewfinder.zoom = 3;
    cam.viewport = FixedAspectRatioViewport(aspectRatio: 0.5625);

    cam.follow(player);

    dPad = DPad();
    dpadAnchor = AlignComponent(
      child: dPad,
      alignment: Anchor.bottomCenter,
    );
    cam.viewport.add(dpadAnchor);
    add(cam);
    hud = Hud();
    cam.viewport.add(hud);
  }


  void enterHospital(HospitalReason reason) {
    if (!confirmationIsActive) {
      confirmation = HospitalConfirmation(reason: reason);
      confirmationIsActive = true;
      dPad.disable();
      confirmationAnchor = AlignComponent(
        child: confirmation,
        alignment: Anchor.center,
      );
      // cam.viewport.remove(dpadAnchor);
      cam.viewport.add(confirmationAnchor);
    }
  }

  Future<void> yesToHospital() async {
    level = 2;
    loadLevelTwoComponents();
  }

  void noToHospital() {
    cam.viewport.remove(confirmationAnchor);
    player.y = player.y + 50;
    dPad.enable();
    confirmationIsActive = false;
  }

  Future<void> okayHospital() async {
    level = 2;
    loadLevelTwoComponents();
  }

  Future<void> loadLevelTwoComponents() async {
    cam.viewport.remove(hud);

    game2Background = RectangleComponent(
      paint: BasicPalette.lightBlue.paint(),
      size: cam.viewport.size
    );
    silhouetteContainer = SilhouetteContainer(
      position: Vector2(cam.viewport.size.x / 2, cam.viewport.size.y * 2 / 5),
      size: Vector2.all(cam.viewport.size.x * 9 / 10)
    );
    draggableContainer = DraggableContainer(
      position: Vector2(cam.viewport.size.x / 2, cam.viewport.size.y * 4 / 5),
      size: Vector2(cam.viewport.size.x * 9 / 10, 100)
    );

    cam.viewport.add(game2Background);
    cam.viewport.add(silhouetteContainer);
    cam.viewport.add(draggableContainer);
  }

}