import 'package:flutter/material.dart';
import '../utils/snake-direction.dart';

typedef DirectionCallback = void Function(SnakeDirection direction);

class SnakeController extends StatelessWidget {
  const SnakeController({Key key, this.onClick}) : super(key: key);

  final DirectionCallback onClick;

  Widget createButton(SnakeDirection direction, IconData icon) {
    return FloatingActionButton(
        elevation: 1,
        backgroundColor: Colors.transparent,
        child: Icon(icon),
        onPressed: () {
          onClick(direction);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 30,
      bottom: 30,
      height: 170,
      width: 170,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: createButton(SnakeDirection.up, Icons.arrow_drop_up),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: createButton(SnakeDirection.right, Icons.arrow_right),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: createButton(SnakeDirection.down, Icons.arrow_drop_down),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: createButton(SnakeDirection.left, Icons.arrow_left),
          )
        ],
      ),
    );
  }
}
