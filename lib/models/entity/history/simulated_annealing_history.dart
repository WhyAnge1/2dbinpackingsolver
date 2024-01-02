import 'package:bin_packing_problem_resolver/algorithms/heuristic/simulated_annealing/simulated_annaling_parameters.dart';
import 'package:bin_packing_problem_resolver/algorithms/heuristic/simulated_annealing/simulated_annealing_result.dart';
import 'package:bin_packing_problem_resolver/models/entity/history/algorithm_history_entity.dart';

class SimulatedAnnealingHistoryEntity extends AlgorithmHistoryEntity {
  final SimulatedAnnealingResult? result;
  final SimulatedAnnealingParameters parameters;

  SimulatedAnnealingHistoryEntity({
    required super.startTime,
    required super.finishTime,
    required super.heuristicAlgorithm,
    required super.findNeighboursAlgorithm,
    required super.binPackingAlgorithm,
    required this.result,
    required this.parameters,
  });
}
