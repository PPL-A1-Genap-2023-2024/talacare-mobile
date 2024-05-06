import 'dart:async';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:talacare/components/draggable_item.dart';
import 'package:talacare/screens/game_2.dart';
import 'package:talacare/helpers/item.dart';
import 'package:talacare/talacare.dart';

class SilhouetteItem extends SpriteComponent
    with
        CollisionCallbacks,
        HasGameRef<TalaCare>,
        HasWorldReference<HospitalPuzzle> {
  final Item item;
  late final RectangleHitbox hitbox;

  SilhouetteItem({required this.item});

  @override
  FutureOr<void> onLoad() async {
    anchor = Anchor.center;
    position = Vector2(item.x, item.y);
    sprite = Sprite(game.images.fromCache('Game_2/item_${item.name}.png'));
    tint(Color.fromARGB(255, 255, 255, 255));
    hitbox = RectangleHitbox(size: Vector2(item.x / 2, item.y / 2));
    add(hitbox);
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is DraggableItem && other.isDragged == false) {
      if (item.index == other.item.index) {
        world.instruction.text = "Sudah Cocok. Lanjutkan!";
        tint(Color.fromARGB(0, 255, 255, 255));
        remove(hitbox);
        world.draggableContainer.removeItem(other);
        world.updateScore();
      } else {
        world.instruction.text = "Belum Cocok. Ayo Coba Lagi!";
      }
    }
    super.onCollision(intersectionPoints, other);
  }
}
