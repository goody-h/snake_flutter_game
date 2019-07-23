import 'package:flutter/material.dart';
import './snake-component.dart';
import '../utils/snake-direction.dart';
import '../utils/grid-info.dart';
import './snake-head.dart';
import './snake-collision.dart';
import './snake-joint.dart';

typedef CollisionCallback = bool Function(Rect snakeHead);

class Snake extends SnakeComponent {
  final GridInfo gridInfo;

  Snake(
      this.gridInfo, this.body, this.currentDirection, this.onDetectCollision) {
    canvasSize = gridInfo.canvasSize;
    head = body[body.length - 1].clone();
    tail = body[0].clone();

    snakeHead = SnakeHead(body.last.clone());
    _buildSnakePath();
  }

  final CollisionCallback onDetectCollision;

  SnakeJoint head;
  List<SnakeJoint> body;
  SnakeJoint tail;

  Path snakePath;
  SnakeHead snakeHead;

  int growth = 0;
  int prevTailOffset = 0;

  SnakeDirection currentDirection = SnakeDirection.right;
  SnakeDirection turnDirection = SnakeDirection.right;
  SnakeDirection changeDirection;

  CollisionPoint collisionPoint;

  double gridSize() => GridInfo.gridSize();
  double _shift() => GridInfo.shift();
  Size canvasSize;
  double snakeWidth = GridInfo.snakeWidth;

  @override
  void drawComponent(Canvas canvas, {Paint paint}) {
    canvas.drawPath(snakePath, paint);
    snakeHead.drawComponent(canvas);
    if (collisionPoint != null) {
      collisionPoint.drawComponent(canvas);
    }
  }

  void updateSnake(double value, {bool rebuild = true}) {
    if (value == 1.0) {
      snakeHead.resetHead();
    }
    final preGrowthChange = growth;

    if (changeDirection != null && value != 1.0) {
      turnDirection = changeDirection;
      snakeHead.beginChangeDirection(turnDirection, value);
      changeDirection = null;
    }

    var moveBy = gridSize() * value;

    moveHead(moveBy, value);

    if (preGrowthChange > 0) {
      moveTail(0, value);
    } else if (growth < 0 && value != 1.0) {
      final newValue = -value * growth;

      var steps = (newValue - prevTailOffset) ~/ 1;

      var excess = newValue % 1.0;
      if (isSnakeShort()) {
        steps = 0;
        excess = value;
        prevTailOffset = 0;
      }

      for (var i = 0; i < steps; i++) {
        if (isSnakeShort()) {
          steps = 0;
          excess = value;
          prevTailOffset = 0;
          break;
        }
        moveTail(gridSize(), 1.0);
      }

      moveTail(gridSize() * excess, value);
      prevTailOffset += steps;
    } else {
      moveTail(moveBy, value);
    }

    if (rebuild) {
      _buildSnakePath();
      snakeHead.updateJoint(body.last, value);
    }
  }

  bool isSnakeShort() {
    var length = 0.0;
    var overflow = 0.0;
    for (var i = body.length - 1; i > 0; i--) {
      var addlength = (body[i].position.dx * body[i - 1].direction.x +
              body[i].position.dy * body[i - 1].direction.y) -
          (body[i - 1].position.dx * body[i - 1].direction.x +
              body[i - 1].position.dy * body[i - 1].direction.y);
      if ([0, gridInfo.canvasSize.width].contains(body[i].position.dx) ||
          [0, gridInfo.canvasSize.height].contains(body[i].position.dy)) {
        overflow = (GridInfo.gridSize() - GridInfo.shift()) *
            (body[i].direction.x + body[i].direction.y) *
            -1;
        continue;
      }
      length += addlength + overflow;
      overflow = 0.0;
      if (length > GridInfo.gridSize() + GridInfo.snakeWidth) {
        return false;
      }
    }
    return true;
  }

  void growSnake(int value) {
    growth += value;
  }

  void moveHead(double moveBy, double value) {
    body[body.length - 1] = head.clone().extendPosition(moveBy);

    checkHeadOverflow();

    if (value == 1.0) {
      if (turnDirection != currentDirection) {
        currentDirection = turnDirection;
        final newEnd = SnakeJoint(body.last.position, currentDirection);
        body[body.length - 1].direction = currentDirection;
        body.add(newEnd);
      }

      updateHead(end: body.last.clone());
    }
  }

  void moveTail(double moveBy, double value) {
    body[0] = tail.clone().extendPosition(moveBy);

    checkTailOverflow();

    if (value == 1.0) {
      if (body.first.matches(body[1])) {
        body.removeAt(0);
      }
      updateTail(end: body.first.clone());
    }

    //print(body[1].position.dx - body[0].position.dx);
  }

  void _buildSnakePath() {
    final snake = Path();

    // form snake path
    snake.moveTo(body[0].position.dx, body[0].position.dy);
    for (var part in body) {
      snake.lineTo(part.position.dx, part.position.dy);
      if (part.position.dx > canvasSize.width) {
        snake.moveTo(-snakeWidth / 2, part.position.dy);
      } else if (part.position.dx < 0) {
        snake.moveTo(canvasSize.width + snakeWidth / 2, part.position.dy);
      } else if (part.position.dy > canvasSize.height) {
        snake.moveTo(part.position.dx, -snakeWidth / 2);
      } else if (part.position.dy < 0) {
        snake.moveTo(part.position.dx, canvasSize.height + snakeWidth / 2);
      }
    }
    snakePath = snake;
  }

