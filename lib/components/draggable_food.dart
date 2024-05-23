import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:talacare/screens/game_2.dart';
import 'package:talacare/talacare.dart';
import 'package:flame/events.dart';

class DraggableFood extends SpriteComponent
    with
        CollisionCallbacks,
        HasGameRef<TalaCare>,
        HasWorldReference<HospitalPuzzle>,
        DragCallbacks {
  final String type;
  final int index;
  late Vector2 initialPosition;
  bool isDraggable = false;

  DraggableFood({required this.type, required this.index, required super.position});

  @override
  FutureOr<void> onLoad() async {
    anchor = Anchor.center;
    sprite = Sprite(game.images.fromCache('Food/${type}_${index}.png'));
    scale = Vector2.all(2);
    initialPosition = Vector2(position.x, position.y);
    add(RectangleHitbox(isSolid: true));
    return super.onLoad();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!isDraggable) return;
    position += Vector2(scale.x * event.localDelta.x, scale.y * event.localDelta.y);
  }

  @override
  Future<void> onDragEnd(DragEndEvent event) async {
    if (!isDraggable) return;
    super.onDragEnd(event);
    await Future.delayed(Duration(milliseconds: 50));
    position = Vector2(initialPosition.x, initialPosition.y);
  }
}