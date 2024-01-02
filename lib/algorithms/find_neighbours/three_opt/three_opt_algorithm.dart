import 'package:bin_packing_problem_resolver/algorithms/find_neighbours/find_neighbours_algorithm.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/rectangle_entity.dart';

class ThreeOptAlgorithm implements FindNeighboursAlgorithm {
  @override
  String get name => "Three-opt";

  @override
  List<List<RectangleEntity>> execute(List<RectangleEntity> startSequence) {
    final neighbors = List<List<RectangleEntity>>.empty(growable: true);

    for (int i = 0; i < startSequence.length - 2; i++) {
      for (int j = i + 1; j < startSequence.length - 1; j++) {
        for (int k = j + 1; k < startSequence.length; k++) {
          var neighbor = List<RectangleEntity>.empty(growable: true);

          neighbor.addAll(startSequence.getRange(0, i));
          neighbor.addAll(startSequence.getRange(i, j + 1).toList().reversed);
          neighbor.addAll(startSequence.getRange(j + 1, k + 1));
          neighbor.addAll(startSequence
              .getRange(k + 1, startSequence.length)
              .toList()
              .reversed);

          neighbors.add(neighbor);
        }
      }
    }

    return neighbors;
  }
}
