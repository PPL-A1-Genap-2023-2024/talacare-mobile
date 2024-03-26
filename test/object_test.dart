import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/components/item_container.dart';
import 'package:talacare/components/item.dart';
import 'package:talacare/talacare.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Object Selection Tests', () {
    testWithGame<TalaCare>(
      'Container and 3 items appear after game 2 starts (by door)', 
      TalaCare.new,
      (game) async {
        await game.ready();
        game.yesToHospital();
        await game.ready();
        final viewport = game.cam.viewport;
        expect(viewport.children.query<ItemContainer>().length, 1);
        final itemContainer = viewport.children.query<ItemContainer>().first;
        expect(itemContainer.children.query<Item>().length, 3);
      }
    );
  });
}