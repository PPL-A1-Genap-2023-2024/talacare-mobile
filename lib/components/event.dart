import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:talacare/talacare.dart';

class ActivityEvent extends SpriteComponent with HasGameRef<TalaCare>, TapCallbacks {
  double timeElapsed = 0.0;
  String variant;
  late List<Sprite> eventSprites;
  int currentSpriteIndex = 0;
  double progress = 0.0;
  final double progressIncrement = 0.1;
  late bool success;

  ActivityEvent({this.variant = 'drawing'});

  List<Sprite> prepareSprites(String imageFile) {
    var data = SpriteAnimationData.sequenced(
      textureSize: Vector2.all(350),
      amount: 2,
      stepTime: 0.5,
    );
    SpriteAnimation animation = SpriteAnimation.fromFrameData(game.images.fromCache(imageFile), data);

    // Split all frames produced from the image
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

    // Set default sprite to show
    sprite = eventSprites[0];

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    timeElapsed += dt;
    // Event duration
    if (timeElapsed >= 10) {
      success = false;
      game.onActivityEnd(this, success);
    }
  }

  @override
  bool onTapUp(TapUpEvent event) {
    currentSpriteIndex = (currentSpriteIndex + 1) % 2;
    sprite = eventSprites[currentSpriteIndex];

    progress += progressIncrement;

    if (progress >= 1.0) {
      success = true;
      game.onActivityEnd(this, success);
    }

    return true;
  }
}
