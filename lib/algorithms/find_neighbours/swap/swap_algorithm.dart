import 'package:bin_packing_problem_resolver/models/entity/bin_packing/rectangle_entity.dart';

import '../../../extentions/swappable_list.dart';
import '../find_neighbours_algorithm.dart';

class SwapAlgorithm implements FindNeighboursAlgorithm {
  @override
  String get name => "Swap";

  @override
  List<List<RectangleEntity>> execute(List<RectangleEntity> startSequence) {
    final neighbours = List<List<RectangleEntity>>.empty(growable: true);
    var startIndex = 0;
    var tempIndex = 1;

    while (startIndex != startSequence.length - 1) {
      final sequenceCopy = startSequence.toList();
      sequenceCopy.swap(startIndex, tempIndex);
      neighbours.add(sequenceCopy);

      if (tempIndex == startSequence.length - 1) {
        startIndex++;
        tempIndex = startIndex + 1;
      } else {
        tempIndex++;
      }
    }

    return neighbours;
  }
}
