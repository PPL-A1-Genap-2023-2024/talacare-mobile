import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/components/draggable_container.dart';
import 'package:talacare/components/draggable_item.dart';
import 'package:talacare/components/silhouette_container.dart';
import 'package:talacare/components/silhouette_item.dart';
import 'package:talacare/talacare.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Object Selection Tests', () {
    testWithGame<TalaCare>(
      '3 draggable items and 1 silhouette item appear after game 2 starts', 
      TalaCare.new,
      (game) async {
        await game.ready();
        game.loadLevelTwoComponents();
        await game.ready();
        final viewport = game.cam.viewport;
        expect(viewport.children.query<SilhouetteContainer>().length, 1);
        final silhouetteContainer = viewport.children.query<SilhouetteContainer>().first;
        expect(silhouetteContainer.children.query<SilhouetteItem>().length, 1);
        expect(viewport.children.query<DraggableContainer>().length, 1);
        final draggableContainer = viewport.children.query<DraggableContainer>().first;
        expect(draggableContainer.children.query<DraggableItem>().length, 3);
      }
    );
    testWithGame<TalaCare>(
      'One of the draggable items must match with the current silhouette', 
      TalaCare.new,
      (game) async {
        await game.ready();
        game.loadLevelTwoComponents();
        await game.ready();
        final viewport = game.cam.viewport;
        final silhouetteContainer = viewport.children.query<SilhouetteContainer>().first;
        final silhouetteIndex = silhouetteContainer.indicesDisplayed.last;
        final draggableContainer = viewport.children.query<DraggableContainer>().first;
        final draggableIndices = draggableContainer.indicesDisplayed;
        expect(draggableIndices.contains(silhouetteIndex), true);
      }
    );
  });
}