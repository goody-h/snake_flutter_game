import 'package:flutter/material.dart';
import '../components/snake-component.dart';

class SnakeScene extends CustomPainter {
  final SnakeComponent snake;
  final SnakeComponent head;
  final SnakeComponent collisionPoint;
  final List<SnakeComponent> food;
  final List<SnakeComponent> animatables;

  final snakePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeJoin = StrokeJoin.round
    ..color = Colors.black
    ..strokeWidth = 10.0;

  final foodPaint = Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true
    ..color = Colors.green;

  SnakeScene({
    this.snake,
    this.head,
    this.collisionPoint,
    this.food,
    this.animatables,
  }) : super();

  @override
  void paint(Canvas canvas, Size size) {
    snake.drawComponent(canvas, paint: snakePaint);

    if (food != null) {
      for (var foodItem in food) {
        foodItem.drawComponent(canvas, paint: foodPaint);
      }
    }

    if (collisionPoint != null) {
      collisionPoint.drawComponent(canvas);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
