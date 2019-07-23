import 'package:flutter/material.dart';
import 'snake-component.dart';
import '../utils/snake-direction.dart';
import '../utils/grid-info.dart';
import './snake-joint.dart';
import 'dart:math';

class SnakeHead extends SnakeComponent {
  SnakeDirection changeDirection;
  SnakeJoint joint;

  double snakeWidth = GridInfo.snakeWidth;

  double directionChangeOffset = 0;
  double startAngle = 0;
  double endAngle = 0;
  double turnAngle = 0;

  Path headPath;

  final headPaint = Paint();


  SnakeHead(this.joint) {
    headPaint.style = PaintingStyle.fill;
    headPaint.isAntiAlias = true;
    headPaint.color = Colors.black;

    changeDirection = joint.direction;

    _buildSnakeHead(0);
  }

  void beginChangeDirection(SnakeDirection newDirection, double value) {

      directionChangeOffset = value;
      startAngle = turnAngle;
      endAngle = _getEndAngle();
      changeDirection = newDirection;
  }

  void updateJoint(SnakeJoint newJoint, double animationValue) {
    joint = newJoint;
    _buildSnakeHead(animationValue);
  }

  void resetHead() {
    turnAngle = 0;
      startAngle = 0;
      endAngle = 0;
  }


  double _getEndAngle() {
    final angle =
        joint.direction.getRelativeDirectionalOffset(changeDirection) * 90.0;

    return angle;
  }

  void _buildSnakeHead(double offset) {
    final head = Path();

    final start = joint.position;

    final angleOffset =
        (offset - directionChangeOffset) / (1 - directionChangeOffset);

    turnAngle = startAngle + angleOffset * (endAngle - startAngle);

    head.moveTo(start.dx, start.dy);

    final c = joint.direction;

    // TODO: fix readability
    final x = (c.x + 1) % 2;
    final y = (c.y + 1) % 2;
    List<int> m = [x * c.y, y * -c.x, c.x, c.y, x * -c.y, y * c.x];

    final one =
        _rotatePoint(turnAngle, Offset(snakeWidth * m[0], snakeWidth * m[1]));
    head.relativeLineTo(one.dx, one.dy);
    final two =
        _rotatePoint(turnAngle, Offset(snakeWidth * m[2], snakeWidth * m[3]));
    head.relativeLineTo(two.dx - one.dx, two.dy - one.dy);
    final three =
        _rotatePoint(turnAngle, Offset(snakeWidth * m[4], snakeWidth * m[5]));
    head.relativeLineTo(three.dx - two.dx, three.dy - two.dy);

    headPath = head;
  }

  Offset _rotatePoint(double angle, Offset point) {
    final rad = angle * pi / 180;
    return MatrixUtils.transformPoint(Matrix4.rotationZ(rad), point);
  }
/*
  Rect getHeadRect() {
    final headCenter = joint.clone().extendPosition(snakeWidth);
    return headCenter.getRect(headCenter.clone().extendPosition(snakeWidth / 4), snakeWidth);
  }
*/
  @override
  void drawComponent(Canvas canvas, {Paint paint}) {
    canvas.drawPath(headPath, headPaint);
  }

}
