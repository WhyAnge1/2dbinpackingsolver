import 'package:bin_packing_problem_resolver/algorithms/algorithm.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/container_entity.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/rectangle_entity.dart';

abstract class BinPackingAlgorithm implements Algorithm {
  List<ContainerEntity> execute(List<RectangleEntity> elementsToFit,
      double containerWidth, double containerHeight);
}
