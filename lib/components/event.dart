import 'dart:async';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:talacare/components/progress_bar.dart';
import 'package:talacare/talacare.dart';

class ActivityEvent extends SpriteComponent with HasGameRef<TalaCare>, TapCallbacks {
  double timeElapsed = 0.0;
  String variant;
  late List<Sprite> eventSprites;
  int currentSpriteIndex = 0;
  int progress = 0;
  final int progressIncrement = 1;
  late bool success;
  late ProgressBar progressBar;
  late final Viewport screen;

  ActivityEvent({this.variant = 'drawing'});

  List<Sprite> prepareSprites(String imageFile) {
    var data = SpriteAnimationData.sequenced(
      textureSize: Vector2.all(350),
      amount: 2,
      stepTime: 0.5,
    );
    SpriteAnimation animation = SpriteAnimation.fromFrameData(game.images.fromCache(imageFile), data);

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

    sprite = eventSprites[0];

    screen = gameRef.camera.viewport;

    progressBar = ProgressBar(
      progress: 0.0,
      width: screen.size.x * 0.8,
      height: 30,
    );
    progressBar.position = Vector2(
      (screen.size.x - progressBar.width) / 2,
      (screen.size.y - progressBar.height) / 400
    );
    add(progressBar);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    timeElapsed += dt;
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
    progressBar.updateProgress(progress / 10.0);

    if (progress >= 10) {
      success = true;
      game.onActivityEnd(this, success);
    }

    return true;
  }
}

