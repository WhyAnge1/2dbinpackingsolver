import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:bin_packing_problem_resolver/algorithms/find_neighbours/find_neighbours_algorithm.dart';
import 'package:bin_packing_problem_resolver/algorithms/find_neighbours/swap/swap_algorithm_fixed.dart';
import 'package:bin_packing_problem_resolver/algorithms/heuristic/heuristic_algorithm.dart';
import 'package:bin_packing_problem_resolver/algorithms/heuristic/simulated_annealing/simulated_annaling_parameters.dart';
import 'package:bin_packing_problem_resolver/algorithms/heuristic/simulated_annealing/simulated_annealing_result.dart';
import 'package:bin_packing_problem_resolver/algorithms/packing/bin_packing_algorithm.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/container_entity.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/rectangle_entity.dart';

class SimulatedAnnealingAlgorithm
    implements HeuristicAlgorithm<SimulatedAnnealingParameters> {
  final FindNeighboursAlgorithm findNeighboursAlgorithm = SwapAlgorithmFixed();
  final random = Random();
  BinPackingAlgorithm packingAlgorithm;
  StreamController<SimulatedAnnealingResult>? _runningController;
  Isolate? _runningIsolate;

  SimulatedAnnealingAlgorithm(this.packingAlgorithm);

  @override
  String get name => "Simulated annealing";

  @override
  void stop() {
    _runningIsolate?.kill(priority: Isolate.immediate);
    _runningIsolate = null;

    _runningController?.close();
    _runningController = null;
  }

  @override
  Future<Stream<SimulatedAnnealingResult>> execute(
    SimulatedAnnealingParameters parameters,
  ) async {
    if (_runningIsolate != null || _runningController != null) {
      stop();
    }

    var runningReceivePort = ReceivePort();
    _runningController = StreamController<SimulatedAnnealingResult>();

    _runningIsolate = await Isolate.spawn(
        _runAlgorithm,
        _AlgoritmInData(
            parameters.elementsToFit,
            packingAlgorithm,
            parameters.containerHeight,
            parameters.containerWidth,
            parameters.coolingAlpha,
            parameters.numAttempts,
            parameters.initialTemperature,
            runningReceivePort.sendPort),
        onError: runningReceivePort.sendPort,
        onExit: runningReceivePort.sendPort);

    runningReceivePort.listen((message) {
      if (message is _AlgoritmOutData) {
        if (!message.isComplete) {
          _runningController?.add(SimulatedAnnealingResult(
              solution: message.solution,
              temperature: message.temperature,
              tryValue: message.tryValue));
        } else {
          runningReceivePort.close();
        }
      }
    }, onDone: () {
      stop();
    }, onError: (Object object, StackTrace stackTrace) {
      stop();
    }, cancelOnError: true);

    return _runningController!.stream;
  }

  void _runAlgorithm(_AlgoritmInData data) async {
    final coolingAlpha = data.coolingAlpha;
    final containerSquare = data.containerHeight * data.containerWidth;
    final neighborhoodSize = data.elementsToFit.length;
    var finalTryValue = 0.0;
    var temperature = 0.0;
    var accepted = 0;
    var rejected = 0;
    var quasiEquilibriumRejectedCounter = 0;

    var initialSolutionElementsToFit = data.elementsToFit.toList();
    initialSolutionElementsToFit.shuffle();
    var initialSolution = data.binPackingAlgorithm.execute(
        initialSolutionElementsToFit,
        data.containerWidth,
        data.containerHeight);
    var bestSolution = initialSolution;

    var initialTemperatureResult = _findInitialTemperature(
        initialSolution, initialSolutionElementsToFit, data);

    temperature = initialTemperatureResult.$1;
    finalTryValue = initialTemperatureResult.$2;

    while (quasiEquilibriumRejectedCounter < 3) {
      final neigbours =
          findNeighboursAlgorithm.execute(initialSolutionElementsToFit);
      final randomNeigbour = neigbours[random.nextInt(neigbours.length)];
      final randomNeighbourSolution = data.binPackingAlgorithm
          .execute(randomNeigbour, data.containerWidth, data.containerHeight);

      final resultDelta = _countDelta(
          randomNeighbourSolution, initialSolution, containerSquare);

      if (random.nextInt(2) < exp(-resultDelta / temperature)) {
        initialSolution = randomNeighbourSolution;
        initialSolutionElementsToFit = randomNeigbour;

        if (_isBetterSolution(bestSolution, initialSolution)) {
          bestSolution = initialSolution;
        }

        accepted++;

        data.port.send(
            _AlgoritmOutData(initialSolution, temperature, finalTryValue));
      } else {
        rejected++;
      }

      if (accepted == neighborhoodSize || rejected == neighborhoodSize * 2) {
        if (rejected == neighborhoodSize * 2) {
          quasiEquilibriumRejectedCounter++;
        } else {
          quasiEquilibriumRejectedCounter = 0;
        }
        temperature = temperature * coolingAlpha;
        accepted = 0;
        rejected = 0;

        data.port
            .send(_AlgoritmOutData(bestSolution, temperature, finalTryValue));
      }
    }

    data.port.send(_AlgoritmOutData(bestSolution, temperature, finalTryValue,
        isComplete: true));
  }

  bool _isBetterSolution(
      List<ContainerEntity> bestSolution, List<ContainerEntity> newSolution) {
    var bestSolutionFreeSpaceLeft = _countFreeSpace(bestSolution);
    var newSolutionFreeSpaceLeft = _countFreeSpace(newSolution);

    var result = newSolution.length < bestSolution.length ||
        (newSolution.length == bestSolution.length &&
            newSolutionFreeSpaceLeft < bestSolutionFreeSpaceLeft);

    return result;
  }

  double _countFreeSpace(List<ContainerEntity> containers) => containers
      .map((e) => e.freeSquare)
      .reduce((value, element) => value + element);

  double _countDelta(List<ContainerEntity> firstSolution,
      List<ContainerEntity> secondSolution, double containerSquare) {
    var fsSpace = _countFreeSpace(firstSolution);
    var firstSolutionFreeSpace = fsSpace +
        (firstSolution.length > secondSolution.length
            ? ((firstSolution.length - secondSolution.length) * containerSquare)
            : 0.0);

    var ssSpace = _countFreeSpace(secondSolution);
    var secondSolutionFreeSpace = ssSpace +
        (secondSolution.length > firstSolution.length
            ? ((secondSolution.length - firstSolution.length) * containerSquare)
            : 0.0);

    return firstSolutionFreeSpace - secondSolutionFreeSpace;
  }

  double _try(
      List<ContainerEntity> initialSolution,
      List<RectangleEntity> initialSolutionElementsToFit,
      double temperature,
      BinPackingAlgorithm binPackingAlgorithm,
      double containerWidth,
      double containerHeight,
      double containerSquare,
      int numAttempts) {
    var accepted = 0;
    var numAttempts1 = 20;

    for (var i = 1; i <= numAttempts1; i++) {
      final neigbours =
          findNeighboursAlgorithm.execute(initialSolutionElementsToFit);

      final randomNeighbourSolution = binPackingAlgorithm.execute(
          neigbours[random.nextInt(neigbours.length)],
          containerWidth,
          containerHeight);
      final resultDelta = _countDelta(
          randomNeighbourSolution, initialSolution, containerSquare);

      if (random.nextInt(2) < exp(-resultDelta / temperature)) {
        accepted++;
      }
    }

    return accepted / numAttempts1;
  }

  (double temperature, double tryValue) _findInitialTemperature(
      List<ContainerEntity> initialSolution,
      List<RectangleEntity> initialSolutionElementsToFit,
      _AlgoritmInData data) {
    final containerSquare = data.containerHeight * data.containerWidth;
    var temperature = data.initialTemperature;
    var tryValue = 0.0;

    while (tryValue < 0.87 || tryValue > 0.93) {
      tryValue = _try(
          initialSolution,
          initialSolutionElementsToFit,
          temperature,
          data.binPackingAlgorithm,
          data.containerWidth,
          data.containerHeight,
          containerSquare,
          data.numAttempts);

      temperature = temperature * 1.001;

      data.port.send(_AlgoritmOutData(
        initialSolution,
        temperature,
        tryValue,
      ));
    }

    return (temperature, tryValue);
  }
}

class _AlgoritmInData {
  final List<RectangleEntity> elementsToFit;
  final BinPackingAlgorithm binPackingAlgorithm;
  final SendPort port;
  final double containerHeight;
  final double containerWidth;
  final double coolingAlpha;
  final int numAttempts;
  final double initialTemperature;

  _AlgoritmInData(
      this.elementsToFit,
      this.binPackingAlgorithm,
      this.containerHeight,
      this.containerWidth,
      this.coolingAlpha,
      this.numAttempts,
      this.initialTemperature,
      this.port);
}

class _AlgoritmOutData {
  final List<ContainerEntity> solution;
  final double temperature;
  final double tryValue;
  final bool isComplete;

  _AlgoritmOutData(this.solution, this.temperature, this.tryValue,
      {this.isComplete = false});
}
