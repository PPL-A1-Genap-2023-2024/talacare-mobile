import 'dart:async';
import 'dart:ui';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:talacare/components/circle_progress.dart';
import 'package:talacare/components/plate.dart';
import 'package:talacare/components/player_eating.dart';
import 'package:talacare/helpers/color_palette.dart';
import 'package:talacare/helpers/text_styles.dart';

import 'minigame.dart';

class FoodMinigame extends Minigame {
  late final CircleProgress progressBar;
  late final Plate plate;
  late final PlayerEating playerEating;
  late final TextComponent instruction;
  late final TextComponent timerText;
  late final Viewport screen;
  int score = 0;

  bool timerStarted = false;
  int timeLimit = 20;
  late Timer countDown;

  FoodMinigame({required super.point});

  @override
  FutureOr<void> onLoad() async {
    screen = gameRef.camera.viewport;
    progressBar = CircleProgress(
        position: Vector2(screen.size.x / 2, screen.size.y * 1 / 7),
        widthInput: screen.size.x * 3 / 5,
        totalPoints: 4);
    instruction = TextComponent(
        anchor: Anchor.center,
        position: Vector2(screen.size.x / 2, screen.size.y * 1 / 4),
        text: "Adek mau makan apa?",
        textRenderer: TextPaint(
          style: AppTextStyles.h2.copyWith(color: AppColors.yellow)
        ));
    playerEating = PlayerEating(
      minigame: this,
      position: Vector2(screen.size.x / 2, screen.size.y * 8 / 17),
    );
    plate = Plate(
        position: Vector2(screen.size.x / 2, screen.size.y * 6 / 7),
        size: Vector2(screen.size.x, screen.size.y * 2 / 7));
    add(progressBar);
    add(instruction);
    add(playerEating);
    add(plate);

    timerText = TextComponent(
        anchor: Anchor.topCenter,
        position: Vector2(screen.size.x / 2, screen.size.y * 1 / 14),
        text: "Sisa waktu: $timeLimit detik",
        textRenderer: TextPaint(
            style: AppTextStyles.large.copyWith(color: AppColors.purple)
        ));
    add(timerText);

    timerStarted = true;
    countDown = Timer(1, repeat: true, onTick: () {
      if (timeLimit > 0) {
        timeLimit--;
        timerText.text = "Sisa waktu: $timeLimit detik";
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
        instruction.text = "Waktu kamu sudah habis";
        plate.disableDragging();
        loseGame();
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
}
