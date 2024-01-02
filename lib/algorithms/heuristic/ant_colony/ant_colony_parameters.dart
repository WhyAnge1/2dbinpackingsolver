import 'package:bin_packing_problem_resolver/algorithms/heuristic/heuristic_parameters.dart';

class AntColonyParameters extends HeuristicParameters {
  final double alpha;
  final double beta;
  final double gamma;
  final double pheromoneStartValue;
  final int antColonySize;
  final double evaporationRate;

  AntColonyParameters({
    required super.elementsToFit,
    required super.containerWidth,
    required super.containerHeight,
    required this.alpha,
    required this.beta,
    required this.gamma,
    required this.pheromoneStartValue,
    required this.antColonySize,
    required this.evaporationRate,
  });
}
