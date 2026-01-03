// lib/features/home/data/dashboard_repository_impl.dart

import 'package:dio/dio.dart';
import '../models/dashboard_data.dart';
import '../models/activity.dart';
import '../models/prospect_status_count.dart';
import '../domain/dashboard_repository.dart';
import '../../contacts/data/datasources/contacts_remote_data_source.dart';
import '../../contacts/data/datasources/prospects_remote_data_source.dart';
import '../../contacts/models/contact.dart';
import '../../contacts/models/prospect.dart';
import '../../../../core/api/api_client.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final IContactsRemoteDataSource contactsRemoteDataSource;
  final IProspectsRemoteDataSource prospectsRemoteDataSource;
  final Dio _dio;

  DashboardRepositoryImpl({
    required this.contactsRemoteDataSource,
    required this.prospectsRemoteDataSource,
    Dio? dio,
  }) : _dio = dio ?? Api.getDio();

  Future<List<Activity>> _getActivitiesFromEndpoint() async {
    try {
      final response = await _dio.get('/activities/');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data as Map)['results'] ?? [];
        
        return data
            .map((item) => Activity.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      // Endpoint doesn't exist or failed, return empty list
      return [];
    }
  }

  Future<int> _getPhoneNumbersCount() async {
    try {
      final response = await _dio.get('/phone-numbers/');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle different response formats
        if (response.data != null) {
          if (response.data is Map) {
            final data = response.data as Map<String, dynamic>;
            // Check if there's a count field
            if (data.containsKey('count') && data['count'] != null) {
              final count = data['count'];
              if (count is int) {
                return count;
              } else if (count is num) {
                return count.toInt();
              } else if (count is String) {
                final parsed = int.tryParse(count);
                if (parsed != null) return parsed;
              }
            }
            // Check if there's a results array with count
            if (data.containsKey('results') && data['results'] != null && data['results'] is List) {
              return (data['results'] as List).length;
            }
          } else if (response.data is List) {
            return (response.data as List).length;
          }
        }
        // Fallback: return 0 if we can't parse
        return 0;
      }
      return 0;
    } catch (e) {
      // If phone-numbers endpoint fails, fallback to contacts count
      return 0;
    }
  }

  Future<int> _getContactsCount() async {
    try {
      final response = await _dio.get('/contacts/');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check if response has a count field (paginated response)
        if (response.data is Map) {
          final data = response.data as Map<String, dynamic>;
          if (data.containsKey('count') && data['count'] != null) {
            final count = data['count'];
            if (count is int) {
              return count;
            } else if (count is num) {
              return count.toInt();
            }
          }
        }
        // If no count field, use the length of the results
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data as Map)['results'] ?? [];
        return data.length;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<DashboardData> getDashboardData() async {
    try {
      // Fetch contacts and prospects from remote API
      final contacts = await contactsRemoteDataSource.fetchContacts();
      final prospects = await prospectsRemoteDataSource.getProspects();

      // Get total contacts count from API (handles pagination)
      int totalContacts = await _getContactsCount();
      // Fallback to contacts list length if count is 0
      if (totalContacts == 0) {
        totalContacts = contacts.length;
      }
      
      final totalProspects = prospects.length;

      // Calculate prospect status counts
      int interested = 0;
      int notInterested = 0;
      int notAnswered = 0;

      for (final prospect in prospects) {
        switch (prospect.status) {
          case ProspectStatus.interested:
            interested++;
            break;
          case ProspectStatus.notInterested:
            notInterested++;
            break;
          case ProspectStatus.notCompleted:
            notAnswered++;
            break;
          default:
            notAnswered++;
            break;
        }
      }

      final statusCount = ProspectStatusCount(
        interested: interested,
        notInterested: notInterested,
        notAnswered: notAnswered,
      );

      // Try to fetch activities from dedicated endpoint first
      List<Activity> recentActivities = await _getActivitiesFromEndpoint();
      
      // If no activities endpoint exists, generate from contacts and prospects
      if (recentActivities.isEmpty) {
        // Add contacts as activities
        for (int i = 0; i < contacts.length; i++) {
          final contact = contacts[i];
          recentActivities.add(Activity(
            id: 'contact_${contact.id}',
            title: contact.type == ContactType.client
                ? 'Client ajouté'
                : 'Prospect ajouté',
            description: contact.name.isNotEmpty 
                ? '${contact.name}${contact.company.isNotEmpty ? ' de ${contact.company}' : ''}'
                : (contact.company.isNotEmpty ? contact.company : 'Contact'),
            timestamp: DateTime.now().subtract(Duration(days: contacts.length - i)),
            type: contact.type == ContactType.client
                ? ActivityType.clientAdded
                : ActivityType.prospectAdded,
          ));
        }

        // Add prospects as activities
        for (int i = 0; i < prospects.length; i++) {
          final prospect = prospects[i];
          recentActivities.add(Activity(
            id: 'prospect_${prospect.id}',
            title: 'Prospect ajouté',
            description: prospect.entreprise.isNotEmpty 
                ? prospect.entreprise 
                : 'Prospect',
            timestamp: DateTime.now().subtract(Duration(days: prospects.length - i)),
            type: ActivityType.prospectAdded,
          ));
        }

        // Sort by timestamp (most recent first)
        recentActivities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }

      // Take top 10 activities
      final topActivities = recentActivities.take(10).toList();

      return DashboardData(
        totalProspects: totalProspects,
        totalContacts: totalContacts,
        prospectStatusCount: statusCount,
        recentActivities: topActivities,
      );
    } catch (e) {
      throw Exception('Repository: Failed to get dashboard data - $e');
    }
  }
}

