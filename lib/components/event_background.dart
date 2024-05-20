import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:talacare/talacare.dart';

class EventBackground extends PositionComponent with HasGameReference<TalaCare> {
  Paint _backgroundPaint;

  EventBackground({
    super.priority = 6,
  })
      : _backgroundPaint = Paint()..color = Colors.black.withOpacity(0.5);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.size.x, game.size.y);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawRect(size.toRect(), _backgroundPaint);
  }
}
