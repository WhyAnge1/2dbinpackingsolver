import 'package:bin_packing_problem_resolver/models/entity/bin_packing/container_entity.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/rectangle_entity.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/shelf_entity.dart';

class RectanglePlacer {
  static bool placeChild(ContainerEntity container, RectangleEntity child) {
    for (var existShelf in container.shelves) {
      if (existShelf.canFit(child, canBeRotated: true)) {
        if (!existShelf.canFit(child)) {
          child.rotate();
        }

        child.x = existShelf.x;
        child.y = existShelf.y;

        container.placedChildren.add(child);

        existShelf.x = existShelf.x + child.width;
        existShelf.width = existShelf.width - child.width;
        if (existShelf.width <= 0) {
          container.shelves.remove(existShelf);
        }

        _fixInterceptShelves(container, child);

        var newShelf = _createNewShelf(container, child);

        if (!container.shelves
            .any((element) => element.hasSameCoordinates(newShelf))) {
          container.shelves.add(newShelf);
        }

        container.shelves.sort(_compareShelves);

        return true;
      }
    }

    return false;
  }

  static void _fixInterceptShelves(
      ContainerEntity container, RectangleEntity child) {
    var interceptShelfs = container.shelves
        .where((element) => element.intercepts(child))
        .toList();
    for (var shelf in interceptShelfs) {
      if (shelf.y < child.y) {
        shelf.height = child.y - shelf.y;
      } else {
        container.shelves.remove(shelf);

        var leftShelf = ShelfEntity.fromShelf(shelf);
        leftShelf.width = child.x - leftShelf.x;
        var rightShelf = ShelfEntity.fromShelf(shelf);
        rightShelf.x = child.rightMostX;
        rightShelf.width = shelf.rightMostX - rightShelf.x;

        if (leftShelf.width > 0 &&
            !container.shelves
                .any((element) => element.hasSameCoordinates(leftShelf))) {
          container.shelves.add(leftShelf);
        }

        if (rightShelf.width > 0 &&
            !container.shelves
                .any((element) => element.hasSameCoordinates(rightShelf)) &&
            container.placedChildren.any((element) =>
                element.topMostY == rightShelf.y &&
                element.x >= rightShelf.x)) {
          container.shelves.add(rightShelf);
        }
      }
    }
  }

  static ShelfEntity _createNewShelf(
      ContainerEntity container, RectangleEntity child) {
    var newShelf = ShelfEntity(width: 0, height: 0, x: 0, y: child.topMostY);

    var elementsToTheLeft = container.placedChildren.where((element) =>
        newShelf.y >= element.y &&
        newShelf.y <= element.topMostY &&
        child.x >= element.rightMostX);
    newShelf.x = elementsToTheLeft.isEmpty
        ? 0
        : elementsToTheLeft
            .reduce((value, element) =>
                element.rightMostX > value.rightMostX ? element : value)
            .rightMostX;

    var elemetsToTheTop = container.placedChildren.where((element) =>
        newShelf.x >= element.x &&
        newShelf.x <= element.rightMostX &&
        child.topMostY <= element.y);
    newShelf.height = elemetsToTheTop.isEmpty
        ? container.height - newShelf.y
        : elemetsToTheTop
                .reduce(
                    (value, element) => element.y < value.y ? element : value)
                .y -
            newShelf.y;

    var elemetsToTheRight = container.placedChildren.where((element) =>
        newShelf.y >= element.y &&
        newShelf.y <= element.topMostY &&
        child.rightMostX <= element.x);
    newShelf.width = elemetsToTheRight.isEmpty
        ? container.width - newShelf.x
        : elemetsToTheRight
                .reduce(
                    (value, element) => element.x < value.x ? element : value)
                .x -
            newShelf.x;

    return newShelf;
  }

  static int _compareShelves(ShelfEntity a, ShelfEntity b) {
    if (a.y < b.y) {
      return -1;
    } else if (a.y == b.y && a.x < b.x) {
      return -1;
    } else if (a.y == b.y && a.x == b.x) {
      return 0;
    } else {
      return 1;
    }
  }
}
