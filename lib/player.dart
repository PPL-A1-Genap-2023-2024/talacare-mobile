import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'helpers/directions.dart';
class Player extends SpriteAnimationComponent
    with HasGameRef {
  /// Pixels/s
  double maxSpeed = 4.0;
  Direction direction = Direction.none;
  bool playerFlipped = false;


  Player()
      : super(size: Vector2.all(100.0), anchor: Anchor.center);


  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    updatePosition(dt);
  }

  void updatePosition(double dt) {
    switch (direction) {
      case Direction.up:
        position.y -= maxSpeed;
        break;
      case Direction.down:
        position.y += maxSpeed;
        break;
      case Direction.left:
        position.x -= maxSpeed;
        break;
      case Direction.right:
        position.x += maxSpeed;
        break;
      case Direction.none:
        break;
    }

    if (direction == Direction.left && playerFlipped) {
      playerFlipped = false;
      flipHorizontallyAroundCenter();
    }

    if (direction == Direction.right && !playerFlipped) {
      playerFlipped = true;
      flipHorizontallyAroundCenter();
    }
  }


}