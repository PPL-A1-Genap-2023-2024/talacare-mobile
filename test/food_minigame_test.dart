import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/components/draggable_food.dart';
import 'package:talacare/components/food_minigame.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/components/point.dart';
import 'package:talacare/helpers/eat_state.dart';
import 'package:talacare/screens/game_1.dart';
import 'package:talacare/talacare.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Start Food Minigame Tests', () {
    testWithGame<TalaCare>(
        'Minigame starts upon collision',
        TalaCare.new,
            (game) async {
          final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
          await game.ready();
          final level = game.children.query<HouseAdventure>().first;
          final player = level.children.query<Player>().first;
          final point = level.children.query<ActivityPoint>().where((point) => point.variant == "eating").first;
          point.onCollision(intersection, player);
          expect(game.gameOne.dPad.disabled, true);
          expect(game.gameOne.hud.timerStarted, false);
          expect(game.minigame, isA<FoodMinigame>());
          await game.ready();
          final foodMinigameList = game.camOne.viewport.children.query<FoodMinigame>();
          expect(foodMinigameList, isNotEmpty);
        }
    );

    testWithGame<TalaCare>(
        'Minigame finish when score is 4',
        TalaCare.new,
            (game) async {
          final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
          await game.ready();
          final level = game.children.query<HouseAdventure>().first;
          final player = level.children.query<Player>().first;
          final point = level.children.query<ActivityPoint>().where((point) => point.variant == "eating").first;
          point.onCollision(intersection, player);
          await game.ready();
          final foodMinigame = game.camOne.viewport.children.query<FoodMinigame>().first;

          // score is 4
          foodMinigame.updateScore();
          foodMinigame.updateScore();
          foodMinigame.updateScore();
          foodMinigame.updateScore();
          await game.ready();
          expect(game.gameOne.dPad.disabled, false);
          expect(game.gameOne.hud.timerStarted, true);
          final foodMinigameList = game.camOne.viewport.children.query<FoodMinigame>();
          expect(foodMinigameList, isEmpty);
          expect(game.score, 1);
        }
    );
  });

  group('Drag And Drop Tests', () {
    testWithGame<TalaCare>(
        'Dragging food to certain position and not releasing it',
        TalaCare.new, (game) async {
      final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
      await game.ready();
      final level = game.children.query<HouseAdventure>().first;
      final player = level.children.query<Player>().first;
      final point = level.children.query<ActivityPoint>().where((point) => point.variant == "eating").first;
      point.onCollision(intersection, player);
      await game.ready();
      final foodMinigame = game.camOne.viewport.children.query<FoodMinigame>().first;

      List<DraggableFood> draggableFoods = foodMinigame.plate.children.query<DraggableFood>();
      DraggableFood draggableFood = draggableFoods[0];
      Vector2 newPosition = Vector2(1000, 1000);
      draggableFood.onDragStart(createDragStartEvents(game: game));
      draggableFood.position.setFrom(newPosition);
      expect(draggableFood.position, newPosition);
    });

    testWithGame<TalaCare>(
        'Dragging and releasing food not on child', TalaCare.new,
            (game) async {
          final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
          await game.ready();
          final level = game.children.query<HouseAdventure>().first;
          final player = level.children.query<Player>().first;
          final point = level.children.query<ActivityPoint>().where((point) => point.variant == "eating").first;
          point.onCollision(intersection, player);
          await game.ready();
          final foodMinigame = game.camOne.viewport.children.query<FoodMinigame>().first;

          List<DraggableFood> draggableFoods = foodMinigame.plate.children.query<DraggableFood>();
          DraggableFood draggableFood = draggableFoods[0];
          Vector2 initialPosition =
          Vector2(draggableFood.position.x, draggableFood.position.y);
          Vector2 newPosition = Vector2(0, 0);
          draggableFood.onDragStart(createDragStartEvents(game: game));
          draggableFood.position.setFrom(newPosition);
          draggableFood.onDragEnd(DragEndEvent(1, DragEndDetails()));
          await Future.delayed(Duration(milliseconds: 100));
          expect(draggableFood.position, initialPosition);
        });

    testWithGame<TalaCare>(
        'Dragging and releasing food on the child',
        TalaCare.new, (game) async {
      final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
      await game.ready();
      final level = game.children.query<HouseAdventure>().first;
      final player = level.children.query<Player>().first;
      final point = level.children.query<ActivityPoint>().where((point) => point.variant == "eating").first;
      point.onCollision(intersection, player);
      await game.ready();
      final foodMinigame = game.camOne.viewport.children.query<FoodMinigame>().first;

      List<DraggableFood> draggableFoods = foodMinigame.plate.children.query<DraggableFood>();
      DraggableFood goodDraggableFood = draggableFoods[0];
      Vector2 newPosition = Vector2(foodMinigame.playerEating.x, foodMinigame.playerEating.y);
      goodDraggableFood.onDragStart(createDragStartEvents(game: game));
      goodDraggableFood.position.setFrom(newPosition);
      goodDraggableFood.onDragEnd(DragEndEvent(1, DragEndDetails()));
      foodMinigame.playerEating.onCollision({newPosition}, goodDraggableFood);
      await game.ready();
      expect(foodMinigame.playerEating.isReacting, true);
      draggableFoods.forEach((food) {
        expect(food.isDraggable, false);
      });
      game.update(2);
      expect(foodMinigame.playerEating.isReacting, false);
      draggableFoods.forEach((food) {
        expect(food.isDraggable, true);
      });
      expect(foodMinigame.playerEating.current, EatState.openmouth);
    });

    testWithGame<TalaCare>(
        'Dragging and releasing good food on the child',
        TalaCare.new, (game) async {
      final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
      await game.ready();
      final level = game.children.query<HouseAdventure>().first;
      final player = level.children.query<Player>().first;
      final point = level.children.query<ActivityPoint>().where((point) => point.variant == "eating").first;
      point.onCollision(intersection, player);
      await game.ready();
      final foodMinigame = game.camOne.viewport.children.query<FoodMinigame>().first;

      List<DraggableFood> draggableFoods = foodMinigame.plate.children.query<DraggableFood>();
      DraggableFood goodDraggableFood = draggableFoods.where((food) => food.type == "good").first;


      Vector2 newPosition = Vector2(foodMinigame.playerEating.x, foodMinigame.playerEating.y);
      goodDraggableFood.onDragStart(createDragStartEvents(game: game));
      goodDraggableFood.position.setFrom(newPosition);
      goodDraggableFood.onDragEnd(DragEndEvent(1, DragEndDetails()));
      foodMinigame.playerEating.onCollision({newPosition}, goodDraggableFood);
      expect(foodMinigame.score, 1);
      expect(foodMinigame.playerEating.current, EatState.good);
      expect(foodMinigame.instruction.text, "Sudah Benar. Lanjutkan!");
    });

    testWithGame<TalaCare>(
        'Dragging and releasing good food on the child',
        TalaCare.new, (game) async {
      final intersection = {Vector2(0.0,0.0), Vector2(0.0,0.0)};
      await game.ready();
      final level = game.children.query<HouseAdventure>().first;
      final player = level.children.query<Player>().first;
      final point = level.children.query<ActivityPoint>().where((point) => point.variant == "eating").first;
      point.onCollision(intersection, player);
      await game.ready();
      final foodMinigame = game.camOne.viewport.children.query<FoodMinigame>().first;

      List<DraggableFood> draggableFoods = foodMinigame.plate.children.query<DraggableFood>();
      DraggableFood goodDraggableFood = draggableFoods.where((food) => food.type == "bad").first;


      Vector2 newPosition = Vector2(foodMinigame.playerEating.x, foodMinigame.playerEating.y);
      goodDraggableFood.onDragStart(createDragStartEvents(game: game));
      goodDraggableFood.position.setFrom(newPosition);
      goodDraggableFood.onDragEnd(DragEndEvent(1, DragEndDetails()));
      foodMinigame.playerEating.onCollision({newPosition}, goodDraggableFood);
      expect(foodMinigame.score, 0);
      expect(foodMinigame.playerEating.current, EatState.bad);
      expect(foodMinigame.instruction.text, "Ayo Coba Lagi!");
    });

  });
}