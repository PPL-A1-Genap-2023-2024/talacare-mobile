import 'package:talacare/talacare.dart';
import 'package:flame/components.dart';

enum HeartState {
  available,
  unavailable,
}

class HealthComponent extends SpriteGroupComponent<HeartState>
    with HasGameReference<TalaCare> {
  final int heartNumber;

  HealthComponent({
    required this.heartNumber,
    required super.position,
    required super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.priority,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final availableSprite = await game.loadSprite(
      'Overlays/health.png',
      srcSize: Vector2.all(32),
    );

    final unavailableSprite = await game.loadSprite(
      'Overlays/health_off.png',
      srcSize: Vector2.all(32),
    );

    sprites = {
      HeartState.available: availableSprite,
      HeartState.unavailable: unavailableSprite,
    };

    current = HeartState.available;
  }

  @override
  void update(double dt) {
    if (game.playerHealth < heartNumber) {
      current = HeartState.unavailable;
    }
    else {
      current = HeartState.available;
    }

    super.update(dt);
  }
}