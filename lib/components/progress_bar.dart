import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ProgressBar extends PositionComponent {
  double progress;
  @override
  final double width;
  @override
  final double height;
  final Paint backgroundPaint;
  final Paint foregroundPaint;

  ProgressBar({
    required this.progress,
    required this.width,
    required this.height,
  })  : backgroundPaint = Paint()..color = Color(0xFF7f647e),
        foregroundPaint = Paint()..color = Color(0xFFD5EF9D),
        super(size: Vector2(width, height));

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    double borderRadius = 15.0;
    double padding = 8.0;

    // Draw background
    final RRect backgroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(-padding, -padding, width + 2 * padding, height + 2 * padding),
      Radius.circular(borderRadius)
    );
    canvas.drawRRect(backgroundRect, backgroundPaint);

    final RRect foregroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, width * progress, height),
      Radius.circular(borderRadius),
    );
    // Draw foreground based on progress
    canvas.drawRRect(foregroundRect, foregroundPaint);
  }

  void updateProgress(double newProgress) {
    progress = newProgress;
  }
}
