import 'package:bin_packing_problem_resolver/algorithms/heuristic/heuristic_result.dart';

class HillClimbingResult extends HeuristicResult {
  final int neighborsCount;

  HillClimbingResult({
    required super.solution,
    required this.neighborsCount,
  });
}
