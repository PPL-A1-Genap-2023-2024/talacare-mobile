import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/main.dart';

void main() {
TestWidgetsFlutterBinding.ensureInitialized();
  group('Activity Trigger Tests', () {
    testWithGame<TalaCare>(
      'Point appears and activity isn\'t active prior to collision', 
      TalaCare.new,
      (game) async {
        await game.ready();
        expect(game.children.query<Player>(), isNotEmpty);
        expect(game.children.query<Point>(), isNotEmpty);
        expect(game.children.query<Activity>(), isEmpty);
        expect(game.isDoingActivity, false);
        expect(game.score, 0);
      }
    );
    testWithGame<TalaCare>(
      'Point disappears and activity is active upon collision', 
      TalaCare.new,
      (game) async {
        final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
        await game.ready();
        final player = game.children.query<Player>().first;
        final point = game.children.query<Point>().first;
        point.onCollision(intersection, player);
        await game.ready();
        expect(game.children.query<Point>(), isEmpty);
        expect(game.children.query<Activity>(), isNotEmpty);
        expect(game.isDoingActivity, true);
        expect(game.score, 1);
      }
    );
    testWithGame<TalaCare>(
      'Activity disappears after a set duration (3 seconds)', 
      TalaCare.new,
      (game) async {
        final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
        await game.ready();
        final player = game.children.query<Player>().first;
        final point = game.children.query<Point>().first;
        point.onCollision(intersection, player);
        await game.ready();
        final activity = game.children.query<Activity>().first;
        activity.update(3);
        await game.ready();
        expect(game.children.query<Activity>(), isEmpty);
        expect(game.isDoingActivity, false);
      }
    );
    testWithGame<TalaCare>(
      'Player is able to move when activity hasn\'t been activated', 
      TalaCare.new,
      (game) async {
        var playerPositionBefore = Vector2(0.0, 0.0);
        var playerPositionAfter = Vector2(0.0, 0.0);
        await game.ready();
        final player = game.children.query<Player>().first;
        player.position.copyInto(playerPositionBefore);
        player.update(1);
        player.position.copyInto(playerPositionAfter);
        expect(playerPositionBefore, isNot(equals(playerPositionAfter)));
      }
    );
    testWithGame<TalaCare>(
      'Player isn\'t able to move when activity is active', 
      TalaCare.new,
      (game) async {
        var playerPositionBefore = Vector2(0.0, 0.0);
        var playerPositionAfter = Vector2(0.0, 0.0);
        final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
        await game.ready();
        final player = game.children.query<Player>().first;
        final point = game.children.query<Point>().first;
        point.onCollision(intersection, player);
        await game.ready();
        player.position.copyInto(playerPositionBefore);
        player.update(1);
        player.position.copyInto(playerPositionAfter);
        expect(playerPositionBefore, equals(playerPositionAfter));
      }
    );
    testWithGame<TalaCare>(
      'Player is able to move after activity has been deactivated', 
      TalaCare.new,
      (game) async {
        var playerPositionBefore = Vector2(0.0, 0.0);
        var playerPositionAfter = Vector2(0.0, 0.0);
        final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
        await game.ready();
        final player = game.children.query<Player>().first;
        final point = game.children.query<Point>().first;
        point.onCollision(intersection, player);
        await game.ready();
        final activity = game.children.query<Activity>().first;
        activity.update(3);
        await game.ready();
        player.position.copyInto(playerPositionBefore);
        player.update(1);
        player.position.copyInto(playerPositionAfter);
        expect(playerPositionBefore, isNot(equals(playerPositionAfter)));
      }
    );
  });
}
