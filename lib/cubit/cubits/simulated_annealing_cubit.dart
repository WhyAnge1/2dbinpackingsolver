import 'package:bin_packing_problem_resolver/algorithms/find_neighbours/swap/swap_algorithm_fixed.dart';
import 'package:bin_packing_problem_resolver/algorithms/heuristic/simulated_annealing/simulated_annaling_parameters.dart';
import 'package:bin_packing_problem_resolver/algorithms/heuristic/simulated_annealing/simulated_annealing_algorithm.dart';
import 'package:bin_packing_problem_resolver/algorithms/heuristic/simulated_annealing/simulated_annealing_result.dart';
import 'package:bin_packing_problem_resolver/algorithms/packing/bin_packing_algorithm.dart';
import 'package:bin_packing_problem_resolver/algorithms/packing/next_fit.dart';
import 'package:bin_packing_problem_resolver/algorithms/packing/first_fit.dart';
import 'package:bin_packing_problem_resolver/cubit/states/simulated_annealing_state.dart';
import 'package:bin_packing_problem_resolver/helpers/configuration.dart';
import 'package:bin_packing_problem_resolver/models/entity/history/simulated_annealing_history.dart';
import 'package:bin_packing_problem_resolver/services/storage/algorithm_history_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimulatedAnnealingCubit extends Cubit<SimulatedAnnealingState> {
  final _algorithmHistoryStorage = AlgorithmHistoryStorage();
  late SimulatedAnnealingAlgorithm _simulatedAnnealingAlgorithm;
  late BinPackingAlgorithm _packingAlgorithm;
  var _coolingAlpha = 0.99;
  var _numAttempts = 20;
  var _initialTemperature = 0.01;
  SimulatedAnnealingParameters? _lastRunParameters;
  SimulatedAnnealingResult? _lastResult;
  DateTime? _algorithmStartTime;

  BinPackingAlgorithm get _selectedPackingAlgorithm => _packingAlgorithm;
  set _selectedPackingAlgorithm(BinPackingAlgorithm algorithm) {
    _packingAlgorithm = algorithm;

    _simulatedAnnealingAlgorithm.packingAlgorithm = algorithm;
  }

  SimulatedAnnealingCubit() : super(InitialSimulatedAnnealingState()) {
    final packingAlgorithms = _createPackingAlgorithms();

    _simulatedAnnealingAlgorithm =
        SimulatedAnnealingAlgorithm(packingAlgorithms.values.first);

    _selectedPackingAlgorithm = packingAlgorithms.values.first;

    Future.delayed(const Duration(milliseconds: 100)).then((value) => emit(
        InitialDataSimulatedAnnealingState(
            packingAlgorithms: packingAlgorithms,
            coolingAlpha: _coolingAlpha,
            numAttempts: _numAttempts,
            initialTemperature: _initialTemperature)));
  }

  void runAlgorithm() async {
    if (ConfigurationHolder.generatedRectangles.isNotEmpty) {
      var parameters = SimulatedAnnealingParameters(
          elementsToFit: ConfigurationHolder.generatedRectangles,
          containerHeight: ConfigurationHolder.containerHeight,
          containerWidth: ConfigurationHolder.containerWidth,
          coolingAlpha: _coolingAlpha,
          numAttempts: _numAttempts,
          initialTemperature: _initialTemperature);

      var stream = await _simulatedAnnealingAlgorithm.execute(parameters);

      _lastRunParameters = parameters;
      _algorithmStartTime = DateTime.now();

      stream.listen(
        (event) {
          emit(ResultSimulatedAnnealingState(
              algorithmResult: event.solution,
              temperature: event.temperature,
              tryValue: event.tryValue,
              maxContainerHeight: ConfigurationHolder.containerHeight,
              isDone: false,
              startTime: _algorithmStartTime!));

          _lastResult = event;
        },
        onDone: () {
          var algorithmFinishTime = DateTime.now();

          emit(ResultSimulatedAnnealingState(
              algorithmResult: _lastResult!.solution,
              temperature: _lastResult!.temperature,
              tryValue: _lastResult!.tryValue,
              maxContainerHeight: ConfigurationHolder.containerHeight,
              isDone: true,
              startTime: _algorithmStartTime!,
              finishTime: algorithmFinishTime));

          emit(AlgorithmStoppedSimulatedAnnealingState());

          _algorithmHistoryStorage.saveAlgorithm(
              SimulatedAnnealingHistoryEntity(
                  startTime: _algorithmStartTime!,
                  finishTime: algorithmFinishTime,
                  heuristicAlgorithm: _simulatedAnnealingAlgorithm,
                  binPackingAlgorithm: _packingAlgorithm,
                  findNeighboursAlgorithm: SwapAlgorithmFixed(),
                  result: _lastResult,
                  parameters: _lastRunParameters!));

          _lastResult = null;
          _lastRunParameters = null;
        },
      );

      emit(AlgorithmStartedSimulatedAnnealingState());
    }
  }

  void stopAlgorithm() {
    _simulatedAnnealingAlgorithm.stop();
  }

  void setPackingAlgorithm(BinPackingAlgorithm selectedAlgorithm) {
    _selectedPackingAlgorithm = selectedAlgorithm;
  }

  Map<String, BinPackingAlgorithm> _createPackingAlgorithms() {
    var greedyPlus = FirstFitAlgorithm();
    var greedy = NextFitAlgorithm();
    final packingAlgorithms = {
      greedyPlus.name: greedyPlus,
      greedy.name: greedy,
    };

    return packingAlgorithms;
  }

  void setCoolingAlpha(double coolingAlpha) {
    _coolingAlpha = coolingAlpha;
  }

  void setNumAttempts(int numAttempts) {
    _numAttempts = numAttempts;
  }

  void setInitialTemperature(double initialTemperature) {
    _initialTemperature = initialTemperature;
  }
}
