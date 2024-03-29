import 'dart:async';
import 'dart:math' as math;
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/layout.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/talacare.dart';

import '../helpers/dialog_reason.dart';
import '../helpers/directions.dart';

class HospitalPuzzle extends World with HasGameRef<TalaCare> {
  final Player player;
  final DialogReason reason;
  late SpriteAnimationComponent nurse;
  bool nurseTransition = false;
  late TiledComponent transition;
  late TiledComponent level;
  late Timer transitionCountdown;
  late AlignComponent playButtonAnchor;
  bool finished = false;

  HospitalPuzzle({required this.player, required this.reason});



  @override
  FutureOr<void> onLoad() async {
    gameRef.camera.viewfinder.anchor = Anchor.center;
    gameRef.camera.viewport = FixedAspectRatioViewport(aspectRatio: 0.5625);
    transition = await TiledComponent.load("Transition_01.tmx", Vector2.all(16));
    transition.priority = -1;
    nurse = SpriteAnimationComponent();
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
        image: game.images.fromCache('Hospital/nurse.png'),
        columns: 6,
        rows: 1);
    nurse.animation = spriteSheet.createAnimation(
        row: 0,
        stepTime: 0.1,
        from: 0,
        to: 5
    );

    startTransition();
    transitionCountdown = Timer(5, onTick: () {
      loadGame();
    });

    level = await TiledComponent.load("Level-02.tmx", Vector2.all(16));
    level.anchor = Anchor.center;

    final newButton = SpriteButtonComponent();
    newButton.button = await game.loadSprite('Dialog/okay.png');
    newButton.buttonDown = await game.loadSprite('Dialog/okay_pressed.png');
    newButton.onPressed = removeBeforeFinish;
    playButtonAnchor = AlignComponent(
      child: newButton,
      alignment: Anchor.center,
    );



    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (nurseTransition) {
      double movement = 100 * dt;
      nurse.position.x += movement;
      player.position.x += movement;
    }
    transitionCountdown.update(dt);
    super.update(dt);
  }

  void startTransition() {
    add(transition);

    final spawnPointsLayer = transition.tileMap.getLayer<ObjectGroup>('SpawnPoint');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        if (spawnPoint.name == 'Player') {
          player.scale = Vector2.all(4);
          player.collisionActive = false;
          if (finished | (reason == DialogReason.enterHospital)) {
            player.direction = (finished) ? Direction.left : Direction.right;
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            gameRef.camera.follow(player);
          } else {

            nurse.scale = Vector2.all(4);
            nurse.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(nurse);



            player.direction = Direction.right;
            player.moveSpeed = 0;
            player.priority = 1;
            player.angle = -math.pi/2;
            player.position = Vector2(spawnPoint.x + 30, spawnPoint.y + 90);
            add(player);
            gameRef.camera.follow(nurse);

            nurseTransition = true;
          }
        }
      }
    }
  }



  Future<void> loadGame() async {
    if (nurseTransition) {
      remove(nurse);
      nurseTransition = false;
      player.moveSpeed = 100;
      player.angle = 0;
    }
    remove(player);
    remove(transition);
    add(level);
    gameRef.camera.viewport.add(playButtonAnchor);
  }

  void removeBeforeFinish() {
    remove(level);
    gameRef.camera.viewport.remove(playButtonAnchor);
    finishGame();
  }

  void finishGame() {
    finished = true;
    startTransition();
    transitionCountdown = Timer(5, onTick: () {
      player.scale = Vector2.all(1);
      player.direction = Direction.none;
      gameRef.exitHospital();
    });
  }
}