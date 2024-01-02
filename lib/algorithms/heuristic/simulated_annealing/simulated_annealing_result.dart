import 'package:bin_packing_problem_resolver/algorithms/heuristic/heuristic_result.dart';

class SimulatedAnnealingResult extends HeuristicResult {
  final double temperature;
  final double tryValue;

  SimulatedAnnealingResult(
      {required super.solution,
      required this.temperature,
      required this.tryValue});
}
