import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/talacare.dart';
import 'package:flame_test/flame_test.dart';
import 'package:talacare/components/dpad_arrow.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  testWithGame<TalaCare>('Camera follows player when moving up', TalaCare.new, (game) async {
    await game.ready();
    game.player.position = Vector2(0, 0);
    game.camOne.viewfinder.position = Vector2(0, 0);
    final DPadArrow upButton = game.gameOne.dPad.upButton;
    upButton.onTapDown(createTapDownEvents(game: game));
    game.update(2.0);
    expect(game.player.position, equals(game.camOne.viewfinder.position));
  });
  testWithGame<TalaCare>('Camera follows player when moving down', TalaCare.new, (game) async {
    await game.ready();
    game.player.position = Vector2(0, 0);
    game.camOne.viewfinder.position = Vector2(0, 0);
    final DPadArrow downButton = game.gameOne.dPad.downButton;
    downButton.onTapDown(createTapDownEvents(game: game));
    game.update(2.0);
    expect(game.player.position, equals(game.camOne.viewfinder.position));
  });
  testWithGame<TalaCare>('Camera follows player when moving left', TalaCare.new, (game) async {
    await game.ready();
    game.player.position = Vector2(0, 0);
    game.camOne.viewfinder.position = Vector2(0, 0);
    final DPadArrow leftButton = game.gameOne.dPad.leftButton;
    leftButton.onTapDown(createTapDownEvents(game: game));
    game.update(2.0);
    expect(game.player.position, equals(game.camOne.viewfinder.position));
  });
  testWithGame<TalaCare>('Camera follows player when moving right', TalaCare.new, (game) async {
    await game.ready();
    game.player.position = Vector2(0, 0);
    game.camOne.viewfinder.position = Vector2(0, 0);
    final DPadArrow rightButton = game.gameOne.dPad.rightButton;
    rightButton.onTapDown(createTapDownEvents(game: game));
    game.update(2.0);
    expect(game.player.position, equals(game.camOne.viewfinder.position));
  });
}
