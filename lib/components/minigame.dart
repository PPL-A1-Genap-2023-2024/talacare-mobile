import 'dart:async';

import 'package:flame/components.dart';
import 'package:talacare/components/point.dart';

import '../talacare.dart';

class Minigame extends Component with HasGameRef<TalaCare> {
  ActivityPoint point;
  Minigame({required this.point});


  void finishGame() {
    game.finishMinigame(point, true);
  }

  void loseGame() {
    game.finishMinigame(point, false);
  }
}