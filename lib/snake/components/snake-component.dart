import 'package:flutter/material.dart';

abstract class SnakeComponent {
  bool overlaps(Rect otherRect) {
    return false;
  }

  void drawComponent(Canvas canvas, {Paint paint});
}