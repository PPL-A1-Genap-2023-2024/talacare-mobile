import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';

class CircleProgress extends RectangleComponent {
  final double width;
  final int totalPoints;
  final List<bool> circlesAreMarked = [];

  CircleProgress({
    required super.position,
    required this.width,
    required this.totalPoints
  });

  @override
  FutureOr<void> onLoad() async {
    anchor = Anchor.center;
    paint = Paint()..color = Color.fromARGB(0, 0, 0, 0);
    final circleDiameter = width / (totalPoints * 2 + 1);
    size = Vector2(width, circleDiameter);
    add(RectangleComponent(
      anchor: Anchor.center,
      paint: Paint()..color = Color.fromARGB(255, 189, 204, 222),
      position: Vector2(size.x / 2, size.y / 2),
      size: Vector2(circleDiameter * (totalPoints * 2 - 1), circleDiameter / 5)
    ));
    for (int i = 0; i < totalPoints; i++) {
      final circle = CircleComponent(
        paint: Paint()..color = Color.fromARGB(255, 150, 161, 174),
        position: Vector2(circleDiameter + (i * 2 * circleDiameter), 0),
        radius: circleDiameter / 2
      );
      add(circle);
      circlesAreMarked.add(false);
    }
    return super.onLoad();
  }

  void updateProgress() {
    final index = circlesAreMarked.indexOf(false);
    final circle = children.query<CircleComponent>()[index];
    circle.paint = Paint()..color = Color.fromARGB(255, 218, 238, 166);
    circlesAreMarked[index] = true;
  }
}