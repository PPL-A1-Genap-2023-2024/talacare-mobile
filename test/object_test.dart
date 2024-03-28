import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/components/draggable_container.dart';
import 'package:talacare/components/draggable_item.dart';
import 'package:talacare/components/silhouette_container.dart';
import 'package:talacare/components/silhouette_item.dart';
import 'package:talacare/helpers/hospital_reason.dart';
import 'package:talacare/talacare.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Object Selection Tests', () {
    testWithGame<TalaCare>(
      'First wave draggable items and silhouette item appear after game 2 starts', 
      TalaCare.new,
      (game) async {
        await game.ready();
        game.currentGame = 2;
        game.switchGame(reason: HospitalReason.playerEnter);
        await game.ready();
        final viewport = game.camera.viewport;
        expect(viewport.children.query<SilhouetteContainer>().length, 1);
        final silhouetteContainer = viewport.children.query<SilhouetteContainer>().first;
        expect(silhouetteContainer.children.query<SilhouetteItem>().length, 1);
        expect(viewport.children.query<DraggableContainer>().length, 1);
        final draggableContainer = viewport.children.query<DraggableContainer>().first;
        expect(draggableContainer.children.query<DraggableItem>().length, 2);
      }
    );
    testWithGame<TalaCare>(
      'Second wave draggable items appear after container is emptied for the first time', 
      TalaCare.new,
      (game) async {
        await game.ready();
        game.currentGame = 2;
        game.switchGame(reason: HospitalReason.playerEnter);
        await game.ready();
        final viewport = game.camera.viewport;
        final draggableContainer = viewport.children.query<DraggableContainer>().first;
        final draggableItems = draggableContainer.children.query<DraggableItem>();
        draggableContainer.removeItem(draggableItems.first);
        draggableContainer.removeItem(draggableItems.last);
        await game.ready();
        expect(draggableContainer.children.query<DraggableItem>().length, 3);
      }
    );
    testWithGame<TalaCare>(
      'One of the draggable items must match with the current silhouette', 
      TalaCare.new,
      (game) async {
        await game.ready();
        game.currentGame = 2;
        game.switchGame(reason: HospitalReason.playerEnter);
        await game.ready();
        final viewport = game.camera.viewport;
        final silhouetteContainer = viewport.children.query<SilhouetteContainer>().first;
        final silhouetteIndex = silhouetteContainer.indicesDisplayed.last;
        final draggableContainer = viewport.children.query<DraggableContainer>().first;
        final draggableIndices = draggableContainer.indicesDisplayed;
        expect(draggableIndices.contains(silhouetteIndex), true);
      }
    );
  });
}