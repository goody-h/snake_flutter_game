import 'package:flutter/material.dart';
import '../components/snake-component.dart';

class SnakeBoard extends CustomPainter {
  final Path grid;
  final List<SnakeComponent> walls;
  final List<SnakeComponent> decorations;

  final gridPaint = Paint();
  final wallPaint = Paint();

  SnakeBoard({@required this.grid, this.walls, this.decorations}) : super() {
    wallPaint.style = PaintingStyle.fill;
    wallPaint.isAntiAlias = true;
    wallPaint.color = Colors.brown;

    gridPaint.style = PaintingStyle.stroke;
    gridPaint.strokeCap = StrokeCap.round;
    gridPaint.isAntiAlias = true;
    gridPaint.strokeJoin = StrokeJoin.round;
    gridPaint.color = Colors.white.withOpacity(0.03);
    gridPaint.strokeWidth = 1;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(grid, gridPaint);
    if (walls != null) {
      for (var wall in walls) {
        wall.drawComponent(canvas, paint: wallPaint);
      }
    }
    if (decorations != null) {
      for (var decoration in decorations) {
        decoration.drawComponent(canvas);
      }
    }
  }

  @override
  bool shouldRepaint(SnakeBoard oldDelegate) =>
      this.walls != oldDelegate.walls ||
      this.grid != oldDelegate.grid ||
      this.decorations != oldDelegate.decorations;
}
