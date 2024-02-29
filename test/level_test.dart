import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/components/level.dart';
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
        player.horizontalMovement = -1;
        player.velocity.x = player.horizontalMovement * player.moveSpeed;
        player.velocity.y = 0;

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
  });
}
