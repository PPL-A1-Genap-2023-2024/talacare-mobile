import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/components/draggable_item.dart';
import 'package:talacare/screens/game_2.dart';
import 'package:talacare/components/silhouette_item.dart';
import 'package:talacare/helpers/dialog_reason.dart';
import 'package:talacare/talacare.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Drag And Drop Tests', () {
    testWithGame<TalaCare>(
        'Dragging object to certain position and not releasing it',
        TalaCare.new, (game) async {
      game.isWidgetTesting = true;    
      await game.ready();
      game.currentGame = 2;
      game.switchGame(reason: DialogReason.enterHospital);
      game.update(5);

      await game.ready();
      final world = game.children.query<HospitalPuzzle>().first;
      List<int> draggableIndices = world.draggableContainer.indicesDisplayed;
      List<DraggableItem> draggableItems =
          world.draggableContainer.children.query<DraggableItem>();
      int matchingDraggableIndex = draggableIndices.indexOf(0);
      DraggableItem draggableItem = draggableItems[matchingDraggableIndex];
      Vector2 newPosition = Vector2(1000, 1000);
      draggableItem.onDragStart(createDragStartEvents(game: game));
      draggableItem.position.setFrom(newPosition);
      expect(draggableItem.position, newPosition);
    });

    testWithGame<TalaCare>(
        'Dragging and releasing object not on the objective', TalaCare.new,
        (game) async {
      game.isWidgetTesting = true;
      await game.ready();
      game.currentGame = 2;
      game.switchGame(reason: DialogReason.enterHospital);
      game.update(5);
      await game.ready();

      final world = game.children.query<HospitalPuzzle>().first;
      List<int> draggableIndices = world.draggableContainer.indicesDisplayed;
      List<DraggableItem> draggableItems =
          world.draggableContainer.children.query<DraggableItem>();
      int matchingDraggableIndex = draggableIndices.indexOf(0);
      DraggableItem draggableItem = draggableItems[matchingDraggableIndex];
      Vector2 initialPosition =
          Vector2(draggableItem.position.x, draggableItem.position.y);
      Vector2 newPosition = Vector2(0, 0);
      draggableItem.onDragStart(createDragStartEvents(game: game));
      draggableItem.position.setFrom(newPosition);
      draggableItem.onDragEnd(DragEndEvent(1, DragEndDetails()));
      await Future.delayed(Duration(milliseconds: 100));
      expect(draggableItem.position, initialPosition);
    });

    testWithGame<TalaCare>(
        'Dragging and releasing object on the objective and in right sequence',
        TalaCare.new, (game) async {
      game.isWidgetTesting = true;
      await game.ready();
      game.currentGame = 2;
      game.switchGame(reason: DialogReason.enterHospital);
      game.update(5);
      await game.ready();

      final world = game.children.query<HospitalPuzzle>().first;
      List<int> draggableIndices = world.draggableContainer.indicesDisplayed;
      List<DraggableItem> draggableItems =
          world.draggableContainer.children.query<DraggableItem>();
      int matchingDraggableIndex = draggableIndices.indexOf(0);
      DraggableItem draggableItem = draggableItems[matchingDraggableIndex];
      List<SilhouetteItem> silhouetteItems =
          world.silhouetteContainer.children.query<SilhouetteItem>();
      SilhouetteItem silhouetteItem =
          silhouetteItems[world.silhouetteContainer.currentIndex];
      Vector2 newPosition = Vector2(silhouetteItem.x, silhouetteItem.y);
      draggableItem.onDragStart(createDragStartEvents(game: game));
      draggableItem.position.setFrom(newPosition);
      draggableItem.onDragEnd(DragEndEvent(1, DragEndDetails()));
      silhouetteItem.onCollision({newPosition}, draggableItem);
      expect(world.score, 1);
      expect(world.instruction.text, "Sudah Cocok. Lanjutkan!");
    });

    testWithGame<TalaCare>(
        'Dragging and releasing object on the objective but not in right sequence',
        TalaCare.new, (game) async {
      game.isWidgetTesting = true;
      await game.ready();
      game.currentGame = 2;
      game.switchGame(reason: DialogReason.enterHospital);
      game.update(5);
      await game.ready();
      final world = game.children.query<HospitalPuzzle>().first;
      List<int> draggableIndices = world.draggableContainer.indicesDisplayed;
      List<DraggableItem> draggableItems =
          world.draggableContainer.children.query<DraggableItem>();
      int matchingDraggableIndex = draggableIndices.indexOf(1);
      DraggableItem draggableItem = draggableItems[matchingDraggableIndex];
      List<SilhouetteItem> silhouetteItems =
          world.silhouetteContainer.children.query<SilhouetteItem>();
      SilhouetteItem silhouetteItem =
          silhouetteItems[world.silhouetteContainer.currentIndex];
      Vector2 newPosition = Vector2(silhouetteItem.x, silhouetteItem.y);
      draggableItem.onDragStart(createDragStartEvents(game: game));
      draggableItem.position.setFrom(newPosition);
      draggableItem.onDragEnd(DragEndEvent(1, DragEndDetails()));
      silhouetteItem.onCollision({newPosition}, draggableItem);
      expect(world.score, 0);
      expect(world.instruction.text, "Belum Cocok. Ayo Coba Lagi!");
    });

    testWithGame<TalaCare>(
      'disableDragging sets isDraggable to false for all DraggableItems',
      TalaCare.new, (game) async {
        game.isWidgetTesting = true;
        await game.ready();
        game.currentGame = 2;
        game.switchGame(reason: DialogReason.enterHospital);
        game.update(5);
        await game.ready();
        final world = game.children.query<HospitalPuzzle>().first;
        world.draggableContainer.disableDragging();
        void verifyDraggableItemIsNotDraggable(Component child) {
          if (child is DraggableItem) {
            expect(child.isDraggable, false);
          }
        }
        world.draggableContainer.children.forEach(verifyDraggableItemIsNotDraggable);
      },
    );
  });
}
