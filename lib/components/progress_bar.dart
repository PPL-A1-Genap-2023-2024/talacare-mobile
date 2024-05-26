import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ProgressBar extends PositionComponent {
  double progress;
  final double width;
  final double height;
  final Paint backgroundPaint;
  final Paint foregroundPaint;

  ProgressBar({
    required this.progress,
    required this.width,
    required this.height,
  })  : backgroundPaint = Paint()..color = Colors.grey,
        foregroundPaint = Paint()..color = Colors.green,
        super(size: Vector2(width, height));

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Draw background
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), backgroundPaint);
    // Draw foreground based on progress
    canvas.drawRect(Rect.fromLTWH(0, 0, width * progress, height), foregroundPaint);
  }

  void updateProgress(double newProgress) {
    progress = newProgress;
  }
}
