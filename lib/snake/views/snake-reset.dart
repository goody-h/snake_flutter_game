import 'package:flutter/material.dart';

class SnakeReset extends StatelessWidget {
  SnakeReset({Key key, this.onclick}): super(key: key);
  final VoidCallback onclick;
  @override
    Widget build(BuildContext context) {
      return Positioned(
          top: 30,
          right: 30,
          child: FloatingActionButton(
            elevation: 1,
            backgroundColor: Colors.transparent,
            child: Icon(Icons.sync),
            onPressed: onclick,
          ),
        );
    }
}