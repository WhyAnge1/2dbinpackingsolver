import 'package:bin_packing_problem_resolver/models/entity/history/algorithm_history_entity.dart';

class AlgorithmHistoryStorage {
  static final _instance = AlgorithmHistoryStorage._singleton();

  final cachedAlgorithmHistory =
      List<AlgorithmHistoryEntity>.empty(growable: true);

  factory AlgorithmHistoryStorage() => _instance;

  AlgorithmHistoryStorage._singleton();

  List<AlgorithmHistoryEntity> get history => cachedAlgorithmHistory.toList();

  void saveAlgorithm(AlgorithmHistoryEntity entity) {
    cachedAlgorithmHistory.insert(0, entity);
  }
}
