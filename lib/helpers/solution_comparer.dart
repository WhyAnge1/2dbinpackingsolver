import 'package:bin_packing_problem_resolver/models/entity/bin_packing/container_entity.dart';

class SolutionComparer {
  static bool isBetter(List<ContainerEntity> firstSolution,
      List<ContainerEntity> secondSolution) {
    return firstSolution.length == secondSolution.length
        ? _countSolutionScore(firstSolution) >
            _countSolutionScore(secondSolution)
        : firstSolution.length < secondSolution.length;
  }

  static double _countSolutionScore(List<ContainerEntity> solution) {
    var score = 0.0;

    for (int i = 0; i < solution.length; i++) {
      final filledPercentage =
          (solution[i].filledSquare / solution[i].square) * 100;

      score += filledPercentage * (solution.length - i);
    }

    return score;
  }
}
