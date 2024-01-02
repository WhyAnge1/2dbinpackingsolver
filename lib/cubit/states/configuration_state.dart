import 'package:bin_packing_problem_resolver/models/entity/bin_packing/rectangle_entity.dart';

abstract class ConfigurationState {}

class InitialConfigurationState extends ConfigurationState {
  InitialConfigurationState();
}

class DataChangedConfigurationState extends ConfigurationState {
  final double containerWidth;
  final double containerHeight;
  final bool shouldUseRandomGeneration;

  DataChangedConfigurationState(
      {required this.containerWidth,
      required this.containerHeight,
      required this.shouldUseRandomGeneration});
}

class GeneratedRectanglesConfigurationState extends ConfigurationState {
  final double rectangleMaxHeight;
  final List<RectangleEntity> rectangles;

  GeneratedRectanglesConfigurationState(
      {required this.rectangles, required this.rectangleMaxHeight});
}
