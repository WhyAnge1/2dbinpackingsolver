import 'package:bin_packing_problem_resolver/algorithms/heuristic/heuristic_result.dart';

class AntColonyResult extends HeuristicResult {
  final int antSpawned;

  AntColonyResult({required this.antSpawned, required super.solution});
}
