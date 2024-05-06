import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:talacare/screens/game_2.dart';
import 'package:talacare/helpers/item.dart';
import 'package:talacare/talacare.dart';
import 'package:flame/events.dart';

class DraggableItem extends SpriteComponent
    with
        CollisionCallbacks,
        HasGameRef<TalaCare>,
        HasWorldReference<HospitalPuzzle>,
        DragCallbacks {
  final Item item;
  late Vector2 initialPosition;

  DraggableItem({required this.item, required super.position});

  @override
  FutureOr<void> onLoad() async {
    anchor = Anchor.center;
    initialPosition = position;
    sprite = Sprite(game.images.fromCache('Game_2/item_${item.name}.png'));
    add(RectangleHitbox());
    initialPosition = Vector2(position.x, position.y);
    return super.onLoad();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;
  }

  @override
  Future<void> onDragEnd(DragEndEvent event) async {
    super.onDragEnd(event);
    await Future.delayed(Duration(milliseconds: 50));
    position = Vector2(initialPosition.x, initialPosition.y);
  }
}
