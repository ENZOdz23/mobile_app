// lib/features/home/data/datasources/dashboard_remote_data_source.dart

import 'package:dio/dio.dart';
import '../../models/dashboard_data.dart';
import '../../../../core/api/api_client.dart';

abstract class IDashboardRemoteDataSource {
  Future<DashboardData> getDashboardData();
}

class DashboardRemoteDataSource implements IDashboardRemoteDataSource {
  final Dio _dio;
  static const String _endpoint = 'dashboard';

  DashboardRemoteDataSource({Dio? dio}) : _dio = dio ?? Api.getDio();

  @override
  Future<DashboardData> getDashboardData() async {
    try {
      final response = await _dio.get('/$_endpoint/');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DashboardData.fromJson(
            response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to fetch dashboard data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Remote: Failed to fetch dashboard data - $e');
    }
  }
}

