import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/components/activity_event.dart';
import 'package:talacare/components/clicker_minigame.dart';
import 'package:talacare/components/hud/hud.dart';
import 'package:talacare/components/hud/progress.dart';
import 'package:talacare/talacare.dart';
import 'package:talacare/screens/game_1.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/components/point.dart';
import 'package:mockito/mockito.dart';

class MockTapUpEvent extends Mock implements TapUpEvent {}


void main() {
TestWidgetsFlutterBinding.ensureInitialized();
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
    'Setup correctly on ClickerMinigame Load',
    TalaCare.new,
    (game) async {
      final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
      await game.ready();
      final level = game.children.query<HouseAdventure>().first;
      final player = level.children.query<Player>().first;
      final point = level.children.query<ActivityPoint>().where((point) => point.variant != "eating").first;
      point.onCollision(intersection, player);
      await game.ready();
      ClickerMinigame minigame = game.camOne.viewport.children.query<ClickerMinigame>()[0];

      expect(minigame.variant, isNot("eating"));
      expect(minigame.activity, isNotNull);
      expect(minigame.activity.done, false);
      expect(minigame.activity.currentSpriteIndex, 0);
      expect(minigame.activity.sprite, isNotNull);
      expect(minigame.activity.eventSprites.length, 2);
      expect(minigame.activity.eventSprites.first.srcSize, Vector2.all(350));
    }
  );

  testWithGame<TalaCare>(
      'Activity Event can be tapped',
      TalaCare.new,
          (game) async {
        final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
        await game.ready();
        final level = game.children.query<HouseAdventure>().first;
        final player = level.children.query<Player>().first;
        final point = level.children.query<ActivityPoint>().where((point) => point.variant != "eating").first;
        point.onCollision(intersection, player);
        await game.ready();
        ClickerMinigame minigame = game.camOne.viewport.children.query<ClickerMinigame>()[0];
        expect(minigame.activity.done, isFalse);

        minigame.activity.onTapUp(MockTapUpEvent());
        expect(minigame.activity.currentSpriteIndex, 1);
      }
  );

  testWithGame<TalaCare>(
      'Sprite will not change after activity is done',
      TalaCare.new,
          (game) async {
        final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
        await game.ready();
        final level = game.children.query<HouseAdventure>().first;
        final player = level.children.query<Player>().first;
        final point = level.children.query<ActivityPoint>().where((point) => point.variant != "eating").first;
        point.onCollision(intersection, player);
        await game.ready();
        ClickerMinigame minigame = game.camOne.viewport.children.query<ClickerMinigame>()[0];
        expect(minigame.activity.done, isFalse);

        for(int i=0;i<10;i++){
          minigame.updateProgress();
        }

        expect(minigame.activity.done, isTrue);
        expect(minigame.activity.currentSpriteIndex, 0);

        minigame.activity.onTapUp(MockTapUpEvent());
        expect(minigame.activity.currentSpriteIndex, 0);
      }
  );

  testWithGame<TalaCare>(
      'Run VoidCallback when OnTap',
      TalaCare.new,
          (game) async {
        final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
        await game.ready();
        final level = game.children.query<HouseAdventure>().first;
        final player = level.children.query<Player>().first;
        final point = level.children.query<ActivityPoint>().where((point) => point.variant != "eating").first;
        point.onCollision(intersection, player);
        await game.ready();
        bool isWorking = false;
        void isTriggered(){
          isWorking = true;
        }
        ClickerMinigame minigame = game.camOne.viewport.children.query<ClickerMinigame>()[0];
        minigame.activity.trigger = isTriggered;
        minigame.activity.onTapUp(MockTapUpEvent());
        expect(isWorking, true);
      }
  );

}