import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/components/draggable_item.dart';
import 'package:talacare/screens/game_2.dart';
import 'package:talacare/components/silhouette_item.dart';
import 'package:talacare/talacare.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Object Selection Tests', () {
    testWithGame<TalaCare>(
      'Initial game condition checks after game 2 starts', 
      TalaCare.new,
      (game) async {
        game.isWidgetTesting = true;
        await game.ready();
        game.currentGame = 2;
        game.switchGame();
        game.update(5);
        await game.ready();
        final world = game.children.query<HospitalPuzzle>().first;
        expect(world.silhouetteContainer.children.query<SpriteComponent>().length, 2);
        expect(world.silhouetteContainer.childIsHappy, false);
        expect(world.silhouetteContainer.children.query<SilhouetteItem>().length, 1);
        expect(world.draggableContainer.children.query<DraggableItem>().length, 2);
        expect(world.instruction.text, "Ayo cocokkan gambar!");
        expect(world.progressBar.circlesAreMarked.contains(true), false);
        expect(world.score, 0);
      }
    );
    testWithGame<TalaCare>(
      'Second wave of items appear after container is emptied once', 
      TalaCare.new,
      (game) async {
        game.isWidgetTesting = true;
        await game.ready();
        game.currentGame = 2;
        game.switchGame();
        game.update(5);
        await game.ready();
        final world = game.children.query<HospitalPuzzle>().first;
        for (int i = 0; i <= 1; i++) {
          var draggableIndices = world.draggableContainer.indicesDisplayed;
          var silhouetteItems = world.silhouetteContainer.children.query<SilhouetteItem>();
          var silhouetteItem = silhouetteItems[world.silhouetteContainer.currentIndex];
          var draggableItems = world.draggableContainer.children.query<DraggableItem>();
          var matchingDraggableIndex = draggableIndices.indexOf(i);
          var draggableItem = draggableItems[matchingDraggableIndex];
          silhouetteItem.onCollision({Vector2(0,0)}, draggableItem);
          await game.ready();
        }
        expect(world.draggableContainer.children.query<DraggableItem>().length, 3);
      }
    );
    testWithGame<TalaCare>(
      'Silhouette, correct draggable, and progress must match at every point', 
      TalaCare.new,
      (game) async {
        game.isWidgetTesting = true;
        await game.ready();
        game.currentGame = 2;
        game.switchGame();
        game.update(5);
        await game.ready();
        final world = game.children.query<HospitalPuzzle>().first;
        for (int i = 0; i <= 4; i++) {
          var draggableIndices = world.draggableContainer.indicesDisplayed;
          expect(world.score, i);
          expect(world.progressBar.circlesAreMarked.indexOf(false), i);
          expect(world.silhouetteContainer.currentIndex, i);
          expect(draggableIndices.contains(i), true);
          var silhouetteItems = world.silhouetteContainer.children.query<SilhouetteItem>();
          var silhouetteItem = silhouetteItems[world.silhouetteContainer.currentIndex];
          var draggableItems = world.draggableContainer.children.query<DraggableItem>();
          var matchingDraggableIndex = draggableIndices.indexOf(i);
          var draggableItem = draggableItems[matchingDraggableIndex];
          silhouetteItem.onCollision({Vector2(0,0)}, draggableItem);
          await game.ready();
        }
      }
    );
    testWithGame<TalaCare>(
      'End game condition checks after all items have been matched', 
      TalaCare.new,
      (game) async {
        game.isWidgetTesting = true;
        await game.ready();
        game.currentGame = 2;
        game.switchGame();
        game.update(5);
        await game.ready();
        final world = game.children.query<HospitalPuzzle>().first;
        for (int i = 0; i <= 4; i++) {
          var draggableIndices = world.draggableContainer.indicesDisplayed;
          var silhouetteItems = world.silhouetteContainer.children.query<SilhouetteItem>();
          var silhouetteItem = silhouetteItems[world.silhouetteContainer.currentIndex];
          var draggableItems = world.draggableContainer.children.query<DraggableItem>();
          var matchingDraggableIndex = draggableIndices.indexOf(i);
          var draggableItem = draggableItems[matchingDraggableIndex];
          silhouetteItem.onCollision({Vector2(0,0)}, draggableItem);
          await game.ready();
        }
        expect(world.silhouetteContainer.children.query<SpriteComponent>().length, 6);
        expect(world.silhouetteContainer.childIsHappy, true);
        expect(world.silhouetteContainer.children.query<SilhouetteItem>().length, 5);
        expect(world.draggableContainer.children.query<DraggableItem>().length, 0);
        expect(world.instruction.text, "Transfusi darah berhasil!");
        expect(world.progressBar.circlesAreMarked.contains(false), false);
        expect(world.score, 5);
      }
    );
  });
}