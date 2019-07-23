import 'package:flutter/material.dart';
import 'snake-component.dart';

class CollisionPoint extends SnakeComponent {
  final Offset point;
  final collisionPaint = Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true
    ..color = Colors.red;

  CollisionPoint(this.point);

  @override
  void drawComponent(Canvas canvas, {Paint paint}) {
    canvas.drawCircle(point, 3, collisionPaint);
  }
}
