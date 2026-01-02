// lib/features/contacts/data/datasources/prospects_remote_data_source.dart

import 'package:dio/dio.dart';
import '../../models/prospect.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/storage/local_storage_service.dart';

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
      // Get current user ID from storage
      final storage = await LocalStorageService.getInstance();
      final userId = storage.getUserId();
      
      if (userId == null) {
        throw Exception('User ID not found. Please login again.');
      }
      
      final requestData = prospect.toJson();
      // Add user field to the request
      requestData['user'] = userId;
      
      print('[ProspectsRemoteDataSource] Creating prospect with data: $requestData');
      
      final response = await _dio.post('/$_endpoint/', data: requestData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Prospect.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to create prospect: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Extract detailed error message from response
      String errorMessage = 'Failed to create prospect';
      if (e.response?.data != null) {
        final responseData = e.response!.data;
        if (responseData is Map) {
          final dataMap = Map<String, dynamic>.from(responseData);
          // Try to extract error details
          if (dataMap.containsKey('error')) {
            errorMessage = dataMap['error'].toString();
          } else if (dataMap.containsKey('message')) {
            errorMessage = dataMap['message'].toString();
          } else if (dataMap.containsKey('detail')) {
            errorMessage = dataMap['detail'].toString();
          } else {
            // Format field errors if present
            final fieldErrors = <String>[];
            dataMap.forEach((key, value) {
              if (value is List) {
                fieldErrors.add('$key: ${value.join(", ")}');
              } else if (value is String) {
                fieldErrors.add('$key: $value');
              }
            });
            if (fieldErrors.isNotEmpty) {
              errorMessage = fieldErrors.join('; ');
            } else {
              errorMessage = dataMap.toString();
            }
          }
        } else {
          errorMessage = responseData.toString();
        }
      }
      print('[ProspectsRemoteDataSource] Error creating prospect: $errorMessage');
      throw Exception('Remote: Failed to create prospect - $errorMessage');
    } catch (e) {
      print('[ProspectsRemoteDataSource] Exception creating prospect: $e');
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
