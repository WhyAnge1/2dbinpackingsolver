import 'package:bin_packing_problem_resolver/algorithms/find_neighbours/find_neighbours_algorithm.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/rectangle_entity.dart';

class OrOptAlgorithm implements FindNeighboursAlgorithm {
  @override
  String get name => "Or-opt";

  @override
  List<List<RectangleEntity>> execute(List<RectangleEntity> startSequence) {
    final neighbors = List<List<RectangleEntity>>.empty(growable: true);
    neighbors.add(startSequence.toList());

    for (var chainLength = 1;
        chainLength < startSequence.length;
        chainLength++) {
      for (var startIndex = 0;
          startIndex < startSequence.length - 1;
          startIndex++) {
        for (var moveToIndex = startIndex + chainLength;
            moveToIndex < startSequence.length;
            moveToIndex++) {
          final sequenceCopy = startSequence.toList();
          final subList =
              sequenceCopy.sublist(startIndex, startIndex + chainLength);
          sequenceCopy.removeRange(startIndex, startIndex + chainLength);
          sequenceCopy.insertAll(moveToIndex - chainLength + 1, subList);

          neighbors.add(sequenceCopy);
        }
      }
    }

    return neighbors;
  }
}
