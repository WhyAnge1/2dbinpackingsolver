import 'dart:async';
import 'dart:isolate';

import 'package:bin_packing_problem_resolver/algorithms/heuristic/heuristic_parameters.dart';
import 'package:bin_packing_problem_resolver/algorithms/heuristic/hill_climbing/hill_climbing_result.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/container_entity.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/rectangle_entity.dart';

import '../../packing/bin_packing_algorithm.dart';
import '../../find_neighbours/find_neighbours_algorithm.dart';
import '../heuristic_algorithm.dart';

class HillClimbingAlgorithm implements HeuristicAlgorithm<HeuristicParameters> {
  BinPackingAlgorithm packingAlgorithm;
  FindNeighboursAlgorithm findNeighboursAlgorithm;

  StreamController<HillClimbingResult>? _runningController;
  Isolate? _runningIsolate;

  HillClimbingAlgorithm(this.packingAlgorithm, this.findNeighboursAlgorithm);

  @override
  String get name => "Hill climbing";

  @override
  void stop() {
    _runningIsolate?.kill(priority: Isolate.immediate);
    _runningIsolate = null;

    _runningController?.close();
    _runningController = null;
  }

  @override
  Future<Stream<HillClimbingResult>> execute(
      HeuristicParameters parameters) async {
    if (_runningIsolate != null || _runningController != null) {
      stop();
    }

    _runningController = StreamController<HillClimbingResult>();
    final receivePort = ReceivePort();

    _runningIsolate = await Isolate.spawn(
        _runAlgorithm,
        _AlgoritmInData(
            parameters.elementsToFit,
            packingAlgorithm,
            findNeighboursAlgorithm,
            parameters.containerHeight,
            parameters.containerWidth,
            receivePort.sendPort));

    receivePort.listen((message) {
      if (message is _AlgoritmOutData) {
        if (!message.isComplete) {
          _runningController?.add(HillClimbingResult(
              solution: message.solution,
              neighborsCount: message.neighborsCount));
        } else {
          receivePort.close();
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
    List<ContainerEntity> bestSolution = List.empty();
    var lastNeighborsCount = 0;
    var elementsToFit = data.elementsToFit;
    var binPackingAlgorithm = data.binPackingAlgorithm;
    var findNeighboursAlgorithm = data.findNeighboursAlgorithm;

    if (elementsToFit.isNotEmpty) {
      var hasBetterSolution = true;
      var currentStepSequence = elementsToFit;
      bestSolution = binPackingAlgorithm.execute(
          currentStepSequence, data.containerWidth, data.containerHeight);

      data.port.send(_AlgoritmOutData(bestSolution));

      while (hasBetterSolution) {
        List<ContainerEntity>? curentStepBestSolution;

        final neighbours = findNeighboursAlgorithm.execute(currentStepSequence);

        for (var neighbour in neighbours) {
          var newSolution = binPackingAlgorithm.execute(
              neighbour, data.containerWidth, data.containerHeight);
          data.port.send(
              _AlgoritmOutData(newSolution, neighborsCount: neighbours.length));

          if (curentStepBestSolution == null ||
              newSolution.length < curentStepBestSolution.length) {
            curentStepBestSolution = newSolution;
            currentStepSequence = neighbour;
          }
        }

        if (curentStepBestSolution != null &&
            curentStepBestSolution.length < bestSolution.length) {
          bestSolution = curentStepBestSolution;
          hasBetterSolution = true;
          lastNeighborsCount = neighbours.length;

          data.port.send(_AlgoritmOutData(bestSolution,
              neighborsCount: neighbours.length));
        } else {
          hasBetterSolution = false;
        }
      }
    }

    data.port.send(_AlgoritmOutData(bestSolution,
        neighborsCount: lastNeighborsCount, isComplete: true));
  }
}

class _AlgoritmInData {
  final List<RectangleEntity> elementsToFit;
  final BinPackingAlgorithm binPackingAlgorithm;
  final FindNeighboursAlgorithm findNeighboursAlgorithm;
  final SendPort port;
  final double containerHeight;
  final double containerWidth;

  _AlgoritmInData(
      this.elementsToFit,
      this.binPackingAlgorithm,
      this.findNeighboursAlgorithm,
      this.containerHeight,
      this.containerWidth,
      this.port);
}

class _AlgoritmOutData {
  final List<ContainerEntity> solution;
  final int neighborsCount;
  final bool isComplete;

  _AlgoritmOutData(this.solution,
      {this.neighborsCount = 0, this.isComplete = false});
}
