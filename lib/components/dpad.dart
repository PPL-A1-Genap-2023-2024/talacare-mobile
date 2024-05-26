import 'package:flame/components.dart';
import 'package:flame/layout.dart';
import 'package:talacare/helpers/arrow_state.dart';
import 'package:talacare/talacare.dart';
import '../helpers/directions.dart';
import 'dpad_arrow.dart';

class DPad extends SpriteComponent with HasGameRef<TalaCare>, HasVisibility {


  late final DPadArrow leftButton;
  late final DPadArrow rightButton;
  late final DPadArrow upButton;
  late final DPadArrow downButton;
  bool disabled = false;


  @override
  Future<dynamic> onLoad() async {
    sprite = await game.loadSprite('D_Pad/D-Pad.png');

    // Buttons
    final leftSprites = await loadArrowSprites('Left');
    leftButton = DPadArrow(arrowDirection: Direction.left)
      ..sprites = leftSprites;

    final rightSprites = await loadArrowSprites('Right');
    rightButton = DPadArrow(arrowDirection: Direction.right)
      ..sprites = rightSprites;

    final downSprites = await loadArrowSprites('Down');
    downButton = DPadArrow(arrowDirection: Direction.down)
      ..sprites = downSprites;

    final upSprites = await loadArrowSprites('Up');
    upButton = DPadArrow(arrowDirection: Direction.up)
      ..sprites = upSprites;

    add(AlignComponent(
      child:leftButton,
      alignment: Anchor.centerLeft,
    ));
    add(AlignComponent(
      child:rightButton,
      alignment: Anchor.centerRight,
    ));
    add(AlignComponent(
      child:upButton,
      alignment: Anchor.topCenter,
    ));
    add(AlignComponent(
      child:downButton,
      alignment: Anchor.bottomCenter,
    ));
  }

  Future<Map<ArrowState, Sprite>> loadArrowSprites(String direction) async {
    final Sprite defaultSprite = await game.loadSprite('D_Pad/$direction.png');
    final Sprite pressedSprite = await game.loadSprite('D_Pad/$direction-Pressed.png');
    return {
      ArrowState.unpressed: defaultSprite,
      ArrowState.pressed: pressedSprite
    };
  }

  void disable() {
    disabled = true;
    upButton.isActive = downButton.isActive = leftButton.isActive = rightButton.isActive = false;
  }

  void enable() {
    disabled = false;
    upButton.isActive = downButton.isActive = leftButton.isActive = rightButton.isActive = true;
  }

}