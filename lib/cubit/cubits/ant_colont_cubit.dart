import 'package:bin_packing_problem_resolver/algorithms/heuristic/ant_colony/ant_colony_algorithm.dart';
import 'package:bin_packing_problem_resolver/algorithms/heuristic/ant_colony/ant_colony_parameters.dart';
import 'package:bin_packing_problem_resolver/algorithms/heuristic/ant_colony/ant_colony_result.dart';
import 'package:bin_packing_problem_resolver/algorithms/packing/bin_packing_algorithm.dart';
import 'package:bin_packing_problem_resolver/algorithms/packing/next_fit.dart';
import 'package:bin_packing_problem_resolver/algorithms/packing/first_fit.dart';
import 'package:bin_packing_problem_resolver/cubit/states/ant_colony_state.dart';
import 'package:bin_packing_problem_resolver/helpers/configuration.dart';
import 'package:bin_packing_problem_resolver/models/entity/history/ant_colony_history_entity.dart';
import 'package:bin_packing_problem_resolver/services/storage/algorithm_history_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AntColonyCubit extends Cubit<AntColonyState> {
  final _algorithmHistoryStorage = AlgorithmHistoryStorage();
  late AntColonyAlgorithm _simulatedAnnealingAlgorithm;
  late BinPackingAlgorithm _packingAlgorithm;
  AntColonyParameters? _lastRunParameters;
  AntColonyResult? _lastResult;
  DateTime? _algorithmStartTime;
  double _alpha = 2;
  double _beta = 3;
  double _gamma = 3;
  double _pheromoneStartValue = 0.4;
  int _antColonySize = 100;
  double _evaporationRate = 0.1;

  BinPackingAlgorithm get _selectedPackingAlgorithm => _packingAlgorithm;
  set _selectedPackingAlgorithm(BinPackingAlgorithm algorithm) {
    _packingAlgorithm = algorithm;

    _simulatedAnnealingAlgorithm.binPackingAlgorithm = algorithm;
  }

  AntColonyCubit() : super(InitialAntColonyState()) {
    final packingAlgorithms = _createPackingAlgorithms();

    _simulatedAnnealingAlgorithm =
        AntColonyAlgorithm(packingAlgorithms.values.first);

    _selectedPackingAlgorithm = packingAlgorithms.values.first;

    Future.delayed(const Duration(milliseconds: 100)).then((value) => emit(
        InitialDataAntColonyState(
            packingAlgorithms: packingAlgorithms,
            alpha: _alpha,
            beta: _beta,
            gamma: _gamma,
            pheromoneStartValue: _pheromoneStartValue,
            antColonySize: _antColonySize,
            evaporationRate: _evaporationRate)));
  }

  void runAlgorithm() async {
    if (ConfigurationHolder.generatedRectangles.isNotEmpty) {
      var parameters = AntColonyParameters(
          elementsToFit: ConfigurationHolder.generatedRectangles,
          containerHeight: ConfigurationHolder.containerHeight,
          containerWidth: ConfigurationHolder.containerWidth,
          alpha: _alpha,
          beta: _beta,
          gamma: _gamma,
          pheromoneStartValue: _pheromoneStartValue,
          antColonySize: _antColonySize,
          evaporationRate: _evaporationRate);

      var stream = await _simulatedAnnealingAlgorithm.execute(parameters);

      _lastRunParameters = parameters;
      _algorithmStartTime = DateTime.now();

      stream.listen(
        (event) {
          emit(ResultAntColonyState(
              algorithmResult: event.solution,
              maxContainerHeight: ConfigurationHolder.containerHeight,
              isDone: false,
              startTime: _algorithmStartTime!,
              antsSpawned: event.antSpawned));

          _lastResult = event;
        },
        onDone: () {
          var algorithmFinishTime = DateTime.now();

          emit(ResultAntColonyState(
              algorithmResult: _lastResult!.solution,
              maxContainerHeight: ConfigurationHolder.containerHeight,
              isDone: true,
              startTime: _algorithmStartTime!,
              finishTime: algorithmFinishTime,
              antsSpawned: _lastResult!.antSpawned));

          emit(AlgorithmStoppedAntColonyState());

          _algorithmHistoryStorage.saveAlgorithm(AntColonyHistoryEntity(
              startTime: _algorithmStartTime!,
              finishTime: algorithmFinishTime,
              heuristicAlgorithm: _simulatedAnnealingAlgorithm,
              binPackingAlgorithm: _packingAlgorithm,
              findNeighboursAlgorithm: null,
              result: _lastResult,
              parameters: _lastRunParameters!));

          _lastResult = null;
          _lastRunParameters = null;
        },
      );

      emit(AlgorithmStartedAntColonyState());
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

  void setAlpha(double alpha) {
    _alpha = alpha;
  }

  void setBeta(double beta) {
    _beta = beta;
  }

  void setGamma(double gamma) {
    _gamma = gamma;
  }

  void setPheromoneStartValue(double pheromoneStartValue) {
    _pheromoneStartValue = pheromoneStartValue;
  }

  void setAntColonySize(int antColonySize) {
    _antColonySize = antColonySize;
  }

  void setEvaporationRate(double evaporationRate) {
    _evaporationRate = evaporationRate;
  }
}
