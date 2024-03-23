import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flame/components.dart';

class HospitalObject<T extends FlameGame> extends SpriteComponent
    with HasGameReference<T> {
  HospitalObject(
      {super.position, required Vector2? size, super.priority, super.key})
      : super(
          size: size,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('temp/syringe.png');
  }
}

class DragCallbacksExample extends FlameGame {
  DraggableObject syringe =
      DraggableObject(position: Vector2(0, 200), size: Vector2(100, 100));

  @override
  Future<void> onLoad() async {
    camera.viewfinder.zoom = 1.0;
    world.add(syringe);
  }
}

class DraggableObject extends HospitalObject with DragCallbacks {
  late Vector2 lastPosition;

  DraggableObject({super.position, required Vector2 size}) : super(size: size);

  @override
  void update(double dt) {
    super.update(dt);
    debugColor = isDragged ? Colors.greenAccent : Colors.purple;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    lastPosition = Vector2(position.x, position.y);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    position.setFrom(lastPosition);
  }
}
