import 'dart:async';
import 'dart:ui';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' as material;
import 'package:talacare/components/circle_progress.dart';
import 'package:talacare/components/draggable_container.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/components/silhouette_container.dart';
import 'package:talacare/talacare.dart';

class HospitalPuzzle extends World with HasGameRef<TalaCare> {
  final Player player;
  late final CircleProgress progressBar;
  late final DraggableContainer draggableContainer;
  late final SilhouetteContainer silhouetteContainer;
  late final TextComponent instruction;
  late final TextComponent timerText; 
  late final Viewport screen;
  int score = 0;
  int timeLimit = 30;
  late Timer countDown;
  bool timerStarted = false;

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
        textRenderer: TextPaint(style: material.TextStyle(
            color: Color.fromARGB(255, 191, 210, 139),
            fontSize: 28
        ))
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
    
    timerText = TextComponent(
      anchor: Anchor.topCenter,
      position: Vector2(screen.size.x / 2, screen.size.y * 1 / 14),
      text: "Sisa waktu: $timeLimit detik",
      textRenderer: TextPaint(style: material.TextStyle(
        color: Color.fromARGB(255, 191, 210, 139),
        fontSize: 24,
      ))
    );
    add(timerText);

    timerStarted = true;
    countDown = Timer(1, repeat: true, onTick: () {
      if (timeLimit > 0) {
        timeLimit--;
        timerText.text = "Sisa waktu: $timeLimit detik";
      } else {
        timerStarted = false;
        finishGame();
      }
    });

    countDown.start();

    return super.onLoad();
  }

   @override
  void update(double dt) {
    super.update(dt);
    _updateTimer(dt);
  }

  void _updateTimer(double dt) {
    if (timerStarted) {
      countDown.update(dt);
      if (timeLimit <= 0) {
        timerStarted = false;
        finishGame();
      }
    }
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
      addExitButton();
    }
  }

  FutureOr<void> addExitButton() async {
    timerStarted = false;
    final buttonText = TextComponent(
        anchor: Anchor.center,
        position: Vector2(screen.size.x / 2, screen.size.y * 6 / 7),
        text: "Kembali ke Rumah",
        textRenderer: TextPaint(style: material.TextStyle(
            color: Color.fromARGB(255, 165, 151, 102),
            fontSize: 22
        ))
    );
    final button = RectangleComponent(
      paint: Paint()..color = Color.fromARGB(255, 253, 233, 168),
      size: Vector2(200, 50),
    );
    final buttonDown = RectangleComponent(
      paint: Paint()..color = Color.fromARGB(255, 222, 202, 138),
      size: Vector2(200, 50),
    );
    final buttonGroup = ButtonComponent(
      anchor: Anchor.center,
      button: button,
      buttonDown: buttonDown,
      onReleased: finishGame,
      position: Vector2(screen.size.x / 2, screen.size.y * 6 / 7),
      size: Vector2(200, 50),
    );
    add(buttonGroup);
    add(buttonText);
  }

  void finishGame() {
    gameRef.exitHospital();
  }
}