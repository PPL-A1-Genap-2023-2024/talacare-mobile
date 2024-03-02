import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/components/collision_block.dart';
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
  });

  group('Dynamic Wall Collision Tests', () {
    testWithGame<TalaCare>(
      'Player stops at collision from the left',
      TalaCare.new,
      (game) async {
        await game.ready();
        final level = game.children.query<Level>().first;
        final player = level.player;
        final initialPosition = player.position.clone();
        
        // Simulate player movement to the left
        player.direction = Direction.left;

        // Process movement until before left wall
        final leftWall = player.collisionBlocks.firstWhere((wall) => wall.type == WallTypes.outerLeft);
        final moveAmount = (initialPosition.x - leftWall.x) / player.moveSpeed;
        game.update(moveAmount); 

        // Proceed moving, collide with left wall
        game.update(0.2);
        expect(player.x, leftWall.x + leftWall.width);
        expect(player.y, initialPosition.y);
      },
    );

    testWithGame<TalaCare>(
      'Player stops at collision from the right',
      TalaCare.new,
      (game) async {
        await game.ready();
        final level = game.children.query<Level>().first;
        final player = level.player;
        final initialPosition = player.position.clone();
        
        player.direction = Direction.right;

        // Process movement until before right wall
        final rightWall = player.collisionBlocks.firstWhere((wall) => wall.type == WallTypes.outerRight);
        final moveAmount = (rightWall.x - initialPosition.x) / player.moveSpeed;
        game.update(moveAmount); 

        // Proceed moving, collide with right wall
        game.update(0.2);
        expect(player.x, rightWall.x - player.width);
        expect(player.y, initialPosition.y);
      },
    );

    testWithGame<TalaCare>(
      'Player stops at collision from the top',
      TalaCare.new,
      (game) async {
        await game.ready();
        final level = game.children.query<Level>().first;
        final player = level.player;
        final initialPosition = player.position.clone();
        
        player.direction = Direction.up;

        // Process movement until before top wall
        final topWall = player.collisionBlocks.firstWhere((wall) => wall.type == WallTypes.outerTop);
        final moveAmount = (initialPosition.y - topWall.y) / player.moveSpeed;
        game.update(moveAmount); 

        // Proceed moving, collide with right wall
        game.update(0.2);
        expect(player.y, topWall.y + topWall.height);
        expect(player.x, initialPosition.x);
      },
    );

    testWithGame<TalaCare>(
      'Player stops at collision from the bottom',
      TalaCare.new,
      (game) async {
        await game.ready();
        final level = game.children.query<Level>().first;
        final player = level.player;
        final initialPosition = player.position.clone();
        
        player.direction = Direction.down;

        // Process movement until before bottom wall
        final bottomWall = player.collisionBlocks.firstWhere((wall) => wall.type == WallTypes.outerBottom);
        final moveAmount = (bottomWall.y - initialPosition.y) / player.moveSpeed;
        game.update(moveAmount); 

        // Proceed moving, collide with bottom wall
        game.update(0.2);
        expect(player.y, bottomWall.y - player.height);
        expect(player.x, initialPosition.x);
      },
    );
  });

  group('Static Wall Collision Tests', () {
    testWithGame<TalaCare>(
      'Player collides with left wall when not moving',
      TalaCare.new,
      (game) async {
        await game.ready();
        final level = game.children.query<Level>().first;
        final player = level.player;
        final leftWall = player.collisionBlocks.firstWhere((wall) => wall.type == WallTypes.outerLeft);
        
        // Place the player at the x coordinate of left wall
        player.x = leftWall.x;
        player.velocity = Vector2.zero();

        game.update(0.1);

        expect(player.position.x, greaterThanOrEqualTo(leftWall.x - leftWall.width));
      },
    );

    testWithGame<TalaCare>(
      'Player collides with right wall when not moving',
      TalaCare.new,
      (game) async {
        await game.ready();
        final level = game.children.query<Level>().first;
        final player = level.player;
        final rightWall = player.collisionBlocks.firstWhere((wall) => wall.type == WallTypes.outerRight);
        
        // Place the player at the x coordinate of right wall
        player.x = rightWall.x;
        player.velocity = Vector2.zero();

        game.update(0.1);

        expect(player.position.x, lessThanOrEqualTo(rightWall.x - player.width));
      },
    );

    testWithGame<TalaCare>(
      'Player collides with top wall when not moving',
      TalaCare.new,
      (game) async {
        await game.ready();
        final level = game.children.query<Level>().first;
        final player = level.player;
        final topWall = player.collisionBlocks.firstWhere((wall) => wall.type == WallTypes.outerTop);
        
        // Place the player at the y coordinate of top wall
        player.y = topWall.y;
        player.velocity = Vector2.zero();

        game.update(0.1);

        expect(player.position.y, greaterThanOrEqualTo(topWall.y + topWall.height));
      },
    );

    testWithGame<TalaCare>(
      'Player collides with bottom wall when not moving',
      TalaCare.new,
      (game) async {
        await game.ready();
        final level = game.children.query<Level>().first;
        final player = level.player;
        final bottomWall = player.collisionBlocks.firstWhere((wall) => wall.type == WallTypes.outerBottom);
        
        // Place the player at the y coordinate of bottom wall
        player.y = bottomWall.y;
        player.velocity = Vector2.zero();

        game.update(0.1);

        expect(player.position.y, lessThanOrEqualTo(bottomWall.y - player.height));
      },
    );

    testWithGame<TalaCare>(
      'Player collides with inner wall when not moving',
      TalaCare.new,
      (game) async {
        await game.ready();
        final level = game.children.query<Level>().first;
        final player = level.player;
        final initialPosition = player.position.clone();

        final innerWall = player.collisionBlocks.firstWhere((wall) => wall.type == WallTypes.inside);
       
       // Place the player at the x and y coordinate of inner wall
        player.position = innerWall.position;
        player.velocity = Vector2.zero();
        game.update(0.1);

        expect(player.position, initialPosition);
      },
    );
  });
}
