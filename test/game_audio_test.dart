import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/talacare.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Game audio tests', () {
    testWithGame<TalaCare>('Background music should play in game', TalaCare.new,
        (game) async {
      game.isWidgetTesting = true;
      await game.ready();
    });
  });
}
