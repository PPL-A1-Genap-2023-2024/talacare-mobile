import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:talacare/components/activity.dart';
import 'package:talacare/components/collision_block.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/components/point.dart';

class Level extends World {
  final String levelName;
  late TiledComponent level;
  final Player player;
  final int taken = 8;
  List<CollisionBlock> collisionBlocks = [];
  List<Activity> activityPoints = [];
  List<Activity> selectedActivity = [];
  
  Level({required this.levelName, required this.player});

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load("$levelName.tmx", Vector2.all(16));
    add(level);

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          case 'Activity':
            final activity = Activity(character: 'Bob', position: Vector2(spawnPoint.x, spawnPoint.y));
            activityPoints.add(activity);
          default:
        }
      }
      selectedActivity = _addRandomActivities(activityPoints, taken);
      for (final activity in selectedActivity) {
        add(activity);
      }

    }

    // dummy point, edit when merged with activity-point-spawn
    final point = ActivityPoint(variant: "drawing");
    point.position = Vector2(200, 200);
    add(point);

    final collisionLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionLayer != null) {
      for (final collision in collisionLayer.objects) {
        final wall = CollisionBlock(
          position: Vector2(collision.x, collision.y),
          size: Vector2(collision.width, collision.height)
        );
        collisionBlocks.add(wall);
        add(wall);
      }
    } 
    player.collisionBlocks = collisionBlocks;
    print(parent);
    return super.onLoad();
  }
  List<Activity> _addRandomActivities(List<Activity> activityPoints, int count) {
    activityPoints.shuffle();
    int manyActivity = count;
    List<Activity> selectedActivityPoints = [];
    for (int i = 0; i < manyActivity; i++) {
      selectedActivityPoints.add(activityPoints[i]);
    }
    return selectedActivityPoints;
  }
}