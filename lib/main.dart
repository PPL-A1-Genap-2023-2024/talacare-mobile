import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'camera.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const CameraTestWidget());
}

class CameraTestWidget extends StatelessWidget {
  const CameraTestWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Talacare',
      home: GameWidget<CameraTest>(
        game: CameraTest(viewportResolution: Vector2(1500, 2000)),
      ),
    );
  }
}
