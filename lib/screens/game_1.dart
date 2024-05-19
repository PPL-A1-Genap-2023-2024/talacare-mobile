import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/layout.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:talacare/components/collision_block.dart';
import 'package:talacare/components/hospital_door.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/components/point.dart';
import 'package:talacare/talacare.dart';

import '../components/dpad.dart';
import '../components/hud/hud.dart';

class HouseAdventure extends World with HasGameRef<TalaCare> {
  final String levelName;
  late TiledComponent level;
  final Player player;
  final int taken = 8;
  List<CollisionBlock> collisionBlocks = [];
  List<ActivityPoint> activityPoints = [];
  List<ActivityPoint> selectedActivity = [];
  late HospitalDoor hospitalDoor;
  late final DPad dPad;
  late AlignComponent dpadAnchor;
  late Hud hud;

  HouseAdventure({required this.levelName, required this.player});

  @override
  FutureOr<void> onLoad() async {
    gameRef.camOne.viewfinder.anchor = Anchor.center;
    gameRef.camOne.viewfinder.zoom = 3;
    gameRef.camOne.viewport = FixedAspectRatioViewport(aspectRatio: 0.5625);

    gameRef.camOne.follow(player);

    dPad = DPad();
    dpadAnchor = AlignComponent(
      child: dPad,
      alignment: Anchor.bottomCenter,
    );
    gameRef.camOne.viewport.add(dpadAnchor);
    hud = Hud();
    gameRef.camOne.viewport.add(hud);

    level = await TiledComponent.load("$levelName.tmx", Vector2.all(16));
    add(level);

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.initialSpawn = player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          case 'Activity':
            final activity = ActivityPoint(
                position: Vector2(spawnPoint.x, spawnPoint.y),
                variant: spawnPoint.name.toLowerCase()
            );
            activityPoints.add(activity);
          case 'Hospital':
            hospitalDoor = HospitalDoor();
            hospitalDoor.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(hospitalDoor);
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