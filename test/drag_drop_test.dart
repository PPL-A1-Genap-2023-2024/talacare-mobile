import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/hospital_dummy.dart';
import 'package:flame/extensions.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Drag And Drop Tests', () {
    testWithGame<DragCallbacksExample>(
        'Dragging object to certain position and not releasing it',
        DragCallbacksExample.new, (game) async {
      await game.ready();
      DraggableObject syringe = game.syringe1;
      Vector2 newPosition = Vector2(0, 0);
      syringe.onDragStart(createDragStartEvents(game: game));
      syringe.position.setFrom(newPosition);

      expect(syringe.position, newPosition);
      expect(syringe.isActive, true);
      expect(game.itemIndex, 0);
    });

    testWithGame<DragCallbacksExample>(
        'Dragging and releasing object not on the objective',
        DragCallbacksExample.new, (game) async {
      await game.ready();
      DraggableObject syringe = game.syringe1;
      Vector2 initialPosition = Vector2(syringe.x, syringe.y);
      syringe.onDragStart(createDragStartEvents(game: game));
      syringe.position.setFrom(Vector2(500, 500));
      syringe.onDragEnd(DragEndEvent(1, DragEndDetails()));

      expect(syringe.position, initialPosition);
      expect(syringe.isActive, true);
      expect(game.itemIndex, 0);
    });

    testWithGame<DragCallbacksExample>(
        'Dragging and releasing object on the objective and in right sequence',
        DragCallbacksExample.new, (game) async {
      await game.ready();
      DraggableObject syringe = game.syringe1;
      syringe.onDragStart(createDragStartEvents(game: game));
      syringe.position.setFrom(syringe.target);
      syringe.onDragEnd(DragEndEvent(1, DragEndDetails()));

      expect(syringe.position, syringe.target);
      expect(syringe.isActive, false);
      expect(game.itemIndex, 1);
    });

    testWithGame<DragCallbacksExample>(
        'Dragging and releasing object on the objective but not in right sequence',
        DragCallbacksExample.new, (game) async {
      await game.ready();
      DraggableObject syringe = game.syringe2;
      Vector2 initialPosition = Vector2(syringe.x, syringe.y);
      syringe.onDragStart(createDragStartEvents(game: game));
      syringe.position.setFrom(syringe.target);
      syringe.onDragEnd(DragEndEvent(1, DragEndDetails()));

      expect(syringe.position, initialPosition);
      expect(syringe.isActive, true);
      expect(game.itemIndex, 0);
    });

    testWithGame<DragCallbacksExample>(
        'Dragging a completed objective', DragCallbacksExample.new,
        (game) async {
      await game.ready();
      DraggableObject syringe = game.syringe1;
      syringe.onDragStart(createDragStartEvents(game: game));
      syringe.position.setFrom(syringe.target);
      syringe.onDragEnd(DragEndEvent(1, DragEndDetails()));
      syringe.onDragStart(createDragStartEvents(game: game));

      expect(syringe.isDragged, false);
    });
  });
}
