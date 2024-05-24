import 'dart:async';
import 'dart:math' as math;
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:talacare/components/mother.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/talacare.dart';

import '../helpers/dialog_reason.dart';
import '../helpers/directions.dart';

class GameTransition extends World with HasGameRef<TalaCare> {
  final Player player;
  final DialogReason reason;
  late Mother mother;
  late SpriteAnimationComponent nurse;
  bool nurseTransition = false;
  late TiledComponent transition;

  GameTransition({required this.player, required this.reason});



  @override
  FutureOr<void> onLoad() async {
    gameRef.transitionCam.viewfinder.anchor = Anchor.center;
    gameRef.transitionCam.viewport = FixedAspectRatioViewport(aspectRatio: 0.5625);
    transition = await TiledComponent.load("Transition_01.tmx", Vector2.all(16));
    transition.priority = -1;
    nurse = SpriteAnimationComponent();
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
        image: game.images.fromCache('Hospital/nurse_with_bed.png'),
        columns: 3,
        rows: 1);
    nurse.animation = spriteSheet.createAnimation(
        row: 0,
        stepTime: 0.25,
        from: 0,
        to: 3
    );

    add(transition);

    final spawnPointsLayer = transition.tileMap.getLayer<ObjectGroup>('SpawnPoint');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        if (spawnPoint.name == 'Player') {
          player.scale = Vector2.all(3.5);
          player.collisionActive = false;
          if ((gameRef.currentGame == 1) | (reason == DialogReason.enterHospital)) {
            player.direction = (gameRef.currentGame == 1) ? Direction.left : Direction.right;
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            player.moveSpeed = 100;
            add(player);
            gameRef.transitionCam.follow(player);
          } else {

            nurse.scale = Vector2.all(3.5);
            nurse.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(nurse);

            player.direction = Direction.right;
            player.moveSpeed = 0;
            player.priority = 1;
            player.angle = -math.pi/2;
            player.position = Vector2(spawnPoint.x + 45, spawnPoint.y + 95);
            add(player);
            gameRef.transitionCam.follow(nurse);

            nurseTransition = true;
          }
        } else if (spawnPoint.name == 'Mother') {
          mother = Mother();
          mother.direction = (gameRef.currentGame == 1) ? Direction.left : Direction.right;
          mother.scale = Vector2.all(3.5);
          mother.position = Vector2(spawnPoint.x, spawnPoint.y);
          add(mother);
        }
      }
    }

    return super.onLoad();

  }

  @override
  void update(double dt) {
    double movement = 100 * dt;
    if (nurseTransition) {
      nurse.position.x += movement;
      player.position.x += movement;
    }
    if (gameRef.currentGame == 1) {
      mother.position.x -= movement;
    } else {
      mother.position.x += movement;
    }
    super.update(dt);
  }



}