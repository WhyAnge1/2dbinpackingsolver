import 'package:bin_packing_problem_resolver/algorithms/packing/bin_packing_algorithm.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/container_entity.dart';

abstract class AntColonyState {}

class InitialAntColonyState extends AntColonyState {
  InitialAntColonyState();
}

class AlgorithmStartedAntColonyState extends AntColonyState {
  AlgorithmStartedAntColonyState();
}

class AlgorithmStoppedAntColonyState extends AntColonyState {
  AlgorithmStoppedAntColonyState();
}

class InitialDataAntColonyState extends AntColonyState {
  final Map<String, BinPackingAlgorithm> packingAlgorithms;
  final double alpha;
  final double beta;
  final double gamma;
  final double pheromoneStartValue;
  final int antColonySize;
  final double evaporationRate;

  InitialDataAntColonyState(
      {required this.packingAlgorithms,
      required this.alpha,
      required this.beta,
      required this.gamma,
      required this.pheromoneStartValue,
      required this.antColonySize,
      required this.evaporationRate});
}

class ResultAntColonyState extends AntColonyState {
  final List<ContainerEntity> algorithmResult;
  final double maxContainerHeight;
  final bool isDone;
  final DateTime startTime;
  final DateTime? finishTime;
  final int antsSpawned;

  ResultAntColonyState(
      {required this.algorithmResult,
      required this.maxContainerHeight,
      required this.isDone,
      required this.startTime,
      required this.antsSpawned,
      this.finishTime});
}
