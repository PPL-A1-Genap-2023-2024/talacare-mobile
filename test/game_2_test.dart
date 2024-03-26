import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/components/collision_block.dart';
import 'package:talacare/components/game_2.dart';
import 'package:talacare/components/hospital_door.dart';
import 'package:talacare/components/hud/hud.dart';
import 'package:talacare/components/game_1.dart';
import 'package:talacare/components/point.dart';
import 'package:talacare/helpers/directions.dart';
import 'package:talacare/helpers/hospital_reason.dart';
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
          expect(confirmation.reason, HospitalReason.playerEnter);
          confirmation.yesButton.onTapDown(createTapDownEvents(game: game));
          confirmation.yesButton.onTapUp(createTapUpEvents(game: game));
          final initialLevel = game.currentGame;

          await game.ready();
          final game_2 = game.children.query<HospitalPuzzle>().first;
          game_2.finish_game();
          await game.ready();
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
          expect(confirmation.reason, HospitalReason.playerEnter);
          confirmation.yesButton.onTapDown(createTapDownEvents(game: game));
          confirmation.yesButton.onTapUp(createTapUpEvents(game: game));
          await game.ready();
          final game_2 = game.children.query<HospitalPuzzle>().first;
          game_2.finish_game();
          await game.ready();
          expect(game.score, initialProgress);

        }
    );
  });


}
