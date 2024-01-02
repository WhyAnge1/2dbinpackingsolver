import 'package:bin_packing_problem_resolver/algorithms/find_neighbours/find_neighbours_algorithm.dart';
import 'package:bin_packing_problem_resolver/algorithms/packing/bin_packing_algorithm.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/container_entity.dart';

abstract class HillClimbingState {}

class InitialHillClimbingState extends HillClimbingState {
  final Map<String, FindNeighboursAlgorithm> neighboursAlgorithms;
  final Map<String, BinPackingAlgorithm> packingAlgorithms;

  InitialHillClimbingState(
      {required this.neighboursAlgorithms, required this.packingAlgorithms});
}

class AlgorithmStartedHillClimbingState extends HillClimbingState {
  AlgorithmStartedHillClimbingState();
}

class AlgorithmStoppedHillClimbingState extends HillClimbingState {
  AlgorithmStoppedHillClimbingState();
}

class ResultHillClimbingState extends HillClimbingState {
  final List<ContainerEntity> algorithmResult;
  final int neighborsCount;
  final double maxContainerHeight;
  final bool isDone;
  final DateTime startTime;
  final DateTime? finishTime;

  ResultHillClimbingState(
      {required this.algorithmResult,
      required this.neighborsCount,
      required this.maxContainerHeight,
      required this.isDone,
      required this.startTime,
      this.finishTime});
}
