import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:talacare/components/game_2.dart';
import 'package:talacare/helpers/item.dart';
import 'package:talacare/talacare.dart';

class DraggableItem extends SpriteComponent with CollisionCallbacks,
HasGameRef<TalaCare>, HasWorldReference<HospitalPuzzle> {
  final Item item;
  late final Vector2 initialPosition;

  DraggableItem({required this.item, required super.position});

  @override
  FutureOr<void> onLoad() async {
    anchor = Anchor.center;
    initialPosition = position;
    sprite = Sprite(game.images.fromCache('Game_2/item_${item.name}.png'));
    add(RectangleHitbox());
    return super.onLoad();
  }
}