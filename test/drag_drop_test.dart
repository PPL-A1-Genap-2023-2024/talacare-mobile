import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/components/draggable_item.dart';
import 'package:talacare/components/game_2.dart';
import 'package:talacare/helpers/hospital_reason.dart';
import 'package:flame/extensions.dart';
import 'package:talacare/talacare.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Drag And Drop Tests', () {
    testWithGame<TalaCare>(
        'Dragging object to certain position and not releasing it',
        TalaCare.new, (game) async {
      await game.ready();
      game.currentGame = 2;
      game.switchGame(reason: HospitalReason.playerEnter);
      await game.ready();
      final world = game.children.query<HospitalPuzzle>().first;
      List<int> draggableIndices = world.draggableContainer.indicesDisplayed;
      List<DraggableItem> draggableItems =
          world.draggableContainer.children.query<DraggableItem>();
      int matchingDraggableIndex = draggableIndices.indexOf(0);
      DraggableItem firstItem = draggableItems[matchingDraggableIndex];
      Vector2 newPosition = Vector2(1000, 1000);
      firstItem.onDragStart(createDragStartEvents(game: game));
      firstItem.position.setFrom(newPosition);
      expect(firstItem.position, newPosition);
    });

    testWithGame<TalaCare>(
        'Dragging and releasing object not on the objective', TalaCare.new,
        (game) async {
      await game.ready();
      game.currentGame = 2;
      game.switchGame(reason: HospitalReason.playerEnter);
      await game.ready();
      final world = game.children.query<HospitalPuzzle>().first;
      List<int> draggableIndices = world.draggableContainer.indicesDisplayed;
      List<DraggableItem> draggableItems =
          world.draggableContainer.children.query<DraggableItem>();
      int matchingDraggableIndex = draggableIndices.indexOf(0);
      DraggableItem firstItem = draggableItems[matchingDraggableIndex];
      Vector2 initialPosition =
          Vector2(firstItem.position.x, firstItem.position.y);
      Vector2 newPosition = Vector2(0, 0);
      firstItem.onDragStart(createDragStartEvents(game: game));
      firstItem.position.setFrom(newPosition);
      firstItem.onDragEnd(DragEndEvent(1, DragEndDetails()));
      await Future.delayed(Duration(milliseconds: 100));
      expect(firstItem.position, initialPosition);
    });

    // testWithGame<DragCallbacksExample>(
    //     'Dragging and releasing object on the objective and in right sequence',
    //     DragCallbacksExample.new, (game) async {
    //   await game.ready();
    //   DraggableObject syringe = game.syringe1;
    //   syringe.onDragStart(createDragStartEvents(game: game));
    //   syringe.position.setFrom(syringe.target);
    //   syringe.onDragEnd(DragEndEvent(1, DragEndDetails()));

    //   expect(syringe.position, syringe.target);
    //   expect(syringe.isActive, false);
    //   expect(game.itemIndex, 1);
    // });

    // testWithGame<DragCallbacksExample>(
    //     'Dragging and releasing object on the objective but not in right sequence',
    //     DragCallbacksExample.new, (game) async {
    //   await game.ready();
    //   DraggableObject syringe = game.syringe2;
    //   Vector2 initialPosition = Vector2(syringe.x, syringe.y);
    //   syringe.onDragStart(createDragStartEvents(game: game));
    //   syringe.position.setFrom(syringe.target);
    //   syringe.onDragEnd(DragEndEvent(1, DragEndDetails()));

    //   expect(syringe.position, initialPosition);
    //   expect(syringe.isActive, true);
    //   expect(game.itemIndex, 0);
    // });

    // testWithGame<DragCallbacksExample>(
    //     'Dragging a completed objective', DragCallbacksExample.new,
    //     (game) async {
    //   await game.ready();
    //   DraggableObject syringe = game.syringe1;
    //   syringe.onDragStart(createDragStartEvents(game: game));
    //   syringe.position.setFrom(syringe.target);
    //   syringe.onDragEnd(DragEndEvent(1, DragEndDetails()));
    //   syringe.onDragStart(createDragStartEvents(game: game));

    //   expect(syringe.isDragged, false);
    // });
  });
}
