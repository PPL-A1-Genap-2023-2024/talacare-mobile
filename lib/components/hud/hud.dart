import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:talacare/components/hud/progress.dart';
import 'package:talacare/helpers/audio_manager.dart';
import 'package:talacare/helpers/dialog_reason.dart';
import 'package:talacare/talacare.dart';
import 'package:talacare/components/hud/health.dart';
import 'package:just_audio/just_audio.dart';

class Hud extends PositionComponent with HasGameReference<TalaCare>, HasVisibility {
  Hud({
    super.priority = 5,
  });

  final int healthDuration = 20; // in second

  late Timer countDown;
  late int healthDurationChecker;
  bool timerStarted = false;
  AudioSource sfx = AudioSource.uri(Uri.parse("asset:///assets/audio/health_notification.mp3"));

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    healthDurationChecker = healthDuration;
    timerStarted = true;
    countDown = Timer(1, onTick: (){
      if (healthDurationChecker > 0){
        healthDurationChecker -= 1;
      }
    }, repeat: true);

    for (var i = 1; i <= game.playerHealth; i++) {
      final healthComponentSize = 48;
      final gap = healthComponentSize + 10;
      final positionX = 10.toDouble();
      final positionY = game.canvasSize.y / healthComponentSize;
      await add(
        HealthComponent(
          heartNumber: i,
          position: Vector2(positionX, positionY + (gap.toDouble() * i)),
          size: Vector2.all(healthComponentSize.toDouble()),
        ),
      );
    }

    for (var i = 1; i <= 8; i++) {
      final progressComponentSize = 30;
      final gap = progressComponentSize;
      final positionX = game.canvasSize.x / progressComponentSize;
      final positionY = 10.toDouble();
      await add(
        ProgressComponent(
          progressNumber: i,
          position: Vector2(positionX + (gap.toDouble() * i), positionY),
          size: Vector2.all(progressComponentSize.toDouble()),
        ),
      );
    }
  }

  @override
  void update(double dt) {
    _updateTimer(dt);
    _updatePlayerHealth();
    _updateScore();
  }

  void _updateTimer(dt){
    if (timerStarted && healthDurationChecker > 0){
      countDown.update(dt);
    }

    if (game.playerHealth == 1 && healthDurationChecker < 1){
      timerStarted = false;
    }
  }

  void _updatePlayerHealth(){
    if (healthDurationChecker == 0 && game.playerHealth > 1){
      game.playerHealth -= 1;
      _updatePlayerMoveSpeed();
      healthDurationChecker = healthDuration;

      if (game.playerHealth ==  1) {
        if(!game.isWidgetTesting) {
          FlameAudio.play('health_notification.mp3');
          AudioManager.getInstance().playSoundEffect(sfx);
        }
        game.showConfirmation(DialogReason.lowBlood);
      }
    }
  }

  void _updatePlayerMoveSpeed(){
    double currentSpeed = game.player.moveSpeed;
    game.player.moveSpeed = currentSpeed - (currentSpeed * 25/100);
  }

  void _updateScore(){
    if (game.score == 8) {
      game.victory();
    }
  }
}