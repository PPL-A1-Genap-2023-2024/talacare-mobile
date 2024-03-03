
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:talacare/talacare.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();


  TalaCare game = TalaCare();
  runApp(GameWidget(game: kDebugMode ? TalaCare() : game));
}

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
      Vector2(playerWidth, playerHeight),
      "blob"
    ));
    add(Point(
      Vector2(
        screenWidth / 2 - pointSize / 2,
        screenHeight / 1.25 - pointSize / 2
      ),
      Vector2(pointSize, pointSize),
      "drawing"
    ));
  }

  // when activity is active: halt other components' updates,
  // remove point, add score, and show event animation
  Future<void> onActivityTrigger(Point point) async {
    if (!isDoingActivity) {
      remove(point);
      add(Activity(
        Vector2(
          screenWidth / 2 - activitySize / 2,
          screenHeight / 2 - activitySize / 2
        ),
        Vector2(activitySize, activitySize),
        point.variant
      ));
      isDoingActivity = true;
      score += 1;
    } 
  }

  // when activity ends: resume other components' updates
  // and remove event animation
  void onActivityEnd(Activity activity) {
    if (isDoingActivity) {
      remove(activity);
      isDoingActivity = false;
    }
  }
}

// placeholder player, currently no animation
class Player extends SpriteComponent with HasGameRef<TalaCare> {
  String variant;

  Player(position, size, this.variant): super(
    position: position,
    size: size
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite('player_idle_front_$variant.png');
    add(RectangleHitbox());
  }

  // for experimentation, player is set to move down when activity isn't active
  @override
  void update(double dt) {
    super.update(dt);
    if (!game.isDoingActivity) {
      y += 75.0 * dt;
    }
  }
}

class Point extends SpriteComponent with CollisionCallbacks, HasGameRef<TalaCare> {
  String variant;
  
  Point(position, size, this.variant): super(
    position: position,
    size: size
  );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite('point_$variant.png');
    add(RectangleHitbox());
  }

  // activity is set to start upon collision between player and point
  @override
  void onCollision(intersectionPoints, other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      game.onActivityTrigger(this);
    }
  }
}

class Activity extends SpriteAnimationComponent with HasGameRef<TalaCare> {
  String variant;
  var timeElapsed = 0.0;
  
  Activity(position, size, this.variant): super(
    position: position,
    size: size
  );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    var data = SpriteAnimationData.sequenced(
      textureSize: Vector2.all(300),
      amount: 2,
      stepTime: 0.5
    );
    animation = await game.loadSpriteAnimation('activity_$variant.png', data);
  }

  // activity is set to end after 3 seconds
  @override
  void update(double dt) {
    super.update(dt);
    timeElapsed += dt;
    if (timeElapsed >= 3) {
      game.onActivityEnd(this);
    }
  }
}
