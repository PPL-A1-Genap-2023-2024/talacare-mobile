import 'package:flame/components.dart';
import 'package:talacare/talacare.dart';
import 'package:talacare/overlays/health.dart';

class Hud extends PositionComponent with HasGameReference<TalaCare> {
  Hud({
    super.priority = 5,
  });

  int lifeTime = 10; // Health lifetime in seconds
  bool timerStarted = false;
  Timer countDown = Timer(1, repeat: true);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    countDown.onTick = () {
      if (lifeTime > 0) {
        lifeTime -= 1;
      }
    };

    for (var i = 1; i <= game.playerHealth; i++) {
      final positionX = game.cam.visibleWorldRect.width - 45;
      final positionY = game.cam.visibleWorldRect.height / 20;
      final gap = 30;
      await add(
        HealthComponent(
          heartNumber: i,
          position: Vector2(positionX, positionY + (gap.toDouble() * i)),
          size: Vector2.all(32),
        ),
      );
    }

    timerStarted = true;
  }

  @override
  void update(double dt) {

    if (timerStarted && lifeTime > 0){
      countDown.update(dt);
    }

    if (lifeTime == 0){
      game.playerHealth -= 1;
      lifeTime = 10;
    }

    if (game.playerHealth == 1){
      timerStarted = false;
    }
  }
}