import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:talacare/components/draggable_container.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/components/silhouette_container.dart';
import 'package:talacare/talacare.dart';

import '../helpers/hospital_reason.dart';

class HospitalPuzzle extends World with HasGameRef<TalaCare> {
  final HospitalReason reason;
  final Player player;
  late final DraggableContainer draggableContainer;
  late final SilhouetteContainer silhouetteContainer;
  late final Viewport screen;
  int score = 0;

  HospitalPuzzle({required this.player, required this.reason});

  @override
  FutureOr<void> onLoad() async {
    final background = SpriteComponent();
    background.sprite = Sprite(game.images.fromCache("Hospital/hospital_setting.jpg"));
    background.scale = Vector2.all(0.5625);
    gameRef.camera.backdrop = background;
    gameRef.camera.viewfinder.anchor = Anchor.topLeft;
    gameRef.camera.viewport = FixedAspectRatioViewport(aspectRatio: 0.5625);

    final screen = gameRef.camera.viewport;
    
    silhouetteContainer = SilhouetteContainer(
      position: Vector2(screen.size.x / 2, screen.size.y / 2),
    );
    draggableContainer = DraggableContainer(
      position: Vector2(screen.size.x / 2, screen.size.y * 6 / 7),
      size: Vector2(screen.size.x, screen.size.y * 2 / 7)
    );
    add(silhouetteContainer);
    add(draggableContainer);

    // final newButton = SpriteButtonComponent();
    // newButton.button = await game.loadSprite('Hospital/okay.png');
    // newButton.buttonDown = await game.loadSprite('Hospital/okay_pressed.png');
    // newButton.onPressed = finishGame;
    // gameRef.camera.viewport.add(AlignComponent(
    //   child: newButton,
    //   alignment: Anchor.bottomCenter,
    // ));
    return super.onLoad();
  }

  void finishGame() {
    gameRef.exitHospital();
  }
}