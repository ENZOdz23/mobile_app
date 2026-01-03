// lib/features/home/domain/get_dashboard_data_usecase.dart

import '../models/dashboard_data.dart';
import 'dashboard_repository.dart';

class GetDashboardDataUseCase {
  final DashboardRepository repository;

  GetDashboardDataUseCase(this.repository);

  Future<DashboardData> call() async {
    return await repository.getDashboardData();
  }
}

