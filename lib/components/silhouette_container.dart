import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:talacare/components/silhouette_item.dart';
import 'package:talacare/helpers/item.dart';
import 'package:talacare/talacare.dart';

class SilhouetteContainer extends RectangleComponent with HasGameRef<TalaCare> {
  final List<int> indicesDisplayed = [];

  SilhouetteContainer({required super.position, required super.size});

  @override
  FutureOr<void> onLoad() async {
    paint = BasicPalette.lightPink.paint();
    anchor = Anchor.center;
    addNextItem();
    return super.onLoad();
  }

  FutureOr<void> addNextItem() async {
    add(SilhouetteItem(item: Item.values[game.game2Score]));
    indicesDisplayed.add(game.game2Score);
  }
}