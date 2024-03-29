import 'package:flame/input.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/components/game_2.dart';
import 'package:talacare/components/hospital_door.dart';
import 'package:talacare/components/game_1.dart';
import 'package:talacare/components/point.dart';
import 'package:talacare/helpers/dialog_reason.dart';
import 'package:talacare/talacare.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Game 2 Transition Test', () {
        testWithGame<TalaCare>(
            'Play transition when entering hospital voluntarily',
            TalaCare.new,
                (game) async {
            await game.ready();
            game.currentGame = 2;
            game.switchGame();
            await game.ready();
            final game_2 = game.children.query<HospitalPuzzle>().first;
            game.update(5);
            await game.ready();
            final button = game_2.playButtonAnchor.children.query<SpriteButtonComponent>().first;
            button.onTapDown(createTapDownEvents(game: game));
            button.onTapUp(createTapUpEvents(game: game));
            await game.ready();
            expect(game_2.finished, true);
            }
        );

        testWithGame<TalaCare>(
            'Play transition when entering hospital because of low blood',
            TalaCare.new,
                (game) async {
              await game.ready();
              game.currentGame = 2;
              game.switchGame(reason: DialogReason.lowBlood);
              await game.ready();
              final game_2 = game.children.query<HospitalPuzzle>().first;
              expect(game_2.nurseTransition, true);
              game.update(5);
              await game.ready();
              final button = game_2.playButtonAnchor.children.query<SpriteButtonComponent>().first;
              button.onTapDown(createTapDownEvents(game: game));
              button.onTapUp(createTapUpEvents(game: game));
              await game.ready();
              expect(game_2.finished, true);
            }
        );
  });
  group('Game 2 to 1 Integration Test', () {
    testWithGame<TalaCare>(
        'Go back to game 1 when game 2 finish with full health and progress maintained',
        TalaCare.new,
            (game) async {
          await game.ready();
          final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
          final game_1 = game.children.query<HouseAdventure>().first;
          final player = game_1.player;
          final point = game_1.children.query<ActivityPoint>().first;
          point.onCollision(intersection, player);
          await game.ready();
          final initialProgress = game.score;
          final door = game_1.children.query<HospitalDoor>().first;
          door.onCollision(intersection, player);
          await game.ready();
          final confirmation = game.confirmation;
          expect(confirmation.reason, DialogReason.enterHospital);
          confirmation.yesButton.onTapDown(createTapDownEvents(game: game));
          confirmation.yesButton.onTapUp(createTapUpEvents(game: game));
          final initialLevel = game.currentGame;

          await game.ready();
          final game_2 = game.children.query<HospitalPuzzle>().first;
          game_2.finishGame();
          expect(game_2.finished, true);
          game.update(5);
          expect(game.currentGame, initialLevel-1);
          expect(game.playerHealth, 4);
          expect(game.player.moveSpeed, 100);
          expect(game.score, initialProgress);

            }
    );

  });


}
