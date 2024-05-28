import 'dart:async';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/layout.dart';
import 'package:just_audio/just_audio.dart';
import 'package:talacare/components/activity_event.dart';
import 'package:talacare/helpers/audio_manager.dart';
import 'package:talacare/components/progress_bar.dart';

import 'package:talacare/components/minigame.dart';

class ClickerMinigame extends Minigame {
  late final Viewport screen;

  // Sprite
  String variant;
  late AlignComponent tapableSprite;
  late SpriteAnimationComponent instruction;
  late ActivityEvent activity;

  // Timer
  bool timerStarted = false;
  int timeLimit = 10;
  late Timer countDown;

  // Progress
  bool firstTap = false;
  late ProgressBar progressBar;
  int progress = 0;
  final int progressIncrement = 1;

  ClickerMinigame({this.variant = 'drawing', required super.point});

  @override
  FutureOr<void> onLoad() {
    screen = gameRef.camera.viewport;

    progressBar = makeActivityProgressBar();
    add(progressBar);

    activity = ActivityEvent(variant: variant, trigger: updateProgress);
    tapableSprite = AlignComponent(
        child: activity,
        alignment: Anchor.center);
    screen.add(tapableSprite);

    // Instruction Disappear After First Tap
    instruction = makeInstructionAnimation();
    screen.add(instruction);

    timerStarted = true;
    countDown = Timer(1, repeat: true, onTick: () {
      if (timeLimit > 0) {
        timeLimit--;
      }
    });

    countDown.start();

    if(!game.isWidgetTesting)AudioManager.getInstance();

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
        loseGame();
        if (!firstTap){
          screen.remove(instruction);
        }
        screen.remove(tapableSprite);
      }
    }
  }

  void updateProgress(){
    if(!firstTap){
      screen.remove(instruction);
      firstTap = true;
    }
    if(!game.isWidgetTesting){
      if(variant == 'drawing')AudioManager.getInstance().playSoundEffect(AudioSource.uri(Uri.parse("asset:///assets/audio/drawing_sound_trim_2.mp3")));
      else AudioManager.getInstance().playSoundEffect(AudioSource.uri(Uri.parse("asset:///assets/audio/brick_sound_trim_2.mp3")));
    }
    

    if (progress < 10){
      progress += progressIncrement;
      progressBar.updateProgress(progress / 10.0);
    }

    if (progress >= 10){
      activity.done = true;
      Future.delayed(Duration(seconds: 1), () {
        if(!game.isWidgetTesting)AudioManager.getInstance().playSoundEffect(AudioSource.uri(Uri.parse("asset:///assets/audio/all_matched.mp3")));
        finishGame();
        screen.remove(tapableSprite);
      });
    }
  }

  SpriteAnimationComponent makeInstructionAnimation() {
    var fileName = 'Activity_Events/tap_instruction2.png';
    var data = SpriteAnimationData.sequenced(
        textureSize: Vector2.all(320),
        amount: 2,
        stepTime: 0.3
    );
    SpriteAnimation animation = SpriteAnimation.fromFrameData(game.images.fromCache(fileName), data);

    return SpriteAnimationComponent(
        animation: animation,
        scale: Vector2.all(0.5),
        position: Vector2(screen.size.x / 2, (screen.size.y + 160) / 2)
    );
  }

  ProgressBar makeActivityProgressBar(){
    ProgressBar progressBar = ProgressBar(
      progress: 0.0,
      width: screen.size.x * 0.8,
      height: 30,
    );
    progressBar.position = Vector2(
        (screen.size.x - progressBar.width) / 2,
        (screen.size.y - progressBar.height) / 10
    );
    return progressBar;
  }
}