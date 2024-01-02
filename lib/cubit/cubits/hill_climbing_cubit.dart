import 'package:bin_packing_problem_resolver/algorithms/find_neighbours/find_neighbours_algorithm.dart';
import 'package:bin_packing_problem_resolver/algorithms/find_neighbours/or_opt/or_opt_algorithm.dart';
import 'package:bin_packing_problem_resolver/algorithms/find_neighbours/three_opt/three_opt_algorithm.dart';
import 'package:bin_packing_problem_resolver/algorithms/heuristic/hill_climbing/hill_climbing_parameters.dart';
import 'package:bin_packing_problem_resolver/algorithms/heuristic/hill_climbing/hill_climbing_result.dart';
import 'package:bin_packing_problem_resolver/algorithms/packing/bin_packing_algorithm.dart';
import 'package:bin_packing_problem_resolver/algorithms/heuristic/hill_climbing/hill_climbing_algorithm.dart';
import 'package:bin_packing_problem_resolver/algorithms/find_neighbours/swap/swap_algorithm.dart';
import 'package:bin_packing_problem_resolver/algorithms/find_neighbours/two_opt/two_opt_algorithm.dart';
import 'package:bin_packing_problem_resolver/algorithms/packing/next_fit.dart';
import 'package:bin_packing_problem_resolver/algorithms/packing/first_fit.dart';
import 'package:bin_packing_problem_resolver/cubit/states/hill_climbing_state.dart';
import 'package:bin_packing_problem_resolver/helpers/configuration.dart';
import 'package:bin_packing_problem_resolver/models/entity/history/hill_climbing_history_entity.dart';
import 'package:bin_packing_problem_resolver/services/storage/algorithm_history_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HillClimbingCubit extends Cubit<HillClimbingState> {
  final _algorithmHistoryStorage = AlgorithmHistoryStorage();
  late HillClimbingAlgorithm _hillClimbingAlgorithm;
  late FindNeighboursAlgorithm _neighbourAlgorithm;
  late BinPackingAlgorithm _packingAlgorithm;
  HillClimbingParameters? _lastRunParameters;
  HillClimbingResult? _lastResult;
  DateTime? _algorithmStartTime;

  FindNeighboursAlgorithm get _selectedNeighbourAlgorithm =>
      _neighbourAlgorithm;
  set _selectedNeighbourAlgorithm(FindNeighboursAlgorithm algorithm) {
    _neighbourAlgorithm = algorithm;

    _hillClimbingAlgorithm.findNeighboursAlgorithm = algorithm;
  }

  BinPackingAlgorithm get _selectedPackingAlgorithm => _packingAlgorithm;
  set _selectedPackingAlgorithm(BinPackingAlgorithm algorithm) {
    _packingAlgorithm = algorithm;

    _hillClimbingAlgorithm.packingAlgorithm = algorithm;
  }

  HillClimbingCubit()
      : super(InitialHillClimbingState(
            neighboursAlgorithms: {}, packingAlgorithms: {})) {
    final neighboursAlgorithms = _createNeighboursAlgorithms();
    final packingAlgorithms = _createPackingAlgorithms();

    _hillClimbingAlgorithm = HillClimbingAlgorithm(
        packingAlgorithms.values.first, neighboursAlgorithms.values.first);

    _selectedNeighbourAlgorithm = neighboursAlgorithms.values.first;
    _selectedPackingAlgorithm = packingAlgorithms.values.first;

    emit(InitialHillClimbingState(
        neighboursAlgorithms: neighboursAlgorithms,
        packingAlgorithms: packingAlgorithms));
  }

  void runAlgorithm() async {
    if (ConfigurationHolder.generatedRectangles.isNotEmpty) {
      var parameters = HillClimbingParameters(
          elementsToFit: ConfigurationHolder.generatedRectangles,
          containerWidth: ConfigurationHolder.containerWidth,
          containerHeight: ConfigurationHolder.containerHeight);

      var stream = await _hillClimbingAlgorithm.execute(parameters);

      _lastRunParameters = parameters;
      _algorithmStartTime = DateTime.now();

      stream.listen(
        (event) {
          emit(ResultHillClimbingState(
              algorithmResult: event.solution,
              neighborsCount: event.neighborsCount,
              maxContainerHeight: ConfigurationHolder.containerHeight,
              isDone: false,
              startTime: _algorithmStartTime!));
          _lastResult = event;
        },
        onDone: () {
          var algorithmFinishTime = DateTime.now();

          emit(ResultHillClimbingState(
              algorithmResult: _lastResult!.solution,
              neighborsCount: _lastResult!.neighborsCount,
              maxContainerHeight: ConfigurationHolder.containerHeight,
              isDone: true,
              startTime: _algorithmStartTime!,
              finishTime: algorithmFinishTime));

          emit(AlgorithmStoppedHillClimbingState());

          _algorithmHistoryStorage.saveAlgorithm(HillClimbingHistoryEntity(
              startTime: _algorithmStartTime!,
              finishTime: algorithmFinishTime,
              heuristicAlgorithm: _hillClimbingAlgorithm,
              binPackingAlgorithm: _packingAlgorithm,
              findNeighboursAlgorithm: _neighbourAlgorithm,
              result: _lastResult,
              parameters: _lastRunParameters!));

          _lastResult = null;
          _lastRunParameters = null;
        },
      );

      emit(AlgorithmStartedHillClimbingState());
    }
  }

  void stopAlgorithm() {
    _hillClimbingAlgorithm.stop();
  }

  void setNeighboursAlgorithm(FindNeighboursAlgorithm selectedAlgorithm) {
    _selectedNeighbourAlgorithm = selectedAlgorithm;
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

  Map<String, FindNeighboursAlgorithm> _createNeighboursAlgorithms() {
    var twoOpt = TwoOptAlgorithm();
    var threeOpt = ThreeOptAlgorithm();
    var orOpt = OrOptAlgorithm();
    var swap = SwapAlgorithm();
    final neighboursAlgorithms = {
      twoOpt.name: twoOpt,
      threeOpt.name: threeOpt,
      orOpt.name: orOpt,
      swap.name: swap,
    };

    return neighboursAlgorithms;
  }
}
