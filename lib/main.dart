import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: TalaCare()));
}

class TalaCare extends FlameGame with HasCollisionDetection, TapDetector {
  final playerWidth = 80.0;
  final playerHeight = 125.0;
  final pointSize = 50.0;
  final activitySize = 300.0;
  late double screenWidth;
  late double screenHeight;
  late Activity activeActivity;
  var isDoingActivity = false;
  var score = 0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    screenWidth = size[0];
    screenHeight = size[1];
    add(Player(
      Vector2(
        screenWidth / 2 - playerWidth / 2,
        screenHeight / 3.25 - playerHeight / 2
      ),
      Vector2(playerWidth, playerHeight)
    ));
    add(Point(
      Vector2(
        screenWidth / 2 - pointSize / 2,
        screenHeight / 1.25 - pointSize / 2
      ),
      Vector2(pointSize, pointSize)
    ));
  }

  // activity event, currently using sprite component and tap detector
  void onActivityTrigger() {
    activeActivity = Activity(
      Vector2(
        screenWidth / 2 - activitySize / 2,
        screenHeight / 2 - activitySize / 2
      ),
      Vector2(activitySize, activitySize)
    );
    add(activeActivity);
    isDoingActivity = true;
    score += 1;
  }

  // for experimentation, event is set to end by tapping the screen
  @override
  void onTap() {
    if (isDoingActivity) {
      remove(activeActivity);
      isDoingActivity = false;
    }
  }
}

// placeholder player, currently one variation and no animation
class Player extends SpriteComponent with CollisionCallbacks, HasGameRef<TalaCare> {
  var velocity = 100.0;
  Player(position, size): super(
    position: position,
    size: size
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite('player.png');
    add(RectangleHitbox());
  }

  // for experimentation, player is set to move down until it reaches activity point
  @override
  void update(double dt) {
    super.update(dt);
    y += velocity * dt;
  }

  @override
  void onCollision(intersectionPoints, other) {
    super.onCollision(intersectionPoints, other);
    velocity = 0;
    game.onActivityTrigger();
  }

}

// placeholder activity point, currently one variation
class Point extends SpriteComponent with CollisionCallbacks, HasGameRef<TalaCare> {
  Point(position, size): super(
    position: position,
    size: size
  );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite('point.png');
    add(RectangleHitbox());
  }

  // point is set to disappear after colliding with player
  @override
  void onCollision(intersectionPoints, other) {
    super.onCollision(intersectionPoints, other);
    removeFromParent();
  }

}

// placeholder activity splash art, currently one variation and no animation
class Activity extends SpriteComponent with HasGameRef<TalaCare> {
  Activity(position, size): super(
    position: position,
    size: size
  );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite('activity.png');
  }
}
