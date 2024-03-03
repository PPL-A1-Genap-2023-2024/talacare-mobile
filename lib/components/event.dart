import 'dart:async';
import 'package:flame/components.dart';
import 'package:talacare/talacare.dart';
import 'package:talacare/components/level.dart';

class ActivityEvent extends SpriteAnimationComponent with HasGameRef<TalaCare>, ParentIsA<Level> {
  String variant;
  var timeElapsed = 0.0;

  ActivityEvent({super.position, this.variant = 'drawing'});
  
  @override
  FutureOr<void> onLoad() {
    var data = SpriteAnimationData.sequenced(
      textureSize: Vector2.all(300),
      amount: 2,
      stepTime: 0.5
    );
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Activity_Events/event_$variant.png'), data);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    timeElapsed += dt;
    if (timeElapsed >= 3) {
      parent.onActivityEnd(this);
    }
  }
}