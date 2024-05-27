import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/talacare.dart';
import 'package:talacare/screens/game_1.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/components/point.dart';
import 'package:mockito/mockito.dart';
import 'package:talacare/components/clicker_minigame.dart';

class MockTapUpEvent extends Mock implements TapUpEvent {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ActivityEvent ProgressBar Tests', () {
    testWithGame<TalaCare>(
      'ProgressBar initializes with 0 progress',
      TalaCare.new,
      (game) async {
        final intersection = {Vector2(0.0, 0.0), Vector2(0.0, 0.0)};
        await game.ready();
        final level = game.children.query<HouseAdventure>().first;
        final player = level.children.query<Player>().first;
        final point = level.children.query<ActivityPoint>().where((point) => point.variant != "eating").first;
        point.onCollision(intersection, player);
        await game.ready();
        ClickerMinigame minigame = game.camOne.viewport.children.query<ClickerMinigame>()[0];

        expect(minigame.progressBar.progress, 0);
      },
    );

    testWithGame<TalaCare>(
      'ProgressBar updates correctly on tap',
      TalaCare.new,
      (game) async {
        final intersection = {Vector2(0.0, 0.0), Vector2(0.0, 0.0)};
        await game.ready();
        final level = game.children.query<HouseAdventure>().first;
        final player = level.children.query<Player>().first;
        final point = level.children.query<ActivityPoint>().where((point) => point.variant != "eating").first;
        point.onCollision(intersection, player);
        await game.ready();

        ClickerMinigame minigame = game.camOne.viewport.children.query<ClickerMinigame>()[0];

        for (int i = 1; i <= 10; i++) {
          minigame.activity.onTapUp(MockTapUpEvent());
          expect(minigame.progressBar.progress, i / 10.0);
        }
      },
    );

    testWithGame<TalaCare>(
      'ProgressBar reaches 100% on completing progress',
      TalaCare.new,
      (game) async {
        final intersection = {Vector2(0.0, 0.0), Vector2(0.0, 0.0)};
        await game.ready();
        final level = game.children.query<HouseAdventure>().first;
        final player = level.children.query<Player>().first;
        final point = level.children.query<ActivityPoint>().where((point) => point.variant != "eating").first;
        point.onCollision(intersection, player);
        await game.ready();

        ClickerMinigame minigame = game.camOne.viewport.children.query<ClickerMinigame>()[0];

        for (int i = 1; i <= 10; i++) {
          minigame.activity.onTapUp(MockTapUpEvent());
        }


        expect(minigame.progressBar.progress, 1.0);
        expect(minigame.activity.done, isTrue);
      },
    );
  });
}
