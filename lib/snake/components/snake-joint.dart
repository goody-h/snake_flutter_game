import 'package:flutter/material.dart';
import '../utils/snake-direction.dart';

class SnakeJoint {
  SnakeDirection direction;
  Offset position;
  bool isDeadEnd = false;

  SnakeJoint(this.position, this.direction);

  SnakeJoint clone() => SnakeJoint(position, direction);
  bool matches(SnakeJoint other) =>
      position.dx == other.position.dx && position.dy == other.position.dy;

  SnakeJoint extendPosition(double extension) {
    position = Offset(
      position.dx + extension * direction.x,
      position.dy + extension * direction.y,
    );
    return this;
  }

  double getAxis() {
    return position.dx * (1 - direction.x * direction.x) +
        position.dy * (1 - direction.y * direction.y);
  }

  double getPointOnAxis(
      {double extension = 0, SnakeDirection changeDirection}) {
    final direction =
        changeDirection != null ? changeDirection : this.direction;
    return position.dx * direction.x * direction.x +
        position.dy * direction.y * direction.y +
        extension * (direction.x + direction.y);
  }

  Rect getRect(SnakeJoint other, double width) {
    final moveX = (direction.x * direction.x - direction.y * direction.y) *
        (direction.x + direction.y) *
        width /
        2;

    final moveY = (direction.y * direction.y - direction.x * direction.x) *
        (direction.x + direction.y) *
        width /
        2;
    final pointOne = Offset(position.dx - moveX, position.dy - moveY);
    final pointTwo =
        Offset(other.position.dx - moveY, other.position.dy - moveX);
    return Rect.fromPoints(pointOne, pointTwo);
  }
}
