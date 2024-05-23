import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/components/hud/hud.dart';
import 'package:talacare/components/hud/progress.dart';
import 'package:talacare/talacare.dart';
import 'package:talacare/components/event.dart';
import 'package:talacare/screens/game_1.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/components/point.dart';
import 'package:talacare/helpers/directions.dart';
import 'package:mockito/mockito.dart';

class MockTapUpEvent extends Mock implements TapUpEvent {}


void main() {
TestWidgetsFlutterBinding.ensureInitialized();
  group('Activity Trigger Tests', () {
    testWithGame<TalaCare>(
      'Point appears and activity isn\'t active prior to collision', 
      TalaCare.new,
      (game) async {
        await game.ready();
        final level = game.children.query<HouseAdventure>().first;
        expect(level.children.query<Player>(), isNotEmpty);
        expect(level.children.query<ActivityPoint>(), isNotEmpty);
        expect(game.eventIsActive, false);
        expect(game.score, 0);
      }
    );
    testWithGame<TalaCare>(
        'All Progress are todo prior collision',
        TalaCare.new,
            (game) async {
          await game.ready();
          Hud hud = game.camera.viewport.children.query<Hud>().first;
          List<ProgressComponent> progressList = hud.children.query<ProgressComponent>();
          for (ProgressComponent progress in progressList) {
            expect(progress.current, ProgressState.todo);
          }
        }
    );
    testWithGame<TalaCare>(
      'Point disappears and activity is active upon collision', 
      TalaCare.new,
      (game) async {
        final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
        await game.ready();
        final level = game.children.query<HouseAdventure>().first;
        final player = level.children.query<Player>().first;
        final point = level.children.query<ActivityPoint>().first;
        point.onCollision(intersection, player);
        await game.ready();
        expect(game.eventAnchor.children.query<ActivityPoint>(), isEmpty);
        expect(game.eventIsActive, true);
        final event = game.eventAnchor.children.query<ActivityEvent>().first;
        for(int i=0;i<10;i++){
          await event.onTapUp(MockTapUpEvent());
        }
        expect(game.score, 1);
      }
    );
    testWithGame<TalaCare>(
        'Progress becomes done upon collision',
        TalaCare.new,
            (game) async {
          final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
          await game.ready();
          final level = game.children.query<HouseAdventure>().first;
          final player = level.children.query<Player>().first;
          final point = level.children.query<ActivityPoint>().where((point) => point.variant != "eating").first;
          point.onCollision(intersection, player);
          Hud hud = game.camera.viewport.children.query<Hud>().first;
          List<ProgressComponent> progressList = hud.children.query<ProgressComponent>();
          game.update(5);
          for (ProgressComponent progress in progressList) {
            if (progress.progressNumber == 1) {
              expect(progress.current, ProgressState.done);
            } else {
              expect(progress.current, ProgressState.todo);
            }
          }
        }
    );
    testWithGame<TalaCare>(
      'Activity disappears after a set duration (10 seconds (when lose))', 
      TalaCare.new,
      (game) async {
        final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
        await game.ready();
        final level = game.children.query<HouseAdventure>().first;
        final player = level.children.query<Player>().first;
        final point = level.children.query<ActivityPoint>().first;
        point.onCollision(intersection, player);
        await game.ready();
        final event = game.eventAnchor.children.query<ActivityEvent>().first;
        event.update(10);
        await game.ready();
        expect(game.eventAnchor.children.query<ActivityEvent>(), isEmpty);
        expect(game.eventIsActive, false);
      }
    );
    testWithGame<TalaCare>(
      'Player is able to move when activity hasn\'t been activated', 
      TalaCare.new,
      (game) async {
        var playerPositionBefore = Vector2(0.0, 0.0);
        var playerPositionAfter = Vector2(0.0, 0.0);
        await game.ready();
        final level = game.children.query<HouseAdventure>().first;
        final player = level.children.query<Player>().first;
        player.position.copyInto(playerPositionBefore);
        player.direction = Direction.up;
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
        final level = game.children.query<HouseAdventure>().first;
        final player = level.children.query<Player>().first;
        final point = level.children.query<ActivityPoint>().first;
        point.onCollision(intersection, player);
        await game.ready();
        player.position.copyInto(playerPositionBefore);
        player.direction = Direction.up;
        player.update(1);
        player.position.copyInto(playerPositionAfter);
        expect(playerPositionBefore, equals(playerPositionAfter));
      }
    );
    // testWithGame<TalaCare>(
    //   'Player is able to move after activity has been deactivated', 
    //   TalaCare.new,
    //   (game) async {
    //     var playerPositionBefore = Vector2(0.0, 0.0);
    //     var playerPositionAfter = Vector2(0.0, 0.0);
    //     final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
    //     await game.ready();
    //     final level = game.children.query<HouseAdventure>().first;
    //     final player = level.children.query<Player>().first;
    //     final point = level.children.query<ActivityPoint>().first;
    //     point.onCollision(intersection, player);
    //     await game.ready();
    //     final event = game.eventAnchor.children.query<ActivityEvent>().first;
    //     event.update(3);
    //     await game.ready();
    //     player.position.copyInto(playerPositionBefore);
    //     player.direction = Direction.up;
    //     player.update(1);
    //     player.position.copyInto(playerPositionAfter);
    //     expect(playerPositionBefore, isNot(equals(playerPositionAfter)));
    //   }
    // );
  });

  group('ActivityEvent', () {
    
    testWithGame<TalaCare>(
      'onTapUp alternates sprites and increases progress',
      TalaCare.new,
      (game) async {
        final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
        await game.ready();
        final level = game.children.query<HouseAdventure>().first;
        final player = level.children.query<Player>().first;
        final point = level.children.query<ActivityPoint>().first;
        point.onCollision(intersection, player);
        await game.ready();
        final event = game.eventAnchor.children.query<ActivityEvent>().first;

        expect(event.currentSpriteIndex, 0);
        expect(event.progress, 0);

        await event.onTapUp(MockTapUpEvent());

        expect(event.currentSpriteIndex, 1);
        expect(event.progress, 1);
      },
    );


    testWithGame<TalaCare>(
      'onTapUp completes progress and calls onActivityEnd',
      TalaCare.new,
      (game) async {
        final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
        await game.ready();
        final level = game.children.query<HouseAdventure>().first;
        final player = level.children.query<Player>().first;
        final point = level.children.query<ActivityPoint>().first;
        point.onCollision(intersection, player);
        await game.ready();
        final event = game.eventAnchor.children.query<ActivityEvent>().first;
        event.progress = 9;

        await event.onTapUp(MockTapUpEvent());
        expect(event.progress, 10);

        expect(event.success, true);
      },
    );

    testWithGame<TalaCare>(
      'onUpdate ends activity if duration exceeds 10 seconds',
      TalaCare.new,
      (game) async {
        final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
        await game.ready();
        final level = game.children.query<HouseAdventure>().first;
        final player = level.children.query<Player>().first;
        final point = level.children.query<ActivityPoint>().first;
        point.onCollision(intersection, player);
        await game.ready();
        final event = game.eventAnchor.children.query<ActivityEvent>().first;
        event.timeElapsed = 11.0;

        event.update(0);

        expect(event.success, false);
      },
    );
  });
}