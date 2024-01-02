import 'package:bin_packing_problem_resolver/models/entity/bin_packing/container_entity.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/rectangle_entity.dart';

import '../../helpers/rectangle_placer.dart';
import 'bin_packing_algorithm.dart';

class FirstFitAlgorithm implements BinPackingAlgorithm {
  @override
  String get name => "First fit";

  @override
  List<ContainerEntity> execute(List<RectangleEntity> elementsToFit,
      double containerWidth, double containerHeight) {
    final containers = [
      ContainerEntity(
          name: "C1", width: containerWidth, height: containerHeight)
    ];

    for (var element in elementsToFit) {
      var copy = RectangleEntity.fromRectangle(element);
      var isPlaced = false;

      for (var container in containers) {
        isPlaced = RectanglePlacer.placeChild(container, copy);

        if (isPlaced) {
          break;
        }
      }

      if (!isPlaced) {
        var newContainer = ContainerEntity(
            name: "C${containers.length + 1}",
            width: containerWidth,
            height: containerHeight);
        containers.add(newContainer);

        RectanglePlacer.placeChild(newContainer, copy);
      }
    }

    return containers;
  }
}
