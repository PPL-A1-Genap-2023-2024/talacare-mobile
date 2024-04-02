import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/layout.dart';
import 'package:talacare/talacare.dart';

import '../helpers/hospital_reason.dart';



class HospitalConfirmation extends SpriteComponent with HasGameRef<TalaCare> {
  HospitalReason reason;
  late String text;
  late final SpriteButtonComponent yesButton;
  late final SpriteButtonComponent noButton;


  HospitalConfirmation({required this.reason});

  @override
  Future<dynamic> onLoad() async {
    sprite = await game.loadSprite('Hospital/Background.png');
    final buttons = <AlignComponent>[];
    switch(reason) {
      case HospitalReason.lowBlood:
        text = 'Kamu perlu transfusi darah di rumah sakit!';

        yesButton = await _loadSpriteButton('okay');
        yesButton.onPressed = game.okayHospital;
        buttons.add(AlignComponent(
            child: yesButton,
            alignment: Anchor.center
        ));
      case HospitalReason.playerEnter:
        text = 'Ke Rumah Sakit?';

        yesButton = await _loadSpriteButton('yes');
        yesButton.onPressed = game.yesToHospital;
        yesButton.anchor = Anchor.centerRight;
        buttons.add(AlignComponent(
          child: yesButton,
          alignment: Anchor.centerRight
        ));

        noButton = await _loadSpriteButton('no');
        noButton.onPressed = game.noToHospital;
        noButton.anchor = Anchor.centerRight;

        buttons.add(AlignComponent(
            child: noButton,
            alignment: Anchor.centerLeft
        ));
    }
    final textBox = TextBoxComponent(text:text);
    textBox.align = Anchor.center;
    add(AlignComponent(
      child: textBox,
      alignment: Anchor.topCenter
    ));

    final buttonRow = PositionComponent();
    buttonRow.size = Vector2(280, 150);
    buttonRow.addAll(buttons);
    add(AlignComponent(
        child: buttonRow,
        alignment: Anchor.bottomCenter
    ));
    return super.onLoad();
  }


  Future<SpriteButtonComponent> _loadSpriteButton(name) async {
    final newButton = SpriteButtonComponent();
    newButton.button = await game.loadSprite('Hospital/$name.png');
    newButton.buttonDown = await game.loadSprite('Hospital/${name}_pressed.png');
    return newButton;
  }


}