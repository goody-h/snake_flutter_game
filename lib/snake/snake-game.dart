import 'package:flutter/material.dart';
import './components/components.dart';
import './painters/painters.dart';
import './utils/utils.dart';
import './views/views.dart';
import 'dart:math';
import 'dart:async';

class Game extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: MediaQuery.of(context).orientation == Orientation.landscape
          ? SnakeGame(
              size: MediaQuery.of(context).size,
            )
          : null,
    );
  }
}

class SnakeGame extends StatefulWidget {
  SnakeGame({Key key, this.size}) : super(key: key);

  final Size size;
  @override
  State<StatefulWidget> createState() {
    return _SnakeGameState();
  }
}

class _SnakeGameState extends State<SnakeGame> {
  GridInfo gridInfo;
  List<Wall> walls;

  @override
  void initState() {
    super.initState();

    gridInfo = GridInfo(widget.size);
    _buildWalls();
  }

  void _buildWalls() {
    final height = GridInfo.getGridlength();
    final hWidth = GridInfo.getGridlength(gridExcess: gridInfo.hGridCount ~/ 3);
    final vWidth = GridInfo.getGridlength(gridExcess: gridInfo.vGridCount ~/ 3);

    walls = [
      // horizontal walls
      Wall(Offset(GridInfo.shift(), GridInfo.shift()), hWidth, height),
      Wall(
          Offset(
              gridInfo.canvasSize.width - GridInfo.shift(), GridInfo.shift()),
          -hWidth,
          height),
      Wall(
          Offset(
              GridInfo.shift(), gridInfo.canvasSize.height - GridInfo.shift()),
          hWidth,
          -height),
      Wall(
          Offset(gridInfo.canvasSize.width - GridInfo.shift(),
              gridInfo.canvasSize.height - GridInfo.shift()),
          -hWidth,
          -height),

      // vertical walls
      Wall(Offset(GridInfo.shift(), GridInfo.shift()), height, vWidth),
      Wall(
          Offset(
              gridInfo.canvasSize.width - GridInfo.shift(), GridInfo.shift()),
          -height,
          vWidth),
      Wall(
          Offset(
              GridInfo.shift(), gridInfo.canvasSize.height - GridInfo.shift()),
          height,
          -vWidth),
      Wall(
          Offset(gridInfo.canvasSize.width - GridInfo.shift(),
              gridInfo.canvasSize.height - GridInfo.shift()),
          -height,
          -vWidth),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.grey,
        width: gridInfo.canvasSize.width,
        height: gridInfo.canvasSize.height,
        child: Stack(
          children: <Widget>[
            CustomPaint(
              size: gridInfo.canvasSize,
              painter: SnakeBoard(
                grid: gridInfo.buildGridPath(),
                walls: walls,
              ),
            ),
            GameScene(
              gridInfo: gridInfo,
              walls: walls,
            ),
          ],
        ),
      ),
    );
  }
}

class GameScene extends StatefulWidget {
  final GridInfo gridInfo;
  final List<Wall> walls;

  GameScene({Key key, this.gridInfo, this.walls}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GameSceneState();
  }
}

