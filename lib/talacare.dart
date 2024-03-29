import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/layout.dart';
import 'package:talacare/components/event.dart';
import 'package:talacare/components/game_2.dart';
import 'package:talacare/components/hospital_confirmation.dart';
import 'package:talacare/components/game_1.dart';
import 'helpers/directions.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/components/point.dart';

import 'helpers/hospital_reason.dart';
enum GameStatus {playing, paused, victory}

class TalaCare extends FlameGame with HasCollisionDetection {
  late final CameraComponent camOne;
  late HouseAdventure gameOne;
  Player player = Player(character: 'Adam');
  int playerHealth = 4;
  GameStatus status = GameStatus.playing;

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
      currentGame = 1;
      switchGame(firstLoad:true);
    }


    return super.onLoad();
  }

  void switchGame({reason, firstLoad=false}) {
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

  void okayHospital() {
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
  }

  void victory() {
    status = GameStatus.victory;
  }

}