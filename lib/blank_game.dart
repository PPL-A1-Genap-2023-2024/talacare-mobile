import 'player.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'helpers/directions.dart';

class BlankGame extends FlameGame {
  late final Player player;

  @override
  Future<void> onLoad() async {
    final Image playerImage = await images.load('chicken.png');
    final playerAnimation = SpriteAnimation.fromFrameData(
      playerImage,
      SpriteAnimationData.sequenced(
        amount: 14,
        stepTime: 0.1,
        textureSize: Vector2(32, 34),
      ),
    );
    player = Player()
      ..animation = playerAnimation;

    world.add(player);
    // camera.viewport.add(joystick);
  }

  void onDirectionChanged(Direction direction) {
    player.direction = direction;
  }
}