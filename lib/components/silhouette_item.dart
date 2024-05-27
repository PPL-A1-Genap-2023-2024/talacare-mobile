import 'dart:async';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:talacare/components/draggable_item.dart';
import 'package:talacare/helpers/audio_manager.dart';
import 'package:talacare/screens/game_2.dart';
import 'package:talacare/helpers/item.dart';
import 'package:talacare/talacare.dart';
import 'package:just_audio/just_audio.dart';

class SilhouetteItem extends SpriteComponent
    with
        CollisionCallbacks,
        HasGameRef<TalaCare>,
        HasWorldReference<HospitalPuzzle> {
  final Item item;
  late final RectangleHitbox hitbox;

  SilhouetteItem({required this.item});

  AudioSource sfx = AudioSource.uri(Uri.parse("asset:///assets/audio/puzzle_drop.mp3"));

  @override
  FutureOr<void> onLoad() async {
    anchor = Anchor.center;
    position = Vector2(item.x, item.y);
    sprite = Sprite(game.images.fromCache('Game_2/item_${item.name}.png'));
    tint(Color.fromARGB(255, 255, 255, 255));
    hitbox = RectangleHitbox(isSolid: true);
    if (size.x < 50) {
      hitbox.scale = Vector2.all(2);
    }
    add(hitbox);
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is DraggableItem && other.isDragged == false) {
      if (item.index == other.item.index) {
        world.instruction.text = "Sudah Cocok. Lanjutkan!";
        if(!game.isWidgetTesting) {
          FlameAudio.play('puzzle_drop.mp3');
          AudioManager.getInstance().playSoundEffect(sfx);
        }

        tint(Color.fromARGB(0, 255, 255, 255));
        remove(hitbox);
        world.draggableContainer.removeItem(other);
        world.updateScore();
      } else {
        world.instruction.text = "Belum Cocok. Ayo Coba Lagi!";
      }
    }
    super.onCollision(intersectionPoints, other);
  }
}
