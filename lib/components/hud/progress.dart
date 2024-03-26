
import 'package:talacare/talacare.dart';
import 'package:flame/components.dart';

enum ProgressState {
  todo,
  done,
}

class ProgressComponent extends SpriteGroupComponent<ProgressState>
    with HasGameReference<TalaCare> {
  final int progressNumber;

  ProgressComponent({
    required this.progressNumber,
    required super.position,
    required super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.priority,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final todoSprite = await game.loadSprite(
      'Overlays/progress_off.png',
      srcSize: Vector2.all(38),
    );

    final doneSprite = await game.loadSprite(
      'Overlays/progress.png',
      srcSize: Vector2.all(38),
    );

    sprites = {
      ProgressState.todo: todoSprite,
      ProgressState.done: doneSprite,
    };

    current = ProgressState.todo;
  }

  @override
  void update(double dt) {
    if (game.score >= progressNumber) {
      current = ProgressState.done;
    }

    super.update(dt);
  }
}