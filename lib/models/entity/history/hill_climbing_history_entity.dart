import 'package:bin_packing_problem_resolver/algorithms/heuristic/hill_climbing/hill_climbing_parameters.dart';
import 'package:bin_packing_problem_resolver/algorithms/heuristic/hill_climbing/hill_climbing_result.dart';
import 'package:bin_packing_problem_resolver/models/entity/history/algorithm_history_entity.dart';

class HillClimbingHistoryEntity extends AlgorithmHistoryEntity {
  final HillClimbingResult? result;
  final HillClimbingParameters parameters;

  HillClimbingHistoryEntity({
    required super.startTime,
    required super.finishTime,
    required super.heuristicAlgorithm,
    required super.findNeighboursAlgorithm,
    required super.binPackingAlgorithm,
    required this.result,
    required this.parameters,
  });
}
