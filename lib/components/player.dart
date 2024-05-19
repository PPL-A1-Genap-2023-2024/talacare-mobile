 import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:talacare/components/collision_block.dart';
import 'package:talacare/components/utils.dart';
import 'package:talacare/talacare.dart';

import '../helpers/directions.dart';

enum PlayerAnimationState {idle, run}
enum PlayerHealthState {healthy, pale}

class Player extends SpriteAnimationGroupComponent with HasGameRef<TalaCare>, ParentIsA<World> {
  String character;
  Player({super.position, required this.character});

  late SpriteAnimation idleAnimation;
  late SpriteAnimation runningAnimation;
  Vector2 initialSpawn = Vector2(0,0);
  final double stepTime = 0.25;
  double horizontalMovement = 0;
  double verticalMovement = 0;
  Direction direction = Direction.none;
  late double moveSpeed;
  Vector2 velocity = Vector2.zero();
  List<CollisionBlock> collisionBlocks = [];
  bool collisionActive = true;

  @override
  FutureOr<void> onLoad() {
    moveSpeed = 100;
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

  void changeCharacter(String name){
    character = name;
    _loadAllAnimations();
    add(RectangleHitbox());
  }

  void _loadAllAnimations() {

    // List of all animations
    animations = {
      (PlayerAnimationState.idle, PlayerHealthState.healthy, Direction.right): _spriteAnimation('idle_healthy', 0),
      (PlayerAnimationState.run, PlayerHealthState.healthy, Direction.right): _spriteAnimation('run_healthy', 0),
      (PlayerAnimationState.idle, PlayerHealthState.healthy, Direction.up): _spriteAnimation('idle_healthy', 6),
      (PlayerAnimationState.run, PlayerHealthState.healthy, Direction.up): _spriteAnimation('run_healthy', 6),
      (PlayerAnimationState.idle, PlayerHealthState.healthy, Direction.left): _spriteAnimation('idle_healthy', 12),
      (PlayerAnimationState.run, PlayerHealthState.healthy, Direction.left): _spriteAnimation('run_healthy', 12),
      (PlayerAnimationState.idle, PlayerHealthState.healthy, Direction.down): _spriteAnimation('idle_healthy', 18),
      (PlayerAnimationState.run, PlayerHealthState.healthy, Direction.down): _spriteAnimation('run_healthy', 18),
      (PlayerAnimationState.idle, PlayerHealthState.healthy, Direction.none): _spriteAnimation('idle_healthy', 18),
      (PlayerAnimationState.run, PlayerHealthState.healthy, Direction.none): _spriteAnimation('run_healthy', 18),
      (PlayerAnimationState.idle, PlayerHealthState.pale, Direction.right): _spriteAnimation('idle_pale', 0),
      (PlayerAnimationState.run, PlayerHealthState.pale, Direction.right): _spriteAnimation('run_pale', 0),
      (PlayerAnimationState.idle, PlayerHealthState.pale, Direction.up): _spriteAnimation('idle_pale', 6),
      (PlayerAnimationState.run, PlayerHealthState.pale, Direction.up): _spriteAnimation('run_pale', 6),
      (PlayerAnimationState.idle, PlayerHealthState.pale, Direction.left): _spriteAnimation('idle_pale', 12),
      (PlayerAnimationState.run, PlayerHealthState.pale, Direction.left): _spriteAnimation('run_pale', 12),
      (PlayerAnimationState.idle, PlayerHealthState.pale, Direction.down): _spriteAnimation('idle_pale', 18),
      (PlayerAnimationState.run, PlayerHealthState.pale, Direction.down): _spriteAnimation('run_pale', 18),
      (PlayerAnimationState.idle, PlayerHealthState.pale, Direction.none): _spriteAnimation('idle_pale', 18),
      (PlayerAnimationState.run, PlayerHealthState.pale, Direction.none): _spriteAnimation('run_pale', 18),
    };

    // Set current animation
    current = (PlayerAnimationState.idle, PlayerHealthState.healthy, Direction.none);
  }

  SpriteAnimation _spriteAnimation(String state, int start) {
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
        image: game.images.fromCache('Characters_free/${character}_${state}.png'),
        columns: 24,
        rows: 1);
    return spriteSheet.createAnimation(
        row: 0,
        stepTime: stepTime,
        from: start,
        to: start + 6
    );
  }

  void _updatePlayerState() {
    PlayerAnimationState playerAnimationState = PlayerAnimationState.idle;
    PlayerHealthState playerHealthState = PlayerHealthState.healthy;
    if (velocity.x != 0 || velocity.y != 0) {
      playerAnimationState = PlayerAnimationState.run;
    }
    if (game.playerHealth <= 2) {
      playerHealthState = PlayerHealthState.pale;
    }
    current = (playerAnimationState, playerHealthState, direction);
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
    if (collisionActive) {
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
              position = initialSpawn;
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

}