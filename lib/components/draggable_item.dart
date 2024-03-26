import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:talacare/helpers/item.dart';

class DraggableItem extends RectangleComponent {
  final Item item;
  late final Vector2 initialPosition;

  DraggableItem({required this.item, required super.position, required super.size});

  @override
  FutureOr<void> onLoad() async {
    anchor = Anchor.center;
    initialPosition = position;
    paint = BasicPalette.purple.paint();
    add(TextComponent(text: item.name));
    add(RectangleHitbox());
    return super.onLoad();
  }
}