import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/talacare.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Timestamp Functionality Test', () {
    testWithGame<TalaCare>('Check Start and End Timestamp', TalaCare.new,
        (game) async {
      await game.ready();
      game.update(1000);
      game.victory();
      expect(game.totalTime, greaterThan(0));
    });
    testWithGame<TalaCare>('Check Time When The Game is Paused', TalaCare.new,
        (game) async {
      await game.ready();
      game.lifecycleStateChange(AppLifecycleState.paused);
      game.lifecycleStateChange(AppLifecycleState.hidden);
      game.update(1000);
      expect(game.paused, true);
      int timeNow = game.totalTime;
      game.update(1000);
      expect(game.totalTime, timeNow);
      game.lifecycleStateChange(AppLifecycleState.resumed);
      expect(game.paused, false);
    });
  });
}
