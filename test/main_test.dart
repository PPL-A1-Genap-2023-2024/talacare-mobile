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
        PauseButton.ID
      ], overlayBuilderMap: {
        PauseButton.ID:
            (BuildContext context, CollidableAnimationExample gameRef) =>
                pauseButton,
        PauseMenu.ID:
            (BuildContext context, CollidableAnimationExample gameRef) =>
                pauseMenu
      }));
      await tester.pump();
      expect(myGame.isLoaded, true);
      expect(myGame.paused, false);
      expect(myGame.overlays.isActive(PauseButton.ID), true);
      expect(myGame.overlays.isActive(PauseMenu.ID), false);
    });
    testWidgets('Pause Functionality', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      final myGame = CollidableAnimationExample();
      final pauseButton = PauseButton(gameRef: myGame);
      final pauseMenu = PauseMenu(gameRef: myGame);
      final GlobalKey resumeButtonKey = pauseMenu.getResumeButtonKey();
      await tester
          .pumpWidget(GameWidget(game: myGame, initialActiveOverlays: const [
        PauseButton.ID
      ], overlayBuilderMap: {
        PauseButton.ID:
            (BuildContext context, CollidableAnimationExample gameRef) =>
                pauseButton,
        PauseMenu.ID:
            (BuildContext context, CollidableAnimationExample gameRef) =>
                pauseMenu
      }));
      await tester.pump();
      final pauseButtonIcon = find.byWidgetPredicate((widget) =>
          widget is IconButton && (widget.icon as Icon).icon == Icons.pause);
      await tester.tap(pauseButtonIcon);
      await tester.pump();
      expect(myGame.overlays.isActive(PauseButton.ID), false);
      expect(myGame.overlays.isActive(PauseMenu.ID), true);
      expect(myGame.paused, true);
      final resumeButtonIcon = find.byKey(resumeButtonKey);
      await tester.tap(resumeButtonIcon);
      expect(myGame.overlays.isActive(PauseButton.ID), true);
      expect(myGame.overlays.isActive(PauseMenu.ID), false);
      expect(myGame.paused, false);
    });
  });
}
