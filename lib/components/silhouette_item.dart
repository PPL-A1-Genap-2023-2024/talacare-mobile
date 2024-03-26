import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:talacare/helpers/item.dart';

class SilhouetteItem extends RectangleComponent {
  final Item item;

  SilhouetteItem({required this.item});

  @override
  FutureOr<void> onLoad() async {
    anchor = Anchor.center;
    paint = BasicPalette.black.paint();
    position = Vector2(item.x, item.y);
    size = Vector2(50, 50);
    add(TextComponent(text: item.name));
    add(RectangleHitbox());
    return super.onLoad();
  }
}