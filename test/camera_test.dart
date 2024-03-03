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
    game.cam.viewfinder.position = Vector2(0, 0);
    final DPadArrow upButton = game.dPad.upButton;
    upButton.onTapDown(createTapDownEvents(game: game));
    game.update(2.0);
    expect(game.player.position, equals(game.cam.viewfinder.position));
  });
  testWithGame<TalaCare>('Camera follows player when moving down', TalaCare.new, (game) async {
    await game.ready();
    game.player.position = Vector2(0, 0);
    game.cam.viewfinder.position = Vector2(0, 0);
    final DPadArrow downButton = game.dPad.downButton;
    downButton.onTapDown(createTapDownEvents(game: game));
    game.update(2.0);
    expect(game.player.position, equals(game.cam.viewfinder.position));
  });
  testWithGame<TalaCare>('Camera follows player when moving left', TalaCare.new, (game) async {
    await game.ready();
    game.player.position = Vector2(0, 0);
    game.cam.viewfinder.position = Vector2(0, 0);
    final DPadArrow leftButton = game.dPad.leftButton;
    leftButton.onTapDown(createTapDownEvents(game: game));
    game.update(2.0);
    expect(game.player.position, equals(game.cam.viewfinder.position));
  });
  testWithGame<TalaCare>('Camera follows player when moving right', TalaCare.new, (game) async {
    await game.ready();
    game.player.position = Vector2(0, 0);
    game.cam.viewfinder.position = Vector2(0, 0);
    final DPadArrow rightButton = game.dPad.rightButton;
    rightButton.onTapDown(createTapDownEvents(game: game));
    game.update(2.0);
    expect(game.player.position, equals(game.cam.viewfinder.position));
  });
}
