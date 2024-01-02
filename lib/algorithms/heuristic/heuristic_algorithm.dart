import 'package:bin_packing_problem_resolver/algorithms/algorithm.dart';
import 'package:bin_packing_problem_resolver/algorithms/heuristic/heuristic_result.dart';

abstract class HeuristicAlgorithm<HeuristicParameters> implements Algorithm {
  Future<Stream<HeuristicResult>> execute(HeuristicParameters parameters);

  void stop();
}
