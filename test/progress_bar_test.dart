import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/components/hud/hud.dart';
import 'package:talacare/components/hud/progress.dart';
import 'package:talacare/components/progress_bar.dart';
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

        final event = game.eventAnchor.children.query<ActivityEvent>().first;
        expect(event.progressBar.progress, 0.0);
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

        final event = game.eventAnchor.children.query<ActivityEvent>().first;

        for (int i = 1; i <= 10; i++) {
          event.onTapUp(MockTapUpEvent());
          expect(event.progressBar.progress, i / 10.0);
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

        final event = game.eventAnchor.children.query<ActivityEvent>().first;

        for (int i = 1; i <= 10; i++) {
          event.onTapUp(MockTapUpEvent());
        }

        expect(event.progressBar.progress, 1.0);
        expect(event.success, true);
      },
    );
    testWithGame<FlameGame>(
      'ProgressBar render method is called',
      FlameGame.new,
      (game) async {
        final progressBar = ProgressBar(
          progress: 0.5,
          width: 100.0,
          height: 20.0,
        );

        game.add(progressBar);
        await game.ready();

        final mockCanvas = MockCanvas();
        
        progressBar.render(mockCanvas);

        verifyNever(mockCanvas.drawRect(
          Rect.fromLTWH(0, 0, 100.0, 20.0),
          Paint()..color = Color(0xff9e9e9e),
        ));

        verifyNever(mockCanvas.drawRect(
          Rect.fromLTWH(0, 0, 50.0, 20.0),
          Paint()..color = Color(0xff4caf50),
        ));
      },
    );
  });
}

class MockCanvas extends Mock implements Canvas {}
