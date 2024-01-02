import 'base_two_dim_shape_entity.dart';

class ShelfEntity extends BaseTwoDimShapeEntity {
  ShelfEntity({
    required double width,
    required double height,
    required double x,
    required double y,
    String name = "",
  }) : super(width, height, x, y, name) {}

  ShelfEntity.fromShelf(ShelfEntity shelf)
      : this(
            width: shelf.width,
            height: shelf.height,
            x: shelf.x,
            y: shelf.y,
            name: shelf.name);
}
