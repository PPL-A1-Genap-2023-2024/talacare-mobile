import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/layout.dart';
import 'package:talacare/helpers/text_styles.dart';
import 'package:talacare/talacare.dart';

import '../helpers/dialog_reason.dart';

class GameDialog extends SpriteComponent with HasGameRef<TalaCare> {
  DialogReason reason;
  late String text;
  late final SpriteButtonComponent yesButton;
  late final SpriteButtonComponent noButton;

  GameDialog({required this.reason});

  @override
  Future<dynamic> onLoad() async {
    sprite = await game.loadSprite('Dialog/Background.png');
    final buttons = <AlignComponent>[];
    switch (reason) {
      case DialogReason.lowBlood:
        text = 'Kamu perlu transfusi darah di rumah sakit!';

        yesButton = await _loadSpriteButton('okay');
        yesButton.onPressed = yesToHospital;
        buttons.add(AlignComponent(child: yesButton, alignment: Anchor.center));
      case DialogReason.enterHospital:
        text = '\nKe Rumah Sakit?';

        yesButton = await _loadSpriteButton('yes');
        yesButton.onPressed = yesToHospital;
        yesButton.anchor = Anchor.centerRight;
        buttons.add(
            AlignComponent(child: yesButton, alignment: Anchor.centerRight));

        noButton = await _loadSpriteButton('no');
        noButton.onPressed = game.noToHospital;
        noButton.anchor = Anchor.centerRight;

        buttons
            .add(AlignComponent(child: noButton, alignment: Anchor.centerLeft));
      case DialogReason.gameVictory:
        text = 'Kamu menang!';

        yesButton = await _loadSpriteButton('replay');
        yesButton.onPressed = gameRef.playAgain;
        yesButton.anchor = Anchor.centerRight;
        buttons.add(
            AlignComponent(child: yesButton, alignment: Anchor.centerRight));

        noButton = await _loadSpriteButton('home');
        noButton.anchor = Anchor.centerRight;

        buttons
            .add(AlignComponent(child: noButton, alignment: Anchor.centerLeft));
    }
    final textBox = TextBoxComponent(text: text);
    textBox.align = Anchor.center;
    textBox.textRenderer = TextPaint(style: AppTextStyles.largeBold);

    add(AlignComponent(child: textBox, alignment: Anchor.topCenter));

    final buttonRow = PositionComponent();
    buttonRow.size = Vector2(280, 150);
    buttonRow.addAll(buttons);
    add(AlignComponent(child: buttonRow, alignment: Anchor.bottomCenter));
    return super.onLoad();
  }

  Future<SpriteButtonComponent> _loadSpriteButton(name) async {
    final newButton = SpriteButtonComponent();
    newButton.button = await game.loadSprite('Dialog/$name.png');
    newButton.buttonDown = await game.loadSprite('Dialog/${name}_pressed.png');
    return newButton;
  }

  void yesToHospital() {
    game.goToHospital(reason);
  }
}
