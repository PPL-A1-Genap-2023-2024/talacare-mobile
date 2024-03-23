import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flame/components.dart';

class HospitalObject<T extends FlameGame> extends SpriteComponent
    with HasGameReference<T> {
  HospitalObject({
    super.position,
    super.priority,
    super.key,
    required Vector2? size,
  }) : super(
          size: size,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('temp/syringe.png');
  }
}

class DragCallbacksExample extends FlameGame {
  DraggableObject syringe = DraggableObject(
      position: Vector2(0, 200),
      size: Vector2(100, 100),
      target: Vector2(0, 0));

  @override
  Future<void> onLoad() async {
    camera.viewfinder.zoom = 1.0;
    world.add(syringe);
  }
}

class DraggableObject extends HospitalObject with DragCallbacks {
  late Vector2 lastPosition;
  late Vector2 target;
  late double hitboxRadius;
  late bool isActive;

  DraggableObject(
      {required super.position, required Vector2 size, required Vector2 target})
      : super(size: size) {
    this.target = target;
    this.hitboxRadius = size.length / 2;
    this.isActive = true;
  }

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
    if (position.distanceTo(target) <= hitboxRadius) {
      this.removeFromParent();
      this.isActive = false;
    } else {
      position.setFrom(lastPosition);
    }
  }
}
