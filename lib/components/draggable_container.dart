import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:talacare/components/draggable_item.dart';
import 'package:talacare/helpers/item.dart';
import 'package:talacare/talacare.dart';

class DraggableContainer extends RectangleComponent with HasGameRef<TalaCare> {
  final List<double> positionFactors = [1/5, 1/2, 4/5];
  final List<int> indicesRemaining = [0, 1, 2, 3, 4];
  final List<int> indicesDisplayed = [];
  final Random rng = Random();

  DraggableContainer({required super.position, required super.size});

  @override
  FutureOr<void> onLoad() async {
    paint = BasicPalette.lightPink.paint();
    anchor = Anchor.center;
    initializeIndicesList();
    for (int i = 0; i <= 2; i++) {
      add(DraggableItem(
          item: Item.values[indicesDisplayed[i]],
          position: Vector2(size.x * positionFactors[i], 50),
          size: Vector2.all(size.y * 3 / 5),
        )
      );
    }
    return super.onLoad();
  }

  void initializeIndicesList() {
    indicesDisplayed.add(0);
    indicesRemaining.remove(0);
    for (int i = 0; i <= 1; i++) {
      int index = indicesRemaining[rng.nextInt(indicesRemaining.length)];
      indicesDisplayed.add(index);
      indicesRemaining.remove(index);
    }
    indicesDisplayed.shuffle();
  }
}