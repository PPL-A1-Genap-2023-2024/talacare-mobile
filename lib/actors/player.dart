import 'dart:async';
import 'package:flame/components.dart';
import 'package:talacare/talacare.dart';

enum PlayerState { idle, running }

enum PlayerDirection { up, down, right, left, none }

class Player extends SpriteAnimationGroupComponent with HasGameRef<TalaCare> {
  String character;
  Player({position, required this.character}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.1;

  PlayerDirection playerDirection = PlayerDirection.right;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
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
  
  void _updatePlayerMovement(double dt) {
    double dirX = 0.0;
    double dirY = 0.0;
    switch (playerDirection) {
      case PlayerDirection.left:
        current = PlayerState.running;
        dirX -= moveSpeed;
        break;
      case PlayerDirection.right:
        current = PlayerState.running;
        dirX += moveSpeed;
        break;
      case PlayerDirection.up:
        current = PlayerState.running;
        dirY -= moveSpeed;
        break;
      case PlayerDirection.down:
        current = PlayerState.running;
        dirY += moveSpeed;
        break;
      case PlayerDirection.none:
        current = PlayerState.idle;
        break;
      default:
    }

    velocity = Vector2(dirX, dirY);
    position += velocity * dt;
  }
}