import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/components/transition.dart';
import 'package:talacare/helpers/dialog_reason.dart';
import 'package:talacare/helpers/directions.dart';
import 'package:talacare/talacare.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Game Transition Test', () {
    testWithGame<TalaCare>(
        'Play transition when entering hospital voluntarily',
        TalaCare.new,
            (game) async {
          await game.ready();
          game.currentGame = 2;
          final player = game.player;
          game.switchGame(reason: DialogReason.enterHospital);
          expect(game.status, GameStatus.transition);
          await game.ready();
          GameTransition transition = game.children.query<GameTransition>().first;
          expect(transition.nurseTransition, false);
          expect(player.direction, Direction.right);


        }
    );

    testWithGame<TalaCare>(
        'Play transition when entering hospital because of low blood',
        TalaCare.new,
            (game) async {
          await game.ready();
          game.currentGame = 2;
          final player = game.player;
          game.switchGame(reason: DialogReason.lowBlood);
          expect(game.status, GameStatus.transition);
          await game.ready();
          GameTransition transition = game.children.query<GameTransition>().first;
          expect(transition.nurseTransition, true);
          Vector2 initialNursePosition = Vector2.zero();
          transition.nurse.position.copyInto(initialNursePosition);
          expect(player.direction, Direction.right);
          game.update(1);
          expect(transition.nurse.position.x, initialNursePosition.x+100);
        }
    );

    testWithGame<TalaCare>(
        'Play transition when exiting hospital',
        TalaCare.new,
            (game) async {
          await game.ready();
          final player = game.player;
          game.switchGame();
          expect(game.status, GameStatus.transition);
          await game.ready();
          GameTransition transition = game.children.query<GameTransition>().first;
          expect(transition.nurseTransition, false);
          expect(player.direction, Direction.left);
        }
    );
  });


}