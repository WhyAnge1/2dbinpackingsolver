import 'package:bin_packing_problem_resolver/models/entity/bin_packing/rectangle_entity.dart';

import '../find_neighbours_algorithm.dart';

class TwoOptAlgorithm implements FindNeighboursAlgorithm {
  @override
  String get name => "Two-opt";

  @override
  List<List<RectangleEntity>> execute(List<RectangleEntity> startSequence) {
    final neighbours = List<List<RectangleEntity>>.empty(growable: true);

    if (startSequence.length >= 4) {
      var startIndex = 0;
      var endIndex = 3;

      while (startIndex != startSequence.length - 3) {
        final correctStartIndex = startIndex + 1;
        final neighbour = startSequence.toList();
        final elementsBetween =
            neighbour.getRange(correctStartIndex, endIndex).toList();
        neighbour.removeRange(correctStartIndex, endIndex);
        neighbour.insertAll(correctStartIndex, elementsBetween.reversed);

        neighbours.add(neighbour);

        if (endIndex == startSequence.length - 1) {
          startIndex++;
          endIndex = startIndex + 3;
        } else {
          endIndex++;
        }
      }
    }

    return neighbours;
  }
}