class _GameSceneState extends State<GameScene>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  Snake snake;

  Food food;

  CollisionPoint collision;

  AnimationController _controller;

  double prevOffset = 0;

  int score = 0;

  int foodCounter = 0;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _controller.addListener(_animatorListener);

    initSnake(startAnimation: false);

    WidgetsBinding.instance.addPostFrameCallback((value) {
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    });
  }

  void getSnakeFood() {
    if (foodCounter < 5) {
      foodCounter++;
      addFood();
    } else {
      final rnd = Random();
      if (foodCounter == 5) {
        foodCounter += 1 + rnd.nextInt(4);
      }

      if (foodCounter == 6) {
        foodCounter = 0;
        var r = rnd.nextInt(2);
        print(r);
        addFood(type: 1 + r);
      } else {
        foodCounter--;
        addFood();
      }
    }
  }

  void addFood({int type = 0}) {
    final rnd = Random();

    var x = rnd.nextInt(widget.gridInfo.hGridCount) * GridInfo.gridSize() +
        GridInfo.snakeWidth / 2 +
        GridInfo.shift();
    var y = rnd.nextInt(widget.gridInfo.vGridCount) * GridInfo.gridSize() +
        GridInfo.snakeWidth / 2 +
        GridInfo.shift();

    //var x = GridInfo.shift() + GridInfo.snakeWidth /2;
    //var y = GridInfo.shift() +  GridInfo.snakeWidth /2 + (widget.gridInfo.vGridCount ~/2) * GridInfo.gridSize();

    Food newFood;

    switch (type) {
      case 0:
        newFood = SnakeFood(Offset(x, y));
        break;
      case 1:
        newFood = BonusFood(Offset(x, y));
        break;
      case 2:
        newFood = ShrinkFood(Offset(x, y));
        break;
    }

    while (snake.detectBodyCollision(newFood.rect) ||
        detectWallCollision(newFood.rect)) {
      x = rnd.nextInt(widget.gridInfo.hGridCount) * GridInfo.gridSize() +
          GridInfo.snakeWidth / 2 +
          GridInfo.shift();
      y = rnd.nextInt(widget.gridInfo.vGridCount) * GridInfo.gridSize() +
          GridInfo.snakeWidth / 2 +
          GridInfo.shift();
      newFood.buildRect(Offset(x, y));
    }

    food = newFood;

    if (type != 0) {
      Timer(Duration(seconds: 15), () {
        if (!(food is SnakeFood)) {
          addFood(type: 0);
        }
      });
    }
  }

  bool detectWallCollision(Rect rect) {
    for (var wall in widget.walls) {
      if (wall.overlaps(rect)) {
        return true;
      }
    }
    return false;
  }

  void detectHeadToFoodCollision(Rect snakeHead) {
    if (food != null) {
      if (food.overlaps(snakeHead)) {
        snake.growSnake(food.value);
        score += food.points;
        getSnakeFood();
      }
    }
  }

  bool onDetectCollision(Rect snakeHead) {
    detectHeadToFoodCollision(snakeHead);
    return detectWallCollision(snakeHead);
  }

  void initSnake({bool startAnimation = true}) {
    if (_controller != null && _controller.isAnimating) {
      _controller
        ..stop()
        ..reset();
    }

    score = 0;

    final x = (widget.gridInfo.hGridCount ~/ 2) * GridInfo.gridSize() +
        GridInfo.shift();
    final y = (widget.gridInfo.vGridCount ~/ 2) * GridInfo.gridSize() +
        GridInfo.snakeWidth / 2 +
        GridInfo.shift();

    // Init snake parts
    final tail = SnakeJoint(
        Offset(x - GridInfo.gridSize() * 6 + GridInfo.snakeWidth / 2, y),
        SnakeDirection.right);
    final head = SnakeJoint(
        Offset(x + GridInfo.gridSize() * 6 - GridInfo.snakeWidth, y),
        SnakeDirection.right);

    snake = Snake(
        widget.gridInfo, [tail, head], SnakeDirection.right, onDetectCollision);

    getSnakeFood();

    if (startAnimation) {
      _controller.repeat();
    }
  }

  void _animatorListener() {
    if (snake.collisionPoint != null) {
      stopSnake();
    } else {
      final offset = _controller.value;
      if (prevOffset > offset) {
        snake.updateSnake(1.0, rebuild: false);
      }
      snake.updateSnake(offset);

      if (offset == 1.0) {
        prevOffset = 0;
      } else {
        prevOffset = offset;
      }
    }
    setState(() {});
  }

  void stopSnake() {
    _controller.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CustomPaint(
          painter: SnakeScene(
            snake: snake,
            collisionPoint: collision,
            food: [food],
          ),
          size: widget.gridInfo.canvasSize,
          willChange: true,
          isComplex: true,
        ),
        SnakeController(
          onClick: (direction) {
            snake.setDirection(direction);
          },
        ),
        SnakeReset(
          onclick: initSnake,
        ),
        ScoreBoard(
          score: score,
        ),
      ],
    );
  }
}
