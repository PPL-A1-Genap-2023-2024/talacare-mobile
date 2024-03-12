import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:talacare/components/collision_block.dart';
import 'package:talacare/components/level.dart';
import 'package:talacare/components/utils.dart';
import 'package:talacare/talacare.dart';

import '../helpers/directions.dart';

enum PlayerState { idle, running }

class Player extends SpriteAnimationGroupComponent with HasGameRef<TalaCare>, ParentIsA<Level> {
  String character;
  Player({super.position, this.character = 'Adam'});

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.1;
  double horizontalMovement = 0;
  double verticalMovement = 0;
  Direction direction = Direction.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerState();
    if (!game.eventIsActive) {
      _updatePlayerMovement(dt);
      _checkCollisions();
    }
    super.update(dt);
  }

  void _loadAllAnimations() {

    // List of all animations
    animations = {
      (PlayerState.idle, Direction.right): _spriteAnimation('idle_anim', 0),
      (PlayerState.running, Direction.right): _spriteAnimation('run', 0),
      (PlayerState.idle, Direction.up): _spriteAnimation('idle_anim', 6),
      (PlayerState.running, Direction.up): _spriteAnimation('run', 6),
      (PlayerState.idle, Direction.left): _spriteAnimation('idle_anim', 12),
      (PlayerState.running, Direction.left): _spriteAnimation('run', 12),
      (PlayerState.idle, Direction.down): _spriteAnimation('idle_anim', 18),
      (PlayerState.running, Direction.down): _spriteAnimation('run', 18),
      (PlayerState.idle, Direction.none): _spriteAnimation('idle_anim', 18),
      (PlayerState.running, Direction.none): _spriteAnimation('run', 18),
    };

    // Set current animation
    current = (PlayerState.idle, Direction.none);
  }

  SpriteAnimation _spriteAnimation(String state, int start) {
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
        image: game.images.fromCache('Characters_free/${character}_${state}_16x16.png'),
        columns: 24,
        rows: 1);
    return spriteSheet.createAnimation(
        row: 0,
        stepTime: stepTime,
        from: start,
        to: start + 5
    );
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x != 0 || velocity.y != 0) {
      playerState = PlayerState.running;
    }
    current = (playerState, direction);
  }

  void _updatePlayerMovement(double dt) {
    horizontalMovement = 0;
    verticalMovement = 0;
    horizontalMovement += (direction == Direction.left ? -1 : 0);
    horizontalMovement += (direction == Direction.right ? 1 : 0);
    verticalMovement += (direction == Direction.up ? -1 : 0);
    verticalMovement += (direction == Direction.down ? 1 : 0);

    velocity.x = horizontalMovement * moveSpeed;
    velocity.y = verticalMovement * moveSpeed;
    position.x += velocity.x * dt;
    position.y += velocity.y * dt;
  }

  void _checkCollisions() {
    for (final block in collisionBlocks) {
      if (checkCollision(this, block)) {
        // Colliding without moving
        if (velocity.x == 0 && velocity.y == 0) {
          if (block.position.x == 0 && block.height == 640){
            position.x = block.x + block.width;
          }
          else if (block.position.y == 0 && block.width == 368) {
            position.y = block.y + block.height;
          }
          else if (block.position.x == 352 && block.height == 640) {
            position.x = block.x - width;
          }
          else if (block.position.y == 624 && block.width == 368) {
            position.y = block.y - height;
          }
          else {
            position = Vector2(176, 576);
          }
        }

        // Colliding while moving right
        if (velocity.x > 0) {
          position.x = block.x - width;
          velocity.x = 0;
        }
        // Colliding while moving left
        else if (velocity.x < 0) {
          position.x = block.x + block.width;
          velocity.x = 0;
        }

        // Colliding while moving down
        if (velocity.y > 0) {
          position.y = block.y - height;
          velocity.y = 0;
        }
        // Colliding while moving up
        else if (velocity.y < 0) {
          position.y = block.y + block.height;
          velocity.y = 0;
        }
      }
    }
  }

}