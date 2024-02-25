import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/camera.dart';

void main() {
  testWidgets('camera follows the movable object', (WidgetTester tester) async {
    // Pump game widget into tester
    final game = CameraTest(viewportResolution: Vector2(1500, 2000));
    await tester.pumpWidget(GameWidget(game: game));
    await tester.pump();
    await tester.pump();

    // Mark down camera position before moving
    final cameraPositionBefore = game.camera.viewfinder.position;
    await simulateKeyDownEvent(LogicalKeyboardKey.keyA);
    final gamePositionBefore = game.object.position;

    // Update game state
    await tester.pump(const Duration(seconds: 2));

    // Mark down camera position after game updates
    final gamePositionAfter = game.object.position;
    final cameraPositionAfter = game.camera.viewfinder.position;

    expect(cameraPositionBefore, equals(gamePositionBefore));
    expect(cameraPositionAfter, equals(gamePositionAfter));
  });
}
