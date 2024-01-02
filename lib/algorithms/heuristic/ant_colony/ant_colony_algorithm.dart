import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:bin_packing_problem_resolver/algorithms/heuristic/ant_colony/ant_colony_parameters.dart';
import 'package:bin_packing_problem_resolver/algorithms/heuristic/ant_colony/ant_colony_result.dart';
import 'package:bin_packing_problem_resolver/algorithms/heuristic/heuristic_algorithm.dart';
import 'package:bin_packing_problem_resolver/algorithms/packing/bin_packing_algorithm.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/container_entity.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/rectangle_entity.dart';

class AntColonyAlgorithm implements HeuristicAlgorithm<AntColonyParameters> {
  BinPackingAlgorithm binPackingAlgorithm;
  StreamController<AntColonyResult>? _runningController;
  Isolate? _runningIsolate;
  final _random = Random();

  AntColonyAlgorithm(this.binPackingAlgorithm);

  @override
  String get name => "Ant colony";

  @override
  void stop() {
    _runningIsolate?.kill(priority: Isolate.immediate);
    _runningIsolate = null;

    _runningController?.close();
    _runningController = null;
  }

  @override
  Future<Stream<AntColonyResult>> execute(
    AntColonyParameters parameters,
  ) async {
    if (_runningIsolate != null || _runningController != null) {
      stop();
    }

    var runningReceivePort = ReceivePort();
    _runningController = StreamController<AntColonyResult>();

    _runningIsolate = await Isolate.spawn(
        _runAlgorithm,
        _AlgoritmInData(
            elementsToFit: parameters.elementsToFit,
            binPackingAlgorithm: binPackingAlgorithm,
            containerHeight: parameters.containerHeight,
            containerWidth: parameters.containerWidth,
            port: runningReceivePort.sendPort,
            alpha: parameters.alpha,
            beta: parameters.beta,
            gamma: parameters.gamma,
            pheromoneStartValue: parameters.pheromoneStartValue,
            antColonySize: parameters.antColonySize,
            evaporationRate: parameters.evaporationRate),
        onError: runningReceivePort.sendPort,
        onExit: runningReceivePort.sendPort);

    runningReceivePort.listen((message) {
      if (message is _AlgoritmOutData) {
        if (!message.isComplete) {
          _runningController?.add(AntColonyResult(
              solution: message.solution, antSpawned: message.antsSpawned));
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
    var bestSolution = List<ContainerEntity>.empty(growable: true);

    data.port.send(_AlgoritmOutData(solution: bestSolution, antsSpawned: 0));

    final pheromoneMap =
        _createPheromoneMatrix(data.pheromoneStartValue, data.elementsToFit);

    for (int i = 1; i <= data.antColonySize; i++) {
      var currentAntSolution = _antActivity(pheromoneMap, data);

      data.port
          .send(_AlgoritmOutData(solution: currentAntSolution, antsSpawned: i));

      if (bestSolution.length < currentAntSolution.length) {
        bestSolution = currentAntSolution;
      }

      for (var pheromone in pheromoneMap) {
        for (var key in pheromone.keys) {
          pheromone[key] = pheromone[key]! * (1 - data.evaporationRate);
        }
      }
    }

    data.port.send(_AlgoritmOutData(
        solution: bestSolution,
        antsSpawned: data.antColonySize,
        isComplete: true));
  }

  List<ContainerEntity> _antActivity(
      List<Map<RectangleEntity, double>> pheromoneMap, _AlgoritmInData data) {
    final antElementsSequence = List<RectangleEntity>.empty(growable: true);
    final variantsToFit = data.elementsToFit.toList();
    var iteration = 0;

    while (variantsToFit.isNotEmpty) {
      var iterationPheromoneSum = 0.0;
      for (var candidate in variantsToFit) {
        final pheromone = pheromoneMap[iteration][candidate]!;
        final square = candidate.square;

        iterationPheromoneSum +=
            pow(pheromone, data.alpha) * (pow(square, data.beta));
      }

      final putProbabilitiesList = <double, RectangleEntity>{};
      for (var candidate in variantsToFit) {
        putProbabilitiesList[
            (pow(pheromoneMap[iteration][candidate]!, data.alpha) *
                    (pow(candidate.square, data.beta))) /
                iterationPheromoneSum] = candidate;
      }

      final randomProbability = _random.nextDouble();
      var probabilitySum = 0.0;

      for (var probability in putProbabilitiesList.keys) {
        probabilitySum += probability;
        if (randomProbability <= probabilitySum) {
          final packedItem = putProbabilitiesList[probability]!;
          antElementsSequence.add(packedItem);
          variantsToFit.remove(packedItem);

          iteration++;

          break;
        }
      }
    }

    var antSolution = data.binPackingAlgorithm.execute(
        antElementsSequence, data.containerWidth, data.containerHeight);

    for (int i = antElementsSequence.length - 1; i >= 0; i--) {
      pheromoneMap[i][antElementsSequence[i]] = pheromoneMap[i]
              [antElementsSequence[i]]! +
          (data.gamma / (i + antSolution.length));
    }
    return antSolution;
  }

  List<Map<RectangleEntity, double>> _createPheromoneMatrix(
      double pheromoneStartValue, List<RectangleEntity> elementsToFit) {
    final pheromoneMap =
        List<Map<RectangleEntity, double>>.empty(growable: true);

    for (int i = 0; i < elementsToFit.length; i++) {
      final pheromoneMatrix = <RectangleEntity, double>{};

      for (var element in elementsToFit) {
        pheromoneMatrix[element] = pheromoneStartValue;
      }

      pheromoneMap.add(pheromoneMatrix);
    }

    return pheromoneMap;
  }
}

class _AlgoritmInData {
  final List<RectangleEntity> elementsToFit;
  final BinPackingAlgorithm binPackingAlgorithm;
  final SendPort port;
  final double containerHeight;
  final double containerWidth;
  final double alpha;
  final double beta;
  final double gamma;
  final double pheromoneStartValue;
  final int antColonySize;
  final double evaporationRate;

  _AlgoritmInData({
    required this.elementsToFit,
    required this.binPackingAlgorithm,
    required this.containerHeight,
    required this.containerWidth,
    required this.port,
    required this.alpha,
    required this.beta,
    required this.gamma,
    required this.pheromoneStartValue,
    required this.antColonySize,
    required this.evaporationRate,
  });
}

class _AlgoritmOutData {
  final List<ContainerEntity> solution;
  final int antsSpawned;
  final bool isComplete;

  _AlgoritmOutData(
      {required this.solution,
      required this.antsSpawned,
      this.isComplete = false});
}
