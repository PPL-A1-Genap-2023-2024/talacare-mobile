import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/talacare.dart';

class ActivityPoint extends SpriteComponent with CollisionCallbacks, HasGameRef<TalaCare> {
  String variant;

  ActivityPoint({super.position, this.variant = 'drawing'});
  
  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('Activity_Points/point_$variant.png'));
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void onCollision(intersectionPoints, other) {
    if ((other is Player) && (!game.confirmationIsActive)) {
      game.startMinigame(this);
    }
    super.onCollision(intersectionPoints, other);
  }
}