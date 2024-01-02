import 'package:bin_packing_problem_resolver/models/entity/bin_packing/rectangle_entity.dart';

class ConfigurationHolder {
  static double containerHeight = 100;
  static double containerWidth = 80;
  static int generateRectanglesCount = 10;
  static bool shouldUseRandomGeneration = false;
  static List<RectangleEntity> generatedRectangles = List.empty(growable: true);
}
