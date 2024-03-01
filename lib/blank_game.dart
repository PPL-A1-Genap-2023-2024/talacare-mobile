import 'package:flame/layout.dart';
import 'package:talacare/dpad_arrow.dart';

import 'player.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'helpers/directions.dart';

class BlankGame extends FlameGame {
  late final Player player;
  late final DPadArrow leftButton;
  late final DPadArrow rightButton;
  late final DPadArrow upButton;
  late final DPadArrow downButton;
  late final SpriteComponent dPad;

  @override
  Future<void> onLoad() async {

    final Image playerImage = await images.load('chicken.png');
    final playerAnimation = SpriteAnimation.fromFrameData(
      playerImage,
      SpriteAnimationData.sequenced(
        amount: 14,
        stepTime: 0.1,
        textureSize: Vector2(32, 34),
      ),
    );
    player = Player()
      ..animation = playerAnimation;

    final Image dPadImage = await images.load('D-Pad.png');
    dPad = SpriteComponent()..sprite = Sprite(dPadImage);


    // Buttons
    final Image leftImage = await images.load('Left.png');
    final Image leftPressedImage = await images.load('Left-Pressed.png');
    leftButton = DPadArrow(arrowDirection: Direction.left, defaultSprite: Sprite(leftImage), pressedSprite: Sprite(leftPressedImage))
      ..sprite = Sprite(leftImage);


    final Image rightImage = await images.load('Right.png');
    final Image rightPressedImage = await images.load('Right-Pressed.png');
    rightButton = DPadArrow(arrowDirection: Direction.right, defaultSprite: Sprite(rightImage), pressedSprite: Sprite(rightPressedImage))
      ..sprite = Sprite(rightImage);

    final Image downImage = await images.load('Down.png');
    final Image downPressedImage = await images.load('Down-Pressed.png');
    downButton = DPadArrow(arrowDirection: Direction.down, defaultSprite: Sprite(downImage), pressedSprite: Sprite(downPressedImage))
      ..sprite = Sprite(downImage);

    final Image upImage = await images.load('Up.png');
    final Image upPressedImage = await images.load('Up-Pressed.png');
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

    camera.viewport.add(AlignComponent(
      child: dPad,
      alignment: Anchor.bottomCenter,
    ));

    world.add(player);
  }

  void changeDirection(Direction direction) {
    player.direction = direction;
  }
}