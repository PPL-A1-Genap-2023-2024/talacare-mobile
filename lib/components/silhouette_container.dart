import 'dart:async';
import 'package:flame/components.dart';
import 'package:talacare/components/game_2.dart';
import 'package:talacare/components/silhouette_item.dart';
import 'package:talacare/helpers/item.dart';
import 'package:talacare/talacare.dart';

class SilhouetteContainer extends SpriteComponent with HasGameRef<TalaCare>, HasWorldReference<HospitalPuzzle> {
  final List<int> indicesDisplayed = [];

  SilhouetteContainer({required super.position});

  @override
  FutureOr<void> onLoad() async {
    anchor = Anchor.center;
    sprite = Sprite(game.images.fromCache('Game_2/hospital_container.png'));
    addNextItem();
    return super.onLoad();
  }

  FutureOr<void> addNextItem() async {
    add(SilhouetteItem(item: Item.values[world.score]));
    indicesDisplayed.add(world.score);
  }
}