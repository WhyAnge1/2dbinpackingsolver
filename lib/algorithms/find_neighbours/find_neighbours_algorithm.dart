import 'package:bin_packing_problem_resolver/algorithms/algorithm.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/rectangle_entity.dart';

abstract class FindNeighboursAlgorithm implements Algorithm {
  List<List<RectangleEntity>> execute(List<RectangleEntity> startSequence);
}
