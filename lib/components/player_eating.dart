import 'dart:async';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:just_audio/just_audio.dart';
import 'package:talacare/components/draggable_food.dart';
import 'package:talacare/helpers/audio_manager.dart';
import 'package:talacare/helpers/eat_state.dart';
import 'package:talacare/talacare.dart';

import 'food_minigame.dart';

class PlayerEating extends SpriteGroupComponent<EatState>
    with
        CollisionCallbacks,
        HasGameRef<TalaCare> {
  late final RectangleHitbox hitbox;
  final FoodMinigame minigame;
  double reactionTime = 0;
  bool isReacting = false;
  PlayerEating({required this.minigame, required super.position});

  AudioSource sfx = AudioSource.uri(Uri.parse("asset:///assets/audio/puzzle_drop.mp3"));



  @override
  FutureOr<void> onLoad() async {
    anchor = Anchor.center;
    sprites = {};
    for (EatState state in EatState.values) {
      sprites?[state] = await game.loadSprite('Food/${game.playedCharacter}_${state.name}.png');
    }
    current = EatState.openmouth;
    hitbox = RectangleHitbox(isSolid: true);
    add(hitbox);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isReacting) {
      reactionTime += dt;
    }
    if (reactionTime >= 2) {
      current = EatState.openmouth;
      isReacting = false;
      reactionTime = 0;
      minigame.plate.enableDragging();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is DraggableFood && other.isDragged == false) {
      if (other.type == "good") {
        current = EatState.good;
        isReacting = true;
        minigame.instruction.text = "Pintar, adek, lanjut makan ya";
        if(!game.isWidgetTesting) {
          FlameAudio.play('puzzle_drop.mp3');
          AudioManager.getInstance().playSoundEffect(sfx);
        }
        tint(Color.fromARGB(0, 255, 255, 255));
        minigame.plate.removeItem(other);
        minigame.updateScore();
      } else {
        current = EatState.bad;
        isReacting = true;
        minigame.instruction.text = "Makanannya tidak sehat";
      }
      minigame.plate.nextWave();
    }
    super.onCollision(intersectionPoints, other);
  }

}