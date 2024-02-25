import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/widgets/overlays/d_pad.dart';
import 'package:talacare/blank_game.dart';

void main() {

    testWidgets('Initial Condition', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      final blankGame = BlankGame();
      final dPadButton = DPadButton(onPressed: blankGame.onDirectionChanged);
      await tester
          .pumpWidget(GameWidget(game: blankGame, initialActiveOverlays: const [
        DPadButton.ID
      ], overlayBuilderMap: {
        DPadButton.ID:
            (BuildContext context, BlankGame gameRef) =>
        dPadButton
      }));
      await tester.pump();
      expect(blankGame.overlays.isActive(DPadButton.ID), true);
    });


    testWidgets('Movement', (tester) async {
      final blankGame = BlankGame();
      final dPadButton = DPadButton(onPressed: blankGame.onDirectionChanged);
      await tester
          .pumpWidget(GameWidget(game: blankGame, initialActiveOverlays: const [
        DPadButton.ID
      ], overlayBuilderMap: {
        DPadButton.ID:
            (BuildContext context, BlankGame gameRef) =>
        dPadButton
      }));
      await tester.pump();
      final initialPosition = blankGame.player.position;

      final leftButton = find.byKey(const Key("Left"));
      await tester.tap(leftButton);
      expect(blankGame.player.position.x, initialPosition.x);

      final rightButton = find.byKey(const Key("Right"));
      await tester.tap(rightButton);
      expect(blankGame.player.position.x, initialPosition.x );

      final downButton = find.byKey(const Key("Down"));
      await tester.tap(downButton);
      expect(blankGame.player.position.y, initialPosition.y);

      final upButton = find.byKey(const Key("Left"));
      await tester.tap(upButton);
      expect(blankGame.player.position.y, initialPosition.y);
    });
}