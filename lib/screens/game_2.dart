import 'dart:async';
import 'dart:ui';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:talacare/components/circle_progress.dart';
import 'package:talacare/components/draggable_container.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/components/silhouette_container.dart';
import 'package:talacare/helpers/text_styles.dart';
import 'package:talacare/talacare.dart';

class HospitalPuzzle extends World with HasGameRef<TalaCare> {
  final Player player;
  late final CircleProgress progressBar;
  late final DraggableContainer draggableContainer;
  late final SilhouetteContainer silhouetteContainer;
  late final TextComponent instruction;
  late final Viewport screen;
  int score = 0;

  HospitalPuzzle({required this.player});

  @override
  FutureOr<void> onLoad() async {
    gameRef.camera.backdrop = RectangleComponent(
        paint: Paint()..color = Color.fromARGB(255, 243, 253, 215),
        size: Vector2(1000, 1000)
    );
    gameRef.camera.viewfinder.anchor = Anchor.topLeft;
    gameRef.camera.viewport = FixedAspectRatioViewport(aspectRatio: 0.5625);

    screen = gameRef.camera.viewport;

    progressBar = CircleProgress(
        position:  Vector2(screen.size.x / 2, screen.size.y * 1 / 7),
        widthInput: screen.size.x * 3 / 5,
        totalPoints: 5
    );
    instruction = TextComponent(
        anchor: Anchor.center,
        position: Vector2(screen.size.x / 2, screen.size.y * 1 / 4),
        text: "Ayo cocokkan gambar!",
        textRenderer: TextPaint(style: AppTextStyles.h2)
    );
    silhouetteContainer = SilhouetteContainer(
      position: Vector2(screen.size.x / 2, screen.size.y * 8 / 17),
    );
    draggableContainer = DraggableContainer(
        position: Vector2(screen.size.x / 2, screen.size.y * 6 / 7),
        size: Vector2(screen.size.x, screen.size.y * 2 / 7)
    );
    add(progressBar);
    add(instruction);
    add(silhouetteContainer);
    add(draggableContainer);
    return super.onLoad();
  }

  FutureOr<void> updateScore() async {
    score++;
    progressBar.updateProgress();
    if (score == 2) {
      draggableContainer.addSecondWaveItems();
    }
    if (score < 5) {
      silhouetteContainer.addNextItem();
    } else {
      instruction.text = "Transfusi darah berhasil!";
      silhouetteContainer.changeChildSprite();
      addExitButton();
    }
  }

  FutureOr<void> addExitButton() async {
    final button = SpriteComponent(
      sprite: Sprite(game.images.fromCache('Button/PlayButton.png')),
    );
    final buttonDown = SpriteComponent(
      sprite: Sprite(game.images.fromCache('Button/PlayButton_pressed.png')),
    );
    final buttonGroup = ButtonComponent(
      anchor: Anchor.center,
      button: button,
      buttonDown: buttonDown,
      onReleased: finishGame,
      position: Vector2(screen.size.x / 2, screen.size.y * 6 / 7),
    );
    add(buttonGroup);
  }

  void finishGame() {
    gameRef.exitHospital();
  }
}