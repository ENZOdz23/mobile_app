// lib/features/home/domain/dashboard_repository.dart

import '../models/dashboard_data.dart';

abstract class DashboardRepository {
  Future<DashboardData> getDashboardData();
}

