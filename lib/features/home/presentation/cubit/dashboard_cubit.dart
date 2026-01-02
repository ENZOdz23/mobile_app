// lib/features/home/presentation/cubit/dashboard_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/get_dashboard_data_usecase.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetDashboardDataUseCase getDashboardDataUseCase;

  DashboardCubit({
    required this.getDashboardDataUseCase,
  }) : super(DashboardInitial());

  Future<void> loadDashboardData() async {
    try {
      emit(DashboardLoading());
      final data = await getDashboardDataUseCase();
      emit(DashboardLoaded(data));
    } catch (e) {
      emit(DashboardError('Failed to load dashboard data: ${e.toString()}'));
    }
  }

  Future<void> refreshDashboardData() async {
    await loadDashboardData();
  }
}

