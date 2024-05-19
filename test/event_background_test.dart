import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/talacare.dart';
import 'package:talacare/components/event_background.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWithGame<TalaCare>(
      'Create a Component with the size of the screen',
      TalaCare.new,
          (game) async {
        await game.ready();
        EventBackground eventBackground = EventBackground();
        game.camera.viewport.add(eventBackground);

        expect(eventBackground.size, game.size);
      }
  );
}
