import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/camera.dart';

void main() {
  testWidgets('camera follows the movable object when pressing A', (WidgetTester tester) async {
    // Pump game widget into tester
    final game = CameraTest(viewportResolution: Vector2(1500, 2000));
    await tester.pumpWidget(GameWidget(game: game));
    await tester.pump();
    await tester.pump();

    // Mark down camera position before moving
    final cameraPositionBefore = game.camera.viewfinder.position;
    final gamePositionBefore = game.object.position;
    await simulateKeyDownEvent(LogicalKeyboardKey.keyA);

    // Update game state
    await tester.pump(const Duration(seconds: 2));
    await simulateKeyDownEvent(LogicalKeyboardKey.keyX);

    // Mark down camera position after game updates
    final gamePositionAfter = game.object.position;
    final cameraPositionAfter = game.camera.viewfinder.position;

    expect(cameraPositionBefore, equals(gamePositionBefore));
    expect(cameraPositionAfter, equals(gamePositionAfter));
  });

  testWidgets('camera follows the movable object when pressing W', (WidgetTester tester) async {
    // Pump game widget into tester
    final game = CameraTest(viewportResolution: Vector2(1500, 2000));
    await tester.pumpWidget(GameWidget(game: game));
    await tester.pump();
    await tester.pump();

    // Mark down camera position before moving
    final cameraPositionBefore = game.camera.viewfinder.position;
    final gamePositionBefore = game.object.position;
    await simulateKeyDownEvent(LogicalKeyboardKey.keyW);
    await simulateKeyDownEvent(LogicalKeyboardKey.keyX);

    // Update game state
    await tester.pump(const Duration(seconds: 2));

    // Mark down camera position after game updates
    final gamePositionAfter = game.object.position;
    final cameraPositionAfter = game.camera.viewfinder.position;

    expect(cameraPositionBefore, equals(gamePositionBefore));
    expect(cameraPositionAfter, equals(gamePositionAfter));
  });

  testWidgets('camera follows the movable object when pressing S', (WidgetTester tester) async {
    // Pump game widget into tester
    final game = CameraTest(viewportResolution: Vector2(1500, 2000));
    await tester.pumpWidget(GameWidget(game: game));
    await tester.pump();
    await tester.pump();

    // Mark down camera position before moving
    final cameraPositionBefore = game.camera.viewfinder.position;
    final gamePositionBefore = game.object.position;
    await simulateKeyDownEvent(LogicalKeyboardKey.keyS);
    await simulateKeyDownEvent(LogicalKeyboardKey.keyX);

    // Update game state
    await tester.pump(const Duration(seconds: 2));

    // Mark down camera position after game updates
    final gamePositionAfter = game.object.position;
    final cameraPositionAfter = game.camera.viewfinder.position;

    expect(cameraPositionBefore, equals(gamePositionBefore));
    expect(cameraPositionAfter, equals(gamePositionAfter));
  });

  testWidgets('camera follows the movable object when pressing D', (WidgetTester tester) async {
    // Pump game widget into tester
    final game = CameraTest(viewportResolution: Vector2(1500, 2000));
    await tester.pumpWidget(GameWidget(game: game));
    await tester.pump();
    await tester.pump();

    // Mark down camera position before moving
    final cameraPositionBefore = game.camera.viewfinder.position;
    final gamePositionBefore = game.object.position;
    await simulateKeyDownEvent(LogicalKeyboardKey.keyD);
    await simulateKeyDownEvent(LogicalKeyboardKey.keyX);

    // Update game state
    await tester.pump(const Duration(seconds: 2));

    // Mark down camera position after game updates
    final gamePositionAfter = game.object.position;
    final cameraPositionAfter = game.camera.viewfinder.position;

    expect(cameraPositionBefore, equals(gamePositionBefore));
    expect(cameraPositionAfter, equals(gamePositionAfter));
  });
}
