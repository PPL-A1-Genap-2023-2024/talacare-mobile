import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';
import 'package:talacare/talacare.dart';
import '../lib/overlays/health.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TalaCare game;
  late HeartHealthComponent heartHealthComponent;

  setUp(() {
    game = TalaCare();
    heartHealthComponent = HeartHealthComponent(
      heartNumber: 1,
      position: Vector2.zero(),
      size: Vector2.all(32),
      lifetime: 5,
    );
    heartHealthComponent.game = game;
  });

  test('HeartHealthComponent initialization test', () async {
    await heartHealthComponent.onLoad();
    expect(heartHealthComponent.timerStarted, true);
    expect(heartHealthComponent.current, HeartState.available); 
  });
}