import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:talacare/dpad_arrow.dart';
import 'package:talacare/blank_game.dart';


void main() {
    TestWidgetsFlutterBinding.ensureInitialized();

    testWithGame<BlankGame>('Left Movement', BlankGame.new, (game) async {
      await game.ready();
      final DPadArrow leftButton = game.leftButton;
      Vector2 initialPosition = Vector2(0,0);
      game.player.position.copyInto(initialPosition);
      leftButton.onTapDown(createTapDownEvents(game: game));
      expect(leftButton.tapped, true);
      game.update(15);
      expect(game.player.position.x, initialPosition.x - game.player.maxSpeed);
      expect(game.player.position.y, initialPosition.y);
    });

    testWithGame<BlankGame>('Right Movement', BlankGame.new, (game) async {
      await game.ready();
      final DPadArrow rightButton = game.rightButton;
      Vector2 initialPosition = Vector2(0,0);
      game.player.position.copyInto(initialPosition);
      rightButton.onTapDown(createTapDownEvents(game: game));
      expect(rightButton.tapped, true);
      game.update(5);
      expect(game.player.position.x, initialPosition.x + game.player.maxSpeed);
      expect(game.player.position.y, initialPosition.y);
      expect(game.player.playerFlipped, true);
    });

    testWithGame<BlankGame>('Right Movement then Left Movement', BlankGame.new, (game) async {
      await game.ready();
      final DPadArrow rightButton = game.rightButton;
      Vector2 initialPosition = Vector2(0,0);
      game.player.position.copyInto(initialPosition);
      rightButton.onTapDown(createTapDownEvents(game: game));
      expect(rightButton.tapped, true);
      game.update(5);
      expect(game.player.position.x, initialPosition.x + game.player.maxSpeed);
      expect(game.player.position.y, initialPosition.y);
      expect(game.player.playerFlipped, true);

      final DPadArrow leftButton = game.leftButton;
      leftButton.onTapDown(createTapDownEvents(game: game));
      expect(leftButton.tapped, true);
      game.update(5);
      expect(game.player.position.x, initialPosition.x);
      expect(game.player.position.y, initialPosition.y);
      expect(game.player.playerFlipped, false);
    });

    testWithGame<BlankGame>('Down Movement', BlankGame.new, (game) async {
      await game.ready();
      final DPadArrow downButton = game.downButton;
      Vector2 initialPosition = Vector2(0,0);
      game.player.position.copyInto(initialPosition);
      downButton.onTapDown(createTapDownEvents(game: game));
      expect(downButton.tapped, true);
      game.update(5);
      expect(game.player.position.x, initialPosition.x);
      expect(game.player.position.y, initialPosition.y + game.player.maxSpeed);
    });

    testWithGame<BlankGame>('Up Movement', BlankGame.new, (game) async {
      await game.ready();
      final DPadArrow upButton = game.upButton;
      Vector2 initialPosition = Vector2(0,0);
      game.player.position.copyInto(initialPosition);
      upButton.onTapDown(createTapDownEvents(game: game));
      expect(upButton.tapped, true);
      game.update(5);
      expect(game.player.position.x, initialPosition.x);
      expect(game.player.position.y, initialPosition.y - game.player.maxSpeed);
    });

    testWithGame<BlankGame>('Tap Release', BlankGame.new, (game) async {
      await game.ready();
      final DPadArrow component = game.upButton;
      Vector2 initialPosition = Vector2(0,0);
      game.player.position.copyInto(initialPosition);
      component.onTapUp(createTapUpEvents(game: game));
      expect(component.tapped, false);
      game.update(5);
      expect(game.player.position.x, initialPosition.x);
      expect(game.player.position.y, initialPosition.y);
    });

    testWithGame<BlankGame>('Tap Cancel', BlankGame.new, (game) async {
      await game.ready();
      final DPadArrow component = game.upButton;
      Vector2 initialPosition = Vector2(0,0);
      game.player.position.copyInto(initialPosition);
      component.onTapCancel(createTapCancelEvents(game));
      expect(component.tapped, false);
      game.update(15);
      expect(game.player.position.x, initialPosition.x);
      expect(game.player.position.y, initialPosition.y);
    });


}

TapCancelEvent createTapCancelEvents(FlameGame game) {
  return TapCancelEvent(
    1,
  );
}