import 'dart:async';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:talacare/components/draggable_food.dart';
import 'package:talacare/helpers/eat_state.dart';
import 'package:talacare/talacare.dart';

import 'food_minigame.dart';

class PlayerEating extends SpriteComponent
    with
        CollisionCallbacks,
        HasGameRef<TalaCare> {
  late final RectangleHitbox hitbox;
  final FoodMinigame minigame;
  PlayerEating({required this.minigame, required super.position});

  // AudioSource sfx = AudioSource.uri(Uri.parse("asset:///assets/audio/puzzle_drop.mp3"));


  @override
  FutureOr<void> onLoad() async {
    anchor = Anchor.center;
    sprite = await game.loadSprite('Food/${game.playedCharacter}_new.png');

    hitbox = RectangleHitbox(isSolid: true);
    add(hitbox);
    return super.onLoad();
  }




  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is DraggableFood && other.isDragged == true) {
      minigame.mouth.current = EatState.openmouth;
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    minigame.mouth.current = minigame.lastState;
    super.onCollisionEnd(other);
  }

}
