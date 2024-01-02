import 'package:bin_packing_problem_resolver/algorithms/find_neighbours/find_neighbours_algorithm.dart';
import 'package:bin_packing_problem_resolver/algorithms/heuristic/heuristic_algorithm.dart';
import 'package:bin_packing_problem_resolver/algorithms/packing/bin_packing_algorithm.dart';

abstract class AlgorithmHistoryEntity {
  final DateTime startTime;
  final DateTime finishTime;
  final FindNeighboursAlgorithm? findNeighboursAlgorithm;
  final BinPackingAlgorithm binPackingAlgorithm;
  final HeuristicAlgorithm heuristicAlgorithm;

  AlgorithmHistoryEntity(
      {required this.startTime,
      required this.finishTime,
      required this.heuristicAlgorithm,
      required this.findNeighboursAlgorithm,
      required this.binPackingAlgorithm});
}
