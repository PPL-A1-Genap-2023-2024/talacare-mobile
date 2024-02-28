import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'actors/karakter.dart';
import 'overlays/hud.dart';

class TalaCare extends FlameGame {
  int starsCollected = 0;
  int health = 3;
  late Karakter _karakter;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'block.png',
      'ember.png',
      'ground.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'water_enemy.png',
    ]);

    camera.viewfinder.anchor = Anchor.topLeft;
    _karakter = Karakter(
      position: Vector2(128, canvasSize.y - 70),
    );
    world.add(_karakter);
    camera.viewport.add(Hud());
  }
}

