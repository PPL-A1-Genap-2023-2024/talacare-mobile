import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/components/level.dart';
import 'package:talacare/helpers/directions.dart';
import 'package:talacare/talacare.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Map Loading Tests', () {
    testWithGame<TalaCare>(
      'Map loads when game loads', 
      TalaCare.new,
      (game) async {
        await game.ready();
        expect(game.children.query<Level>(), isNotEmpty);
      }
    );
    testWithGame<TalaCare>(
      'Default level name is level 1', 
      TalaCare.new,
      (game) async {
        await game.ready();
        expect(game.children.query<Level>().first.levelName, "Level-01");
      }
    );
    testWithGame<TalaCare>(
      'Collision blocks on map is not empty', 
      TalaCare.new,
      (game) async {
        await game.ready();
        expect(game.children.query<Level>().first.collisionBlocks, isNotEmpty);
      }
    );
    testWithGame<TalaCare>(
      'Activity Spawn Points size is taken',
      TalaCare.new,
      (game) async {
        await game.ready();
        final level = game.children.query<Level>().first;
        final numberOfActivityPoints = level.selectedActivity.length;
        expect(numberOfActivityPoints, level.taken);
      }
    );

  });

  group('Wall Collision Tests', () {
    testWithGame<TalaCare>(
      'Player stops at wall collision',
      TalaCare.new,
      (game) async {
        await game.ready();
        final level = game.children.query<Level>().first;
        final player = level.player;
        final initialPosition = player.position.clone();
        
        // Simulate player movement to the left
        player.direction = Direction.left;

        // Process movement until before left wall
        const leftWallXPosition = 16;
        final moveAmount = (initialPosition.x - leftWallXPosition) / player.moveSpeed;
        game.update(moveAmount); 

        // Proceed moving, collide with left wall
        game.update(0.2);
        expect(player.position.x, leftWallXPosition);
        expect(player.position.y, initialPosition.y);
      },
    );
    testWithGame<TalaCare>(
      'Player does not move through outer walls of house',
      TalaCare.new,
      (game) async {
        await game.ready();
        // Place player next to right wall
        final level = game.children.query<Level>().first;
        final player = level.player;
        const rightWallXPosition = 352;
        player.position.x = rightWallXPosition-player.width;
        // Attempt to move player through the wall
        player.position.x += 20; // Simulate moving right into a wall

        // Process the movement
        game.update(0.1);
        
        // Verify player has not moved through the wall
        expect(player.position.x, lessThanOrEqualTo(rightWallXPosition));
      },
    );
  });
}
