import 'dart:async';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:talacare/components/draggable_food.dart';
import 'package:talacare/helpers/eat_state.dart';
import 'package:talacare/talacare.dart';

import 'food_minigame.dart';

class Mouth extends SpriteGroupComponent<EatState>
    with
        CollisionCallbacks,
        HasGameRef<TalaCare> {
  late final RectangleHitbox hitbox;
  final FoodMinigame minigame;
  Mouth({required this.minigame, required super.position});

  // AudioSource sfx = AudioSource.uri(Uri.parse("asset:///assets/audio/puzzle_drop.mp3"));



  @override
  FutureOr<void> onLoad() async {
    anchor = Anchor.center;
    sprites = {};
    for (EatState state in EatState.values) {
      sprites?[state] = await game.loadSprite('Food/mouth_${state.name}_new.png');
    }
    current = EatState.openmouth;
    hitbox = RectangleHitbox(isSolid: true);
    add(hitbox);
    return super.onLoad();
  }





  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is DraggableFood && other.isDragged == false) {
      if (other.type == "good") {
        minigame.lastState = current = EatState.good;
        // isReacting = true;
        minigame.instruction.text = "Sudah Benar. Lanjutkan!";
        // FlameAudio.play('puzzle_drop.mp3');
        // AudioManager.getInstance().playSoundEffect(sfx);
        tint(Color.fromARGB(0, 255, 255, 255));
        minigame.plate.removeItem(other);
        minigame.updateScore();
      } else {
        minigame.lastState = current = EatState.bad;
        // isReacting = true;
        minigame.instruction.text = "Ayo Coba Lagi!";
      }
      minigame.plate.nextWave();
    }
    super.onCollision(intersectionPoints, other);
  }

}
