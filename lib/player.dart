import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'helpers/directions.dart';
class Player extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  /// Pixels/s
  double maxSpeed = 4.0;
  late final Vector2 _lastSize = size.clone();
  late final Transform2D _lastTransform = transform.clone();
  Direction direction = Direction.none;
  bool playerFlipped = false;
  final GlobalKey _playerKey = GlobalKey();


  Player()
      : super(size: Vector2.all(100.0), anchor: Anchor.center);

  GlobalKey getPlayerKey() {
    return _playerKey;
  }

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

  updatePosition(double dt) {
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

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints,
      PositionComponent other,
      ) {
    super.onCollisionStart(intersectionPoints, other);
    transform.setFrom(_lastTransform);
    size.setFrom(_lastSize);
  }


}