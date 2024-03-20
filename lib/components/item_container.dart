import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:talacare/components/item.dart';

class ItemContainer extends RectangleComponent {
  @override
  final paint = BasicPalette.lightPink.paint();

  ItemContainer({super.size});

  @override
  FutureOr<void> onLoad() {
    final itemPositionFactors = [1/5, 1/2, 4/5];

    for (double factor in itemPositionFactors) {
      add(Item(
          position: Vector2(size.x * factor, 50),
          size: Vector2.all(size.y * 3 / 5),
        )..anchor = Anchor.center
      );
    }

    return super.onLoad();
  }
}