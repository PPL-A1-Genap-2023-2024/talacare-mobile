import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/layout.dart';
import 'package:flutter/material.dart';
import 'package:talacare/components/event.dart';
import 'package:talacare/screens/game_2.dart';
import 'package:talacare/components/game_dialog.dart';
import 'package:talacare/screens/game_1.dart';
import 'package:talacare/helpers/data_sender.dart';
import 'components/food_minigame.dart';
import 'components/minigame.dart';
import 'components/transition.dart';
import 'helpers/directions.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/components/point.dart';

import 'helpers/dialog_reason.dart';

enum GameStatus { playing, victory, transition }

class TalaCare extends FlameGame
    with HasCollisionDetection, WidgetsBindingObserver, TapCallbacks {
  String playedCharacter;
  Player player = Player(character: 'tala');
  late CameraComponent camOne;
  late HouseAdventure gameOne;
  late int currentGame;
  late CameraComponent transitionCam;
  late Timer transitionCountdown;
  late int playerHealth;
  GameStatus status = GameStatus.playing;
  late GameDialog confirmation;
  late int score;
  late DateTime startTimestamp;
  late int totalTime;
  late bool haveSentRecap;
  @override
  late World world;
  late Minigame minigame;
  late AlignComponent eventAnchor;
  late AlignComponent confirmationAnchor;
  bool eventIsActive = false;
  bool confirmationIsActive = false;

  final bool isWidgetTesting;
  final String email;
  TalaCare(
      {this.isWidgetTesting = false,
      this.email = '',
      this.playedCharacter = 'tala'});

  @override
  void update(double dt) {
    if (status == GameStatus.transition) {
      transitionCountdown.update(dt);
    }
    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() async {
    startTimestamp = DateTime.now();
    totalTime = 0;
    haveSentRecap = false;
    if (!isWidgetTesting) {
      playerHealth = 4;
      score = 0;
      status = GameStatus.playing;
      await images.loadAllImages();
      checkingPlayedCharacter();
      currentGame = 1;
      world = gameOne = HouseAdventure(player: player, levelName: 'Level-01');
      camera = camOne = CameraComponent(world: gameOne);
      addAll([camera, world]);
    }
    return super.onLoad();
  }

  @override
  void pauseEngine() {
    super.pauseEngine();
    totalTime += DateTime.now().difference(startTimestamp).inMilliseconds;
  }

  @override
  void resumeEngine() {
    super.resumeEngine();
    startTimestamp = DateTime.now();
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    super.lifecycleStateChange(state);
    if (state == AppLifecycleState.paused && !paused) {
      pauseEngine();
    } else if (state == AppLifecycleState.resumed) {
      resumeEngine();
    }
  }

  void switchGame({reason = DialogReason.enterHospital}) {
    removeAll([camera, world]);

    final transition = GameTransition(player: player, reason: reason);
    transitionCam = CameraComponent(world: transition);
    addAll([transitionCam, transition]);
    status = GameStatus.transition;
    transitionCountdown = Timer(5, onTick: () {
      removeAll([transitionCam, transition]);
      status = GameStatus.playing;
      player.angle = 0;
      player.scale = Vector2.all(1);
      player.moveSpeed = 100;
      player.x = gameOne.hospitalDoor.x;
      player.y = gameOne.hospitalDoor.y + 50;
      player.direction = Direction.none;
      playerHealth = 4;
      player.collisionActive = true;

      switch (currentGame) {
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

  void switchGameLose({reason = DialogReason.enterHospital}) {
    removeAll([camera, world]);

    final transition = GameTransition(player: player, reason: reason);
    transitionCam = CameraComponent(world: transition);
    addAll([transitionCam, transition]);
    status = GameStatus.transition;
    transitionCountdown = Timer(5, onTick: () {
      removeAll([transitionCam, transition]);
      status = GameStatus.playing;
      player.angle = 0;
      player.scale = Vector2.all(1);
      player.moveSpeed = 56.25; //75% of 75% of 100
      player.x = gameOne.hospitalDoor.x;
      player.y = gameOne.hospitalDoor.y + 50;
      player.direction = Direction.none;
      playerHealth = 2; //half
      player.collisionActive = true;

      world = gameOne;
      camera = camOne;

      addAll([camera, world]);
    });
  }

  void checkingPlayedCharacter() {
    if (player.character != playedCharacter) {
      player = Player(character: playedCharacter);
    }
  }

  void changeDirection(Direction direction) {
    player.direction = direction;
  }

  Future<void> onActivityStart(ActivityPoint point) async {
    if (!eventIsActive) {
      world.remove(point);
      eventAnchor = AlignComponent(
          child: ActivityEvent(variant: point.variant),
          alignment: Anchor.center);
      camera.viewport.add(eventAnchor);
      eventIsActive = true;
    }
  }

  void onActivityEnd(ActivityEvent event, bool success) {
    if (eventIsActive) {
      eventAnchor.remove(event);
      camera.viewport.remove(eventAnchor);
      eventIsActive = false;
    }
    if(success){
      score += 1;
    }
    else{
      //add back and implement cooldown

    }
  }

  void startMinigame(ActivityPoint point) {
    world.remove(point);
    gameOne.hud.timerStarted = false;
    camOne.viewport.remove(gameOne.hud);
    gameOne.dPad.disable();
    player.direction = Direction.none;
    camOne.viewport.remove(gameOne.dpadAnchor);
    switch(point.variant) {
      case "eating":
        minigame = FoodMinigame(point:point);
        break;
      default:
        minigame = Minigame(point:point);
        break;
    }
    camOne.viewport.add(minigame);
  }

  void finishMinigame(ActivityPoint point, bool isVictory) {
    camOne.viewport.remove(minigame);
    gameOne.hud.timerStarted = true;
    camOne.viewport.add(gameOne.hud);
    gameOne.dPad.enable();
    camOne.viewport.add(gameOne.dpadAnchor);
    if (isVictory) {
      score += 1;
    } else {
      world.add(point);
      // implement cooldown here
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
    removeConfirmation();
    currentGame = 1;
    switchGame();
  }

  void loseHospital() {
    removeConfirmation();
    currentGame = 1;
    switchGameLose();
  }

  void victory() {
    if (!haveSentRecap) {
      sendRecap();
      haveSentRecap = true;
    }

    status = GameStatus.victory;
    if (!eventIsActive) {
      showConfirmation(DialogReason.gameVictory);
    }
  }

  void sendRecap() {
    totalTime += DateTime.now().difference(startTimestamp).inMilliseconds;
    sendData(email: email, totalTime: totalTime);
  }

  void playAgain() {
    removeConfirmation();
    removeAll([world, camera]);
    onLoad();
  }

  
}