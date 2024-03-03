import 'dart:async';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:talacare/helpers/arrow_state.dart';
import 'package:talacare/talacare.dart';
import '../helpers/directions.dart';

class DPadArrow extends SpriteGroupComponent<ArrowState> with TapCallbacks, HasGameRef<TalaCare> {
  Direction arrowDirection;

  DPadArrow({required this.arrowDirection});


  @override
  FutureOr<void> onLoad() {
    current = ArrowState.unpressed;
  }

  @override
  void onTapUp(TapUpEvent event) {
    // Do something in response to a tap event
    current = ArrowState.unpressed;
    game.changeDirection(Direction.none);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    // Do something in response to a tap event
    current = ArrowState.unpressed;
    game.changeDirection(Direction.none);
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Do something in response to a tap event
    current = ArrowState.pressed;
    game.changeDirection(arrowDirection);
  }
}