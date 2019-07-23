
class SnakeDirection {
  const SnakeDirection(this.x, this.y);

  final int x;
  final int y;

  static const up = SnakeDirection(0, -1);
  static const right = SnakeDirection(1, 0);
  static const down = SnakeDirection(0, 1);
  static const left = SnakeDirection(-1, 0);

  bool isOpposite(SnakeDirection other) => x + other.x == 0 && y + other.y == 0;

  int getRelativeOffset(SnakeDirection other) {
    return 1 - (x * other.x + y * other.y);
  }

  int getRelativeDirectionalOffset(SnakeDirection other) {
    return (-x + y) * (-other.x - other.y) * getRelativeOffset(other);
  }

  @override
  String toString() {
    return "Direction[$x, $y]";
  }
}