  void checkHeadOverflow() {
    final offset = body.last.position;
    if (offset.dx > canvasSize.width) {
      final overflowX = offset.dx - canvasSize.width;
      final last = Offset(canvasSize.width + gridSize() - _shift(), offset.dy);

      body[body.length - 1].position = last;

      updateHead(position: Offset(-snakeWidth + _shift(), head.position.dy));

      if (collisionPoint != null) {
        body.add(head.clone());
      } else {
        body
          ..add(SnakeJoint(Offset(0, offset.dy), head.direction))
          ..add(SnakeJoint(Offset(overflowX, offset.dy), head.direction));
      }
    } else if (offset.dx < 0) {
      final overflowX = offset.dx;
      final last = Offset(-gridSize() + _shift(), offset.dy);

      body[body.length - 1].position = last;

      updateHead(
          position: Offset(
              canvasSize.width + snakeWidth / 2 + _shift(), head.position.dy));

      if (collisionPoint != null) {
        body.add(head.clone());
      } else {
        body
          ..add(SnakeJoint(Offset(canvasSize.width, offset.dy), head.direction))
          ..add(SnakeJoint(
              Offset(canvasSize.width + overflowX, offset.dy), head.direction));
      }
    } else if (offset.dy > canvasSize.height) {
      final overflowY = offset.dy - canvasSize.height;
      final last = Offset(offset.dx, canvasSize.height + gridSize() - _shift());

      body[body.length - 1].position = last;

      updateHead(position: Offset(head.position.dx, -snakeWidth + _shift()));

      if (collisionPoint != null) {
        body.add(head.clone());
      } else {
        body
          ..add(SnakeJoint(Offset(offset.dx, 0), head.direction))
          ..add(SnakeJoint(Offset(offset.dx, overflowY), head.direction));
      }
    } else if (offset.dy < 0) {
      final overflowY = offset.dy;
      final last = Offset(offset.dx, -gridSize() + _shift());

      body[body.length - 1].position = last;

      updateHead(
          position: Offset(
              head.position.dx, canvasSize.height + snakeWidth / 2 + _shift()));

      if (collisionPoint != null) {
        body.add(head.clone());
      } else {
        body
          ..add(
              SnakeJoint(Offset(offset.dx, canvasSize.height), head.direction))
          ..add(SnakeJoint(Offset(offset.dx, canvasSize.height + overflowY),
              head.direction));
      }
    }
  }

  void checkTailOverflow() {
    final offset = body.first.position;
    if (offset.dx > canvasSize.width) {
      final overflowX = offset.dx - canvasSize.width;

      body.removeRange(0, 2);
      final first = Offset(overflowX, offset.dy);
      body[0].position = first;

      updateTail(position: Offset(-snakeWidth + _shift(), tail.position.dy));
    } else if (offset.dx < 0) {
      final overflowX = offset.dx;

      body.removeRange(0, 2);
      final first = Offset(canvasSize.width + overflowX, offset.dy);
      body[0].position = first;

      updateTail(
          position: Offset(
              canvasSize.width + snakeWidth / 2 + _shift(), tail.position.dy));
    } else if (offset.dy > canvasSize.height) {
      final overflowY = offset.dy - canvasSize.height;

      body.removeRange(0, 2);
      final first = Offset(offset.dx, overflowY);
      body[0].position = first;

      updateTail(position: Offset(tail.position.dx, -snakeWidth + _shift()));
    } else if (offset.dy < 0) {
      final overflowY = offset.dy;

      body.removeRange(0, 2);
      final first = Offset(offset.dx, canvasSize.height + overflowY);
      body[0].position = first;

      updateTail(
          position: Offset(
              tail.position.dx, canvasSize.height + snakeWidth / 2 + _shift()));
    }
  }

  void updateHead({SnakeJoint end, Offset position, SnakeDirection direction}) {
    if (end != null) {
      head = end;
      detectCollision();
    } else if (head != null) {
      if (direction != null) {
        head.direction = direction;
      }
      if (position != null) {
        head.position = position;
      }
      detectCollision();
    }
  }

  void updateTail({SnakeJoint end, Offset position, SnakeDirection direction}) {
    if (end != null) {
      tail = end;
    } else {
      if (direction != null) {
        tail.direction = direction;
      }
      if (position != null) {
        tail.position = position;
      }
    }
  }

  void detectCollision() {
    if (growth > 0) {
      growth--;
    } else if (growth < 0) {
      growth = 0;
      prevTailOffset = 0;
    }
    detectHeadCollision();
  }

  void detectHeadCollision() {
    final headCenter = head.clone().extendPosition(snakeWidth);
    Rect headRect = headCenter.getRect(
        headCenter.clone().extendPosition(snakeWidth / 4), snakeWidth);

    if (onDetectCollision(headRect) || detectBodyCollision(headRect)) {
      final headCenter = head.clone().extendPosition(snakeWidth);
      collisionPoint = CollisionPoint(headCenter.position);
    }
  }

  bool detectBodyCollision(Rect rect) {
    for (var i = 0; i < body.length - 2; i++) {
      final firstEdge = body[i];

      if (firstEdge.position.dx > canvasSize.width ||
          firstEdge.position.dx < 0 ||
          firstEdge.position.dy > canvasSize.height ||
          firstEdge.position.dy < 0) {
        continue;
      }
      final secondEdge = body[i + 1];
      final bodyRect = firstEdge.getRect(secondEdge, snakeWidth);

      if (rect.overlaps(bodyRect)) {
        return true;
      }
    }
    return false;
  }

  void setDirection(SnakeDirection newDirection) {
    if (newDirection != turnDirection &&
        !newDirection.isOpposite(currentDirection)) {
      changeDirection = newDirection;
    }
  }
}
