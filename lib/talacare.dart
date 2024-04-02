import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/layout.dart';
import 'package:talacare/components/event.dart';
import 'package:talacare/components/game_2.dart';
import 'package:talacare/components/game_dialog.dart';
import 'package:talacare/components/game_1.dart';
import 'components/transition.dart';
import 'helpers/directions.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/components/point.dart';

import 'helpers/dialog_reason.dart';
enum GameStatus {playing, victory, transition}

class TalaCare extends FlameGame with HasCollisionDetection {
  late CameraComponent camOne;
  late HouseAdventure gameOne;
  late int currentGame;
  late CameraComponent transitionCam;
  late Timer transitionCountdown;
  late Player player;
  late int playerHealth;
  GameStatus status = GameStatus.playing;
  late GameDialog confirmation;
  late int score;
  @override
  late World world;
  late AlignComponent eventAnchor;
  late AlignComponent confirmationAnchor;
  bool eventIsActive = false;
  bool confirmationIsActive = false;
  
  final bool isWidgetTesting;
  TalaCare({this.isWidgetTesting = false});



  @override
  void update(double dt) {
    // TODO: implement update
    if (status==GameStatus.transition) {
      transitionCountdown.update(dt);
    }
    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() async {
    if (!isWidgetTesting) {
      playerHealth = 4;
      score = 0;
      status = GameStatus.playing;
      await images.loadAllImages();
      player = Player(character: 'Adam');
      currentGame = 1;
      world = gameOne = HouseAdventure(player: player, levelName: 'Level-01');
      camera = camOne = CameraComponent(world: gameOne);
      addAll([camera, world]);
    }
    return super.onLoad();
  }


  void switchGame({reason=DialogReason.enterHospital}) {

    removeAll([camera, world]);

    final transition = GameTransition(player: player, reason: reason);
    transitionCam = CameraComponent(world: transition);
    addAll([transitionCam, transition]);
    status = GameStatus.transition;
    transitionCountdown = Timer(5, onTick: () {
      removeAll([transitionCam, transition]);
      status = GameStatus.playing;
      player.angle = 0;
      player.scale=Vector2.all(1);
      player.moveSpeed = 100;
      player.x = gameOne.hospitalDoor.x;
      player.y = gameOne.hospitalDoor.y + 50;
      player.direction = Direction.none;
      playerHealth = 4;
      player.collisionActive = true;

      switch(currentGame) {
        case 1:
          world = gameOne;
          camera = camOne;
        case 2:
          world = HospitalPuzzle(player: player);
          camera = CameraComponent(world: world);
      }
      addAll([camera, world]);

    });


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

  void showConfirmation(DialogReason reason) {
    if (!confirmationIsActive) {
      confirmation = GameDialog(reason: reason);
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


  void goToHospital(reason) {

    removeConfirmation();
    currentGame = 2;
    switchGame(reason: reason);
  }

  void noToHospital() {
    removeConfirmation();
    player.y = player.y + 50;
  }


  void exitHospital() {
    currentGame = 1;
    switchGame();
  }

  void victory() {
    status = GameStatus.victory;
    if (!eventIsActive) {
      showConfirmation(DialogReason.gameVictory);
    }
  }

  void playAgain() {

  }
}