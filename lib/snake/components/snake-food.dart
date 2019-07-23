import 'package:flutter/material.dart';
import 'snake-component.dart';
import '../utils//grid-info.dart';

abstract class Food extends SnakeComponent {
  Food(this.value, this.points);
  final int value;
  final points;
  Rect rect;

  void buildRect(Offset offset);
}

class SnakeFood extends Food {
  SnakeFood(Offset offset) : super(1, 10) {
    buildRect(offset);
  }

  void buildRect(Offset offset) {
    rect = Rect.fromPoints(
        Offset(offset.dx - GridInfo.snakeWidth / 2,
            offset.dy - GridInfo.snakeWidth / 2),
        Offset(offset.dx + GridInfo.snakeWidth / 2,
            offset.dy + GridInfo.snakeWidth / 2));
  }

  @override
  void drawComponent(Canvas canvas, {Paint paint}) {
    canvas.drawRect(rect, paint);
  }

  @override
  bool overlaps(Rect otherRect) {
    return rect.overlaps(otherRect);
  }
}

class BonusFood extends Food {
  Paint foodPaint = Paint();
  BonusFood(Offset offset) : super(1, 30) {
    buildRect(offset);
    foodPaint.style = PaintingStyle.fill;
    foodPaint.isAntiAlias = true;
    foodPaint.color = Colors.blue;
  }

  void buildRect(Offset offset) {
    rect = Rect.fromPoints(
        Offset(offset.dx - GridInfo.snakeWidth / 2,
            offset.dy - GridInfo.snakeWidth / 2),
        Offset(offset.dx + GridInfo.snakeWidth / 2,
            offset.dy + GridInfo.snakeWidth / 2));
  }

  @override
  void drawComponent(Canvas canvas, {Paint paint}) {
    canvas.drawRect(rect, foodPaint);
  }

  @override
  bool overlaps(Rect otherRect) {
    return rect.overlaps(otherRect);
  }
}

class ShrinkFood extends Food {
  Paint foodPaint = Paint();

  ShrinkFood(Offset offset) : super(-3, 0) {
    buildRect(offset);

    foodPaint.style = PaintingStyle.fill;
    foodPaint.isAntiAlias = true;
    foodPaint.color = Colors.pink;
  }

  void buildRect(Offset offset) {
    rect = Rect.fromPoints(
        Offset(offset.dx - GridInfo.snakeWidth / 2,
            offset.dy - GridInfo.snakeWidth / 2),
        Offset(offset.dx + GridInfo.snakeWidth / 2,
            offset.dy + GridInfo.snakeWidth / 2));
  }

  @override
  void drawComponent(Canvas canvas, {Paint paint}) {
    canvas.drawRect(rect, foodPaint);
  }

  @override
  bool overlaps(Rect otherRect) {
    return rect.overlaps(otherRect);
  }
}
