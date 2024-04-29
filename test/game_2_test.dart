import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/components/game_2.dart';
import 'package:talacare/components/hospital_door.dart';
import 'package:talacare/components/game_1.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/components/point.dart';
import 'package:talacare/helpers/dialog_reason.dart';
import 'package:talacare/talacare.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Game 2 to 1 Integration Test', () {
    testWithGame<TalaCare>(
        'Go back to game 1 when game 2 finish with full health',
        TalaCare.new,
            (game) async {
          await game.ready();
          final game_1 = game.children.query<HouseAdventure>().first;
          final player = game_1.player;
          final door = game_1.children.query<HospitalDoor>().first;
          door.onCollision({Vector2(0.0,0.0), Vector2(0.0,0.0)}, player);
          await game.ready();
          final confirmation = game.confirmation;
          expect(confirmation.reason, DialogReason.enterHospital);
          confirmation.yesButton.onTapDown(createTapDownEvents(game: game));
          confirmation.yesButton.onTapUp(createTapUpEvents(game: game));
          final initialLevel = game.currentGame;
          game.update(5);
          await game.ready();
          final game_2 = game.children.query<HospitalPuzzle>().first;
          game_2.finishGame();
          game.update(5);
          expect(game.currentGame, initialLevel-1);
          expect(game.playerHealth, 4);
          expect(game.player.moveSpeed, 100);
        }
    );

    testWithGame<TalaCare>(
        'Go back to game 1 when game 2 finish with progress maintained',
        TalaCare.new,
            (game) async {
          final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
          await game.ready();
          final game_1 = game.children.query<HouseAdventure>().first;
          final player = game_1.player;
          final point = game_1.children.query<ActivityPoint>().first;
          point.onCollision(intersection, player);
          await game.ready();
          final initialProgress = game.score;
          final door = game_1.children.query<HospitalDoor>().first;
          door.onCollision({Vector2(0.0,0.0), Vector2(0.0,0.0)}, player);
          await game.ready();
          final confirmation = game.confirmation;
          expect(confirmation.reason, DialogReason.enterHospital);
          confirmation.yesButton.onTapDown(createTapDownEvents(game: game));
          confirmation.yesButton.onTapUp(createTapUpEvents(game: game));
          game.update(5);
          await game.ready();
          final game_2 = game.children.query<HospitalPuzzle>().first;
          game_2.finishGame();
          game.update(5);
          expect(game.score, initialProgress);

        }
    );
  });
  group('HospitalPuzzle Timer Test', () {
    testWithGame<TalaCare>(
      'HospitalPuzzle Timer Test Timer starts with 10 seconds and  decreases by 1 second each update, and back to 10 seconds if success drag each object',
      TalaCare.new,
      (game) async {
         final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
          await game.ready();
          final game_1 = game.children.query<HouseAdventure>().first;
          final player = game_1.player;
          final point = game_1.children.query<ActivityPoint>().first;
          point.onCollision(intersection, player);
          await game.ready();
          final initialProgress = game.score;
          final door = game_1.children.query<HospitalDoor>().first;
          door.onCollision({Vector2(0.0,0.0), Vector2(0.0,0.0)}, player);
          await game.ready();
          final confirmation = game.confirmation;
          expect(confirmation.reason, DialogReason.enterHospital);
          confirmation.yesButton.onTapDown(createTapDownEvents(game: game));
          confirmation.yesButton.onTapUp(createTapUpEvents(game: game));
          game.update(5);
          await game.ready();
          final game_2 = game.children.query<HospitalPuzzle>().first;
          expect(game_2.timeLimit, 10);
          game_2.update(1.0);
          expect(game_2.timeLimit, 9);
          game_2.update(9.0);
          game_2.updateScore();
          expect(game_2.timeLimit, 10);
          game_2.update(10.0);
          final instructionText = game_2.instruction.text;

          expect(instructionText, "Kamu belum berhasil");
          expect(game_2.timerStarted, false);
      },
    );
    testWithGame<TalaCare>(
        'Go back to game 1 when game 2 lose, health and speed adjusted and progress maintained',
        TalaCare.new,
            (game) async {
          final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
          await game.ready();
          final game_1 = game.children.query<HouseAdventure>().first;
          final player = game_1.player;
          final point = game_1.children.query<ActivityPoint>().first;
          point.onCollision(intersection, player);
          await game.ready();
          final initialProgress = game.score;
          final door = game_1.children.query<HospitalDoor>().first;
          door.onCollision({Vector2(0.0,0.0), Vector2(0.0,0.0)}, player);
          await game.ready();
          final confirmation = game.confirmation;
          expect(confirmation.reason, DialogReason.enterHospital);
          confirmation.yesButton.onTapDown(createTapDownEvents(game: game));
          confirmation.yesButton.onTapUp(createTapUpEvents(game: game));
          game.update(5);
          await game.ready();
          final game_2 = game.children.query<HospitalPuzzle>().first;
          game_2.loseGame();
          game.update(5);
          expect(game.playerHealth, 2);
          expect(player.moveSpeed, 56.25);  //75% of 75% of 100
          expect(game.score, initialProgress);
        }
    );
  });
  
}