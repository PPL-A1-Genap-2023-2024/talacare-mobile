import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/main.dart';
import 'package:talacare/widgets/overlays/pause_button.dart';
import 'package:talacare/widgets/overlays/pause_menu.dart';

void main() {
  group('PauseMenuTest', () {
    testWidgets('Initial Condition', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      final myGame = CollidableAnimationExample();
      final pauseButton = PauseButton(gameRef: myGame);
      final pauseMenu = PauseMenu(gameRef: myGame);
      await tester
          .pumpWidget(GameWidget(game: myGame, initialActiveOverlays: const [
        PauseButton.id
      ], overlayBuilderMap: {
        PauseButton.id:
            (BuildContext context, CollidableAnimationExample gameRef) =>
                pauseButton,
        PauseMenu.id:
            (BuildContext context, CollidableAnimationExample gameRef) =>
                pauseMenu
      }));
      await tester.pump();
      expect(myGame.isLoaded, true);
      expect(myGame.paused, false);
      expect(myGame.overlays.isActive(PauseButton.id), true);
      expect(myGame.overlays.isActive(PauseMenu.id), false);
    });
    testWidgets('Pause Functionality', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      final myGame = CollidableAnimationExample();
      final pauseButton = PauseButton(gameRef: myGame);
      final pauseMenu = PauseMenu(gameRef: myGame);
      final GlobalKey pauseButtonKey = pauseButton.getPauseButtonKey();
      final GlobalKey resumeButtonKey = pauseMenu.getResumeButtonKey();
      await tester
          .pumpWidget(GameWidget(game: myGame, initialActiveOverlays: const [
        PauseButton.id
      ], overlayBuilderMap: {
        PauseButton.id:
            (BuildContext context, CollidableAnimationExample gameRef) =>
                pauseButton,
        PauseMenu.id:
            (BuildContext context, CollidableAnimationExample gameRef) =>
                pauseMenu
      }));
      await tester.pump();
      final pauseButtonIcon = find.byKey(pauseButtonKey);
      await tester.tap(pauseButtonIcon);
      await tester.pump();
      expect(myGame.overlays.isActive(PauseButton.id), false);
      expect(myGame.overlays.isActive(PauseMenu.id), true);
      expect(myGame.paused, true);
      final resumeButtonIcon = find.byKey(resumeButtonKey);
      await tester.tap(resumeButtonIcon);
      expect(myGame.overlays.isActive(PauseButton.id), true);
      expect(myGame.overlays.isActive(PauseMenu.id), false);
      expect(myGame.paused, false);
    });
  });
}
