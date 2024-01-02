import 'package:bin_packing_problem_resolver/algorithms/heuristic/ant_colony/ant_colony_parameters.dart';
import 'package:bin_packing_problem_resolver/algorithms/heuristic/ant_colony/ant_colony_result.dart';
import 'package:bin_packing_problem_resolver/models/entity/history/algorithm_history_entity.dart';

class AntColonyHistoryEntity extends AlgorithmHistoryEntity {
  final AntColonyResult? result;
  final AntColonyParameters parameters;

  AntColonyHistoryEntity({
    required super.startTime,
    required super.finishTime,
    required super.heuristicAlgorithm,
    required super.findNeighboursAlgorithm,
    required super.binPackingAlgorithm,
    required this.result,
    required this.parameters,
  });
}
