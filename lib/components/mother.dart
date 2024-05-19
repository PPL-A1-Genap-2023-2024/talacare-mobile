import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:talacare/talacare.dart';
import 'package:talacare/helpers/directions.dart';

class Mother extends SpriteAnimationComponent with HasGameRef<TalaCare> {
  Direction direction;
  late int beginningSprite;
  late String state;

  Mother({super.position, this.direction = Direction.none});

  @override
  FutureOr<void> onLoad() {
    switch(direction) {
      case Direction.left: {
        beginningSprite = 12;
        state = 'run';
      }
      case Direction.right: {
        beginningSprite = 0;
        state = 'run';
      }
      default: {
        beginningSprite = 18;
        state = 'idle';
      }
    }
    final motherSpritesheet = SpriteSheet.fromColumnsAndRows(
      image: game.images.fromCache('Characters_free/mother_$state.png'),
      columns: 24,
      rows: 1
    );
    animation = motherSpritesheet.createAnimation(
      row: 0,
      stepTime: 0.25,
      from: beginningSprite,
      to: beginningSprite + 6
    );
    return super.onLoad();
  }
}