import 'package:flame/components.dart';
import 'package:talacare/components/hud/progress.dart';
import 'package:talacare/helpers/hospital_reason.dart';
import 'package:talacare/talacare.dart';
import 'package:talacare/components/hud/health.dart';

class Hud extends PositionComponent with HasGameReference<TalaCare> {
  Hud({
    super.priority = 5,
  });

  final int healthDuration = 10; // in second

  late Timer countDown;
  late int healthDurationChecker;
  bool timerStarted = false;

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
      final gap = healthComponentSize;
      final positionX = 0.toDouble();
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
      final positionY = 0.toDouble();
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
        game.showConfirmation(HospitalReason.lowBlood);
      }
    }
  }

  void _updatePlayerMoveSpeed(){
    double currentSpeed = game.player.moveSpeed;
    game.player.moveSpeed = currentSpeed - (currentSpeed * 25/100);
  }
}