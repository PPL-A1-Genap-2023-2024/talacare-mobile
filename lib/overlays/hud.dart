import 'package:flame/components.dart';
import '../talacare.dart';
import 'health.dart';

class Hud extends PositionComponent with HasGameReference<TalaCare> {
  Hud({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 5,
  });

  @override
  Future<void> onLoad() async {
    for (var i = 1; i <= game.playerHealth; i++) {
      final positionX = 40 * i;
      await add(
        HeartHealthComponent(
          heartNumber: i,
          lifetime: i * 10,
          position: Vector2(positionX.toDouble(), 20),
          size: Vector2.all(32),
        ),
      );
    }
  }
}