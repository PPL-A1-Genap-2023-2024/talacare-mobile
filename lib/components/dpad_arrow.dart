import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:talacare/talacare.dart';
import '../helpers/directions.dart';

class DPadArrow extends SpriteComponent with TapCallbacks, HasGameRef<TalaCare> {
  Direction arrowDirection;
  Sprite defaultSprite;
  Sprite pressedSprite;
  bool tapped = false;

  DPadArrow({required this.arrowDirection, required this.defaultSprite, required this.pressedSprite});



  @override
  void onTapUp(TapUpEvent event) {
    // Do something in response to a tap event
    sprite = defaultSprite;
    game.changeDirection(Direction.none);
    tapped = false;
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    // Do something in response to a tap event
    sprite = defaultSprite;
    game.changeDirection(Direction.none);
    tapped = false;
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Do something in response to a tap event
    sprite = pressedSprite;
    game.changeDirection(arrowDirection);
    tapped = true;
  }
}