import 'package:flutter/material.dart';

class GridInfo {
  static const double snakeWidth = 10;
  Size canvasSize;
  int hGridCount;
  int vGridCount;

  GridInfo(Size size) {
    hGridCount = size.width ~/ gridSize();
    final width = hGridCount * gridSize();
    vGridCount = size.height ~/ gridSize();
    final height = vGridCount * gridSize();

    canvasSize = Size(width, height);
  }

  static double getGridlength({gridExcess = 0}) {
    return snakeWidth + gridSize() * gridExcess;
  }

  static double gridSize() => snakeWidth + snakeWidth/2 ;

  static double shift() => snakeWidth / 4;


  Path buildGridPath() {
    final grid = Path();

    var start = snakeWidth / 2 + shift();
    for (var i = 0; i < hGridCount; i++) {
      grid.moveTo(start + gridSize() * i, 0);
      grid.lineTo(start + gridSize() * i, canvasSize.height);
    }
    for (var i = 0; i < vGridCount; i++) {
      grid.moveTo(0, start + gridSize() * i);
      grid.lineTo(canvasSize.width, start + gridSize() * i);
    }
    return grid;
  }
}