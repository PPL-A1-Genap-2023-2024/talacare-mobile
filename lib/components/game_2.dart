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


  HospitalPuzzle({required this.player, required this.reason});

  @override
  FutureOr<void> onLoad() async {
    final background = SpriteComponent();
    background.sprite = await game.loadSprite("Hospital/hospital_setting.jpg");
    background.scale = Vector2.all(0.5625);
    gameRef.camera.backdrop = background;
    gameRef.camera.viewfinder.anchor = Anchor.center;
    gameRef.camera.viewport = FixedAspectRatioViewport(aspectRatio: 0.5625);

    screen = gameRef.camera.viewport;
    
    silhouetteContainer = SilhouetteContainer(
      position: Vector2(screen.size.x / 2, screen.size.y * 2 / 5),
      size: Vector2.all(screen.size.x * 9 / 10)
    );
    draggableContainer = DraggableContainer(
      position: Vector2(screen.size.x / 2, screen.size.y * 4 / 5),
      size: Vector2(screen.size.x * 9 / 10, 100)
    );
    gameRef.camera.viewport.add(silhouetteContainer);
    gameRef.camera.viewport.add(draggableContainer);

    // final newButton = SpriteButtonComponent();
    // newButton.button = await game.loadSprite('Hospital/okay.png');
    // newButton.buttonDown = await game.loadSprite('Hospital/okay_pressed.png');
    // newButton.onPressed = finishGame;
    // gameRef.camera.viewport.add(AlignComponent(
    //   child: newButton,
    //   alignment: Anchor.center,
    // ));
    return super.onLoad();
  }

  void finishGame() {
    gameRef.exitHospital();
  }
}