import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/statistics_repository.dart';
import '../../models/statistics_model.dart';

// States
abstract class StatisticsState {}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final StatisticsModel statistics;

  StatisticsLoaded(this.statistics);
}

class StatisticsError extends StatisticsState {
  final String message;

  StatisticsError(this.message);
}

// Cubit
class StatisticsCubit extends Cubit<StatisticsState> {
  final StatisticsRepository _repository;

  StatisticsCubit(this._repository) : super(StatisticsInitial());

  Future<void> loadStatistics() async {
    try {
      emit(StatisticsLoading());
      final stats = await _repository.getStatistics();
      emit(StatisticsLoaded(stats));
    } catch (e) {
      emit(StatisticsError('Erreur lors du chargement des statistiques'));
    }
  }

  Future<void> refreshStatistics() async {
    // Don't emit loading on refresh to allow pull-to-refresh UI to handle it or just update silently
    // But commonly for full screen states, we might want to show loading or keep previous state.
    // For this implementation, we will emit loading to show clearly that data is updating.
    try {
      final stats = await _repository.getStatistics();
      emit(StatisticsLoaded(stats));
    } catch (e) {
      emit(StatisticsError('Erreur lors de l\'actualisation'));
    }
  }
}
