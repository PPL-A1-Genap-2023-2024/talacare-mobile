import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:talacare/components/collision_block.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/components/point.dart';

class Level extends World {
  final String levelName;
  late TiledComponent level;
  final Player player;
  final int taken = 8;
  List<CollisionBlock> collisionBlocks = [];
  List<ActivityPoint> activityPoints = [];
  List<ActivityPoint> selectedActivity = [];
  
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
            final activity = ActivityPoint(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              variant: spawnPoint.name.toLowerCase()
            );
            activityPoints.add(activity);
          default:
        }
      }
      selectedActivity = _addRandomActivities(activityPoints, taken);
      for (final activity in selectedActivity) {
        add(activity);
      }
    }

    final collisionLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionLayer != null) {
      for (final collision in collisionLayer.objects) {
        final wall = CollisionBlock(
            position: Vector2(collision.x, collision.y),
            size: Vector2(collision.width, collision.height)
        );
        if (collision.class_ == "Outer") {
          wall.type = WallTypes.values[int.parse(collision.name)];
        }
        collisionBlocks.add(wall);
        add(wall);
      }
    }
    player.collisionBlocks = collisionBlocks;
    return super.onLoad();
  }
  List<ActivityPoint> _addRandomActivities(List<ActivityPoint> activityPoints, int count) {
    activityPoints.shuffle();
    int manyActivity = count;
    List<ActivityPoint> selectedActivityPoints = [];
    for (int i = 0; i < manyActivity; i++) {
      selectedActivityPoints.add(activityPoints[i]);
    }
    return selectedActivityPoints;
  }
}