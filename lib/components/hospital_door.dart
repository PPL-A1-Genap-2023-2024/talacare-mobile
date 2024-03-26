import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/talacare.dart';

import '../helpers/hospital_reason.dart';

class HospitalDoor extends SpriteComponent with CollisionCallbacks, HasGameRef<TalaCare> {
  @override
  bool isColliding = false;

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('Hospital/hospital_symbol.png'));
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void onCollision(intersectionPoints, other) {
    if (other is Player) {
      isColliding = true;
      game.enterHospital(HospitalReason.playerEnter);
    }
    super.onCollision(intersectionPoints, other);
  }
}