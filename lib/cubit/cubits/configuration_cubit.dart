import 'package:bin_packing_problem_resolver/cubit/states/configuration_state.dart';
import 'package:bin_packing_problem_resolver/helpers/configuration.dart';
import 'package:bin_packing_problem_resolver/helpers/generator.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/rectangle_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfigurationCubit extends Cubit<ConfigurationState> {
  ConfigurationCubit() : super(InitialConfigurationState());

  Future requestConfigurationRefresh() async {
    await Future.delayed(Duration(milliseconds: 100), () {
      emit(DataChangedConfigurationState(
          containerHeight: ConfigurationHolder.containerHeight,
          containerWidth: ConfigurationHolder.containerWidth,
          shouldUseRandomGeneration:
              ConfigurationHolder.shouldUseRandomGeneration));
    }).then((value) {
      if (ConfigurationHolder.generatedRectangles.isNotEmpty) {
        var rectangleMaxHeight = ConfigurationHolder.generatedRectangles
            .reduce((value, element) =>
                value.height > element.height ? value : element)
            .height;

        emit(GeneratedRectanglesConfigurationState(
            rectangles: ConfigurationHolder.generatedRectangles,
            rectangleMaxHeight: rectangleMaxHeight));
      }
    });
  }

  Future generateRectangles() async {
    var rectangles = Generator.generateElementsToFit(
        ConfigurationHolder.generateRectanglesCount,
        ConfigurationHolder.shouldUseRandomGeneration);

    if (rectangles.isNotEmpty) {
      ConfigurationHolder.generatedRectangles = rectangles;
      var rectangleMaxHeight = ConfigurationHolder.generatedRectangles
          .reduce((value, element) =>
              value.height > element.height ? value : element)
          .height;

      emit(GeneratedRectanglesConfigurationState(
          rectangles: rectangles, rectangleMaxHeight: rectangleMaxHeight));
    }
  }

  void setContainerHeight(double newHeight) {
    ConfigurationHolder.containerHeight = newHeight;

    emit(DataChangedConfigurationState(
        containerHeight: ConfigurationHolder.containerHeight,
        containerWidth: ConfigurationHolder.containerWidth,
        shouldUseRandomGeneration:
            ConfigurationHolder.shouldUseRandomGeneration));
  }

  void setContainerWidth(double newWidth) {
    ConfigurationHolder.containerWidth = newWidth;

    emit(DataChangedConfigurationState(
        containerHeight: ConfigurationHolder.containerHeight,
        containerWidth: ConfigurationHolder.containerWidth,
        shouldUseRandomGeneration:
            ConfigurationHolder.shouldUseRandomGeneration));
  }

  void setShouldUseRandomGeneration(bool shouldUseRandomGeneration) {
    ConfigurationHolder.shouldUseRandomGeneration = shouldUseRandomGeneration;

    emit(DataChangedConfigurationState(
        containerHeight: ConfigurationHolder.containerHeight,
        containerWidth: ConfigurationHolder.containerWidth,
        shouldUseRandomGeneration:
            ConfigurationHolder.shouldUseRandomGeneration));
  }

  void setGenerateRectanglesCount(int newGenerateRectanglesCount) {
    ConfigurationHolder.generateRectanglesCount = newGenerateRectanglesCount;
  }

  void addRectangle(String name, double width, double height) {
    ConfigurationHolder.generatedRectangles.add(RectangleEntity(
        width: width,
        height: height,
        name: name.isEmpty
            ? "R${ConfigurationHolder.generatedRectangles.length + 1}"
            : name));

    var rectangleMaxHeight = ConfigurationHolder.generatedRectangles
        .reduce(
            (value, element) => value.height > element.height ? value : element)
        .height;

    emit(GeneratedRectanglesConfigurationState(
        rectangles: ConfigurationHolder.generatedRectangles,
        rectangleMaxHeight: rectangleMaxHeight));
  }

  void removeRectangle(RectangleEntity rectangle) {
    ConfigurationHolder.generatedRectangles.remove(rectangle);

    var rectangleMaxHeight = ConfigurationHolder.generatedRectangles
        .reduce(
            (value, element) => value.height > element.height ? value : element)
        .height;

    emit(GeneratedRectanglesConfigurationState(
        rectangles: ConfigurationHolder.generatedRectangles,
        rectangleMaxHeight: rectangleMaxHeight));
  }
}
