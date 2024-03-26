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
import 'package:talacare/components/player.dart';
import 'package:talacare/components/point.dart';

import 'helpers/hospital_reason.dart';

class TalaCare extends FlameGame with HasCollisionDetection {
  late final CameraComponent camOne;
  late final CameraComponent camTwo;
  late HouseAdventure gameOne;
  late HospitalPuzzle gameTwo;
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

  
  final bool isWidgetTesting;
  TalaCare({this.isWidgetTesting = false});

  @override
  FutureOr<void> onLoad() async {
    if (!isWidgetTesting) {
      // Load all images into cache
      await images.loadAllImages();
      gameOne = HouseAdventure(player: player, levelName: 'Level-01');
      camOne = CameraComponent(world: gameOne);

      gameTwo = HospitalPuzzle(player: player);
      camTwo = CameraComponent(world: gameTwo);

      loadGameOne();
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
      camOne.viewport.add(eventAnchor);
      eventIsActive = true;
      score += 1;
    }
  }

  void onActivityEnd(ActivityEvent event) {
    if (eventIsActive) {
      eventAnchor.remove(event);
      camOne.viewport.remove(eventAnchor);
      eventIsActive = false;
    }
  }


  Future<void> loadGameOne() async {
    currentGame = 1;
    world = gameOne;
    addAll([camOne, world]);
  }

  Future<void> loadGameTwo() async {
    currentGame = 2;
    world = gameTwo;
    addAll([camTwo, world]);
  }


  void confirmHospital(HospitalReason reason) {
    if (!confirmationIsActive) {
      confirmation = HospitalConfirmation(reason: reason);
      confirmationIsActive = true;
      gameOne.dPad.disable();
      confirmationAnchor = AlignComponent(
        child: confirmation,
        alignment: Anchor.center,
      );
      camOne.viewport.add(confirmationAnchor);
    }
  }

  void removeConfirmation() {
    camOne.viewport.remove(confirmationAnchor);
    gameOne.dPad.enable();
    confirmationIsActive = false;
  }

  void yesToHospital() {
    removeConfirmation();
    removeAll([camOne, world]);
    gameTwo.reason = HospitalReason.playerEnter;
    loadGameTwo();
  }

  void noToHospital() {
    removeConfirmation();
    player.y = player.y + 50;

  }

  void okayHospital() {
    removeConfirmation();
    removeAll([camOne, world]);
    gameTwo.reason = HospitalReason.lowBlood;
    loadGameTwo();
  }

  void exitHospital() {
    removeAll([camTwo, world]);
    loadGameOne();
    player.x = gameOne.hospitalDoor.x;
    player.y = gameOne.hospitalDoor.y + 50;
    playerHealth = 4;
    player.moveSpeed = 100;
    Hud hud = camOne.viewport.children.query<Hud>().first;
    hud.healthDurationChecker = hud.healthDuration;
  }

}