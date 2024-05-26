import 'dart:async';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:talacare/components/minigame.dart';
import 'package:talacare/components/progress_bar.dart';
import 'package:talacare/talacare.dart';
import 'package:talacare/components/clicker_minigame.dart';
import 'package:talacare/components/progress_bar.dart';
import 'package:flutter/material.dart';

class ActivityEvent extends SpriteComponent with HasGameRef<TalaCare>, TapCallbacks {
  double timeElapsed = 0.0;

  String variant;
  late List<Sprite> eventSprites;
  int currentSpriteIndex = 0;

  bool firstTap = false;
  bool done = false;

  // Callback function to be called when the event is tapped
  VoidCallback onTapCallback = () {};

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

    return super.onLoad();
  }

  @override
  bool onTapUp(TapUpEvent event) {
    if (!firstTap){
      firstTap = true;
    }

    onTapCallback();

    currentSpriteIndex = (currentSpriteIndex + 1) % 2;
    sprite = eventSprites[currentSpriteIndex];

    return true;
  }
}

