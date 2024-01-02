import 'package:bin_packing_problem_resolver/models/entity/bin_packing/rectangle_entity.dart';

class HeuristicParameters {
  final List<RectangleEntity> elementsToFit;
  final double containerWidth;
  final double containerHeight;

  HeuristicParameters(
      {required this.elementsToFit,
      required this.containerWidth,
      required this.containerHeight});
}
