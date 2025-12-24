// lib/features/contacts/data/datasources/prospects_remote_data_source.dart

import 'package:dio/dio.dart';
import '../../models/prospect.dart';
import '../../../../core/api/api_client.dart';

abstract class IProspectsRemoteDataSource {
  Future<List<Prospect>> getProspects();
  Future<Prospect> createProspect(Prospect prospect);
  Future<Prospect> updateProspect(Prospect prospect);
  Future<void> deleteProspect(String id);
}

class ProspectsRemoteDataSource implements IProspectsRemoteDataSource {
  final Dio _dio;
  static const String _endpoint = 'prospects';

  ProspectsRemoteDataSource({Dio? dio}) : _dio = dio ?? Api.getDio();

  @override
  Future<List<Prospect>> getProspects() async {
    try {
      final response = await _dio.get('/$_endpoint/');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data as Map)['results'] ?? [];

        return data
            .map((item) => Prospect.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to fetch prospects: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Remote: Failed to fetch prospects - $e');
    }
  }

  @override
  Future<Prospect> createProspect(Prospect prospect) async {
    try {
      final response = await _dio.post('/$_endpoint/', data: prospect.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Prospect.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to create prospect: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Remote: Failed to create prospect - $e');
    }
  }

  @override
  Future<Prospect> updateProspect(Prospect prospect) async {
    try {
      final response = await _dio.put(
        '/$_endpoint/${prospect.id}/',
        data: prospect.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Prospect.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to update prospect: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Remote: Failed to update prospect - $e');
    }
  }

  @override
  Future<void> deleteProspect(String id) async {
    try {
      final response = await _dio.delete('/$_endpoint/$id/');

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete prospect: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Remote: Failed to delete prospect - $e');
    }
  }
}
