import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:talacare/talacare.dart';

class ActivityEvent extends SpriteComponent with HasGameRef<TalaCare>, TapCallbacks {
  double timeElapsed = 0.0;
  String variant;
  late List<Sprite> eventSprites;

  ActivityEvent({this.variant = 'drawing'});

  List<Sprite> prepareSprites(String imageFile){
    var data = SpriteAnimationData.sequenced(
        textureSize: Vector2.all(350),
        amount: 2,
        stepTime: 0.5
    );
    SpriteAnimation animation = SpriteAnimation.fromFrameData(game.images.fromCache(imageFile), data);

    // Split all Frames produced from the Image
    List<Sprite> animationSprites = [];
    for (int i = 0; i < animation.frames.length; i++) {
      animationSprites.add(animation.frames[i].sprite);
    }

    return animationSprites;
  }

  @override
  FutureOr<void> onLoad() {
    var fileName = 'Activity_Events/event_${variant}_${game.playedCharacter}.png';
    eventSprites = prepareSprites(fileName);

    // Set Default Sprite to Show
    sprite = eventSprites[0];

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    timeElapsed += dt;
    // Event Duration
    if (timeElapsed >= 10) {
      game.onActivityEnd(this);
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    // Implement Mechanics

  }
}

