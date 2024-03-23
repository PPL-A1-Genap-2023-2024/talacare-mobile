import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:meta/meta.dart';

class HospitalObject<T extends FlameGame> extends SpriteComponent
    with HasGameReference<T> {
  @mustCallSuper
  @override
  Future<void> onLoad() async {}
}

class DragCallbacksExample extends FlameGame {
  @override
  Future<void> onLoad() async {}
}

class DraggableObject extends HospitalObject with DragCallbacks {
  @override
  bool debugMode = true;

  @override
  void update(double dt) {}

  @override
  void onDragUpdate(DragUpdateEvent event) {}

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
  }
}
