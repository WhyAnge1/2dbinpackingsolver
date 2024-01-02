import 'package:bin_packing_problem_resolver/algorithms/heuristic/heuristic_parameters.dart';

class SimulatedAnnealingParameters extends HeuristicParameters {
  final double coolingAlpha;
  final int numAttempts;
  final double initialTemperature;

  SimulatedAnnealingParameters({
    required super.elementsToFit,
    required super.containerWidth,
    required super.containerHeight,
    required this.coolingAlpha,
    required this.numAttempts,
    required this.initialTemperature,
  });
}
