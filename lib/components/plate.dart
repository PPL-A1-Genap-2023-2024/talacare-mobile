import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:talacare/components/draggable_food.dart';
import 'package:talacare/talacare.dart';
class Plate extends SpriteComponent with HasGameRef<TalaCare> {
  Map<String, List<int>> indicesDisplayed = {};

  Plate({required super.position, required super.size});

  @override
  FutureOr<void> onLoad() async {
    sprite = Sprite(game.images.fromCache('Food/dish_big.png'));
    anchor = Anchor.center;
    indicesDisplayed["bad"] = indicesDisplayed["good"] = List.generate(8, (index) => index + 1);
    nextWave();
    enableDragging();
    return super.onLoad();
  }

  FutureOr<void> nextWave() async {
    children.whereType<DraggableFood>().forEach((child) {
      remove(child);
    });
    int i = 0;
    indicesDisplayed.forEach((key, value) {
      value.shuffle();
      DraggableFood food = DraggableFood(type: key, index: value[0], position: Vector2(size.x * (i+1)/3, size.y / 2));
      add(food);

      i++;
    });

  }

  FutureOr<void> removeItem(DraggableFood food) async {
    remove(food);
    indicesDisplayed[food.type]?.remove(food.index);
  }


  void enableDragging() {
    children.whereType<DraggableFood>().forEach((child) {
      child.isDraggable = true;
    });
  }

  void disableDragging(){
    children.whereType<DraggableFood>().forEach((child) {
      child.isDraggable = false;
    });
  }

}
