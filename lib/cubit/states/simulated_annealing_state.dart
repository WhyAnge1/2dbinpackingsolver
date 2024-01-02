import 'package:bin_packing_problem_resolver/algorithms/packing/bin_packing_algorithm.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/container_entity.dart';

abstract class SimulatedAnnealingState {}

class InitialSimulatedAnnealingState extends SimulatedAnnealingState {
  InitialSimulatedAnnealingState();
}

class AlgorithmStartedSimulatedAnnealingState extends SimulatedAnnealingState {
  AlgorithmStartedSimulatedAnnealingState();
}

class AlgorithmStoppedSimulatedAnnealingState extends SimulatedAnnealingState {
  AlgorithmStoppedSimulatedAnnealingState();
}

class InitialDataSimulatedAnnealingState extends SimulatedAnnealingState {
  final Map<String, BinPackingAlgorithm> packingAlgorithms;
  final double coolingAlpha;
  final int numAttempts;
  final double initialTemperature;

  InitialDataSimulatedAnnealingState(
      {required this.packingAlgorithms,
      required this.coolingAlpha,
      required this.initialTemperature,
      required this.numAttempts});
}

class ResultSimulatedAnnealingState extends SimulatedAnnealingState {
  final List<ContainerEntity> algorithmResult;
  final double temperature;
  final double tryValue;
  final double maxContainerHeight;
  final bool isDone;
  final DateTime startTime;
  final DateTime? finishTime;

  ResultSimulatedAnnealingState(
      {required this.algorithmResult,
      required this.temperature,
      required this.tryValue,
      required this.maxContainerHeight,
      required this.isDone,
      required this.startTime,
      this.finishTime});
}
