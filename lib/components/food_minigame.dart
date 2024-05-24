import 'dart:async';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:talacare/components/circle_progress.dart';
import 'package:talacare/components/mouth.dart';
import 'package:talacare/components/plate.dart';
import 'package:talacare/components/player_eating.dart';
import 'package:talacare/helpers/text_styles.dart';

import '../helpers/eat_state.dart';
import 'minigame.dart';


class FoodMinigame extends Minigame {
  late final CircleProgress progressBar;
  late final Plate plate;
  late final PlayerEating playerEating;
  late EatState lastState;
  late final Mouth mouth;
  late final TextComponent instruction;
  late final TextComponent timerText;
  late final Viewport screen;
  int score = 0;

  FoodMinigame({required super.point});

  @override
  FutureOr<void> onLoad() async {



    screen = gameRef.camera.viewport;
    progressBar = CircleProgress(
        position:  Vector2(screen.size.x / 2, screen.size.y * 1 / 9),
        widthInput: screen.size.x * 3 / 5,
        totalPoints: 4
    );
    instruction = TextComponent(
        anchor: Anchor.center,
        position: Vector2(screen.size.x / 2, screen.size.y * 1 / 6),
        text: "Pilih makanan yang sehat!",
        textRenderer: TextPaint(style: AppTextStyles.h2)
    );
    playerEating = PlayerEating(
      minigame: this,
      position: Vector2(screen.size.x / 2, screen.size.y * 8 / 17),
    );
    playerEating.scale = Vector2.all(1.7);
    mouth = Mouth(
      minigame: this,
      position: Vector2(screen.size.x / 2, screen.size.y * 8 / 18.5),
    );
    mouth.scale = Vector2.all(0.08);
    plate = Plate(
        position: Vector2(screen.size.x / 2, screen.size.y * 6 / 7),
        size: Vector2(screen.size.x, screen.size.y * 2 / 7)
    );
    lastState = EatState.good;
    add(progressBar);
    add(instruction);
    add(playerEating);
    add(mouth);
    add(plate);


    return super.onLoad();
  }




  FutureOr<void> updateScore() async {
    score++;
    progressBar.updateProgress();
    if (score >= 4) {
      finishGame();
    }
  }



}