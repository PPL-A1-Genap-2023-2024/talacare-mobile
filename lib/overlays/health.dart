import 'package:talacare/talacare.dart';
import 'package:flame/components.dart';

enum HeartState {
  available,
  unavailable,
}

class HeartHealthComponent extends SpriteGroupComponent<HeartState>
    with HasGameReference<TalaCare> {
  // Health Component Behavior
  late Timer countDown;
  int lifetime;
  bool timerStarted = false;
  final int heartNumber;

  HeartHealthComponent({
    required this.heartNumber,
    required super.position,
    required super.size,
    required this.lifetime,
    super.scale,
    super.angle,
    super.anchor,
    super.priority,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final availableSprite = await game.loadSprite(
      'heart.png',
      srcSize: Vector2.all(32),
    );

    final unavailableSprite = await game.loadSprite(
      'heart_half.png',
      srcSize: Vector2.all(32),
    );

    sprites = {
      HeartState.available: availableSprite,
      HeartState.unavailable: unavailableSprite,
    };

    // Timer
    current = HeartState.available;
    timerStarted = true;
    countDown = Timer(1, onTick: () {
      if (lifetime > 0) {
        lifetime -= 1;
        print(lifetime);
      }
    }, repeat: true);
  }

  @override
  void update(double dt) {
    if (lifetime == 0) {
      game.playerHealth--;
      current = HeartState.unavailable;
    }

    if (game.playerHealth < heartNumber) {
    } else {
      current = HeartState.available;
    }

    super.update(dt);

    if (timerStarted && lifetime > 0) {
      countDown.update(dt);
    }
  }
}