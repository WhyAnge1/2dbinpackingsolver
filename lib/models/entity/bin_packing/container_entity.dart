import 'rectangle_entity.dart';
import 'shelf_entity.dart';
import 'base_two_dim_shape_entity.dart';

class ContainerEntity extends BaseTwoDimShapeEntity {
  final placedChildren = List<RectangleEntity>.empty(growable: true);
  final shelves = List<ShelfEntity>.empty(growable: true);

  double get filledSquare => placedChildren.isEmpty
      ? 0
      : placedChildren
          .map((e) => e.square)
          .reduce((value, element) => value + element);

  double get freeSquare => square - filledSquare;

  int get filledPercent => ((filledSquare / square) * 100).truncate();

  ContainerEntity({
    required double width,
    required double height,
    String name = "",
  }) : super(width, height, 0, 0, name) {
    shelves.add(ShelfEntity(width: width, height: height, x: x, y: y));
  }

  @override
  String toString() =>
      "Container $name has ${placedChildren.length} (${placedChildren.map((e) => e.name).join(", ")}) placed children; $filledSquare filled square; $freeSquare free square; $square total square";
}
