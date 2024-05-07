import 'dart:async';
import 'package:flame/components.dart';
import 'package:talacare/talacare.dart';

class ActivityEvent extends SpriteAnimationComponent with HasGameRef<TalaCare> {
  double timeElapsed = 0.0;
  String variant;

  ActivityEvent({this.variant = 'drawing'});
  
  @override
  FutureOr<void> onLoad() {
    var data = SpriteAnimationData.sequenced(
      textureSize: Vector2.all(350),
      amount: 2,
      stepTime: 0.5
    );
    var fileName = 'Activity_Events/event_${variant}_${game.playedCharacter}.png';
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(fileName), data);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    timeElapsed += dt;
    if (timeElapsed >= 3) {
      game.onActivityEnd(this);
    }
  }
}