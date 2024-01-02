import 'package:bin_packing_problem_resolver/cubit/states/history_state.dart';
import 'package:bin_packing_problem_resolver/services/storage/algorithm_history_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final _algorithmHistoryStorage = AlgorithmHistoryStorage();

  HistoryCubit() : super(InitialHistoryState());

  void loadHistory() async {
    if (_algorithmHistoryStorage.history.isNotEmpty) {
      emit(LoadedDataHistoryState(history: _algorithmHistoryStorage.history));
    } else {
      emit(EmptyDataHistoryState());
    }
  }
}
