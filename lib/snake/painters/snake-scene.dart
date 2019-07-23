import 'package:flutter/material.dart';
import '../components/snake-component.dart';

class SnakeScene extends CustomPainter {
  final SnakeComponent snake;
  final SnakeComponent head;
  final SnakeComponent collisionPoint;
  final List<SnakeComponent> food;
  final List<SnakeComponent> animatables;

  final snakePaint = Paint();
  final collisionPaint = Paint();
  final foodPaint = Paint();

  SnakeScene({
    this.snake,
    this.head,
    this.collisionPoint,
    this.food,
    this.animatables,
  }) : super() {
    snakePaint.style = PaintingStyle.stroke;
    snakePaint.strokeCap = StrokeCap.round;
    snakePaint.isAntiAlias = true;
    snakePaint.strokeJoin = StrokeJoin.round;
    snakePaint.color = Colors.black;
    snakePaint.strokeWidth = 10.0;

    collisionPaint.style = PaintingStyle.fill;
    collisionPaint.isAntiAlias = true;
    collisionPaint.color = Colors.red;

    foodPaint.style = PaintingStyle.fill;
    foodPaint.isAntiAlias = true;
    foodPaint.color = Colors.green;
  }

  @override
  void paint(Canvas canvas, Size size) {
    snake.drawComponent(canvas, paint: snakePaint);

    if (food != null) {
      for (var foodItem in food) {
        foodItem.drawComponent(canvas, paint: foodPaint);
      }
    }

    if (collisionPoint != null) {
      collisionPoint.drawComponent(canvas, paint: collisionPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
