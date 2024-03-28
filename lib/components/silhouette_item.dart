import 'dart:async';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:talacare/helpers/item.dart';
import 'package:talacare/talacare.dart';

class SilhouetteItem extends SpriteComponent with HasGameRef<TalaCare> {
  final Item item;
  late final RectangleHitbox hitbox;

  SilhouetteItem({required this.item});

  @override
  FutureOr<void> onLoad() async {
    anchor = Anchor.center;
    position = Vector2(item.x, item.y);
    sprite = Sprite(game.images.fromCache('Game_2/item_${item.name}.png'));
    tint(Color.fromARGB(255, 255, 255, 255));
    hitbox = RectangleHitbox();
    add(hitbox);
    return super.onLoad();
  }
}