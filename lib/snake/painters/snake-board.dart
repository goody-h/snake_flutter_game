import 'package:flutter/material.dart';
import '../components/snake-component.dart';

class SnakeBoard extends CustomPainter {
  final Path grid;
  final List<SnakeComponent> walls;
  final List<SnakeComponent> decorations;

  final gridPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeJoin = StrokeJoin.round
    ..color = Colors.white.withOpacity(0.03)
    ..strokeWidth = 1;

  final wallPaint = Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true
    ..color = Colors.brown;

  SnakeBoard({@required this.grid, this.walls, this.decorations}) : super();

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
