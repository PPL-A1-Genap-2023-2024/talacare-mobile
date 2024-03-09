import 'dart:async';
import 'package:flame/components.dart';
import 'package:talacare/talacare.dart';

enum ActivityState { idle, busy }

class Activity extends SpriteAnimationGroupComponent with HasGameRef<TalaCare> {
  String character;
  Activity({position, required this.character}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  final double stepTime = 0.1;

  ActivityState activityState = ActivityState.idle;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // No movement update for Activity
    super.update(dt);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('idle_anim', 24);

    // List of all animations
    animations = {
      ActivityState.idle: idleAnimation,
    };

    // Set current animation
    current = ActivityState.idle;
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
}