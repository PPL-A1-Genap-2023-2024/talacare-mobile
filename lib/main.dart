import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'talacare.dart';

void main() {
  runApp(
    const GameWidget<TalaCare>.controlled(
      gameFactory: TalaCare.new,
    ),
  );
}