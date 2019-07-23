import 'package:flutter/material.dart';
import 'snake-component.dart';

class Wall extends SnakeComponent {
  Rect wall;
  Wall(Offset topRight, double width, double height) {
    wall = Rect.fromPoints(topRight, Offset(topRight.dx + width, topRight.dy + height));
  }

  @override
  bool overlaps(Rect otherRect) {
    return wall.overlaps(otherRect);
  }

  @override
  void drawComponent(Canvas canvas, {Paint paint}) {
    canvas.drawRect(wall, paint);
  }
}
