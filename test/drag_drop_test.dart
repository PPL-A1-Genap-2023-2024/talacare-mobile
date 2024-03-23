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
      DraggableObject syringe = game.syringe;
      Vector2 newPosition = Vector2(0, 0);
      syringe.onDragStart(createDragStartEvents(game: game));
      syringe.position.setFrom(newPosition);
      expect(syringe.position, newPosition);
      expect(syringe.isActive, true);
    });

    testWithGame<DragCallbacksExample>(
        'Dragging and releasing object not on the objective',
        DragCallbacksExample.new, (game) async {
      await game.ready();
      DraggableObject syringe = game.syringe;
      Vector2 initialPosition = Vector2(syringe.x, syringe.y);
      syringe.onDragStart(createDragStartEvents(game: game));
      syringe.position.setFrom(Vector2(500, 500));
      syringe.onDragEnd(DragEndEvent(1, DragEndDetails()));
      expect(initialPosition, syringe.position);
      expect(syringe.isActive, true);
    });

    testWithGame<DragCallbacksExample>(
        'Dragging and releasing object on the objective',
        DragCallbacksExample.new, (game) async {
      await game.ready();
      DraggableObject syringe = game.syringe;
      expect(syringe.isActive, true);
      syringe.onDragStart(createDragStartEvents(game: game));
      syringe.position.setFrom(Vector2(0, 0));
      syringe.onDragEnd(DragEndEvent(1, DragEndDetails()));
      expect(syringe.isActive, false);
    });
  });
}
