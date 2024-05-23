import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/layout.dart';
import 'package:talacare/components/circle_progress.dart';
import 'package:talacare/components/event.dart';
import 'package:talacare/helpers/text_styles.dart';

import 'minigame.dart';

class ClickerMinigame extends Minigame {
  late final CircleProgress progressBar;
  late final Viewport screen;

  String variant;
  late AlignComponent tapableSprite;

  bool firstTap = false;
  late SpriteAnimationComponent instruction;

  // Timer
  // late final TextComponent timerText;
  bool timerStarted = false;
  int timeLimit = 5;
  late Timer countDown;

  int score = 0;

  ClickerMinigame({this.variant = 'drawing', required super.point});

  @override
  FutureOr<void> onLoad() async {
    screen = gameRef.camera.viewport;

    progressBar = CircleProgress(
        position: Vector2(screen.size.x / 2, screen.size.y * 1 / 7),
        widthInput: screen.size.x * 3 / 5,
        totalPoints: 4);
    add(progressBar);

    // timerText = TextComponent(
    //     anchor: Anchor.topCenter,
    //     position: Vector2(screen.size.x / 2, screen.size.y * 1 / 14),
    //     text: "Sisa waktu: $timeLimit detik",
    //     textRenderer: TextPaint(style: AppTextStyles.large));
    // add(timerText);

    tapableSprite = AlignComponent(
        child: ActivityEvent(variant: point.variant),
        alignment: Anchor.center);
    screen.add(tapableSprite);

    print(screen.size);

    instruction = makeInstructionAnimation();
    screen.add(instruction);

    timerStarted = true;
    countDown = Timer(1, repeat: true, onTick: () {
      if (timeLimit > 0) {
        timeLimit--;
        // timerText.text = "Sisa waktu: $timeLimit detik";
      }
    });

    countDown.start();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    updateTimer(dt);
  }

  void updateTimer(double dt) {
    if (timerStarted) {
      countDown.update(dt);
      if (timeLimit <= 0) {
        // instruction.text = "Waktu kamu sudah habis";
        loseGame();
        if (!firstTap){
          screen.remove(instruction);
        }
        screen.remove(tapableSprite);
      }
    }
  }

  FutureOr<void> updateScore() async {
    score++;
    progressBar.updateProgress();
    if (score >= 4) {
      finishGame();
    }
  }

  SpriteAnimationComponent makeInstructionAnimation() {
    var fileName = 'Activity_Events/tap_instruction.png';
    var data = SpriteAnimationData.sequenced(
        textureSize: Vector2.all(320),
        amount: 2,
        stepTime: 0.3
    );
    SpriteAnimation animation = SpriteAnimation.fromFrameData(game.images.fromCache(fileName), data);

    return SpriteAnimationComponent(
        animation: animation,
        scale: Vector2.all(0.6),
        position: Vector2(screen.size.x / 2, screen.size.y / 2)
    );
  }

}
