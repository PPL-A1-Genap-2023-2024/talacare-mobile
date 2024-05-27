import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:talacare/components/dpad_arrow.dart';
import 'package:talacare/helpers/arrow_state.dart';
import 'package:talacare/talacare.dart';


void main() {
    TestWidgetsFlutterBinding.ensureInitialized();

    testWithGame<TalaCare>('Left Movement', TalaCare.new, (game) async {
      game.isWidgetTesting = true;
      await game.ready();
      final DPadArrow leftButton = game.gameOne.dPad.leftButton;
      Vector2 initialPosition = Vector2(0,0);
      game.player.position.copyInto(initialPosition);
      leftButton.onTapDown(createTapDownEvents(game: game));
      expect(leftButton.current, ArrowState.pressed);
      final delta = 5.0;
      game.update(delta);
      expect(game.player.position.x, initialPosition.x - game.player.moveSpeed * delta);
      expect(game.player.position.y, initialPosition.y);
    });

    testWithGame<TalaCare>('Right Movement', TalaCare.new, (game) async {
      game.isWidgetTesting = true;
      await game.ready();
      final DPadArrow rightButton = game.gameOne.dPad.rightButton;
      Vector2 initialPosition = Vector2(0,0);
      game.player.position.copyInto(initialPosition);
      rightButton.onTapDown(createTapDownEvents(game: game));
      expect(rightButton.current, ArrowState.pressed);
      final delta = 5.0;
      game.update(delta);
      expect(game.player.position.x, initialPosition.x + game.player.moveSpeed * delta);
      expect(game.player.position.y, initialPosition.y);
      // expect(game.player.playerFlipped, true);
    });


    testWithGame<TalaCare>('Down Movement', TalaCare.new, (game) async {
      game.isWidgetTesting = true;
      await game.ready();
      final DPadArrow downButton = game.gameOne.dPad.downButton;
      Vector2 initialPosition = Vector2(0,0);
      game.player.position.copyInto(initialPosition);
      downButton.onTapDown(createTapDownEvents(game: game));
      expect(downButton.current, ArrowState.pressed);
      final delta = 5.0;
      game.update(delta);
      expect(game.player.position.x, initialPosition.x);
      expect(game.player.position.y, initialPosition.y + game.player.moveSpeed * delta);
    });

    testWithGame<TalaCare>('Up Movement', TalaCare.new, (game) async {
      game.isWidgetTesting = true;
      await game.ready();
      final DPadArrow upButton = game.gameOne.dPad.upButton;
      Vector2 initialPosition = Vector2(0,0);
      game.player.position.copyInto(initialPosition);
      upButton.onTapDown(createTapDownEvents(game: game));
      expect(upButton.current, ArrowState.pressed);
      final delta = 5.0;
      game.update(delta);
      expect(game.player.position.x, initialPosition.x);
      expect(game.player.position.y, initialPosition.y - game.player.moveSpeed * delta);
    });

    testWithGame<TalaCare>('Tap Release', TalaCare.new, (game) async {
      game.isWidgetTesting = true;
      await game.ready();
      final DPadArrow component = game.gameOne.dPad.upButton;
      Vector2 initialPosition = Vector2(0,0);
      game.player.position.copyInto(initialPosition);
      component.onTapUp(createTapUpEvents(game: game));
      expect(component.current, ArrowState.unpressed);
      final delta = 5.0;
      game.update(delta);
      expect(game.player.position.x, initialPosition.x);
      expect(game.player.position.y, initialPosition.y);
    });

    testWithGame<TalaCare>('Tap Cancel', TalaCare.new, (game) async {
      game.isWidgetTesting = true;
      await game.ready();
      final DPadArrow component = game.gameOne.dPad.upButton;
      Vector2 initialPosition = Vector2(0,0);
      game.player.position.copyInto(initialPosition);
      component.onTapCancel(createTapCancelEvents(game));
      expect(component.current, ArrowState.unpressed);
      final delta = 5.0;
      game.update(delta);
      expect(game.player.position.x, initialPosition.x);
      expect(game.player.position.y, initialPosition.y);
    });


}

TapCancelEvent createTapCancelEvents(FlameGame game) {
  return TapCancelEvent(
    1,
  );
}