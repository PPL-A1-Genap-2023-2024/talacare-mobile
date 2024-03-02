import 'dart:async';
import 'package:flame/components.dart';
import 'package:talacare/components/collision_block.dart';
import 'package:talacare/components/utils.dart';
import 'package:talacare/talacare.dart';

import '../helpers/directions.dart';

enum PlayerState { idle, running }

class Player extends SpriteAnimationGroupComponent with HasGameRef<TalaCare> {
  String character;
  Player({super.position, this.character = 'Adam'});

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.1;
  double horizontalMovement = 0;
  double verticalMovement = 0;
  Direction direction = Direction.none;
  bool playerFlipped = false;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMovement(dt);
    _checkCollisions();
    super.update(dt);
  }


  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('idle_anim', 24);
    runningAnimation = _spriteAnimation('run', 24);

    // List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
    };

    // Set current animation
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Characters_free/${character}_${state}_16x16.png'), 
      SpriteAnimationData.sequenced(
        amount: amount, 
        stepTime: stepTime, 
        textureSize: Vector2(16, 32)
      )
    );
  }
  
  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x != 0 || velocity.y != 0) {
      playerState = PlayerState.running;
    }
    current = playerState;
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
          // Left wall
          if (block.type == WallTypes.outerLeft){
            position.x = block.x + block.width;
          }
          // Bottom wall
          else if (block.type == WallTypes.outerBottom) {
            position.y = block.y - height;
          }
          // Right wall
          else if (block.type == WallTypes.outerRight) {
            position.x = block.x - width;
          }
          // Top wall
          else if (block.type == WallTypes.outerTop) {
            position.y = block.y + block.height;
          }
          else {
            // Back to spawn point
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