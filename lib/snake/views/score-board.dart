import 'package:flutter/material.dart';

class ScoreBoard extends StatelessWidget {
  ScoreBoard({Key key, this.score}): super(key: key);
  final int score;
  @override
    Widget build(BuildContext context) {
      return Positioned(
          top: 30,
          left: 30,
          child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Score: ", style: TextStyle( fontSize: 20),),
          Text(score.toString(), style: TextStyle( fontSize: 20),)
        ],
      ),
        );
    }
}