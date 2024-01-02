import 'package:bin_packing_problem_resolver/models/entity/history/algorithm_history_entity.dart';

abstract class HistoryState {}

class InitialHistoryState extends HistoryState {
  InitialHistoryState();
}

class LoadedDataHistoryState extends HistoryState {
  final List<AlgorithmHistoryEntity> history;

  LoadedDataHistoryState({required this.history});
}

class EmptyDataHistoryState extends HistoryState {
  EmptyDataHistoryState();
}
