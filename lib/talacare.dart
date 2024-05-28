import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/layout.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:talacare/components/clicker_minigame.dart';
import 'package:talacare/components/transaparent_layer.dart';
import 'package:talacare/helpers/time_limit.dart';
import 'package:talacare/helpers/cooldown_timer_manager.dart';
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
  late bool haveSentRecap;
  @override
  late World world;
  late Minigame minigame;
  late AlignComponent confirmationAnchor;
  bool eventIsActive = false;
  bool confirmationIsActive = false;
  late CooldownTimerManager cooldownTimerManager;
  final double cooldownDuration = 10;
  late TransparentLayer transparentLayer;
  int totalTime = 0;

  bool isWidgetTesting;
  final String email;
  int remainingTime;
  BuildContext? context;
  TalaCare(
      {this.isWidgetTesting = false,
        this.email = '',
        this.playedCharacter = 'tala',
        this.remainingTime = 1,
        this.context});

  @override
  void update(double dt) {
    if (status == GameStatus.transition) {
      transitionCountdown.update(dt);
    }
    checkRemainingTime();
    cooldownTimerManager.update(dt);

    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() async {
    startTimestamp = DateTime.now();
    totalTime = 0;
    haveSentRecap = false;
    cooldownTimerManager = CooldownTimerManager(cooldownDuration: cooldownDuration);

    playerHealth = 4;
    score = 0;
    status = GameStatus.playing;
    if (!isWidgetTesting) {
      await images.loadAllImages();
      checkingPlayedCharacter();
      currentGame = 1;
      world = gameOne = HouseAdventure(player: player, levelName: 'Level-01');
      camera = camOne = CameraComponent(world: gameOne);
      addAll([camera, world]);
      transparentLayer = TransparentLayer()
        ..size = size
        ..position = Vector2.zero();
    }
    return super.onLoad();
  }

  @override
  void pauseEngine() {
    totalTime += DateTime.now().difference(startTimestamp).inMilliseconds;
    remainingTime -= (totalTime / 1000).round();
    super.pauseEngine();
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

  void checkRemainingTime() {
    int timeDiff = DateTime.now().difference(startTimestamp).inSeconds;
    if (timeDiff >= remainingTime && !confirmationIsActive) {
      sendRecap();
      showConfirmation(DialogReason.timeLimitExceeded);
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
    player = Player(character: playedCharacter);
  }

  void changeDirection(Direction direction) {
    player.direction = direction;
  }

  void enableDarkBackground() {
    gameOne.hud.timerStarted = false;
    gameOne.hud.isVisible = false;
    player.direction = Direction.none;
    gameOne.dPad.disable();
    gameOne.dPad.isVisible = false;
    camera.viewport.add(transparentLayer);
  }

  void disableDarkBackground() {
    gameOne.hud.timerStarted = true;
    gameOne.hud.isVisible = true;
    gameOne.dPad.enable();
    gameOne.dPad.isVisible = true;
    camera.viewport.remove(transparentLayer);
  }

  void startMinigame(ActivityPoint point) {
    gameOne.remove(point);
    switch (point.variant) {
      case "eating":
        minigame = FoodMinigame(point: point);
        break;
      default:
        minigame = ClickerMinigame(variant: point.variant, point: point);
        break;
    }
    enableDarkBackground();
    camOne.viewport.add(minigame);
  }

  void finishMinigame(ActivityPoint point, bool isVictory) {
    camOne.viewport.remove(minigame);
    disableDarkBackground();
    if (isVictory) {
      score += 1;
    } else {
      cooldownTimerManager.startCooldown(point, () {
        gameOne.add(point);
      });
    }
  }

  void showConfirmation(DialogReason reason) {
    if (!confirmationIsActive) {
      confirmation = GameDialog(reason: reason);
      confirmationIsActive = true;
      confirmationAnchor = AlignComponent(
        child: confirmation,
        alignment: Anchor.center,
      );
      enableDarkBackground();
      camera.viewport.add(confirmationAnchor);
    }
  }

  void removeConfirmation() {
    camera.viewport.remove(confirmationAnchor);
    disableDarkBackground();
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
    saveUsageData(newDurationInMillisecond: totalTime);
  }

  void exitToMainMenu(BuildContext? context) {
    if (context != null) {
      if(!isWidgetTesting)FlameAudio.bgm.stop();
      Navigator.of(context).pop();
    }
  }

  void playAgain() {
    removeConfirmation();
    removeAll([world, camera]);
    onLoad();
  }
}
