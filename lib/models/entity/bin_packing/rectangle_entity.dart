import 'base_two_dim_shape_entity.dart';

class RectangleEntity extends BaseTwoDimShapeEntity {
  RectangleEntity(
      {required double width,
      required double height,
      double x = 0,
      double y = 0,
      String name = ""})
      : super(width, height, x, y, name) {}

  RectangleEntity.fromRectangle(RectangleEntity rectangle)
      : this(
            width: rectangle.width,
            height: rectangle.height,
            x: rectangle.x,
            y: rectangle.y,
            name: rectangle.name);
}
