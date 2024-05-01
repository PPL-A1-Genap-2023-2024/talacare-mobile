import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/talacare.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Timestamp Functionality Test', () {
    testWithGame<TalaCare>('Check Start and End Timestamp', TalaCare.new,
        (game) async {
      await game.ready();
      game.update(1000);
      game.victory();
      expect(DateTime.now().difference(game.startTimestamp),
          greaterThan(Duration(seconds: 0)));
    });
  });
}
