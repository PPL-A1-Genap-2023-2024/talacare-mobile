import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class TransparentLayer extends PositionComponent {
  @override
  void render(Canvas canvas) {
    final paint = BasicPalette.black.paint()
      ..color = Colors.black.withOpacity(0.7);
    canvas.drawRect(size.toRect(), paint);
  }
}
