import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/components/hud/hud.dart';
import 'package:talacare/components/hud/health.dart';
import 'package:talacare/talacare.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWithGame<TalaCare>(
      'Player has health',
      TalaCare.new,
          (game) async {
        game.isWidgetTesting = true;
        await game.ready();
        expect(game.playerHealth, isNotNull);
      }
  );

  testWithGame<TalaCare>(
      'HUD added to Camera Viewport',
      TalaCare.new,
          (game) async {
        game.isWidgetTesting = true;
        await game.ready();
        expect(game.camera.viewport.children.any((element) => element is Hud), isTrue);
      }
  );

  group('Player Health Display', () {
    testWithGame<TalaCare>(
        'Displayed Health equal to Player Health',
        TalaCare.new,
            (game) async {
          game.isWidgetTesting = true;
          await game.ready();
          Hud target = game.camera.viewport.children.query<Hud>().first;
          expect(target.children.query<HealthComponent>().length, game.playerHealth);
        }
    );
  });

  group('Health Timer', () {
    testWithGame<TalaCare>(
        'Ensure the Health Timer set up correctly',
        TalaCare.new,
            (game) async {
          game.isWidgetTesting = true;
          await game.ready();
          Hud target = game.camera.viewport.children.query<Hud>().first;
          expect(target.healthDurationChecker, isNotNull);
          expect(target.timerStarted, isTrue);
          expect(target.countDown.limit,  1);
        }
    );

    testWithGame<TalaCare>(
        'Health Timer should be working',
        TalaCare.new,
            (game) async {
          game.isWidgetTesting = true;
          await game.ready();
          Hud target = game.camera.viewport.children.query<Hud>().first;
          final initHealthDurationChecker = target.healthDurationChecker;

          // Do 1 tick
          target.update(1);
          // HealthDurationChecker should've reduced after 1 tick
          expect(target.healthDurationChecker, isNot(initHealthDurationChecker));
        }
    );

    testWithGame<TalaCare>(
        'healthDurationChecker refreshed after 1 duration of healthDuration',
        TalaCare.new,
            (game) async {
          game.isWidgetTesting = true;
          await game.ready();
          Hud target = game.camera.viewport.children.query<Hud>().first;
          final initHealthDurationChecker = target.healthDurationChecker;

          target.update(target.healthDuration.toDouble());
          expect(target.healthDurationChecker, initHealthDurationChecker);
        }
    );

    testWithGame<TalaCare>(
        'HealthComponent becomes unavailable after 1 duration of healthDuration',
        TalaCare.new,
            (game) async {
          game.isWidgetTesting = true;
          await game.ready();
          final initHealth = game.playerHealth;
          Hud target = game.camera.viewport.children.query<Hud>().first;
          List<HealthComponent> healthList = target.children.query<HealthComponent>();

          game.update(target.healthDuration.toDouble());
          for (HealthComponent health in healthList) {
            if (health.heartNumber == initHealth) {
              expect(health.current, HeartState.unavailable);
            } else {
              expect(health.current, HeartState.available);
            }
          }
        }
    );

    testWithGame<TalaCare>(
        'Health Timer stop when 1 health remaining',
        TalaCare.new,
            (game) async {
          game.isWidgetTesting = true;
          await game.ready();
          Hud target = game.camera.viewport.children.query<Hud>().first;
          final initHealth = game.playerHealth;

          // Left the Player with 1 health
          for (int i = 0; i < initHealth - 1; i++) {
            target.update(target.healthDuration.toDouble());
          }

          // The timer should still count for the last health
          // expect(game.playerHealth, 1);
          // expect(target.timerStarted, true);
          // target.update(target.healthDuration.toDouble());

          // The timer should've stop and the player still has 1 health
          expect(game.playerHealth, 1);
          expect(target.timerStarted, false);
        }
    );
  });

  group('Health effect to Player Movement', () {
    testWithGame<TalaCare>(
        'Missing Health Reduce Character Movement',
        TalaCare.new,
            (game) async {
          game.isWidgetTesting = true;
          await game.ready();
          Hud target = game.camera.viewport.children.query<Hud>().first;
          final initHealth = game.playerHealth;
          final initPlayerMoveSpeed = game.player.moveSpeed;
          target.update(target.healthDuration.toDouble());
          expect(game.playerHealth, initHealth - 1);
          expect(game.player.moveSpeed, isNot(initPlayerMoveSpeed));
        }
    );

    testWithGame<TalaCare>(
        'Player movement speed loss is 25% of current movement speed',
        TalaCare.new,
            (game) async {
          game.isWidgetTesting = true;
          await game.ready();
          Hud target = game.camera.viewport.children.query<Hud>().first;
          final initHealth = game.playerHealth;

          for (int i = 1; i <= initHealth; i++) {
            final lastMoveSpeed = game.player.moveSpeed;
            target.update(target.healthDuration.toDouble());

            if (i == initHealth){
              expect(game.player.moveSpeed, lastMoveSpeed);
            } else {
              expect(game.player.moveSpeed, lastMoveSpeed - (lastMoveSpeed * 25/100));
            }
          }
        }
    );
  });

}
