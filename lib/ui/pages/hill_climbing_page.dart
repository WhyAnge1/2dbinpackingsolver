import 'package:bin_packing_problem_resolver/algorithms/find_neighbours/find_neighbours_algorithm.dart';
import 'package:bin_packing_problem_resolver/algorithms/packing/bin_packing_algorithm.dart';
import 'package:bin_packing_problem_resolver/cubit/cubits/hill_climbing_cubit.dart';
import 'package:bin_packing_problem_resolver/cubit/states/hill_climbing_state.dart';
import 'package:bin_packing_problem_resolver/resources/app_colors.dart';
import 'package:bin_packing_problem_resolver/ui/cells/container_cell.dart';
import 'package:bin_packing_problem_resolver/ui/controls/info_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HillClimbingPage extends StatefulWidget {
  const HillClimbingPage({super.key});

  @override
  State<StatefulWidget> createState() => _HillClimbingPageState();
}

class _HillClimbingPageState extends State<HillClimbingPage>
    with AutomaticKeepAliveClientMixin {
  final cubit = HillClimbingCubit();
  FindNeighboursAlgorithm? selectedNeighbourAlgorithm;
  BinPackingAlgorithm? selectedPackingAlgorithm;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Hill Climbing algorithm",
                    style: TextStyle(
                      color: AppColors.labelColor,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  BlocBuilder<HillClimbingCubit, HillClimbingState>(
                    bloc: cubit,
                    buildWhen: (previous, current) =>
                        current is InitialHillClimbingState ||
                        current is AlgorithmStoppedHillClimbingState ||
                        current is AlgorithmStartedHillClimbingState,
                    builder: (context, state) {
                      return TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 25),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 33, 32, 42),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: state is AlgorithmStartedHillClimbingState
                            ? _stopAlgorithm
                            : _runAlgorithm,
                        child: Text(
                          state is AlgorithmStartedHillClimbingState
                              ? "Stop algorithm"
                              : "Run algorithm",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Finding neighbors algorithm",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: AppColors.labelGrayTitleColor,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          BlocBuilder<HillClimbingCubit, HillClimbingState>(
                            bloc: cubit,
                            buildWhen: (previous, current) =>
                                current is InitialHillClimbingState,
                            builder: (context, state) {
                              return state is InitialHillClimbingState
                                  ? DropdownButton<FindNeighboursAlgorithm>(
                                      icon: Icon(MdiIcons.chevronDown),
                                      value: selectedNeighbourAlgorithm ??=
                                          state.neighboursAlgorithms.values
                                              .first,
                                      onChanged: (value) {
                                        cubit.setNeighboursAlgorithm(value!);
                                        setState(() {
                                          selectedNeighbourAlgorithm = value;
                                        });
                                      },
                                      isExpanded: true,
                                      isDense: true,
                                      items: state.neighboursAlgorithms.entries
                                          .map((e) => DropdownMenuItem(
                                                value: e.value,
                                                child: Text(e.key),
                                              ))
                                          .toList(),
                                      underline: Container(),
                                    )
                                  : Container();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Packing algorithm",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: AppColors.labelGrayTitleColor,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          BlocBuilder<HillClimbingCubit, HillClimbingState>(
                            bloc: cubit,
                            buildWhen: (previous, current) =>
                                current is InitialHillClimbingState,
                            builder: (context, state) {
                              return state is InitialHillClimbingState
                                  ? DropdownButton<BinPackingAlgorithm>(
                                      icon: Icon(MdiIcons.chevronDown),
                                      value: selectedPackingAlgorithm ??=
                                          state.packingAlgorithms.values.first,
                                      onChanged: (value) {
                                        cubit.setPackingAlgorithm(value!);
                                        setState(() {
                                          selectedPackingAlgorithm = value;
                                        });
                                      },
                                      isExpanded: true,
                                      isDense: true,
                                      items: state.packingAlgorithms.entries
                                          .map((e) => DropdownMenuItem(
                                                value: e.value,
                                                child: Text(e.key),
                                              ))
                                          .toList(),
                                      underline: Container(),
                                    )
                                  : Container();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              BlocBuilder<HillClimbingCubit, HillClimbingState>(
                bloc: cubit,
                buildWhen: (previous, current) =>
                    current is ResultHillClimbingState,
                builder: (context, state) {
                  return state is ResultHillClimbingState
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Solution",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: AppColors.labelColor,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  InfoContainer(
                                    icon: MdiIcons.clockStart,
                                    title: "Time started",
                                    data: DateFormat('dd-MM-yy H:m:s')
                                        .format(state.startTime),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InfoContainer(
                                    icon: MdiIcons.clockEnd,
                                    title: "Time finished",
                                    data: state.finishTime != null
                                        ? DateFormat('dd-MM-yy H:m:s')
                                            .format(state.finishTime!)
                                        : "In progress...",
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InfoContainer(
                                    icon: MdiIcons.clockFast,
                                    title: "Run durationd",
                                    data: state.finishTime != null
                                        ? "${state.finishTime!.difference(state.startTime).inMilliseconds} milliseconds"
                                        : "In progress...",
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                children: [
                                  InfoContainer(
                                    icon: MdiIcons.packageVariantClosed,
                                    title: "Containers used",
                                    data:
                                        state.algorithmResult.length.toString(),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InfoContainer(
                                    icon: MdiIcons.homeGroup,
                                    title: "Neighbours found",
                                    data: state.neighborsCount.toString(),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              _buildContainersGridView(state),
                            ],
                          ),
                        )
                      : Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContainersGridView(ResultHillClimbingState state) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: state.algorithmResult.map((container) {
        return IgnorePointer(
          ignoring: !state.isDone,
          child: Tooltip(
            message:
                "Container: ${container.name}\nFilled: ${container.filledPercent}%\nElements placed: ${container.placedChildren.length}\nSquare free: ${container.freeSquare} \nSquare filled: ${container.filledSquare}\nSquare total: ${container.square}",
            child: ContainerCell(
              model: container,
            ),
          ),
        );
      }).toList(),
    );
  }

  void _runAlgorithm() {
    cubit.runAlgorithm();
  }

  void _stopAlgorithm() {
    cubit.stopAlgorithm();
  }
}
