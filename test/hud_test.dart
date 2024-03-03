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
          Hud target = game.cam.viewport.children.query<Hud>().first;
          expect(target.lifeTime, isNotNull);
          expect(target.timerStarted, false);
          expect(target.countDown.limit, 1);
        }
    );

    testWithGame<TalaCare>(
        'Health Timer works after load',
        TalaCare.new,
            (game) async {
          await game.ready();
          Hud target = game.cam.viewport.children.query<Hud>().first;
          final int initLifeTime = target.lifeTime;
          expect(target.timerStarted, true);

          // Simulate 1 second
          target.update(1);

          // Expect LifeTime to reduce
          expect(target.lifeTime, isNot(initLifeTime));
        }
    );

    testWithGame<TalaCare>(
        'When Health lifetime reach 0, playerHealth reduced, and LifeTime refresh',
        TalaCare.new,
            (game) async {
          await game.ready();
          Hud target = game.cam.viewport.children.query<Hud>().first;
          final initPlayerHealth = game.playerHealth;
          final initLifeTime     = target.lifeTime;

          // Simulate 1 second remaining of 1 Health LifeTime
          target.update(target.lifeTime.toDouble() - 1);

          // Sanity Check
          expect(game.playerHealth, initPlayerHealth);
          expect(target.lifeTime, isNot(initLifeTime));

          target.update(1);
          expect(game.playerHealth, isNot(initPlayerHealth));
          expect(target.lifeTime, initLifeTime);
        }
    );

    testWithGame<TalaCare>(
        'Health stop reducing when 1 Health remains',
        TalaCare.new,
            (game) async {
          await game.ready();
          Hud target = game.cam.viewport.children.query<Hud>().first;

          // Reduce the amount of Health to 2
          for (int i = 0; i < game.playerHealth + 1; i++) {
            target.update(target.lifeTime.toDouble());
          }

          // Reduce the amount of Health to 1
          target.update(target.lifeTime.toDouble());
          expect(target.timerStarted, false);
        }
    );
  });

}
