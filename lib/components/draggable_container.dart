import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:talacare/components/draggable_item.dart';
import 'package:talacare/helpers/item.dart';
import 'package:talacare/talacare.dart';

class DraggableContainer extends RectangleComponent with HasGameRef<TalaCare> {
  final List<int> indicesDisplayed = [];

  DraggableContainer({required super.position, required super.size});

  @override
  FutureOr<void> onLoad() async {
    paint = Paint()..color = Color.fromARGB(255, 218, 238, 166);
    anchor = Anchor.center;
    addFirstWaveItems();
    return super.onLoad();
  }

  FutureOr<void> addFirstWaveItems() async {
    indicesDisplayed.addAll([0, 1]);
    indicesDisplayed.shuffle();
    for (int i = 0; i <= 1; i++) {
      add(DraggableItem(
          item: Item.values[indicesDisplayed[i]],
          position: Vector2(size.x * (i + 1) / 3, size.y / 2),
        )
      );
    }
  }

  FutureOr<void> addSecondWaveItems() async {
    indicesDisplayed.addAll([2, 3, 4]);
    indicesDisplayed.shuffle();
    int bedFactor = 0;
    for (int i = 0; i <= 2; i++) {
      int index = indicesDisplayed[i];
      if (index == 2) {
        bedFactor++;
      }
      DraggableItem item = DraggableItem(
        item: Item.values[index],
        position: Vector2(size.x * (i + 1 + bedFactor) / 6, size.y / 2),
      );
      add(item);
      if (index == 2) {
        bedFactor++;
      }
    }
  }

  FutureOr<void> removeItem(DraggableItem item) async {
    remove(item);
    indicesDisplayed.remove(item.item.index);
  }

  void disableDragging() {
    // children.forEach((child) {
    //   if (child is DraggableItem) {
    //     child.isDraggable = false;
    //   }
    // });
    children.whereType<DraggableItem>().forEach((child) {
      child.isDraggable = false;
    });
  }

}
