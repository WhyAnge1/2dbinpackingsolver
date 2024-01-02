import 'package:bin_packing_problem_resolver/models/entity/bin_packing/container_entity.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/rectangle_entity.dart';
import 'package:bin_packing_problem_resolver/models/entity/history/algorithm_history_entity.dart';
import 'package:bin_packing_problem_resolver/models/entity/history/ant_colony_history_entity.dart';
import 'package:bin_packing_problem_resolver/models/entity/history/hill_climbing_history_entity.dart';
import 'package:bin_packing_problem_resolver/models/entity/history/simulated_annealing_history.dart';
import 'package:bin_packing_problem_resolver/resources/app_colors.dart';
import 'package:bin_packing_problem_resolver/ui/cells/container_cell.dart';
import 'package:bin_packing_problem_resolver/ui/controls/generated_rectangle.dart';
import 'package:bin_packing_problem_resolver/ui/controls/info_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HistoryCell extends StatelessWidget {
  final AlgorithmHistoryEntity model;
  final int index;

  const HistoryCell({required this.model, required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$index. ${model.heuristicAlgorithm.name}",
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: AppColors.labelColor,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          _selectCorrectInfoBuilder(),
        ],
      ),
    );
  }

  Widget _selectCorrectInfoBuilder() {
    switch (model.heuristicAlgorithm.name) {
      case "Hill climbing":
        return _constructHillClimbingInfo(model as HillClimbingHistoryEntity);
      case "Simulated annealing":
        return _constructSimulatedAnnealingInfo(
            model as SimulatedAnnealingHistoryEntity);
      case "Ant colony":
        return _constructAntColonyInfo(model as AntColonyHistoryEntity);
      default:
        return Container();
    }
  }

  Widget _constructSimulatedAnnealingInfo(
      SimulatedAnnealingHistoryEntity simulatedAnnealingModel) {
    return Column(
      children: [
        Row(
          children: [
            InfoContainer(
              icon: MdiIcons.clockStart,
              title: "Time started",
              data: DateFormat('dd-MM-yy H:m:s')
                  .format(simulatedAnnealingModel.startTime),
            ),
            const SizedBox(
              width: 10,
            ),
            InfoContainer(
              icon: MdiIcons.clockEnd,
              title: "Time finished",
              data: DateFormat('dd-MM-yy H:m:s')
                  .format(simulatedAnnealingModel.finishTime),
            ),
            const SizedBox(
              width: 10,
            ),
            InfoContainer(
              icon: MdiIcons.clockFast,
              title: "Run durationd",
              data:
                  "${model.finishTime.difference(simulatedAnnealingModel.startTime).inMilliseconds} milliseconds",
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            InfoContainer(
              icon: MdiIcons.squareOutline,
              title: "Rectangles packed",
              data: simulatedAnnealingModel.parameters.elementsToFit.length
                  .toString(),
            ),
            const SizedBox(
              width: 10,
            ),
            InfoContainer(
              icon: MdiIcons.arrowUpDown,
              title: "Container height",
              data:
                  simulatedAnnealingModel.parameters.containerHeight.toString(),
            ),
            const SizedBox(
              width: 10,
            ),
            InfoContainer(
              icon: MdiIcons.arrowLeftRight,
              title: "Container width",
              data:
                  simulatedAnnealingModel.parameters.containerWidth.toString(),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            InfoContainer(
              icon: MdiIcons.cubeScan,
              title: "Bin packing algorithm used",
              data: simulatedAnnealingModel.binPackingAlgorithm.name,
            ),
            const SizedBox(
              width: 10,
            ),
            InfoContainer(
              icon: MdiIcons.magnifyScan,
              title: "Find neighbours algorithm used",
              data: simulatedAnnealingModel.findNeighboursAlgorithm?.name ??
                  "None",
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            InfoContainer(
              icon: MdiIcons.snowflakeThermometer,
              title: "Colling alpha set",
              data: simulatedAnnealingModel.parameters.coolingAlpha.toString(),
            ),
            const SizedBox(
              width: 10,
            ),
            InfoContainer(
              icon: MdiIcons.temperatureCelsius,
              title: "Initial temperature set",
              data: simulatedAnnealingModel.parameters.initialTemperature
                  .toString(),
            ),
            const SizedBox(
              width: 10,
            ),
            InfoContainer(
              icon: MdiIcons.numeric,
              title: "Number of Try function attempts set",
              data: simulatedAnnealingModel.parameters.numAttempts.toString(),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        if (simulatedAnnealingModel.result != null)
          Row(
            children: [
              InfoContainer(
                icon: MdiIcons.packageVariantClosed,
                title: "Containers used",
                data:
                    simulatedAnnealingModel.result!.solution.length.toString(),
              ),
              const SizedBox(
                width: 10,
              ),
              InfoContainer(
                icon: MdiIcons.fire,
                title: "Temperature was",
                data: simulatedAnnealingModel.result!.temperature.toString(),
              ),
              const SizedBox(
                width: 10,
              ),
              InfoContainer(
                icon: MdiIcons.function,
                title: "Try function value found",
                data: simulatedAnnealingModel.result!.tryValue.toString(),
              ),
            ],
          ),
        const SizedBox(
          height: 30,
        ),
        _constructRectanglesList(
            simulatedAnnealingModel.parameters.elementsToFit,
            simulatedAnnealingModel.parameters.containerHeight),
        const SizedBox(
          height: 30,
        ),
        if (simulatedAnnealingModel.result != null)
          _constructSolution(simulatedAnnealingModel.result!.solution,
              simulatedAnnealingModel.parameters.containerHeight),
      ],
    );
  }

  Widget _constructHillClimbingInfo(
      HillClimbingHistoryEntity hillClimbingModel) {
    return Column(
      children: [
        Row(
          children: [
            InfoContainer(
              icon: MdiIcons.clockStart,
              title: "Time started",
              data: DateFormat('dd-MM-yy H:m:s')
                  .format(hillClimbingModel.startTime),
            ),
            const SizedBox(
              width: 10,
            ),
            InfoContainer(
              icon: MdiIcons.clockEnd,
              title: "Time finished",
              data: DateFormat('dd-MM-yy H:m:s')
                  .format(hillClimbingModel.finishTime),
            ),
            const SizedBox(
              width: 10,
            ),
            InfoContainer(
              icon: MdiIcons.clockFast,
              title: "Run durationd",
              data:
                  "${model.finishTime.difference(hillClimbingModel.startTime).inMilliseconds} milliseconds",
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            InfoContainer(
              icon: MdiIcons.squareOutline,
              title: "Rectangles packed",
              data:
                  hillClimbingModel.parameters.elementsToFit.length.toString(),
            ),
            const SizedBox(
              width: 10,
            ),
            InfoContainer(
              icon: MdiIcons.arrowUpDown,
              title: "Container height",
              data: hillClimbingModel.parameters.containerHeight.toString(),
            ),
            const SizedBox(
              width: 10,
            ),
            InfoContainer(
              icon: MdiIcons.arrowLeftRight,
              title: "Container width",
              data: hillClimbingModel.parameters.containerWidth.toString(),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            InfoContainer(
              icon: MdiIcons.cubeScan,
              title: "Bin packing algorithm used",
              data: hillClimbingModel.binPackingAlgorithm.name,
            ),
            const SizedBox(
              width: 10,
            ),
            InfoContainer(
              icon: MdiIcons.magnifyScan,
              title: "Find neighbours algorithm used",
              data: hillClimbingModel.findNeighboursAlgorithm?.name ?? "None",
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        if (hillClimbingModel.result != null)
          Row(
            children: [
              InfoContainer(
                icon: MdiIcons.homeGroup,
                title: "Neighbours found",
                data: hillClimbingModel.result!.neighborsCount.toString(),
              ),
              const SizedBox(
                width: 10,
              ),
              InfoContainer(
                icon: MdiIcons.packageVariantClosed,
                title: "Containers used",
                data: hillClimbingModel.result!.solution.length.toString(),
              ),
            ],
          ),
        const SizedBox(
          height: 30,
        ),
        _constructRectanglesList(hillClimbingModel.parameters.elementsToFit,
            hillClimbingModel.parameters.containerHeight),
        const SizedBox(
          height: 30,
        ),
        if (hillClimbingModel.result != null)
          _constructSolution(hillClimbingModel.result!.solution,
              hillClimbingModel.parameters.containerHeight),
      ],
    );
  }

  Widget _constructAntColonyInfo(AntColonyHistoryEntity antColonyModel) {
    return Column(
      children: [
        Row(
          children: [
            InfoContainer(
              icon: MdiIcons.clockStart,
              title: "Time started",
              data:
                  DateFormat('dd-MM-yy H:m:s').format(antColonyModel.startTime),
            ),
            const SizedBox(
              width: 10,
            ),
            InfoContainer(
              icon: MdiIcons.clockEnd,
              title: "Time finished",
              data: DateFormat('dd-MM-yy H:m:s')
                  .format(antColonyModel.finishTime),
            ),
            const SizedBox(
              width: 10,
            ),
            InfoContainer(
              icon: MdiIcons.clockFast,
              title: "Run durationd",
              data:
                  "${model.finishTime.difference(antColonyModel.startTime).inMilliseconds} milliseconds",
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            InfoContainer(
              icon: MdiIcons.squareOutline,
              title: "Rectangles packed",
              data: antColonyModel.parameters.elementsToFit.length.toString(),
            ),
            const SizedBox(
              width: 10,
            ),
            InfoContainer(
              icon: MdiIcons.arrowUpDown,
              title: "Container height",
              data: antColonyModel.parameters.containerHeight.toString(),
            ),
            const SizedBox(
              width: 10,
            ),
            InfoContainer(
              icon: MdiIcons.arrowLeftRight,
              title: "Container width",
              data: antColonyModel.parameters.containerWidth.toString(),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            InfoContainer(
              icon: MdiIcons.cubeScan,
              title: "Bin packing algorithm used",
              data: antColonyModel.binPackingAlgorithm.name,
            ),
            const SizedBox(
              width: 10,
            ),
            InfoContainer(
              icon: MdiIcons.magnifyScan,
              title: "Find neighbours algorithm used",
              data: antColonyModel.findNeighboursAlgorithm?.name ?? "None",
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            InfoContainer(
              icon: MdiIcons.alpha,
              title: "Alpha set",
              data: antColonyModel.parameters.alpha.toString(),
            ),
            const SizedBox(
              width: 10,
            ),
            InfoContainer(
              icon: MdiIcons.beta,
              title: "Beta set",
              data: antColonyModel.parameters.beta.toString(),
            ),
            const SizedBox(
              width: 10,
            ),
            InfoContainer(
              icon: MdiIcons.gamma,
              title: "Gamma set",
              data: antColonyModel.parameters.gamma.toString(),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            InfoContainer(
              icon: MdiIcons.wavesArrowUp,
              title: "Evaporation rate set",
              data: antColonyModel.parameters.evaporationRate.toString(),
            ),
            const SizedBox(
              width: 10,
            ),
            InfoContainer(
              icon: MdiIcons.dotsTriangle,
              title: "Ant colony size set",
              data: antColonyModel.parameters.antColonySize.toString(),
            ),
            const SizedBox(
              width: 10,
            ),
            InfoContainer(
              icon: MdiIcons.scent,
              title: "Pheromone start value set",
              data: antColonyModel.parameters.pheromoneStartValue.toString(),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        if (antColonyModel.result != null)
          Row(
            children: [
              InfoContainer(
                icon: MdiIcons.packageVariantClosed,
                title: "Containers used",
                data: antColonyModel.result!.solution.length.toString(),
              ),
            ],
          ),
        const SizedBox(
          height: 30,
        ),
        _constructRectanglesList(antColonyModel.parameters.elementsToFit,
            antColonyModel.parameters.containerHeight),
        const SizedBox(
          height: 30,
        ),
        if (antColonyModel.result != null)
          _constructSolution(antColonyModel.result!.solution,
              antColonyModel.parameters.containerHeight),
      ],
    );
  }

  Widget _constructSolution(List<ContainerEntity> solution, double maxHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Solution",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: AppColors.labelGrayTitleColor,
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: maxHeight,
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              width: 10,
            ),
            itemCount: solution.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Tooltip(
                message:
                    "Container: ${solution[index].name}\nFilled: ${solution[index].filledPercent}%\nElements placed: ${solution[index].placedChildren.length}\nSquare free: ${solution[index].freeSquare} \nSquare filled: ${solution[index].filledSquare}\nSquare total: ${solution[index].square}",
                child: ContainerCell(
                  model: solution[index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _constructRectanglesList(
      List<RectangleEntity> rectangles, double maxHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Rectangles",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: AppColors.labelGrayTitleColor,
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: maxHeight,
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              width: 10,
            ),
            itemCount: rectangles.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GeneratedRectangle(
                rectangleName: rectangles[index].name,
                rectangleHeight: rectangles[index].height.toDouble(),
                rectangleWidth: rectangles[index].width.toDouble(),
                maxHeight: maxHeight,
              );
            },
          ),
        ),
      ],
    );
  }
}
