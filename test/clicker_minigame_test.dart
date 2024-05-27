import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/layout.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/components/clicker_minigame.dart';
import 'package:talacare/talacare.dart';
import 'package:talacare/screens/game_1.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/components/point.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

class MockTapUpEvent extends Mock implements TapUpEvent {}
class SpyClickerMinigame extends Mock implements ClickerMinigame {}

@GenerateMocks([ClickerMinigame])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Progress', () {
      testWithGame<TalaCare>(
          'Verify that ActivityEvent On Tap also run a function in ClickerMinigame',
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

            // Create a spy on the real ClickerMinigame instance
            final spyMinigame = SpyClickerMinigame();
            when(spyMinigame.updateProgress()).thenAnswer((_) => minigame.updateProgress());

            // Replace the activity event with a spy
            minigame.activity.trigger = spyMinigame.updateProgress;

            // Trigger the tap event
            minigame.activity.onTapUp(MockTapUpEvent());

            // Verify that updateProgress was called once
            verify(spyMinigame.updateProgress()).called(1);
        }
      );

      testWithGame<TalaCare>(
          'Check that updateProgress() work as expected',
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

            minigame.updateProgress();

            expect(minigame.firstTap, true);
            expect(minigame.screen.children.query<SpriteAnimationComponent>()[0].isRemoving, true);
            expect(minigame.progress, 1);

            // in case of 10 progress
            for(int i=0;i<10;i++){
              minigame.updateProgress();
            }

            expect(minigame.activity.done, true);
            minigame.update(1);
            expect(minigame.screen.children.query<AlignComponent>()[0].isRemoving, false);
            // Validate that the finishGame() is called
            expect(game.eventIsActive, false);
          }
      );
    });

  group('Timer', () {
    testWithGame<TalaCare>(
        'Timer is working on load',
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
          expect(minigame.timerStarted, isTrue);
          final initTimeLimit = minigame.timeLimit;

          // WIll run updateTimer()
          minigame.update(1);
          expect(minigame.timeLimit, initTimeLimit - 1);

          // Because ActivityEvent is not tapped screen should not remove instruction
          expect(minigame.screen.children.query<SpriteAnimationComponent>()[0].isRemoving, false);
        }
    );

    testWithGame<TalaCare>(
        'Timer stop when timeLimit reached 0',
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
          expect(minigame.timerStarted, isTrue);

          // WIll run updateTimer()
          minigame.update(10);

          // Because ActivityEvent is not tapped screen should not remove instruction
          expect(minigame.screen.children.query<SpriteAnimationComponent>()[0].isRemoving, true);
          expect(minigame.screen.children.query<AlignComponent>()[0].isRemoving, false);
        }
    );
  });

}