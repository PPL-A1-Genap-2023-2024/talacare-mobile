import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/layout.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/components/level.dart';
import 'package:flame/image_composition.dart';
import 'components/dpad_arrow.dart';
import 'helpers/directions.dart';

class TalaCare extends FlameGame with HasKeyboardHandlerComponents {

  late final CameraComponent cam;
  Player player = Player(character: 'Adam');
  late final DPadArrow leftButton;
  late final DPadArrow rightButton;
  late final DPadArrow upButton;
  late final DPadArrow downButton;
  late final SpriteComponent dPad;

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    final world = Level(
      player: player,
      levelName: 'Level-01'
    );

    cam = CameraComponent.withFixedResolution(world: world, width: 360, height: 640);
    cam.viewfinder.anchor = Anchor.topLeft;


    final Image dPadImage = await images.load('D_Pad/D-Pad.png');
    dPad = SpriteComponent()..sprite = Sprite(dPadImage)..anchor=Anchor.bottomCenter;


    // Buttons
    final Image leftImage = await images.load('D_Pad/Left.png');
    final Image leftPressedImage = await images.load('D_Pad/Left-Pressed.png');
    leftButton = DPadArrow(arrowDirection: Direction.left, defaultSprite: Sprite(leftImage), pressedSprite: Sprite(leftPressedImage))
      ..sprite = Sprite(leftImage);


    final Image rightImage = await images.load('D_Pad/Right.png');
    final Image rightPressedImage = await images.load('D_Pad/Right-Pressed.png');
    rightButton = DPadArrow(arrowDirection: Direction.right, defaultSprite: Sprite(rightImage), pressedSprite: Sprite(rightPressedImage))
      ..sprite = Sprite(rightImage);

    final Image downImage = await images.load('D_Pad/Down.png');
    final Image downPressedImage = await images.load('D_Pad/Down-Pressed.png');
    downButton = DPadArrow(arrowDirection: Direction.down, defaultSprite: Sprite(downImage), pressedSprite: Sprite(downPressedImage))
      ..sprite = Sprite(downImage);

    final Image upImage = await images.load('D_Pad/Up.png');
    final Image upPressedImage = await images.load('D_Pad/Up-Pressed.png');
    upButton = DPadArrow(arrowDirection: Direction.up, defaultSprite: Sprite(upImage), pressedSprite: Sprite(upPressedImage))
      ..sprite = Sprite(upImage);

    dPad.add(AlignComponent(
      child:leftButton,
      alignment: Anchor.centerLeft,
    ));
    dPad.add(AlignComponent(
      child:rightButton,
      alignment: Anchor.centerRight,
    ));
    dPad.add(AlignComponent(
      child:upButton,
      alignment: Anchor.topCenter,
    ));
    dPad.add(AlignComponent(
      child:downButton,
      alignment: Anchor.bottomCenter,
    ));

    cam.viewport.add(AlignComponent(
      child:dPad,
      alignment: Anchor.bottomCenter,
    ));
    addAll([cam, world]);

    return super.onLoad();
  }

  void changeDirection(Direction direction) {
    player.direction = direction;
  }
}