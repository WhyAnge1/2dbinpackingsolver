import 'dart:math';

import 'package:bin_packing_problem_resolver/helpers/configuration.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/rectangle_entity.dart';

class Generator {
  static List<RectangleEntity> generateElementsToFit(int count, bool isRandom) {
    var elementsToFit = List<RectangleEntity>.empty(growable: true);

    if (isRandom) {
      if (count > 0) {
        elementsToFit = List.generate(count, (index) {
          var width = Random()
                  .nextInt(ConfigurationHolder.containerWidth.toInt() - 10) +
              10;
          var height = Random()
                  .nextInt(ConfigurationHolder.containerHeight.toInt() - 10) +
              10;

          return RectangleEntity(
              width: width.toDouble(),
              height: height.toDouble(),
              name: "R${index + 1}");
        });
      }
    } else {
      elementsToFit.add(RectangleEntity(width: 30, height: 40, name: "R1"));
      elementsToFit.add(RectangleEntity(width: 20, height: 60, name: "R2"));
      elementsToFit.add(RectangleEntity(width: 40, height: 20, name: "R3"));
      elementsToFit.add(RectangleEntity(width: 30, height: 30, name: "R4"));
      elementsToFit.add(RectangleEntity(width: 50, height: 10, name: "R5"));
      elementsToFit.add(RectangleEntity(width: 50, height: 90, name: "R6"));
      elementsToFit.add(RectangleEntity(width: 10, height: 30, name: "R7"));
      elementsToFit.add(RectangleEntity(width: 20, height: 30, name: "R8"));
      elementsToFit.add(RectangleEntity(width: 20, height: 80, name: "R9"));
      elementsToFit.add(RectangleEntity(width: 10, height: 40, name: "R10"));
      elementsToFit.add(RectangleEntity(width: 70, height: 20, name: "R11"));
      elementsToFit.add(RectangleEntity(width: 20, height: 20, name: "R12"));
      elementsToFit.add(RectangleEntity(width: 50, height: 60, name: "R13"));
      elementsToFit.add(RectangleEntity(width: 70, height: 10, name: "R14"));
      elementsToFit.add(RectangleEntity(width: 30, height: 30, name: "R15"));
    }

    return elementsToFit;
  }
}
