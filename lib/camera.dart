import 'object.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraTest extends FlameGame with HasKeyboardHandlerComponents {
  CameraTest({required this.viewportResolution})
      : super(
          camera: CameraComponent.withFixedResolution(
            width: viewportResolution.x,
            height: viewportResolution.y,
          ),
        );

  MovableObject object = MovableObject();
  final Vector2 viewportResolution;

  @override
  Future<void> onLoad() async {
    world.add(Map());
    world.add(object);
    camera.follow(object);
    camera.setBounds(Map.bounds);
  }
}

class MovableObject extends Object<CameraTest>
    with CollisionCallbacks, KeyboardHandler {
  static const double speed = 300;

  Vector2 velocity = Vector2.zero();
  late final Vector2 textPosition;
  late final maxPosition = Vector2.all(Map.size - size.x / 2);
  late final minPosition = -maxPosition;

  MovableObject() : super(priority: 2);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    final deltaPosition = velocity * (speed * dt);
    position.add(deltaPosition);
    position.clamp(minPosition, maxPosition);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event.logicalKey == LogicalKeyboardKey.keyA) {
      velocity.x = -1;
      velocity.y = 0;
    } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
      velocity.x = 1;
      velocity.y = 0;
    } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
      velocity.x = 0;
      velocity.y = -1;
    } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
      velocity.x = 0;
      velocity.y = 1;
    } else if (event.logicalKey == LogicalKeyboardKey.keyX) {
      velocity.x = 0;
      velocity.y = 0;
    }
    return false;
  }
}

class Map extends Component {
  static const double size = 1500;
  static final Rectangle bounds = Rectangle.fromLTRB(-size, -size, size, size);
  static final Paint _paintBorder = Paint()
    ..color = Colors.white12
    ..strokeWidth = 10;
  late final List<Rect> _rectPool;

  Map() : super(priority: 0) {
    _rectPool = List<Rect>.generate(
      (size / 50).ceil(),
      (i) => Rect.fromCircle(center: Offset.zero, radius: size - i * 50),
      growable: false,
    );
  }

  @override
  void render(Canvas canvas) {
    for (var i = 0; i < (size / 50).ceil(); i++) {
      canvas.drawRect(_rectPool[i], _paintBorder);
    }
  }
}
