import 'package:bin_packing_problem_resolver/algorithms/packing/bin_packing_algorithm.dart';
import 'package:bin_packing_problem_resolver/cubit/cubits/ant_colont_cubit.dart';
import 'package:bin_packing_problem_resolver/cubit/states/ant_colony_state.dart';
import 'package:bin_packing_problem_resolver/resources/app_colors.dart';
import 'package:bin_packing_problem_resolver/ui/cells/container_cell.dart';
import 'package:bin_packing_problem_resolver/ui/controls/info_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AntColonyPage extends StatefulWidget {
  const AntColonyPage({super.key});

  @override
  State<StatefulWidget> createState() => _AntColonyPageState();
}

class _AntColonyPageState extends State<AntColonyPage>
    with AutomaticKeepAliveClientMixin {
  final cubit = AntColonyCubit();
  final alphaTextEditingController = TextEditingController();
  final betaTextEditingController = TextEditingController();
  final gammaTextEditingController = TextEditingController();
  final evaporationRateTextEditingController = TextEditingController();
  final pheromoneStartValueTextEditingController = TextEditingController();
  final antColonySizeTextEditingController = TextEditingController();
  BinPackingAlgorithm? selectedPackingAlgorithm;
  bool shouldShowAlphaError = false;
  bool shouldShowBetaError = false;
  bool shouldShowGammaError = false;
  bool shouldShowEvaporationRateError = false;
  bool shouldShowPheromoneStartValueError = false;
  bool shouldShowAntColonySizeError = false;

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
                    "Ant colony algorithm",
                    style: TextStyle(
                      color: AppColors.labelColor,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  BlocBuilder<AntColonyCubit, AntColonyState>(
                    bloc: cubit,
                    buildWhen: (previous, current) =>
                        current is InitialAntColonyState ||
                        current is AlgorithmStoppedAntColonyState ||
                        current is AlgorithmStartedAntColonyState,
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
                        onPressed: state is AlgorithmStartedAntColonyState
                            ? _stopAlgorithm
                            : _runAlgorithm,
                        child: Text(
                          state is AlgorithmStartedAntColonyState
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
              BlocBuilder<AntColonyCubit, AntColonyState>(
                bloc: cubit,
                buildWhen: (previous, current) =>
                    current is ResultAntColonyState,
                builder: (context, state) {
                  return state is ResultAntColonyState
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
                                    icon: MdiIcons.packageVariantClosed,
                                    title: "Ants spawned",
                                    data: state.antsSpawned.toString(),
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

  Widget _buildContainersGridView(ResultAntColonyState state) {
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
                  "Alpha",
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
                        onChanged: _trySetAlpha,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          isDense: true,
                        ),
                        controller: alphaTextEditingController,
                      ),
                    ),
                    AnimatedScale(
                      scale: shouldShowAlphaError ? 1 : 0,
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
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Beta",
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
                        onChanged: _trySetBeta,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          isDense: true,
                        ),
                        controller: betaTextEditingController,
                      ),
                    ),
                    AnimatedScale(
                      scale: shouldShowBetaError ? 1 : 0,
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
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Gamma",
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
                        onChanged: _trySetGamma,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          isDense: true,
                        ),
                        controller: gammaTextEditingController,
                      ),
                    ),
                    AnimatedScale(
                      scale: shouldShowGammaError ? 1 : 0,
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
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Evaporation rate",
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
                        onChanged: _trySetEvaporationRate,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          isDense: true,
                        ),
                        controller: evaporationRateTextEditingController,
                      ),
                    ),
                    AnimatedScale(
                      scale: shouldShowEvaporationRateError ? 1 : 0,
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
                BlocConsumer<AntColonyCubit, AntColonyState>(
                  bloc: cubit,
                  listener: _algorithmConfigurationListener,
                  buildWhen: (previous, current) =>
                      current is InitialDataAntColonyState,
                  builder: (context, state) {
                    return state is InitialDataAntColonyState
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
                  height: 50,
                ),
                const Text(
                  "Ant colony size",
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
                        onChanged: _trySetAntColonySize,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          isDense: true,
                        ),
                        controller: antColonySizeTextEditingController,
                      ),
                    ),
                    AnimatedScale(
                      scale: shouldShowAntColonySizeError ? 1 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: Tooltip(
                        message:
                            "Value should ba a number and be in range [0, 999999]",
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
                  "Pheromone start value",
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
                        onChanged: _trySetPheromoneStartValue,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          isDense: true,
                        ),
                        controller: pheromoneStartValueTextEditingController,
                      ),
                    ),
                    AnimatedScale(
                      scale: shouldShowPheromoneStartValueError ? 1 : 0,
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _algorithmConfigurationListener(
      BuildContext context, AntColonyState state) {
    if (state is InitialDataAntColonyState) {
      alphaTextEditingController.text = state.alpha.toString();
      betaTextEditingController.text = state.beta.toString();
      gammaTextEditingController.text = state.gamma.toString();
      evaporationRateTextEditingController.text =
          state.evaporationRate.toString();
      pheromoneStartValueTextEditingController.text =
          state.pheromoneStartValue.toString();
      antColonySizeTextEditingController.text = state.antColonySize.toString();
    }
  }

  void _runAlgorithm() {
    cubit.runAlgorithm();
  }

  void _stopAlgorithm() {
    cubit.stopAlgorithm();
  }

  void _trySetAlpha(String newValue) {
    if (double.tryParse(newValue) != null) {
      final alpha = double.parse(newValue);
      if (alpha >= 0 && alpha <= double.maxFinite) {
        cubit.setAlpha(alpha);
        setState(() {
          shouldShowAlphaError = false;
        });
      } else {
        setState(() {
          shouldShowAlphaError = true;
        });
      }
    } else {
      setState(() {
        shouldShowAlphaError = true;
      });
    }
  }

  void _trySetBeta(String newValue) {
    if (double.tryParse(newValue) != null) {
      final beta = double.parse(newValue);
      if (beta >= 1 && beta <= double.maxFinite) {
        cubit.setBeta(beta);
        setState(() {
          shouldShowBetaError = false;
        });
      } else {
        setState(() {
          shouldShowBetaError = true;
        });
      }
    } else {
      setState(() {
        shouldShowBetaError = true;
      });
    }
  }

  void _trySetGamma(String newValue) {
    if (double.tryParse(newValue) != null) {
      final gamma = double.parse(newValue);
      if (gamma >= 1 && gamma <= double.maxFinite) {
        cubit.setGamma(gamma);
        setState(() {
          shouldShowGammaError = false;
        });
      } else {
        setState(() {
          shouldShowGammaError = true;
        });
      }
    } else {
      setState(() {
        shouldShowGammaError = true;
      });
    }
  }

  void _trySetEvaporationRate(String newValue) {
    if (double.tryParse(newValue) != null) {
      final evaporationRate = double.parse(newValue);
      if (evaporationRate >= 0 && evaporationRate <= 1) {
        cubit.setEvaporationRate(evaporationRate);
        setState(() {
          shouldShowEvaporationRateError = false;
        });
      } else {
        setState(() {
          shouldShowEvaporationRateError = true;
        });
      }
    } else {
      setState(() {
        shouldShowEvaporationRateError = true;
      });
    }
  }

  void _trySetPheromoneStartValue(String newValue) {
    if (double.tryParse(newValue) != null) {
      final pheromoneStartValue = double.parse(newValue);
      if (pheromoneStartValue >= 0 && pheromoneStartValue <= 1) {
        cubit.setPheromoneStartValue(pheromoneStartValue);
        setState(() {
          shouldShowPheromoneStartValueError = false;
        });
      } else {
        setState(() {
          shouldShowPheromoneStartValueError = true;
        });
      }
    } else {
      setState(() {
        shouldShowPheromoneStartValueError = true;
      });
    }
  }

  void _trySetAntColonySize(String newValue) {
    if (int.tryParse(newValue) != null) {
      final antColonySize = int.parse(newValue);
      if (antColonySize >= 0 && antColonySize <= 999999) {
        cubit.setAntColonySize(antColonySize);
        setState(() {
          shouldShowAntColonySizeError = false;
        });
      } else {
        setState(() {
          shouldShowAntColonySizeError = true;
        });
      }
    } else {
      setState(() {
        shouldShowAntColonySizeError = true;
      });
    }
  }
}
