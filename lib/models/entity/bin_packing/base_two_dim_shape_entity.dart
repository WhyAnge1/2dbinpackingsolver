abstract class BaseTwoDimShapeEntity {
  bool _isRotated = false;

  String name;
  double width;
  double height;
  double x;
  double y;

  double get rightMostX => x + width;
  double get topMostY => y + height;
  double get square => width * height;
  bool get isRotated => _isRotated;

  BaseTwoDimShapeEntity(this.width, this.height, this.x, this.y, this.name);

  bool canFit(BaseTwoDimShapeEntity shape, {bool canBeRotated = false}) =>
      (shape.width <= width && shape.height <= height) ||
      (canBeRotated && shape.width <= height && shape.height <= width);

  bool intercepts(BaseTwoDimShapeEntity shape) => !(x >= shape.rightMostX ||
      shape.x >= rightMostX ||
      y >= shape.topMostY ||
      shape.y >= topMostY);

  bool hasSameCoordinates(BaseTwoDimShapeEntity shape) =>
      x == shape.x && y == shape.y;

  void rotate() {
    var tmp = width;
    width = height;
    height = tmp;

    _isRotated = !_isRotated;
  }

  @override
  String toString() =>
      "${name}W${width}H${height}X${x}Y${y}R${isRotated ? "T" : "F"}";
}
