import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/layout.dart';
import 'package:talacare/components/event.dart';
import 'package:talacare/components/game_2.dart';
import 'package:talacare/components/hospital_confirmation.dart';
import 'package:talacare/components/game_1.dart';
import 'components/hud/hud.dart';
import 'helpers/directions.dart';
import 'package:talacare/components/draggable_container.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/components/point.dart';
import 'package:talacare/components/silhouette_container.dart';

import 'helpers/hospital_reason.dart';

class TalaCare extends FlameGame with HasCollisionDetection {
  late final CameraComponent camOne;
  late HouseAdventure gameOne;
  Player player = Player(character: 'Adam');
  int playerHealth = 4;


  late HospitalConfirmation confirmation;
  @override
  late World world;
  late AlignComponent eventAnchor;
  late AlignComponent confirmationAnchor;
  bool eventIsActive = false;
  bool confirmationIsActive = false;

  late int currentGame;
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
      await images.loadAllImages();
      gameOne = HouseAdventure(player: player, levelName: 'Level-01');
      camOne = CameraComponent(world: gameOne);
      currentGame = 1;
      switchGame(firstLoad:true);
    }
    return super.onLoad();
  }

  FutureOr<void> switchGame({reason, firstLoad=false}) async {
    if (!firstLoad) {
      removeAll([camera, world]);
    }
    switch(currentGame) {
      case 1:
        world = gameOne;
        camera = camOne;
      case 2:
        world = HospitalPuzzle(player: player, reason: reason);
        camera = CameraComponent(world: world);
    }
    addAll([camera, world]);
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
      camera.viewport.add(eventAnchor);
      eventIsActive = true;
      score += 1;
    }
  }

  void onActivityEnd(ActivityEvent event) {
    if (eventIsActive) {
      eventAnchor.remove(event);
      camera.viewport.remove(eventAnchor);
      eventIsActive = false;
    }
  }

  void showConfirmation(HospitalReason reason) {
    if (!confirmationIsActive) {
      confirmation = HospitalConfirmation(reason: reason);
      confirmationIsActive = true;
      gameOne.dPad.disable();
      confirmationAnchor = AlignComponent(
        child: confirmation,
        alignment: Anchor.center,
      );
      camera.viewport.add(confirmationAnchor);
    }
  }

  void removeConfirmation() {
    camera.viewport.remove(confirmationAnchor);
    gameOne.dPad.enable();
    confirmationIsActive = false;
  }

  void yesToHospital() {
    removeConfirmation();
    currentGame = 2;
    switchGame(reason: HospitalReason.playerEnter);
  }

  void noToHospital() {
    removeConfirmation();
    player.y = player.y + 50;
  }

  Future<void> okayHospital() async {
    removeConfirmation();
    currentGame = 2;
    switchGame(reason: HospitalReason.lowBlood);
  }

  void exitHospital() {
    currentGame = 1;
    switchGame();
    player.x = gameOne.hospitalDoor.x;
    player.y = gameOne.hospitalDoor.y + 50;
    playerHealth = 4;
    player.moveSpeed = 100;
    Hud hud = camera.viewport.children.query<Hud>().first;
    hud.healthDurationChecker = hud.healthDuration;
  }
}