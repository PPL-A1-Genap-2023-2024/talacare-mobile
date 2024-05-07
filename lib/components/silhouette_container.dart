import 'dart:async';
import 'package:flame/components.dart';
import 'package:talacare/screens/game_2.dart';
import 'package:talacare/components/silhouette_item.dart';
import 'package:talacare/helpers/item.dart';
import 'package:talacare/talacare.dart';

class SilhouetteContainer extends SpriteComponent with HasGameRef<TalaCare>,
HasWorldReference<HospitalPuzzle> {
  int currentIndex = -1;
  late bool childIsHappy;
  late SpriteComponent child;

  SilhouetteContainer({required super.position});

  @override
  FutureOr<void> onLoad() async {
    anchor = Anchor.center;
    sprite = Sprite(game.images.fromCache('Game_2/hospital_container.png'));
    child = SpriteComponent(
      anchor: Anchor.center,
      position: Vector2(225, 160),
      sprite: Sprite(game.images.fromCache('Game_2/child_${game.playedCharacter}_before.png'))
    );
    childIsHappy = false;
    add(child);
    addNextItem();
    return super.onLoad();
  }

  FutureOr<void> addNextItem() async {
    add(SilhouetteItem(item: Item.values[world.score]));
    currentIndex++;
  }

  FutureOr<void> changeChildSprite() async {
    child.sprite = Sprite(game.images.fromCache('Game_2/child_${game.playedCharacter}_after.png'));
    childIsHappy = true;
  }
}