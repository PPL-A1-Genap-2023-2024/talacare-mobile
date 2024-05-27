import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/layout.dart';
import 'package:flutter/material.dart';
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
    String iconVariant = "";
    final buttons = <AlignComponent>[];
    switch (reason) {
      case DialogReason.lowBlood:
        text = 'Kamu perlu transfusi darah!';
        iconVariant = 'hospital';
        yesButton = await _loadSpriteButton('okay');
        yesButton.onPressed = yesToHospital;
        buttons.add(AlignComponent(child: yesButton, alignment: Anchor.center));

      case DialogReason.enterHospital:
        text = 'Ke Rumah Sakit?';
        iconVariant = 'hospital';
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
        iconVariant = 'trophy';
        yesButton = await _loadSpriteButton('replay');
        yesButton.onPressed = gameRef.playAgain;
        yesButton.anchor = Anchor.centerRight;
        buttons.add(
            AlignComponent(child: yesButton, alignment: Anchor.centerRight));
        noButton = await _loadSpriteButton('home');
        noButton.anchor = Anchor.centerRight;
        buttons
            .add(AlignComponent(child: noButton, alignment: Anchor.centerLeft));

      case DialogReason.winGame2:
        text = 'Kamu berhasil!\nKembali ke Rumah';
        iconVariant = 'house';
        yesButton = await _loadSpriteButton('okay');
        yesButton.onPressed = gameRef.exitHospital;
        yesButton.anchor = Anchor.centerRight;
        buttons.add(AlignComponent(child: yesButton, alignment: Anchor.center));

      case DialogReason.loseGame2:
        text = 'Waktu habis!\nKembali ke Rumah';
        iconVariant = 'house';
        yesButton = await _loadSpriteButton('okay');
        yesButton.onPressed = gameRef.loseHospital;
        yesButton.anchor = Anchor.centerRight;
        buttons.add(AlignComponent(child: yesButton, alignment: Anchor.center));

      case DialogReason.timeLimitExceeded:
        text =
            '\n\nWaktu bermain kamu hari ini sudah habis.\n\nDatang lagi \nbesok, ya!';
        yesButton = await _loadSpriteButton('home');
        yesButton.onPressed = () {
          gameRef.exitToMainMenu(gameRef.context);
        };
        yesButton.anchor = Anchor.center;
        buttons.add(AlignComponent(child: yesButton, alignment: Anchor.center));
    }

    if (iconVariant != "") {
      final iconRow = RectangleComponent(
          anchor: Anchor.center,
          paint: Paint()..color = Color.fromARGB(0, 0, 0, 0),
          size: Vector2.all(125));
      final icon = SpriteComponent(
          anchor: Anchor.bottomCenter,
          position: Vector2(iconRow.size.x / 2, iconRow.size.y),
          sprite: await game.loadSprite('Dialog/dialog_icon_$iconVariant.png'));
      iconRow.add(icon);
      add(AlignComponent(child: iconRow, alignment: Anchor.topCenter));
    }

    final textBox = TextBoxComponent(text: text);
    textBox.align = Anchor.center;
    textBox.textRenderer = TextPaint(style: AppTextStyles.largeBold);
    if (iconVariant != "") {
      add(AlignComponent(child: textBox, alignment: Anchor.center));
    } else {
      add(AlignComponent(child: textBox, alignment: Anchor.topCenter));
    }

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
