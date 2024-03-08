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
          expect(target.healthDurationChecker, isNotNull);
          expect(target.timerStarted, isTrue);
          expect(target.countDown.limit, 1);
        }
    );
  });

  group('Health effect to Player Movement', () {
    testWithGame<TalaCare>(
        'Missing Health Reduce Character Movement',
        TalaCare.new,
            (game) async {
          await game.ready();
          Hud target = game.cam.viewport.children.query<Hud>().first;
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
          await game.ready();
          Hud target = game.cam.viewport.children.query<Hud>().first;
          final initHealth = game.playerHealth;
          late double lastMoveSpeed = game.player.moveSpeed;
          for (int i = 0; i < initHealth; i++) {
            target.update(target.healthDuration.toDouble());
            double currentMoveSpeed = game.player.moveSpeed;
            expect(currentMoveSpeed, lastMoveSpeed * 75/100);
          }
        }
    );
  });

}
