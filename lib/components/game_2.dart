import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/layout.dart';
import 'package:talacare/components/player.dart';
import 'package:talacare/talacare.dart';

import '../helpers/hospital_reason.dart';

class HospitalPuzzle extends World with HasGameRef<TalaCare> {
  final Player player;
  late HospitalReason reason;


  HospitalPuzzle({required this.player});

  @override
  FutureOr<void> onLoad() async {

  }

  void finish_game() {
  }
}