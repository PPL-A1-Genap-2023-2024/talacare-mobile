import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'blank_game.dart';
import 'helpers/directions.dart';

class DPadArrow extends SpriteComponent with TapCallbacks, HasGameRef<BlankGame> {
  Direction arrowDirection;
  Sprite defaultSprite;
  Sprite pressedSprite;
  bool tapped = false;

  DPadArrow({required this.arrowDirection, required this.defaultSprite, required this.pressedSprite});

  @override
  void onTapUp(_) {
    // Do something in response to a tap event
    sprite = defaultSprite;
    game.changeDirection(Direction.none);
    tapped = false;
  }

  @override
  void onTapCancel(_) {
    // Do something in response to a tap event
    sprite = defaultSprite;
    game.changeDirection(Direction.none);
    tapped = false;
  }

  @override
  void onTapDown(_) {
    // Do something in response to a tap event
    sprite = pressedSprite;
    game.changeDirection(arrowDirection);
    tapped = true;
  }
}