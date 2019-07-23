import 'package:flutter/material.dart';
import 'snake-component.dart';

class CollisionPoint extends SnakeComponent {
  Offset point;
  final collisionPaint = Paint();

  CollisionPoint(this.point) {

    collisionPaint.style = PaintingStyle.fill;
    collisionPaint.isAntiAlias = true;
    collisionPaint.color = Colors.red;

  }
  @override
  void drawComponent(Canvas canvas, {Paint paint}) {
      canvas.drawCircle(point, 3, collisionPaint);
  }
}
