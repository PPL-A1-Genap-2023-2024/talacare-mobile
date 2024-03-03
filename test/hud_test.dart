import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/overlays/hud.dart';
import 'package:talacare/overlays/health.dart';
import 'package:talacare/talacare.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWithGame<TalaCare>(
      'Player has health',
      TalaCare.new,
          (game) async {
        await game.ready();
        expect(game.playerHealth, isNotNull);
      }
  );

  testWithGame<TalaCare>(
      'HUD added to Camera Viewport',
      TalaCare.new,
          (game) async {
        await game.ready();
        expect(game.cam.viewport.children.any((element) => element is Hud), isTrue);
      }
  );

  group('Player Health Display', () {
    testWithGame<TalaCare>(
        'Displayed Health equal to Player Health',
        TalaCare.new,
            (game) async {
          await game.ready();
          Hud target = game.cam.viewport.children.query<Hud>().first;
          expect(target.children.query<HealthComponent>().length, game.playerHealth);
        }
    );
  });

  group('Health Timer', () {
    testWithGame<TalaCare>(
        'Health Timer Set Up Correctly',
        TalaCare.new,
            (game) async {
          await game.ready();
          Hud target = game.cam.viewport.children.query<Hud>().first;
          expect(target.lifeTime, isNotNull);
          expect(target.timerStarted, isTrue);
          expect(target.countDown.limit, 1);
        }
    );

    testWithGame<TalaCare>(
        '',
        TalaCare.new,
            (game) async {
          await game.ready();
          Hud test = Hud();
          expect(test.lifeTime, isNotNull);
          expect(test.timerStarted, true);
          expect(test.countDown.limit, 1);
        }
    );
  });

}
