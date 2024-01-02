import 'dart:math';

import 'package:bin_packing_problem_resolver/extentions/swappable_list.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/rectangle_entity.dart';

import '../find_neighbours_algorithm.dart';

class SwapAlgorithmFixed implements FindNeighboursAlgorithm {
  final rand = Random();

  @override
  String get name => "Swap fixed";

  @override
  List<List<RectangleEntity>> execute(List<RectangleEntity> startSequence) {
    final neighbours = List<List<RectangleEntity>>.empty(growable: true);
    final neighboursCount = startSequence.length;

    while (neighbours.length < neighboursCount) {
      final startIndex = rand.nextInt(startSequence.length - 1);
      var moveToIndex = rand.nextInt(startSequence.length);
      while (moveToIndex == startIndex) {
        moveToIndex = rand.nextInt(startSequence.length);
      }

      final sequenceCopy = startSequence.toList();
      sequenceCopy.swap(startIndex, moveToIndex);
      neighbours.add(sequenceCopy);
    }

    return neighbours;
  }
}
