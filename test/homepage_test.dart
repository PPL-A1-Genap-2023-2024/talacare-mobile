import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/talacare.dart';
import 'package:talacare/widgets/overlays/pause_button.dart';
import 'package:talacare/widgets/overlays/pause_menu.dart';
import 'package:talacare/widgets/homepage.dart';

void main() {
  group('HomePageTest', () {
    testWidgets('Initial Condition', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      final myGame = TalaCare(isWidgetTesting: true);
      final homePage = HomePage(gameRef: myGame);
      await tester
          .pumpWidget(GameWidget(game: myGame, initialActiveOverlays: const [
        HomePage.id
      ], overlayBuilderMap: {
        HomePage.id: (BuildContext context, TalaCare gameRef) => homePage,
      }));
      await tester.pump();
      expect(myGame.isLoaded, true);
      expect(myGame.paused, true);
      expect(myGame.overlays.isActive(HomePage.id), true);
    });
    testWidgets('Play Button Functionality', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      final myGame = TalaCare(isWidgetTesting: true);
      final homePage = HomePage(gameRef: myGame);
      final GlobalKey playButtonKey = homePage.getPlayButtonKey();
      final pauseButton = PauseButton(gameRef: myGame);
      final pauseMenu = PauseMenu(gameRef: myGame);
      await tester
          .pumpWidget(GameWidget(game: myGame, initialActiveOverlays: const [
        HomePage.id
      ], overlayBuilderMap: {
        HomePage.id: (BuildContext context, TalaCare gameRef) => homePage,
        PauseButton.id: (BuildContext context, TalaCare gameRef) => pauseButton,
        PauseMenu.id: (BuildContext context, TalaCare gameRef) => pauseMenu
      }));
      await tester.pump();
      final playButton = find.byKey(playButtonKey);
      await tester.tap(playButton);
      await tester.pump();
      expect(myGame.paused, false);
      expect(myGame.overlays.isActive(HomePage.id), false);
      expect(myGame.overlays.isActive(PauseButton.id), true);
    });
  });

  group('Character Selection Test', (){
    testWidgets('Check Default Character', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      final myGame = TalaCare(isWidgetTesting: true);
      final homePage = HomePage(gameRef: myGame);
      final pauseButton = PauseButton(gameRef: myGame);
      final pauseMenu = PauseMenu(gameRef: myGame);
      await tester
          .pumpWidget(GameWidget(game: myGame, initialActiveOverlays: const [
        HomePage.id
      ], overlayBuilderMap: {
        HomePage.id: (BuildContext context, TalaCare myGame) => homePage,
        PauseButton.id: (BuildContext context, TalaCare myGame) => pauseButton,
        PauseMenu.id: (BuildContext context, TalaCare myGame) => pauseMenu
      }));
      await tester.pump();
      expect(myGame.player.character, 'boy');
    });
  });
}
