import 'package:bin_packing_problem_resolver/algorithms/packing/bin_packing_algorithm.dart';
import 'package:bin_packing_problem_resolver/cubit/cubits/simulated_annealing_cubit.dart';
import 'package:bin_packing_problem_resolver/cubit/states/simulated_annealing_state.dart';
import 'package:bin_packing_problem_resolver/resources/app_colors.dart';
import 'package:bin_packing_problem_resolver/ui/cells/container_cell.dart';
import 'package:bin_packing_problem_resolver/ui/controls/info_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SimulatedAnnealingPage extends StatefulWidget {
  const SimulatedAnnealingPage({super.key});

  @override
  State<StatefulWidget> createState() => _SimulatedAnnealingPageState();
}

class _SimulatedAnnealingPageState extends State<SimulatedAnnealingPage>
    with AutomaticKeepAliveClientMixin {
  final coolingAlphaTextEditingController = TextEditingController();
  final numAttemptsTextEditingController = TextEditingController();
  final initialTemperatureTextEditingController = TextEditingController();
  final cubit = SimulatedAnnealingCubit();
  BinPackingAlgorithm? selectedPackingAlgorithm;
  bool shouldShowCoolingAlphaError = false;
  bool shouldShowNumAttemptsError = false;
  bool shouldShowInitialTemperatureError = false;

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
                    "Simulated annealing algorithm",
                    style: TextStyle(
                      color: AppColors.labelColor,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  BlocBuilder<SimulatedAnnealingCubit, SimulatedAnnealingState>(
                    bloc: cubit,
                    buildWhen: (previous, current) =>
                        current is InitialSimulatedAnnealingState ||
                        current is AlgorithmStoppedSimulatedAnnealingState ||
                        current is AlgorithmStartedSimulatedAnnealingState,
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
                        onPressed:
                            state is AlgorithmStartedSimulatedAnnealingState
                                ? _stopAlgorithm
                                : _runAlgorithm,
                        child: Text(
                          state is AlgorithmStartedSimulatedAnnealingState
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
              _buildAlgorithmConfiguration(),
              const SizedBox(
                height: 40,
              ),
              BlocBuilder<SimulatedAnnealingCubit, SimulatedAnnealingState>(
                bloc: cubit,
                buildWhen: (previous, current) =>
                    current is ResultSimulatedAnnealingState,
                builder: (context, state) {
                  return state is ResultSimulatedAnnealingState
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
                                    icon: MdiIcons.fire,
                                    title: "Temperature was",
                                    data: state.temperature.toString(),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InfoContainer(
                                    icon: MdiIcons.function,
                                    title: "Try function value found",
                                    data: state.tryValue.toString(),
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

  Widget _buildContainersGridView(ResultSimulatedAnnealingState state) {
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

  Widget _buildAlgorithmConfiguration() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Cooling alpha",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppColors.labelGrayTitleColor,
                    fontSize: 15,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: _trySetCoolingAlpha,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          isDense: true,
                        ),
                        controller: coolingAlphaTextEditingController,
                      ),
                    ),
                    AnimatedScale(
                      scale: shouldShowCoolingAlphaError ? 1 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: Tooltip(
                        message:
                            "Value should ba a number and be in range [0, 1]",
                        child: Icon(
                          MdiIcons.alertCircle,
                          color: Color.fromARGB(255, 195, 91, 87),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  "Try function number of attempts",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppColors.labelGrayTitleColor,
                    fontSize: 15,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: _trySetNumAttempts,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          isDense: true,
                        ),
                        controller: numAttemptsTextEditingController,
                      ),
                    ),
                    AnimatedScale(
                      scale: shouldShowNumAttemptsError ? 1 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: Tooltip(
                        message:
                            "Value should ba a number and be in range [1, 999]",
                        child: Icon(
                          MdiIcons.alertCircle,
                          color: Color.fromARGB(255, 195, 91, 87),
                        ),
                      ),
                    ),
                  ],
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
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
                BlocConsumer<SimulatedAnnealingCubit, SimulatedAnnealingState>(
                  bloc: cubit,
                  listener: _algorithmConfigurationListener,
                  buildWhen: (previous, current) =>
                      current is InitialDataSimulatedAnnealingState,
                  builder: (context, state) {
                    return state is InitialDataSimulatedAnnealingState
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
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "Initial temperature",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppColors.labelGrayTitleColor,
                    fontSize: 15,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: _trySetInitialTemperature,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          isDense: true,
                        ),
                        controller: initialTemperatureTextEditingController,
                      ),
                    ),
                    AnimatedScale(
                      scale: shouldShowInitialTemperatureError ? 1 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: Tooltip(
                        message:
                            "Value should ba a number and be in range [0, max double]",
                        child: Icon(
                          MdiIcons.alertCircle,
                          color: Color.fromARGB(255, 195, 91, 87),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _trySetCoolingAlpha(String newValue) {
    if (double.tryParse(newValue) != null) {
      final coolingAlpha = double.parse(newValue);
      if (coolingAlpha >= 0 && coolingAlpha <= 1) {
        cubit.setCoolingAlpha(coolingAlpha);
        setState(() {
          shouldShowCoolingAlphaError = false;
        });
      } else {
        setState(() {
          shouldShowCoolingAlphaError = true;
        });
      }
    } else {
      setState(() {
        shouldShowCoolingAlphaError = true;
      });
    }
  }

  void _trySetNumAttempts(String newValue) {
    if (int.tryParse(newValue) != null) {
      final numAttempts = int.parse(newValue);
      if (numAttempts >= 1 && numAttempts <= 999) {
        cubit.setNumAttempts(numAttempts);
        setState(() {
          shouldShowNumAttemptsError = false;
        });
      } else {
        setState(() {
          shouldShowNumAttemptsError = true;
        });
      }
    } else {
      setState(() {
        shouldShowNumAttemptsError = true;
      });
    }
  }

  void _trySetInitialTemperature(String newValue) {
    if (double.tryParse(newValue) != null) {
      final initialTemperature = double.parse(newValue);
      if (initialTemperature >= 0 && initialTemperature <= double.maxFinite) {
        cubit.setInitialTemperature(initialTemperature);
        setState(() {
          shouldShowInitialTemperatureError = false;
        });
      } else {
        setState(() {
          shouldShowInitialTemperatureError = true;
        });
      }
    } else {
      setState(() {
        shouldShowInitialTemperatureError = true;
      });
    }
  }

  void _algorithmConfigurationListener(
      BuildContext context, SimulatedAnnealingState state) {
    if (state is InitialDataSimulatedAnnealingState) {
      coolingAlphaTextEditingController.text = state.coolingAlpha.toString();
      numAttemptsTextEditingController.text = state.numAttempts.toString();
      initialTemperatureTextEditingController.text =
          state.initialTemperature.toString();
    }
  }

  void _runAlgorithm() {
    if (!shouldShowCoolingAlphaError && !shouldShowNumAttemptsError) {
      cubit.runAlgorithm();
    }
  }

  void _stopAlgorithm() {
    cubit.stopAlgorithm();
  }
}
