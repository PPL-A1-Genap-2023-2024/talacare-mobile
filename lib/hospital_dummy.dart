import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flame/components.dart';

class HospitalObject extends SpriteComponent
    with HasGameReference<DragCallbacksExample> {
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
  DraggableObject syringe1 = DraggableObject(
      position: Vector2(-200, 200),
      size: Vector2(100, 100),
      target: Vector2(-200, -200));
  DraggableObject syringe2 = DraggableObject(
      position: Vector2(0, 200),
      size: Vector2(100, 100),
      target: Vector2(0, -200));
  DraggableObject syringe3 = DraggableObject(
      position: Vector2(200, 200),
      size: Vector2(100, 100),
      target: Vector2(200, -200));
  List<DraggableObject> listOfObject = [];
  int itemIndex = 0;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.zoom = 1.0;
    listOfObject.add(syringe1);
    listOfObject.add(syringe2);
    listOfObject.add(syringe3);
    for (DraggableObject item in listOfObject) {
      world.add(item);
    }
    listOfObject[0].spawnTarget();
  }

  Future<void> nextItem() async {
    itemIndex++;
    if (itemIndex < listOfObject.length) {
      listOfObject[itemIndex].spawnTarget();
    }
  }
}

class DraggableObject extends HospitalObject with DragCallbacks {
  late Vector2 lastPosition;
  late Vector2 target;
  late double hitboxRadius;
  late bool isActive;
  late RectangleComponent targetRectangle;

  DraggableObject(
      {required super.position, required Vector2 size, required this.target})
      : super(size: size) {
    hitboxRadius = size.length / 2;
    isActive = true;
    targetRectangle = RectangleComponent(position: target, size: size);
  }

  void spawnTarget() {
    game.world.add(targetRectangle);
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
    if (isActive &&
        this == game.listOfObject[game.itemIndex] &&
        position.distanceTo(target) <= hitboxRadius) {
      targetRectangle.removeFromParent();
      position.setFrom(target);
      isActive = false;
      game.nextItem();
    } else {
      position.setFrom(lastPosition);
    }
  }
}
