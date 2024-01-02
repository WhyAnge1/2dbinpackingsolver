import 'package:bin_packing_problem_resolver/algorithms/find_neighbours/find_neighbours_algorithm.dart';
import 'package:bin_packing_problem_resolver/algorithms/heuristic/heuristic_algorithm.dart';
import 'package:bin_packing_problem_resolver/algorithms/packing/bin_packing_algorithm.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/container_entity.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/rectangle_entity.dart';

abstract class MainState {}

class InitialMainState extends MainState {
  final Map<String, FindNeighboursAlgorithm> neighboursAlgorithms;
  final Map<String, BinPackingAlgorithm> packingAlgorithms;
  final Map<String, HeuristicAlgorithm> heuristicAlgorithms;

  InitialMainState(
      {required this.neighboursAlgorithms,
      required this.packingAlgorithms,
      required this.heuristicAlgorithms});
}

class AlgorithmResultMainState extends MainState {
  final List<ContainerEntity> algorithmResult;
  final double maxContainerHeight;
  final bool isDone;

  AlgorithmResultMainState(
      {required this.algorithmResult,
      required this.maxContainerHeight,
      required this.isDone});
}

class GeneratedRectanglesMainState extends MainState {
  final List<RectangleEntity> rectangles;
  final double teoreticalBestSolution;
  final double maxContainerHeight;

  GeneratedRectanglesMainState(
      {required this.rectangles,
      required this.teoreticalBestSolution,
      required this.maxContainerHeight});
}
